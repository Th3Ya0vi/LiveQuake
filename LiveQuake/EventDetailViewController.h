//
//  EventDetailViewController.h
//  TestOne
//
//  Created by Massimo Chericoni on 10/22/12.
//  Copyright (c) 2012 Massimo Chericoni. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "GeoEvent.h"

@interface EventDetailViewController : UIViewController <UIActionSheetDelegate>

@property (nonatomic) GeoEvent *geoEvent;
@property (nonatomic, strong) IBOutlet MKMapView *mapView;
@property (nonatomic, strong) IBOutlet UILabel *depthLabel;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *btnSendTo;

- (IBAction)sendTo:(id)sender;

@end
