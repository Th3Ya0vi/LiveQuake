//
//  GeoEventParser.h
//  LiveQuake
//
//  Created by Massimo Chericoni on 11/27/12.
//  Copyright (c) 2012 Massimo Chericoni. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol GeoEventParser <NSObject>

+(NSArray*)parseEvents:(id)feed;

@end
