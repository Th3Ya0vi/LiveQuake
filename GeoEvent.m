//
//  GeoEvent.m
//  TestOne
//
//  Created by Massimo Chericoni on 10/18/12.
//  Copyright (c) 2012 Massimo Chericoni. All rights reserved.
//

#import "GeoEvent.h"
#import "Predicates.h"
#import "LocationHelper.h"

@implementation GeoEvent

@synthesize place=_place;
@synthesize mag=_mag;
@synthesize coordinate=_coordinate;

-(id)initWithPlace:(NSString*) place magnitude:(int) mag longitude:(float) longitude andLatitude:(float) latitude {
    if (self = [super init]){
        _place = [place copy];
        _coordinate = CLLocationCoordinate2DMake(latitude, longitude);
        _mag = mag;
    }
    return self;
}

-(BOOL)isNearMe
{
    return [LocationHelper distanceBetweenLocation:_coordinate andLocation:[Predicates getOne].currentLocation.coordinate] < 100;
}

-(BOOL)isRecent
{
    return YES;
}

-(BOOL)hasAtLeastMagnitude
{
    return (self.mag >= 4);
}


//===========================================================
//  Keyed Archiving
//
//===========================================================
- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.place forKey:@"place"];
    [encoder encodeInt:self.mag forKey:@"mag"];
    [encoder encodeFloat:self.coordinate.latitude forKey:@"latitude"];
    [encoder encodeFloat:self.coordinate.longitude forKey:@"longitude"];
}

- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super init];
    if (self) {
        self.place = [decoder decodeObjectForKey:@"place"];
        self.mag = [decoder decodeIntForKey:@"mag"];
        float latitude = [decoder decodeFloatForKey:@"latitude"];
        float longitude = [decoder decodeFloatForKey:@"longitude"];
        _coordinate = CLLocationCoordinate2DMake(latitude, longitude);
    }
    return self;
}

@end
