//
//  UserSettings.m
//  LiveQuake
//
//  Created by Massimo Chericoni on 11/22/12.
//  Copyright (c) 2012 Massimo Chericoni. All rights reserved.
//

#import "UserSettings.h"

@implementation UserSettings

@synthesize minimumDistance = _minimumDistance;
@synthesize minimumMagnitude = _minimumMagnitude;
@synthesize refreshDelay = _refreshDelay;

+ (id)sharedUserSettings
{
    static dispatch_once_t onceQueue;
    static UserSettings *userSettings = nil;
    
    dispatch_once(&onceQueue, ^{ userSettings = [[self alloc] init]; });
    return userSettings;
}

@end
