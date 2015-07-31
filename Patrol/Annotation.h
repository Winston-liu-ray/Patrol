//
//  Annotation.h
//  MyFirstObejApp
//
//  Created by Ｗinston on 7/13/15.
//  Copyright (c) 2015 Ｗinston. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface Annotation : NSObject <MKAnnotation> {
    CLLocationCoordinate2D myCoordinate;
    NSString *myTitle;
    NSString *mySubTitle;
}

@property(assign, nonatomic) CLLocationCoordinate2D myCoordinate;
@property(retain, nonatomic) NSString *myTitle;
@property(retain, nonatomic) NSString *mySubTitle;

@end