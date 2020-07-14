//
//  TestViewController.m
//  ChoreMate
//
//  Created by Jasdeep Gill on 7/14/20.
//  Copyright © 2020 jazgill. All rights reserved.
//

#import "TestViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

@interface TestViewController ()

@end

@implementation TestViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  FBSDKLoginButton *loginButton = [[FBSDKLoginButton alloc] init];
  // Optional: Place the button in the center of your view.
    loginButton.center = self.view.center;
    
    [self.view addSubview:loginButton];
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
