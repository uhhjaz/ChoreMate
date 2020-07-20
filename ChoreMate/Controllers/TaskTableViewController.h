//
//  TaskTableViewController.h
//  ChoreMate
//
//  Created by Jasdeep Gill on 7/17/20.
//  Copyright © 2020 jazgill. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

NS_ASSUME_NONNULL_BEGIN

@protocol TaskTableViewControllerDelegate

// MARK: Methods

@end

@interface TaskTableViewController : UITableViewController

@property (nonatomic, weak) id<TaskTableViewControllerDelegate> delegate;
@property (strong, nonatomic) User *currUser;

@end

NS_ASSUME_NONNULL_END
