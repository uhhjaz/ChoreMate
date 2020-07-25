/**
 * TaskScreenViewController.h
 * ChoreMate
 *
 * Description: Declaration of the task screen view.
 * Allows user to see user tasks, mark tasks as complete, see household tasks, nudge housemates.
 * Allows user to navigate to view to create new tasks.
 *
 *
 * Created by Jasdeep Gill on 7/13/20.
 * Copyright © 2020 jazgill. All rights reserved.
 */

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TaskScreenViewController : UIViewController

FOUNDATION_EXPORT int const TASK_TYPE_ONETIME;
FOUNDATION_EXPORT int const TASK_TYPE_RECURRING;
FOUNDATION_EXPORT int const TASK_TYPE_ROTATIONAL;

- (void) refreshTable;
@end

NS_ASSUME_NONNULL_END
