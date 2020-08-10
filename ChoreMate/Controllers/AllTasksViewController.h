//
//  AllTasksViewController.h
//  ChoreMate
//
//  Created by Jasdeep Gill on 8/9/20.
//  Copyright © 2020 jazgill. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AllTasksViewController : UIViewController

@property (strong, nonatomic) NSMutableArray *myTasks;
@property (strong, nonatomic) NSMutableArray *myTasksWithDates;
@property (strong, nonatomic) NSDictionary *myTasksByDueDate;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

NS_ASSUME_NONNULL_END
