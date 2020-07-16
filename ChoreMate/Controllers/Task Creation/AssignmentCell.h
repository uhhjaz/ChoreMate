//
//  AssignmentCell.h
//  ChoreMate
//
//  Created by Jasdeep Gill on 7/16/20.
//  Copyright © 2020 jazgill. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

NS_ASSUME_NONNULL_BEGIN

@interface AssignmentCell : UICollectionViewCell

@property (strong, nonatomic) User *user;
@property (weak, nonatomic) IBOutlet UIButton *checkButton;
@property (weak, nonatomic) IBOutlet UILabel *userLabel;

- (void)setCellValues;

@end

NS_ASSUME_NONNULL_END
