//
//  MapController.m
//  MyFirstObejApp
//
//  Created by Ｗinston on 7/3/15.
//  Copyright (c) 2015 Ｗinston. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PathViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "Annotation.h"
#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
@interface PathViewController() <UISearchResultsUpdating, UISearchBarDelegate>

@end

@implementation PathViewController{
    MKLocalSearch *localSearch;
    MKLocalSearchResponse *results;
    MKDirectionsRequest *directionsRequest;
    
}
@synthesize locationManager;
@synthesize mapView;
@synthesize searchBar;


- (void)viewDidLoad {
    
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    
#ifdef __IPHONE_8_0
    if(IS_OS_8_OR_LATER){
        [self.locationManager requestAlwaysAuthorization];
    }
#endif
    if([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]){
        NSUInteger code = [CLLocationManager authorizationStatus];
        if (code == kCLAuthorizationStatusNotDetermined && ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)] || [self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)])) {
            // choose one request according to your business.
            if([[NSBundle mainBundle] objectForInfoDictionaryKey:@"NSLocationAlwaysUsageDescription"]){
                [self.locationManager requestAlwaysAuthorization];
            } else if([[NSBundle mainBundle] objectForInfoDictionaryKey:@"NSLocationWhenInUseUsageDescription"]) {
                [self.locationManager  requestWhenInUseAuthorization];
            } else {
                NSLog(@"Info.plist does not contain NSLocationAlwaysUsageDescription or NSLocationWhenInUseUsageDescription");
            }
        }
    }
    // search config
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.searchResultsUpdater = self;
    self.searchController.searchBar.delegate = self;
    
    // location(GPS) config
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [self.locationManager startUpdatingLocation];
    
    // Map config
    self.mapView.delegate = self;
    self.mapView.showsUserLocation = YES;
    [self.mapView setMapType:MKMapTypeStandard];
    [self.mapView setZoomEnabled:YES];
    [self.mapView setScrollEnabled:YES];
    
    if([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]){
        NSUInteger code = [CLLocationManager authorizationStatus];
        if (code == kCLAuthorizationStatusNotDetermined && ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)] || [self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)])) {
            // choose one request according to your business.
            if([[NSBundle mainBundle] objectForInfoDictionaryKey:@"NSLocationAlwaysUsageDescription"]){
                [self.locationManager requestAlwaysAuthorization];
            } else if([[NSBundle mainBundle] objectForInfoDictionaryKey:@"NSLocationWhenInUseUsageDescription"]) {
                [self.locationManager  requestWhenInUseAuthorization];
            } else {
                NSLog(@"Info.plist does not contain NSLocationAlwaysUsageDescription or NSLocationWhenInUseUsageDescription");
            }
        }
    }
    /*directionsRequest = [MKDirectionsRequest new];
     CLLocationCoordinate2D sourceCoords = CLLocationCoordinate2DMake(25.1, 121.55);
     MKPlacemark *sourcePlacemark = [[MKPlacemark alloc] initWithCoordinate:sourceCoords addressDictionary:nil];
     MKMapItem *source = [[MKMapItem alloc] initWithPlacemark:sourcePlacemark];
     // Make the destination
     CLLocationCoordinate2D destinationCoords = CLLocationCoordinate2DMake(25.016959, 121.538530);
     MKPlacemark *destinationPlacemark = [[MKPlacemark alloc] initWithCoordinate:destinationCoords addressDictionary:nil];
     MKMapItem *destination = [[MKMapItem alloc] initWithPlacemark:destinationPlacemark];
     // Set the source and destination on the request
     [directionsRequest setSource:source];
     [directionsRequest setDestination:destination];
     
     MKDirections *directions = [[MKDirections alloc] initWithRequest:directionsRequest];
     [directions calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse *response, NSError *error) {
     // Handle the response here
     if (error) {
     NSLog(@"There was an error getting your directions");
     return;
     }
     
     [self plotRouteOnMap:[response.routes firstObject]];
     }];
     */
    
    
    MKCoordinateRegion region;
    region.center.latitude = self.mapView.userLocation.coordinate.latitude;   // Taipei City
    region.center.longitude = self.mapView.userLocation.coordinate.longitude;
    region.span.latitudeDelta = 0.2;
    region.span.longitudeDelta = 0.2;
    
    NSLog(@"%f",    self.mapView.userLocation.coordinate.latitude);
    NSLog(@"%f",    self.mapView.userLocation.coordinate.longitude);
    [self.mapView setRegion:region animated:YES];
    NSMutableArray *annotations = [[NSMutableArray alloc] init];
    
    for (int i = 1; i <= 30; i++){
        Annotation *annotation = [[Annotation alloc] init];
        CLLocationCoordinate2D coordinate;
        if (i % 4 == 0){
            coordinate.latitude = mapView.centerCoordinate.latitude + (float)(arc4random() % 100) / 1000;
            coordinate.longitude = mapView.centerCoordinate.longitude + (float)(arc4random() % 100) / 1000;
        }else if(i % 4 == 1){
            coordinate.latitude = mapView.centerCoordinate.latitude - (float)(arc4random() % 100) / 1000;
            coordinate.longitude = mapView.centerCoordinate.longitude - (float)(arc4random() % 100) / 1000;
        }else if(i % 4 == 2){
            coordinate.latitude = mapView.centerCoordinate.latitude + (float)(arc4random() % 100) / 1000;
            coordinate.longitude = mapView.centerCoordinate.longitude - (float)(arc4random() % 100) / 1000;
        }else{
            coordinate.latitude = mapView.centerCoordinate.latitude - (float)(arc4random() % 100) / 1000;
            coordinate.longitude = mapView.centerCoordinate.longitude + (float)(arc4random() % 100) / 1000;
        }
        
        annotation.myCoordinate = coordinate;
        annotation.myTitle = [NSString stringWithFormat:@"I am annotation title %i", i];
        annotation.mySubTitle = [NSString stringWithFormat:@"I am annotation subtitle %i", i];
        [annotations addObject:annotation];
    }
    
    [self.mapView addAnnotations:annotations];
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];   //translate long&lati from address
    [geocoder geocodeAddressString:@"National Taiwan University"
                 completionHandler:^(NSArray* placemarks, NSError* error){
                     
                     
                     CLPlacemark *placemark = [placemarks firstObject];
                     Annotation *annotation = [[Annotation alloc] init];
                     annotation.myCoordinate = placemark.location.coordinate;
                     annotation.myTitle = [NSString stringWithFormat:@"NTU"];
                     annotation.mySubTitle = [NSString stringWithFormat:@"National Taiwan U"];
                     [annotations addObject:annotation];
                     
                     MKCoordinateRegion region;
                     region.center.latitude = placemark.location.coordinate.latitude;   // Taipei City
                     region.center.longitude = placemark.location.coordinate.longitude;
                     region.span.latitudeDelta = 0.05;
                     region.span.longitudeDelta = 0.05;
                     //  NSLog(@"%f",region.center.latitude);
                     //NSLog(@"%f",region.center.longitude);
                     
                     //  [self.mapView setRegion:region animated:YES];
                     
                     [self.mapView addAnnotations:annotations];
                     
                 }];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    NSLog(@"%@", [locations lastObject]);
}
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    double X= userLocation.coordinate.latitude;
    double Y= userLocation.coordinate.longitude;
    
    NSLog(@"%f,%f",X,Y);
    
    CLLocationCoordinate2D currentPosition = [userLocation coordinate];
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(currentPosition, 800, 800);
    [self.mapView setRegion:[self.mapView regionThatFits:region] animated:YES];
}


- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"didUpdateToLocation: %@", newLocation);
    CLLocation *currentLocation = newLocation;
    
    if (currentLocation != nil) {
        NSLog(@"%.8f", currentLocation.coordinate.longitude);
        NSLog(@"%.8f", currentLocation.coordinate.latitude);
    }
    
    // Stop Location Manager
    [locationManager stopUpdatingLocation];
    
    
}

- (IBAction)setMap:(id)sender {
    
    switch (((UISegmentedControl *) sender).selectedSegmentIndex) {
        case 0:
            self.mapView.mapType = MKMapTypeStandard;
            break;
        case 1:
            self.mapView.mapType = MKMapTypeSatellite;
            break;
        case 2:
            self.mapView.mapType = MKMapTypeHybrid;
            break;
        default:
            break;
    }
}
/*
 if (searchBar.text!= NULL) {
 NSString *location = searchBar.text;
 CLGeocoder *geocoder = [[CLGeocoder alloc] init];
 [geocoder geocodeAddressString:location
 completionHandler:^(NSArray* placemarks, NSError* error){
 if (placemarks && placemarks.count > 0) {
 CLPlacemark *topResult = [placemarks objectAtIndex:0];
 MKPlacemark *placemark = [[MKPlacemark alloc] initWithPlacemark:topResult];
 MKCoordinateRegion region = self.mapView.region;
 region.center = [(CLCircularRegion *)placemark.region center];
 //region.center = placemark.region.center;
 region.span.longitudeDelta /= 8.0;
 region.span.latitudeDelta /= 8.0;
 
 [self.mapView setRegion:region animated:YES];
 [self.mapView addAnnotation:placemark];
 }
 }
 ];
 }
 */

