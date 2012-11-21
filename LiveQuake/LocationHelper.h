//
//  LocationHelper.h
//  LiveQuake
//
//  Created by Massimo Chericoni on 11/19/12.
//  Copyright (c) 2012 Massimo Chericoni. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface LocationHelper : NSObject

+(double)distanceBetweenLocation:(CLLocationCoordinate2D) location1 andLocation:(CLLocationCoordinate2D) location2;

@end
