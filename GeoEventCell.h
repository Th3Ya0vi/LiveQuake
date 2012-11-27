//
//  GeoEventCell.h
//  TestOne
//
//  Created by Massimo Chericoni on 11/6/12.
//  Copyright (c) 2012 Massimo Chericoni. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GeoEventCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel *placeLabel;
@property (nonatomic, strong) IBOutlet UILabel *magnitudeLabel;
@property (weak, nonatomic) IBOutlet UILabel *eventTimeLabel;

@end
