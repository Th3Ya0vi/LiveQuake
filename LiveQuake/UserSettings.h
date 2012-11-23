//
//  UserSettings.h
//  LiveQuake
//
//  Created by Massimo Chericoni on 11/22/12.
//  Copyright (c) 2012 Massimo Chericoni. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserSettings : NSObject

@property (nonatomic) int minimumDistance;
@property (nonatomic) int minimumMagnitude;
@property (nonatomic) int refreshDelay;

@end
