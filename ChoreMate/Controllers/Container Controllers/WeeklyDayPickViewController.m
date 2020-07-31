//
//  WeeklyDayPickViewController.m
//  ChoreMate
//
//  Created by Jasdeep Gill on 7/23/20.
//  Copyright © 2020 jazgill. All rights reserved.
//

#import "WeeklyDayPickViewController.h"
#import "CMColor.h"

@interface WeeklyDayPickViewController ()

@end

@implementation WeeklyDayPickViewController

- (void)viewWillAppear:(BOOL)animated {
    if([self.type isEqual:@"recurring"]){
        self.weeklyDayPickSegControl.selectedSegmentTintColor = [CMColor recurringTaskColor];
    }
    else if([self.type isEqual:@"rotational"]) {
        self.weeklyDayPickSegControl.selectedSegmentTintColor = [CMColor rotationalTaskColor];
    }
}

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