#pragma mark - Search Methods

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    // Cancel any previous searches.
    [localSearch cancel];
    // Perform a new search.
    MKLocalSearchRequest *request = [[MKLocalSearchRequest alloc] init];
    request.naturalLanguageQuery = searchBar.text;
    request.region = self.mapView.region;
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    localSearch = [[MKLocalSearch alloc] initWithRequest:request];
    [localSearch startWithCompletionHandler:^(MKLocalSearchResponse *response, NSError *error){
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        if (error != nil) {
            [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Map Error",nil)
                                        message:[error localizedDescription]
                                       delegate:nil
                              cancelButtonTitle:NSLocalizedString(@"OK",nil) otherButtonTitles:nil] show];
            return;
        }
        
        if ([response.mapItems count] == 0) {
            [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"No Results",nil)
                                        message:nil
                                       delegate:nil
                              cancelButtonTitle:NSLocalizedString(@"OK",nil) otherButtonTitles:nil] show];
            return;
        }
        
        results = response;
        
        [self.searchDisplayController.searchResultsTableView reloadData];
    }];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [results.mapItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *IDENTIFIER = @"SearchResultsCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:IDENTIFIER];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:IDENTIFIER];
    }
    
    MKMapItem *item = results.mapItems[indexPath.row];
    
    cell.textLabel.text = item.name;
    cell.detailTextLabel.text = item.placemark.addressDictionary[@"Street"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.searchDisplayController setActive:NO animated:YES];
    MKMapItem *item = results.mapItems[indexPath.row];
    [self.mapView addAnnotation:item.placemark];
    [self.mapView setCenterCoordinate:item.placemark.location.coordinate animated:YES];
    [self.mapView setUserTrackingMode:MKUserTrackingModeNone];
    
    directionsRequest = [MKDirectionsRequest new];
    CLLocationCoordinate2D sourceCoords = CLLocationCoordinate2DMake(25.016959, 121.538530);
    MKPlacemark *sourcePlacemark = [[MKPlacemark alloc] initWithCoordinate:sourceCoords addressDictionary:nil];
    MKMapItem *source = [[MKMapItem alloc] initWithPlacemark:sourcePlacemark];
    // Make the destination
    
    // Set the source and destination on the request
    [directionsRequest setSource:source];
    [directionsRequest setDestination:item];
    
    MKDirections *directions = [[MKDirections alloc] initWithRequest:directionsRequest];
    [directions calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse *response, NSError *error) {
        // Handle the response here
        if (error) {
            NSLog(@"There was an error getting your directions");
            return;
        }
        
        [self plotRouteOnMap:[response.routes firstObject]];
    }];
    
}
- (void)searchBar:(UISearchBar *)searchBar selectedScopeButtonIndexDidChange:(NSInteger)selectedScope {
    [self updateSearchResultsForSearchController:self.searchController];
}

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController{
}

//draw a line


- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay
{
    MKPolylineRenderer *renderer = [[MKPolylineRenderer alloc] initWithPolyline:overlay];
    renderer.strokeColor = [UIColor greenColor];
    renderer.lineWidth = 4.0;
    return  renderer;
}

- (void)plotRouteOnMap:(MKRoute *)route
{
    [self.mapView addOverlay:route.polyline];
    NSLog(@"%@",route.steps);
}
@end