//
//  USGSMonitor.h
//  TestOne
//
//  Created by Massimo Chericoni on 10/18/12.
//  Copyright (c) 2012 Massimo Chericoni. All rights reserved.
//

#import <Foundation/Foundation.h>

#define USGS_UPDATE @"USGS_UPDATE"
#define USGS_URL @"http://earthquake.usgs.gov/earthquakes/feed/geojson/all/hour"
//#define USGS_URL @"http://earthquake.usgs.gov/earthquakes/feed/geojson/2.5/day"

@interface USGSMonitor : NSObject
+ (void) startMonitor;
+ (void) stopMonitor;
@end
