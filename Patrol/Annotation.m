//
//  Annotation.m
//  MyFirstObejApp
//
//  Created by Ｗinston on 7/13/15.
//  Copyright (c) 2015 Ｗinston. All rights reserved.
//

#import "Annotation.h"

@interface Annotation ()

@end

@implementation Annotation
@synthesize myCoordinate, myTitle, mySubTitle;

- (CLLocationCoordinate2D)coordinate;
{
    return self.myCoordinate;
}

- (NSString *)title
{
    return self.myTitle;
}

- (NSString *)subtitle
{
    return self.mySubTitle;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
