//
//  MapViewController.m
//  Patrol
//
//  Created by Ｗinston on 7/14/15.
//  Copyright (c) 2015 Ｗinston. All rights reserved.
//
#import "CHCSVParser.h"
#import "MapViewController.h"
#import "Annotation.h"
#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

@interface MapViewController ()

@end

@implementation MapViewController
@synthesize mapView;
- (void)viewDidLoad {
    
    #ifdef __IPHONE_8_0
        if(IS_OS_8_OR_LATER) {
            [self.locationManager requestAlwaysAuthorization];
        }
    #endif
 
    // for iOS 8.0 later configuration
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

    // Map config
    self.mapView.delegate = self;
    self.mapView.showsUserLocation = YES;
    [self.mapView setMapType:MKMapTypeStandard];
    [self.mapView setZoomEnabled:YES];
    [self.mapView setScrollEnabled:YES];
    
    
    // location config
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [self.locationManager startUpdatingLocation];

     NSBundle *bundle = [NSBundle bundleForClass:[self class]];
     NSURL *fileURL = [bundle URLForResource:@"trafficStatistics" withExtension:@"csv"];
     NSArray *rows = [NSArray arrayWithContentsOfCSVURL:fileURL];  // stupid method name, misleading me
     NSMutableArray *annotations = [[NSMutableArray alloc] init];

    if (rows == nil) {
        NSLog(@"error parsing file");
        return;
    }
    
    for (NSArray* currentArray in rows) {
        NSString *currentString = [currentArray componentsJoinedByString:@" "];
        NSArray *partOneArray = [currentString  componentsSeparatedByString:@" "];
        double dataLatitude = [[partOneArray objectAtIndex:6] doubleValue];
        double dataLongtitude = [[partOneArray objectAtIndex:7] doubleValue];
        NSLog(@"L:%f",dataLatitude);
        NSLog(@"S:%f",dataLongtitude);
        
            Annotation *annotation = [[Annotation alloc] init];
            CLLocationCoordinate2D coordinate;
            
            coordinate.latitude = dataLatitude;
            coordinate.longitude = dataLongtitude;
        
            annotation.myCoordinate = coordinate;
            annotation.myTitle = [NSString stringWithFormat:@"I am annotation title "];
            annotation.mySubTitle = [NSString stringWithFormat:@"I am annotation subtitle"];
            [annotations addObject:annotation];
        
            [self.mapView addAnnotations:annotations];
    }

    
    
    // show the initial map
    MKCoordinateRegion region;
    region.center.latitude = 25.03;   // Taipei City
    region.center.longitude = 121.5;
    region.span.latitudeDelta = 0.2;
    region.span.longitudeDelta = 0.2;
    
    //[self.mapView setRegion:region animated:YES];
    
    
    //NSMutableArray *annotations = [[NSMutableArray alloc] init];
    /*
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
     */
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(currentPosition, 600, 400);
    [self.mapView setRegion:[self.mapView regionThatFits:region] animated:YES];
}

@end
