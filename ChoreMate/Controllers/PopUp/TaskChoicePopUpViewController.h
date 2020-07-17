//
//  TaskChoicePopUpViewController.h
//  ChoreMate
//
//  Created by Jasdeep Gill on 7/16/20.
//  Copyright © 2020 jazgill. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OnceTimeTaskViewController.h"

NS_ASSUME_NONNULL_BEGIN

@protocol TaskChoiceControllerDelegate

// MARK: Methods
- (void)didChoose:(int)type;

@end

@interface TaskChoicePopUpViewController : UIViewController

@property (nonatomic, weak) id<TaskChoiceControllerDelegate> delegate;

FOUNDATION_EXPORT int const TASK_CHOSEN_ONETIME;
FOUNDATION_EXPORT int const TASK_CHOSEN_RECURRING;
FOUNDATION_EXPORT int const TASK_CHOSEN_ROTATIONAL;


@end

NS_ASSUME_NONNULL_END
