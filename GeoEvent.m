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
@synthesize depth = _depth;
@synthesize url = _url;
@synthesize eventTime = _eventTime;

-(id)initWithPlace:(NSString*) place magnitude:(int) mag longitude:(float) longitude andLatitude:(float) latitude {
    if (self = [super init]){
        _place = [place copy];
        _coordinate = CLLocationCoordinate2DMake(latitude, longitude);
        _mag = mag;
    }
    return self;
}

// TODO: Use UserSettings

-(BOOL)isNearMe
{
    return [LocationHelper distanceBetweenLocation:_coordinate andLocation:[Predicates getOne].currentLocation.coordinate] < 100;
}

-(BOOL)isRecent
{
    return [self.eventTime timeIntervalSinceNow] < (60 * 30);
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
    [encoder encodeFloat:self.depth forKey:@"depth"];
    [encoder encodeObject:self.url forKey:@"url"];
    [encoder encodeObject:self.eventTime forKey:@"eventTime"];
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
        self.depth = [decoder decodeFloatForKey:@"depth"];
        self.url = [decoder decodeObjectForKey:@"url"];
        self.eventTime = [decoder decodeObjectForKey:@"eventTime"];
    }
    return self;
}

@end
