//
//  GeoEventsViewController.h
//  TestOne
//
//  Created by Massimo Chericoni on 10/22/12.
//  Copyright (c) 2012 Massimo Chericoni. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface GeoEventsViewController : UITableViewController <CLLocationManagerDelegate>
{
    CLLocationManager *locationMgr;
    NSUInteger			noUpdates;
    NSMutableArray *nonFilteredGeoEvents;
}

@property (nonatomic, strong) NSMutableArray *geoEvents;
@property (nonatomic, strong) IBOutlet UISegmentedControl *segmentedControl;

- (IBAction)button:(id)sender;
- (IBAction)segmentChanged:(id)sender;

@end
