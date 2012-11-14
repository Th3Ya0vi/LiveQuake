//
//  Predicates.m
//  TestOne
//
//  Created by Massimo Chericoni on 11/4/12.
//  Copyright (c) 2012 Massimo Chericoni. All rights reserved.
//

#import "Predicates.h"

@implementation Predicates

@synthesize currentLocation;
@synthesize magnitudeThreshold;

+ (Predicates*) getOne {
    static Predicates* _one = nil;
    
    @synchronized( self ) {
        if( _one == nil ) {
            _one = [[ Predicates alloc ] init ];
            //FIXME: set threshold elsewhere
            _one.magnitudeThreshold = 4;
        }
    }
    
    return _one;
}

- (NSPredicate*) nearPredicate
{
    NSPredicate *nearPred = [NSPredicate predicateWithFormat:
                              @"SELF.isNearMe == YES"];
    return nearPred;
}

- (NSPredicate*) recentPredicate
{
    //TODO: compare dates
    NSPredicate *recentPred = [NSPredicate predicateWithFormat:
                             @"SELF.isRecent == YES"];
    return recentPred;
}

- (NSPredicate*) magnitudePredicate
{
    NSPredicate *magPred = [NSPredicate predicateWithFormat:
                            @"SELF.hasAtLeastMagnitude == YES"];
    return magPred;
}

@end
