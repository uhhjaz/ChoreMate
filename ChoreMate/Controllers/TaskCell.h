//
//  TaskCell.h
//  ChoreMate
//
//  Created by Jasdeep Gill on 7/20/20.
//  Copyright © 2020 jazgill. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Task.h"

NS_ASSUME_NONNULL_BEGIN

@interface TaskCell : UITableViewCell <UICollectionViewDataSource, UICollectionViewDelegate>

@property (strong, nonatomic) IBOutlet UIButton *taskCompletedButton;
@property (weak, nonatomic) IBOutlet UILabel *taskDescriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *taskDueDateLabel;
@property (weak, nonatomic) IBOutlet UIView *taskContainerView;
@property (weak, nonatomic) IBOutlet UIView *taskContainerBorderView;

@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;

@property (strong, nonatomic) Task *task;
@property (strong, nonatomic) NSArray *taskAssignees;

- (void) setTaskValues;
- (void) getTasksAssignees;
- (void) getArrayOfTaskAssignees:(NSArray *)usersIds completionHandler:(void (^)(NSArray *allAssignees))completionHandler;

@end

NS_ASSUME_NONNULL_END
