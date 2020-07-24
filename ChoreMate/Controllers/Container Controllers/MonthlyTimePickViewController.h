//
//  MonthlyTimePickViewController.h
//  ChoreMate
//
//  Created by Jasdeep Gill on 7/23/20.
//  Copyright © 2020 jazgill. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MonthlyTimePickViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIPickerView *dayOfMonthPicker;
@property (strong, nonatomic) NSString *pickedDay;

@end

NS_ASSUME_NONNULL_END
