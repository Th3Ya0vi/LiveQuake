//
//  GeoEvent.m
//  TestOne
//
//  Created by Massimo Chericoni on 10/18/12.
//  Copyright (c) 2012 Massimo Chericoni. All rights reserved.
//

#import "GeoEvent.h"
#import "Predicates.h"

@implementation GeoEvent

@synthesize place=_place;
@synthesize mag=_mag;
@synthesize coordinate;
@synthesize title;
@synthesize subTitle;

-(id)initWithPlace:(NSString*) place magnitude:(int) mag longitude:(float) longitude andLatitude:(float) latitude {
    if (self = [super init]){
        _place = [place copy];
        coordinate = CLLocationCoordinate2DMake(latitude, longitude);
        _mag = mag;
        title = place;
        subTitle = [NSString stringWithFormat:@"%d", mag];;
    }
    return self;
}

-(BOOL)isNearMe
{
    return [self distanceFromLocation:coordinate toLocation:[Predicates getOne].currentLocation.coordinate] < 100;
}

-(BOOL)isRecent
{
    return YES;
}

-(BOOL)hasAtLeastMagnitude
{
    return (self.mag >= 4);
}

//TODO: Move into util class
-(double)distanceFromLocation:(CLLocationCoordinate2D) location1 toLocation:(CLLocationCoordinate2D) location2
{
    double latitude1, longitude1, latitude2, longitude2;
    double pi = 3.14159265358979323846;
    latitude1 = location1.latitude;
    longitude1 = location1.longitude;
    latitude2 = location2.latitude;
    longitude2 = location2.longitude;
    double d = sin(latitude1 * pi/180) * sin(latitude2 * pi/180) + cos(latitude1 * pi/180) * cos(latitude2 * pi/180) * cos(abs((longitude2 * pi/180) - (longitude1 * pi/180)));
    d = atan((sqrt(1 - pow(d, 2)))/d);
    d = (1.852 * 60.0 * ((d/pi)*180)) / 1.609344;
    NSLog(@"distance from %@: %f", self.place, d);
    return d;
}

@end
