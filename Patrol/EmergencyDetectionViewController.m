//
//  EmergencyDetectionViewController.m
//  Patrol
//
//  Created by Ｗinston on 7/21/15.
//  Copyright (c) 2015 Ｗinston. All rights reserved.
//

#import "EmergencyDetectionViewController.h"
@interface EmergencyDetectionViewController ()

@end

@implementation EmergencyDetectionViewController
@synthesize vibration;
@synthesize volumn;
@synthesize detectionResult;
@synthesize systemSwitch;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    [systemSwitch addTarget:self
                     action:@selector(outputAccelertionData:)
           forControlEvents:UIControlEventValueChanged];
    

     AccelX_threshold = 0.1;
     AccelY_threshold = 0.1;
     AccelZ_threshold = 0.1;
     RotX_threshold = 0.1;
     RotY_threshold = 0.1;
     RotZ_threshold = 0.1;

    self.motionManager = [[CMMotionManager alloc] init];
    
    self.motionManager.accelerometerUpdateInterval = .2;
    
    self.motionManager.gyroUpdateInterval = .2;
    
    
    
    [self.motionManager startAccelerometerUpdatesToQueue:[NSOperationQueue currentQueue]
     
                        withHandler:^(CMAccelerometerData  *accelerometerData, NSError *error) {
                                                 
                             [self outputAccelertionData:accelerometerData.acceleration];
                            
                                if(error){

                                   NSLog(@"%@", error);
                                                     
                                }
                                                 
    }];
    
    
    
    [self.motionManager startGyroUpdatesToQueue:[NSOperationQueue currentQueue]
     
                                    withHandler:^(CMGyroData *gyroData, NSError *error) {
                                        
                                        [self outputRotationData:gyroData.rotationRate];
                                        
    }];
    
    
    
    
    
    
    
}
    // Do any additional setup after loading the view.


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillDisappear:(BOOL)animated{

    self.tabBarController.tabBar.hidden = NO;
    
}

-(void)outputAccelertionData:(CMAcceleration)acceleration
{
    //NSLog(@"one\n");
    //self.accX.text = [NSString stringWithFormat:@" %.2fg",acceleration.x];
    NSLog(@"%f",acceleration.x);
    NSLog(@"%f",acceleration.y);
    NSLog(@"%f",acceleration.z);

    if(fabs(acceleration.x) > fabs(AccelX_threshold))
        
    {
        
        NSLog(@"%f",acceleration.x);
        
    }
    
    //self.accY.text = [NSString stringWithFormat:@" %.2fg",acceleration.y];
    
    if(fabs(acceleration.y) > fabs(AccelY_threshold))
        
    {
        
        NSLog(@"hio");
        
    }
    
    //self.accZ.text = [NSString stringWithFormat:@" %.2fg",acceleration.z];
    
    if(fabs(acceleration.z) > fabs(AccelZ_threshold))
        
    {
        
        NSLog(@"hi");
        
    }
    
    //self.maxAccX.text = [NSString stringWithFormat:@" %.2f",currentMaxAccelX];
}

-(void)outputRotationData:(CMRotationRate)rotation
{
    
    
    
    //self.rotX.text = [NSString stringWithFormat:@" %.2fr/s",rotation.x];
    
    if(fabs(rotation.x) > fabs(RotX_threshold))
    {
        
        NSLog(@"hi");
        
    }
    
    //self.rotY.text = [NSString stringWithFormat:@" %.2fr/s",rotation.y];
    
    if(fabs(rotation.y) > fabs(RotY_threshold))
    {
        NSLog(@"hi");
        
    }
    
    if(fabs(rotation.z) > fabs(RotZ_threshold))
    {
        
        NSLog(@"hi");

    }
    
    
  
    
}
- (IBAction)save:(id)sender {
    if ([self.systemSwitch isOn]) {
        self.detectionResult.text = @"";
        NSLog(@"Switch is on");
    } else {
        self.detectionResult.text = @"偵測系統關閉";
        NSLog(@"off");
    }
}
@end
