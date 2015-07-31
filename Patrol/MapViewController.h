//
//  MapViewController.h
//  Patrol
//
//  Created by Ｗinston on 7/14/15.
//  Copyright (c) 2015 Ｗinston. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface MapViewController : UIViewController<CLLocationManagerDelegate, MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) UISearchController *searchController;
@property(nonatomic, weak) id< UISearchResultsUpdating > searchResultsUpdater;
@end
