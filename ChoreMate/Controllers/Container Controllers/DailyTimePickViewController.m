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
//    self.pickedTime = [NSString stringWithFormat:@"%ld", sender.selectedSegmentIndex+1 ];
    switch (sender.selectedSegmentIndex) {
        case 0:
            self.pickedTime = @"6";
            break;
        case 1:
            self.pickedTime = @"12";
            break;
        case 2:
            self.pickedTime = @"18";
            break;
        default:
            break;
    }
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
