//
//  GeoEventCell.m
//  TestOne
//
//  Created by Massimo Chericoni on 11/6/12.
//  Copyright (c) 2012 Massimo Chericoni. All rights reserved.
//

#import "GeoEventCell.h"

@implementation GeoEventCell

@synthesize placeLabel;
@synthesize magnitudeLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
