//
//  RegisterViewController.m
//  Patrol
//
//  Created by Ｗinston on 7/21/15.
//  Copyright (c) 2015 Ｗinston. All rights reserved.
//

#import "RegisterViewController.h"

@interface RegisterViewController ()

@end

@implementation RegisterViewController
@synthesize account;
@synthesize password;
@synthesize repassword;
@synthesize phone;
@synthesize contact1;
@synthesize contact2;
@synthesize contact3;
- (void)viewDidLoad {
    [super viewDidLoad];
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

- (IBAction)submit:(id)sender {

    NSLog(@"%@",[self.password text]);
    NSLog(@"%@",[self.repassword text]);
    
    if ( ! [[self.password text] isEqualToString:[self.repassword text]]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"密碼不同"
                                                        message:@"請檢查密碼"
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil ];
        
        alert.alertViewStyle = UIAlertViewStyleDefault;
        [alert show];
        return ;
    }

    //initialize url that is going to be fetched.
    NSURL *url = [NSURL URLWithString:@"https://chroot.tw/PatrolApi/verify.php"];
    
    //initialize a request from url
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[url standardizedURL]];
    
    //set http method
    [request setHTTPMethod:@"POST"];
    
    //initialize a post data
    NSString *key =[NSString stringWithFormat:@"query=register&m_account=%@&m_password=%@&m_phonenum=%@&m_emergency_phonenum_n1=%@&m_emergency_phonenum_n2=%@&m_emergency_phonenum_n3=%@",[self.account text], [self.password text],[self.phone text], [self.contact1 text], [self.contact2 text], [self.contact3 text]];
    
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
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"恭喜"
                                                                message:msg
                                                               delegate:self
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil ];
                
                alert.alertViewStyle = UIAlertViewStyleDefault;
                [alert show];
                
                UIViewController *mainPage = [self.storyboard instantiateViewControllerWithIdentifier:@"TabBarController"];
                [self presentViewController:mainPage animated:YES completion:nil];
            }
            else{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"註冊失敗"
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
