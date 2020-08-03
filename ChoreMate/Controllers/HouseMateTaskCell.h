//
//  HouseMateTaskCell.h
//  ChoreMate
//
//  Created by Jasdeep Gill on 7/31/20.
//  Copyright © 2020 jazgill. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Task.h"
#import "User.h"

NS_ASSUME_NONNULL_BEGIN
@protocol HouseMateTaskCellDelegate;

@interface HouseMateTaskCell : UITableViewCell <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, weak) id<HouseMateTaskCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet UILabel *taskDescriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIButton *nudgeButton;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIView *taskContainerView;

@property (strong, nonatomic) Task *task;
@property (strong, nonatomic) NSArray *taskAssignees;

- (void) setTaskValues;
- (void) getTasksAssignees;

@end

@protocol HouseMateTaskCellDelegate

- (void)taskCell:(HouseMateTaskCell *) taskCell didTap: (Task *)task;

@end

NS_ASSUME_NONNULL_END
