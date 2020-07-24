//
//  MonthlyTimePickViewController.m
//  ChoreMate
//
//  Created by Jasdeep Gill on 7/23/20.
//  Copyright © 2020 jazgill. All rights reserved.
//

#import "MonthlyTimePickViewController.h"

@interface MonthlyTimePickViewController () <UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, strong) NSArray *datePicker;
@property (weak, nonatomic) IBOutlet UIButton *endDateButton;
@property (weak, nonatomic) IBOutlet UIButton *beginningDateButton;
@property (weak, nonatomic) IBOutlet UIView *pickerContainerView;
@property (weak, nonatomic) IBOutlet UITextField *dateTextField;

@end

@implementation MonthlyTimePickViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.pickedDay = @"1";

    self.dayOfMonthPicker.dataSource = self;
    self.dayOfMonthPicker.delegate = self;
    
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(1, 31)];

    NSMutableArray *elements = [NSMutableArray array];
        [indexSet enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
            [elements addObject:[NSNumber numberWithInteger:idx]];
        }];
    self.datePicker = (NSArray *)elements;
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)thePickerView {
     return 1;
}

- (NSInteger)pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component {
    return self.datePicker.count;
}

- (NSString *)pickerView:(UIPickerView *)thePickerView
             titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [self.datePicker[row] stringValue];
}

- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.pickedDay = self.datePicker[row];
    [self.dateTextField setText:[self.datePicker[row] stringValue]];

}

- (IBAction)endSelected:(id)sender {
    [self.dateTextField setText:@"End"];
    self.pickedDay = @"31";
}



@end
