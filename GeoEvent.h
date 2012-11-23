//
//  GeoEvent.h
//  TestOne
//
//  Created by Massimo Chericoni on 10/18/12.
//  Copyright (c) 2012 Massimo Chericoni. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface GeoEvent : NSObject <MKAnnotation, NSCoding>
#pragma mark - TODO Add properties -> Keyed Archiving
{
	int depth;
	NSString *url;
	NSDate *eventTime;
}

@property(nonatomic, copy) NSString *place;
@property(nonatomic, assign) int mag;
@property(nonatomic, readonly) CLLocationCoordinate2D coordinate;

-(id)initWithPlace:(NSString*) place magnitude:(int) mag longitude:(float) longitude andLatitude:(float) latitude;

-(BOOL)isNearMe;
-(BOOL)isRecent;
-(BOOL)hasAtLeastMagnitude;

@end
