//
//  StatisticViewController.m
//  Patrol
//
//  Created by Ｗinston on 7/21/15.
//  Copyright (c) 2015 Ｗinston. All rights reserved.
//

#import "StatisticViewController.h"

@interface StatisticViewController ()

@end

@implementation StatisticViewController
@synthesize scrollView;
- (void)viewDidLoad {
    [super viewDidLoad];
    scrollView.contentSize=CGSizeMake(357, 900);
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
