//
//  PathViewController.h
//  Patrol
//
//  Created by Ｗinston on 7/21/15.
//  Copyright (c) 2015 Ｗinston. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface PathViewController : UIViewController <UISearchBarDelegate, MKMapViewDelegate,CLLocationManagerDelegate>
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) UISearchController *searchController;
@property(nonatomic, weak) id< UISearchResultsUpdating > searchResultsUpdater;


@end
