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

@interface TaskCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *taskCompletedButton;
@property (weak, nonatomic) IBOutlet UILabel *taskDescriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *taskDueDateLabel;
@property (weak, nonatomic) IBOutlet UIView *taskContainerView;

@property (strong, nonatomic) Task *task;

- (void) setTaskValues;

@end

NS_ASSUME_NONNULL_END
