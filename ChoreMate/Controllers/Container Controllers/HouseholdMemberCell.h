//
//  HouseholdMemberCell.h
//  ChoreMate
//
//  Created by Jasdeep Gill on 7/27/20.
//  Copyright © 2020 jazgill. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

NS_ASSUME_NONNULL_BEGIN

@interface HouseholdMemberCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *householdMemberNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *householdMemberProfileView;
@property (strong, nonatomic) User *houseMember;

- (void) setHouseMembersData;
@end

NS_ASSUME_NONNULL_END
