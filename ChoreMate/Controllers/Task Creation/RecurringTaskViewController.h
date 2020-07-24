//
//  RecurringTaskViewController.h
//  ChoreMate
//
//  Created by Jasdeep Gill on 7/16/20.
//  Copyright © 2020 jazgill. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RecurringTaskViewController : UIViewController

FOUNDATION_EXPORT int const DAY_TIME_CHOSEN;
FOUNDATION_EXPORT int const WEEK_DAY_CHOSEN;
FOUNDATION_EXPORT int const MONTH_DAY_CHOSEN;

- (int) daysBetweenDates: (NSInteger)startDate currentDate: (NSDate *)endDate;
- (int) weeksBetweenDates: (NSInteger)weekDayChosen currentDate: (NSDate *)endDate;
- (int) monthsBetweenDates: (NSInteger)dayChosen currentDate: (NSDate *)endDate;

@end

NS_ASSUME_NONNULL_END
