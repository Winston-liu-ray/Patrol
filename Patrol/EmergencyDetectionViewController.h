//
//  EmergencyDetectionViewController.h
//  Patrol
//
//  Created by Ｗinston on 7/21/15.
//  Copyright (c) 2015 Ｗinston. All rights reserved.
//
#import <CoreMotion/CoreMotion.h>
#import <UIKit/UIKit.h>

@interface EmergencyDetectionViewController : UIViewController{
    double AccelX_threshold;
    double AccelY_threshold;
    double AccelZ_threshold;
    double RotX_threshold;
    double RotY_threshold;
    double RotZ_threshold;
}
@property (weak, nonatomic) IBOutlet UILabel *vibration;
@property (weak, nonatomic) IBOutlet UILabel *volumn;
@property (weak, nonatomic) IBOutlet UILabel *detectionResult;
@property (strong, nonatomic) IBOutlet UISwitch *systemSwitch;

@property (strong, nonatomic) CMMotionManager *motionManager;
- (IBAction)save:(id)sender;
@end
