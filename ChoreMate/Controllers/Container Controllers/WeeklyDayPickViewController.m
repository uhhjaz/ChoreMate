//
//  WeeklyDayPickViewController.m
//  ChoreMate
//
//  Created by Jasdeep Gill on 7/23/20.
//  Copyright © 2020 jazgill. All rights reserved.
//

#import "WeeklyDayPickViewController.h"

@interface WeeklyDayPickViewController ()

@end

@implementation WeeklyDayPickViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.pickedDay = @"1";
}

- (IBAction)pickedDay:(UISegmentedControl *)sender {
    self.pickedDay = [NSString stringWithFormat:@"%ld", sender.selectedSegmentIndex+1 ];
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
