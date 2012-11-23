//
//  USGSMonitor.m
//  TestOne
//
//  Created by Massimo Chericoni on 10/18/12.
//  Copyright (c) 2012 Massimo Chericoni. All rights reserved.
//

#import "USGSMonitor.h"
#import "AFJSONRequestOperation.h"
#import "GeoEvent.h"
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
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = true;
        NSURL *url = [NSURL URLWithString:USGS_URL];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        
        AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
            [UIApplication sharedApplication].networkActivityIndicatorVisible = false;
            NSLog(@"%@", [NSString stringWithCString:class_getName([JSON class]) encoding:NSUTF8StringEncoding]);
			// Check the returned object
			if([JSON respondsToSelector:@selector(objectForKey:)]){
				id innerJSON = [JSON objectForKey:@"features"];
				// Check that we have an NSArray
                NSLog(@"%@", [NSString stringWithCString:class_getName([innerJSON class]) encoding:NSUTF8StringEncoding]);
				if ([innerJSON isKindOfClass:[NSArray class]]){
                    NSArray *places = [JSON valueForKeyPath:@"features.properties.place"];
                    NSLog(@"Places: %@", places);                  
                    NSMutableArray *mutableItems = [NSMutableArray arrayWithCapacity:[innerJSON count]];
                    for (NSDictionary *attributes in innerJSON) {
                        //NSLog(@"Attribute: %@", attributes);
                        NSLog(@"coordinates: %@", [attributes valueForKeyPath: @"geometry.coordinates"]);
                        NSArray *coordinates = [attributes valueForKeyPath: @"geometry.coordinates"];
                        float longitude = [[coordinates objectAtIndex:0] floatValue];
                        float latitude = [[coordinates objectAtIndex:1] floatValue];
                        float depth = [[coordinates objectAtIndex:2] floatValue];
                        NSLog(@"longitude: %f", longitude);
                        NSLog(@"latitude: %f", latitude);
                        NSLog(@"depth: %f", depth);
                        
                        NSString *place = [attributes valueForKeyPath: @"properties.place"];
                        NSLog(@"place: %@", place);
                        NSLog(@"magnitude: %@", [attributes valueForKeyPath: @"properties.mag"]);
                        int mag = [[attributes valueForKeyPath: @"properties.mag"] intValue];
                        
                        GeoEvent *event = [[GeoEvent alloc] initWithPlace: place magnitude:mag longitude:longitude andLatitude:latitude];
                        event.mag = mag;
                        
                        [mutableItems addObject:event];
                    }
                    
                    if(mutableItems!= nil){
                        geoEvents = mutableItems;
                        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:geoEvents, @"events", [NSDate date], @"date", nil];
                        
                        // Write to file the geoEvents (not the dictionary with also the date)                        
                        NSMutableData *data = [[NSMutableData alloc]init];
                        NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc]initForWritingWithMutableData:data];
                        [archiver encodeObject:geoEvents forKey: @"events"];
                        [archiver finishEncoding];
                        [data writeToFile:fileName atomically:YES];
                        
                        [[NSNotificationCenter defaultCenter] postNotificationName:USGS_UPDATE object:dict];
                    }
                }
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

#pragma mark - USGS Parser

+(NSArray*)parseUSGS:(id)JSON{
	if([JSON respondsToSelector:@selector(objectForKey:)]){
		id innerJSON = [JSON objectForKey:@"features"];
		// Check that we have an NSArray
		NSLog(@"%@", [NSString stringWithCString:class_getName([innerJSON class]) encoding:NSUTF8StringEncoding]);
		if ([innerJSON isKindOfClass:[NSArray class]]){
			NSArray *places = [JSON valueForKeyPath:@"features.properties.place"];
			NSLog(@"Places: %@", places);                  
			NSMutableArray *mutableItems = [NSMutableArray arrayWithCapacity:[innerJSON count]];
			for (NSDictionary *attributes in innerJSON) {
				//NSLog(@"Attribute: %@", attributes);
				NSLog(@"coordinates: %@", [attributes valueForKeyPath: @"geometry.coordinates"]);
				NSArray *coordinates = [attributes valueForKeyPath: @"geometry.coordinates"];
				float longitude = [[coordinates objectAtIndex:0] floatValue];
				float latitude = [[coordinates objectAtIndex:1] floatValue];
				float depth = [[coordinates objectAtIndex:2] floatValue];
				NSLog(@"longitude: %f", longitude);
				NSLog(@"latitude: %f", latitude);
				NSLog(@"depth: %f", depth);
				
				NSString *place = [attributes valueForKeyPath: @"properties.place"];
				NSLog(@"place: %@", place);
				NSLog(@"magnitude: %@", [attributes valueForKeyPath: @"properties.mag"]);
				int mag = [[attributes valueForKeyPath: @"properties.mag"] intValue];
				
				GeoEvent *event = [[GeoEvent alloc] initWithPlace: place magnitude:mag longitude:longitude andLatitude:latitude];
				event.mag = mag;
				
				[mutableItems addObject:event];
			}
			return mutableItems;
		}
	}
	else return nil;
}

@end
