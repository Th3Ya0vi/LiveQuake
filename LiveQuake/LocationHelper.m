//
//  LocationHelper.m
//  LiveQuake
//
//  Created by Massimo Chericoni on 11/19/12.
//  Copyright (c) 2012 Massimo Chericoni. All rights reserved.
//

#import "LocationHelper.h"

@implementation LocationHelper

+(double)distanceBetweenLocation:(CLLocationCoordinate2D) location1 andLocation:(CLLocationCoordinate2D) location2
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
    NSLog(@"distance is: %f", d);
    
    return fabs(d);
} //distanceBetweenLocation:andLocation:

@end
