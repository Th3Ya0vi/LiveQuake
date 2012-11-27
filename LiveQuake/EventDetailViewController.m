//
//  EventDetailViewController.m
//  TestOne
//
//  Created by Massimo Chericoni on 10/22/12.
//  Copyright (c) 2012 Massimo Chericoni. All rights reserved.
//

#import "EventDetailViewController.h"

@interface EventDetailViewController ()

@end

@implementation EventDetailViewController

@synthesize geoEvent;
@synthesize mapView;
@synthesize depthLabel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    NSLog(@"Detail did load: %f", geoEvent.coordinate.latitude);
    MKCoordinateRegion region;
    region.center.latitude = geoEvent.coordinate.latitude;
    region.center.longitude = geoEvent.coordinate.longitude;
    region.span.latitudeDelta = 10;
    region.span.longitudeDelta = 10;
    [mapView setRegion:region animated:YES];
    //mapView.region = region;
    mapView.showsUserLocation=NO;
    [mapView addAnnotation: geoEvent];
    
    depthLabel.text = [NSString stringWithFormat:@"Depth: %f", geoEvent.depth];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)sendTo:(id)sender {
    UIActionSheet *act = [[UIActionSheet alloc]
                          initWithTitle:@"Menu"
                          delegate:self
                          cancelButtonTitle:@"Cancel"
                          destructiveButtonTitle:nil
                          otherButtonTitles:@"Send to Twitter", nil];
    
    [act showFromBarButtonItem:self.btnSendTo animated:YES];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"Button pressed: %d", buttonIndex);
} //actionSheet:clickedButtonAtIndex:

@end
