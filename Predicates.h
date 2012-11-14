//
//  Predicates.h
//  TestOne
//
//  Created by Massimo Chericoni on 11/4/12.
//  Copyright (c) 2012 Massimo Chericoni. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface Predicates : NSObject

@property (nonatomic, strong) CLLocation *currentLocation;
@property (nonatomic, assign) int magnitudeThreshold;

+ (Predicates*) getOne;
- (NSPredicate*) nearPredicate;
- (NSPredicate*) recentPredicate;
- (NSPredicate*) magnitudePredicate;

@end
