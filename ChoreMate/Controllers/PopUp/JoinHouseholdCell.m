//
//  JoinHouseholdCell.m
//  ChoreMate
//
//  Created by Jasdeep Gill on 7/28/20.
//  Copyright © 2020 jazgill. All rights reserved.
//

#import "JoinHouseholdCell.h"

@implementation JoinHouseholdCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setHouseCells{
    self.householdCodeLabel.text = self.household.objectId;
    self.householdNameLabel.text = self.household.name;
}


@end
