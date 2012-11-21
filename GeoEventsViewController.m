//
//  GeoEventsViewController.m
//  TestOne
//
//  Created by Massimo Chericoni on 10/22/12.
//  Copyright (c) 2012 Massimo Chericoni. All rights reserved.
//

#import "GeoEventsViewController.h"
#import "USGSMonitor.h"
#import "GeoEvent.h"
#import "GeoEventCell.h"
#import "EventDetailViewController.h"
#import "Predicates.h"

@interface GeoEventsViewController ()

@end

@implementation GeoEventsViewController

@synthesize geoEvents;
@synthesize segmentedControl;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    noUpdates = 0;
    locationMgr = [[CLLocationManager alloc] init];
    locationMgr.delegate = self;
    [locationMgr startUpdatingLocation];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(feedUpdate:) name:USGS_UPDATE object:nil];
    [USGSMonitor startMonitor];
}

-(void)feedUpdate:(NSNotification*)notification{
    NSLog(@"feedUpdate");
    NSDictionary *dict = notification.object;
    NSMutableArray *arr = [dict objectForKey:@"events"];
    NSDate *date = [dict objectForKey:@"date"];
    if(arr!=nil){
        nonFilteredGeoEvents = arr;
        [self applyPredicate];
    }
}

-(void)applyPredicate
{
    self.geoEvents = [nonFilteredGeoEvents mutableCopy];

    NSPredicate *aPred;
    if ([segmentedControl selectedSegmentIndex] == 0)
        aPred = [Predicates getOne].recentPredicate;
    else if ([segmentedControl selectedSegmentIndex] == 1)
        aPred = [Predicates getOne].nearPredicate;
    else
        aPred = [Predicates getOne].magnitudePredicate;
    
    [self.geoEvents filterUsingPredicate: aPred];
    
    NSLog(@"geoEvents count %d", [self.geoEvents count]);
    if ([self.geoEvents count] > 0){
        NSLog([[self.geoEvents objectAtIndex: 0] place]);
    }
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return [self.geoEvents count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"GeoEventCell";
    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    // FIXME: iOS 6
    GeoEventCell *cell = (GeoEventCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    
    GeoEvent *geoEvent = [self.geoEvents objectAtIndex:indexPath.row];
    cell.placeLabel.text = geoEvent.place;
    cell.magnitudeLabel.text = [NSString stringWithFormat:@"%d", geoEvent.mag];
    cell.magnitudeLabel.textColor = [UIColor blackColor]; // default
    if (geoEvent.mag >=2)
        cell.magnitudeLabel.textColor = [UIColor blueColor];
    return cell;
}

-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    //[self performSegueWithIdentifier:@"showEventDetail" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showEventDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        GeoEvent *event = [geoEvents objectAtIndex:indexPath.row];
        EventDetailViewController *destViewController = segue.destinationViewController;
        destViewController.geoEvent = event;
    }
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

- (IBAction)button:(id)sender
{
    NSLog(@"Generic button");
}

- (IBAction)segmentChanged:(id)sender
{
    NSLog(@"segmentChanged button %@", NSStringFromClass([sender class]));
    if (sender==segmentedControl)
    {
        NSLog(@"Selected index: %d",[segmentedControl selectedSegmentIndex]);
        [self applyPredicate];
    }
}

- (IBAction)refresh:(id)sender {
    NSLog(@"Refresh button");
}

- (void)locationManager:(CLLocationManager *)manager
	didUpdateToLocation:(CLLocation *)newLocation
		   fromLocation:(CLLocation *)oldLocation{
	noUpdates++;
	if(noUpdates >= 10){
		[locationMgr stopUpdatingLocation];
	}
	[self updateLocation: newLocation];
}

-(void) updateLocation:(CLLocation*) update{
    NSLog(@"Update #:%i\n", noUpdates);
    [Predicates getOne].currentLocation = update;
    NSLog(@"Setting location: %@", [update description]);
}

@end
