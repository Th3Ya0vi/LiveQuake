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

static NSThread *monitor    = NULL;
static NSArray  *geoEvents      = NULL;
static NSString *fileName   = NULL;

@implementation USGSMonitor

+(NSArray*)currentEvents{
    return geoEvents;
}

+(NSArray*)getCachedCopy{
    // NSDictionary back from the stored NSData
    NSData *data = [NSData dataWithContentsOfFile:fileName];
    //    NSString *feedXML = [[[NSString alloc] initWithData:data encoding:NSStringEncodingConversionAllowLossy] autorelease];
    //    if(feedXML){
    //        return [self parseXML:feedXML];
    //    }
    return nil;
}

+(void)keepMonitoring{
    NSLog(@"keepMonitoring");
    while(![[NSThread currentThread]  isCancelled]){
        if(!geoEvents){
            geoEvents = [self getCachedCopy];
            NSDate *modificationDate = [[[NSFileManager defaultManager] attributesOfItemAtPath:fileName error:nil] objectForKey:NSFileModificationDate];
            if(geoEvents){
                NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:geoEvents, @"spots", modificationDate, @"date", nil];
                [[NSNotificationCenter defaultCenter] postNotificationName:USGS_UPDATE object:dict];
            }
        }
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = true;
        NSURL *url = [NSURL URLWithString:USGS_URL];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        
        AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
            
			// Check the returned object
			if([JSON respondsToSelector:@selector(messageIWishToSend)]){
				id innerJSON = [JSON objectForKey:@"features"];
				// Again, check that we have an NSDictionary
				if ([innerJSON isMemberOfClass:[NSDictionary class]]){
                    
                    
                    
                    
                    NSArray *places = [JSON valueForKeyPath:@"features.properties.place"];
                    NSLog(@"Places: %@", places);
                    
                    //             if(places != nil){
                    //                [places writeToFile:fileName  atomically:YES encoding:NSStringEncodingConversionAllowLossy error:nil];
                    //            }
                    
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
                        int mag = [[attributes valueForKeyPath: @"properties.mag"] intValue];
                        
                        GeoEvent *event = [[GeoEvent alloc] initWithPlace: place magnitude:mag longitude:longitude andLatitude:latitude];
                        event.mag = mag;
                        
                        [mutableItems addObject:event];
                    }
                    
                    if(mutableItems!= nil){
                        geoEvents = mutableItems;
                        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:geoEvents, @"events", [NSDate date], @"date", nil];
                        
                        // -> NSData and write to file (only the events)
                        
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
