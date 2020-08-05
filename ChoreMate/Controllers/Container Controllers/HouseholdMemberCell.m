//
//  HouseholdMemberCell.m
//  ChoreMate
//
//  Created by Jasdeep Gill on 7/27/20.
//  Copyright © 2020 jazgill. All rights reserved.
//

#import "HouseholdMemberCell.h"
#import "UIImageView+AFNetworking.h"

@implementation HouseholdMemberCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) setHouseMembersData{
    self.householdMemberNameLabel.text = self.houseMember.name;
    
    NSString *profileImageURLString = self.houseMember.profileImageView.url;
    NSURL *profileImageURL = [NSURL URLWithString:profileImageURLString];
    [self.householdMemberProfileView setImageWithURL:profileImageURL];
}

@end
