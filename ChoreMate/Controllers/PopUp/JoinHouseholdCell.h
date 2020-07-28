//
//  JoinHouseholdCell.h
//  ChoreMate
//
//  Created by Jasdeep Gill on 7/28/20.
//  Copyright © 2020 jazgill. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Household.h"

NS_ASSUME_NONNULL_BEGIN

@interface JoinHouseholdCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *joinHouseholdButton;
@property (weak, nonatomic) IBOutlet UILabel *householdNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *householdCodeLabel;
@property (weak, nonatomic) IBOutlet Household *household;

- (void)setHouseCells;
@end

NS_ASSUME_NONNULL_END
