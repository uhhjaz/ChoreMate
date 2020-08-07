//
//  WeeklyCalendarViewController.h
//  ChoreMate
//
//  Created by Jasdeep Gill on 8/6/20.
//  Copyright © 2020 jazgill. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WeeklyCalendarViewController : UIViewController

@property (strong, nonatomic) NSMutableArray *myTasks;
@property (strong, nonatomic) NSDictionary *myTasksByDueDate;

@end

NS_ASSUME_NONNULL_END
