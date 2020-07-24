//
//  AssigneeNameCell.h
//  ChoreMate
//
//  Created by Jasdeep Gill on 7/20/20.
//  Copyright © 2020 jazgill. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"
#import "Task.h"

NS_ASSUME_NONNULL_BEGIN

@interface AssigneeNameCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) User *user;
@property (strong, nonatomic) Task *task;
@property (weak, nonatomic) IBOutlet UIView *cellContentView;


- (void) setAssignee;
@end

NS_ASSUME_NONNULL_END
