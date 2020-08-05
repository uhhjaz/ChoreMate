//
//  OnceTimeTaskViewController.h
//  ChoreMate
//
//  Created by Jasdeep Gill on 7/16/20.
//  Copyright © 2020 jazgill. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <THCalendarDatePicker-umbrella.h>

NS_ASSUME_NONNULL_BEGIN

@interface OneTimeTaskViewController : UIViewController<THDatePickerDelegate>

@property (nonatomic, strong) THDatePickerViewController * datePicker;

@end

NS_ASSUME_NONNULL_END
