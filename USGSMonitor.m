//
//  USGSMonitor.m
//  TestOne
//
//  Created by Massimo Chericoni on 10/18/12.
//  Copyright (c) 2012 Massimo Chericoni. All rights reserved.
//

#import "USGSMonitor.h"
#import "AFJSONRequestOperation.h"
#import "AFXMLRequestOperation.h"
#import "GeoEvent.h"
#import "USGSParser.h"
#import "EMSCXmlParserDelegate.h"
#import <objc/runtime.h>

static NSThread *monitor    = NULL;
static NSArray  *geoEvents      = NULL;
static NSString *fileName   = NULL;

@implementation USGSMonitor

+(NSArray*)currentEvents{
    return geoEvents;
}

+(NSArray*)getCachedCopy{
    // NSDictionary back from the stored NSData
    NSData *codedData = [NSData dataWithContentsOfFile:fileName];
    if (codedData == nil) return nil;
    
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:codedData];
    NSLog(@"%@", [NSString stringWithCString:class_getName([[unarchiver decodeObjectForKey:@"events"] class]) encoding:NSUTF8StringEncoding]);
    
    return [unarchiver decodeObjectForKey:@"events"];
}

+(void)keepMonitoring{
    NSLog(@"keepMonitoring");
    while(![[NSThread currentThread]  isCancelled]){
        if(!geoEvents){
            geoEvents = [self getCachedCopy];
            NSDate *modificationDate = [[[NSFileManager defaultManager] attributesOfItemAtPath:fileName error:nil] objectForKey:NSFileModificationDate];
            if(geoEvents){
                NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:geoEvents, @"events", modificationDate, @"date", nil];
                [[NSNotificationCenter defaultCenter] postNotificationName:USGS_UPDATE object:dict];
            }
        }
        
#pragma mark - EMSC request
        NSURLRequest *emscRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.emsc-csem.org/service/rss/rss.php?typ=emsc"]];
        AFXMLRequestOperation *xmlOperation = [AFXMLRequestOperation XMLParserRequestOperationWithRequest:emscRequest success:^(NSURLRequest *request, NSHTTPURLResponse *response, NSXMLParser *xmlParser) {
            NSLog(@"EMSC operation");
            xmlParser.delegate = [EMSCXmlParserDelegate sharedEMSCXmlParserDelegate];
            BOOL parsingResult = [xmlParser parse];
            NSLog(@"parsingResult: %i", parsingResult);
        }  failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, NSXMLParser *XMLParser){
            NSLog(@"EMSC failure %@", [error debugDescription]);
        }];
        
        [xmlOperation start];
        
#pragma mark - USGS request
        [UIApplication sharedApplication].networkActivityIndicatorVisible = true;
        NSURL *url = [NSURL URLWithString:USGS_URL];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        
        AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
            [UIApplication sharedApplication].networkActivityIndicatorVisible = false;
            NSLog(@"%@", [NSString stringWithCString:class_getName([JSON class]) encoding:NSUTF8StringEncoding]);
            
           NSArray  *parsedEvents = [USGSParser parseEvents:JSON];
            
            if(parsedEvents!= nil){
                geoEvents = parsedEvents;
                NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:geoEvents, @"events", [NSDate date], @"date", nil];
                
                // Write to file the geoEvents (not the dictionary with also the date)
                NSMutableData *data = [[NSMutableData alloc]init];
                NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc]initForWritingWithMutableData:data];
                [archiver encodeObject:geoEvents forKey: @"events"];
                [archiver finishEncoding];
                [data writeToFile:fileName atomically:YES];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:USGS_UPDATE object:dict];
            }
        } failure:nil];
        // TODO: implement failure block
        
        [operation start];
        
		// TODO: Configurable sleep time
        [NSThread  sleepForTimeInterval:30];
    }
}

+(void) startMonitor{
    fileName = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/feed.xml"];
    NSLog(@"fileName: %@", fileName);
    if(monitor == NULL){
        NSLog(@"Starting monitor");
        monitor = [[NSThread  alloc] initWithTarget:self selector:@selector(keepMonitoring) object:nil];
        [monitor start];
    }
}

+(void)stopMonitor{
    if(monitor != NULL){
        [monitor cancel];
        monitor = NULL;
    }
}

@end
