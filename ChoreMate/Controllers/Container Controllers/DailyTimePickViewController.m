//
//  DailyTimePickViewController.m
//  ChoreMate
//
//  Created by Jasdeep Gill on 7/23/20.
//  Copyright © 2020 jazgill. All rights reserved.
//

#import "DailyTimePickViewController.h"

@interface DailyTimePickViewController ()

@end

@implementation DailyTimePickViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.pickedTime = @"1";
}

- (IBAction)pickedTime:(UISegmentedControl *)sender {
    self.pickedTime = [NSString stringWithFormat:@"%ld", sender.selectedSegmentIndex+1 ];
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
