//
//  USGSParser.m
//  LiveQuake
//
//  Created by Massimo Chericoni on 11/27/12.
//  Copyright (c) 2012 Massimo Chericoni. All rights reserved.
//

#import "USGSParser.h"
#import "GeoEvent.h"

@implementation USGSParser

+(NSArray*)parseEvents:(id)feed{
	if([feed respondsToSelector:@selector(objectForKey:)]){
		id innerJSON = [feed objectForKey:@"features"];
		// Check that we have an NSArray
		NSLog(@"%@", [NSString stringWithCString:class_getName([innerJSON class]) encoding:NSUTF8StringEncoding]);
		if ([innerJSON isKindOfClass:[NSArray class]]){
			NSArray *places = [feed valueForKeyPath:@"features.properties.place"];
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
				event.depth = depth;
                event.url = [attributes valueForKeyPath: @"properties.url"];
                
                NSString *eventTime = [attributes valueForKeyPath: @"properties.time"];
                // (Step 1) Convert event time to SECONDS since 1970
                NSTimeInterval seconds = [eventTime doubleValue];
                NSLog (@"Epoch time %@ equates to %qi seconds since 1970", eventTime, (long long) seconds);
                
                // (Step 2) Create NSDate object
                NSDate *epochNSDate = [[NSDate alloc] initWithTimeIntervalSince1970:seconds];
                NSLog (@"Epoch time %@ equates to UTC %@", eventTime, epochNSDate);
                
                event.eventTime = epochNSDate;
                
				[mutableItems addObject:event];
			}
			return mutableItems;
		}
	}
	return nil;
}

@end
