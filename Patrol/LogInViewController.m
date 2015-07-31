//
//  LogInViewController.m
//  Patrol
//
//  Created by Ｗinston on 7/21/15.
//  Copyright (c) 2015 Ｗinston. All rights reserved.
//

#import "LogInViewController.h"

@interface LogInViewController ()

@end

@implementation LogInViewController
@synthesize account;
@synthesize password;
@synthesize connection;
@synthesize receivedData;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)logIn:(id)sender {
    //if there is a connection going on just cancel it.
    [self.connection cancel];
    
    //initialize new mutable data
    NSMutableData *data = [[NSMutableData alloc] init];
    self.receivedData = data;
    
    //initialize url that is going to be fetched.
    NSURL *url = [NSURL URLWithString:@"https://chroot.tw/PatrolApi/verify.php"];
    
    //initialize a request from url
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[url standardizedURL]];
    
    //set http method
    [request setHTTPMethod:@"POST"];
    //initialize a post data
    
    NSString *key =[NSString stringWithFormat:@"query=login&m_account=%@&m_password=%@",[self.account text], [self.password text]];
    //NSLog(@"this is %@",key);
    NSString *postData = [[NSString alloc] initWithString:key];
    //set request content type we MUST set this value.
    
    [request setValue:@"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    //set post data of request
    [request setHTTPBody:[postData dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        if (error) {
            //do something with error
        } else {
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
            NSString *result = [json objectForKey:@"Result"];
            NSString *msg = [json objectForKey:@"Msg"];
            NSLog(@"%@",result);
            NSLog(@"%@",msg);
            
            if ([result  isEqual: @"1"]) {
                UIViewController *mainPage = [self.storyboard instantiateViewControllerWithIdentifier:@"TabBarController"];
                [self presentViewController:mainPage animated:YES completion:nil];
            }
            else{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"登入失敗"
                                                                message:msg
                                                               delegate:self
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil ];
                
                alert.alertViewStyle = UIAlertViewStyleDefault;
                [alert show];
            }

        }
    }];
    
    
}
@end
