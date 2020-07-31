//
//  EndPickerWithDateViewController.m
//  ChoreMate
//
//  Created by Jasdeep Gill on 7/23/20.
//  Copyright © 2020 jazgill. All rights reserved.
//

#import "EndPickerWithDateViewController.h"
#import "CMColor.h"

@interface EndPickerWithDateViewController ()
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UIView *datePickerBackground;

@end

@implementation EndPickerWithDateViewController

- (void)viewWillAppear:(BOOL)animated {
    if([self.type isEqual:@"recurring"]){
        self.datePickerBackground.backgroundColor = [CMColor recurringTaskColor];
    }
    else if([self.type isEqual:@"rotational"]) {
        self.datePickerBackground.backgroundColor = [CMColor rotationalTaskColor];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.datePicker setDatePickerMode:UIDatePickerModeDate];
    [self.datePicker setMinimumDate:[NSDate date]];
    
}

- (IBAction)selectedDate:(id)sender {
    NSDate *chosen = [self.datePicker date];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString * strTimestamp = [dateFormatter stringFromDate:chosen];
    NSLog(@"your string time stamp: %@",strTimestamp);
    
    self.pickedDate = chosen;
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
