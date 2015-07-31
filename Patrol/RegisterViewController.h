//
//  RegisterViewController.h
//  Patrol
//
//  Created by Ｗinston on 7/21/15.
//  Copyright (c) 2015 Ｗinston. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegisterViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *account;
@property (strong, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UITextField *repassword;
@property (weak, nonatomic) IBOutlet UITextField *phone;
@property (weak, nonatomic) IBOutlet UITextField *contact1;
@property (weak, nonatomic) IBOutlet UITextField *contact2;
@property (weak, nonatomic) IBOutlet UITextField *contact3;
- (IBAction)submit:(id)sender;

@end
