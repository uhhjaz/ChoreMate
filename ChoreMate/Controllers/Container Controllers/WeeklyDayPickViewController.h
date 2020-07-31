//
//  WeeklyDayPickViewController.h
//  ChoreMate
//
//  Created by Jasdeep Gill on 7/23/20.
//  Copyright © 2020 jazgill. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WeeklyDayPickViewController : UIViewController
@property (weak, nonatomic) IBOutlet UISegmentedControl *weeklyDayPickSegControl;
@property (strong, nonatomic) NSString *pickedDay;
@property (strong, nonatomic) NSString *type;

@end

NS_ASSUME_NONNULL_END
