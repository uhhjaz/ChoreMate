//
//  AssignmentCell.m
//  ChoreMate
//
//  Created by Jasdeep Gill on 7/16/20.
//  Copyright © 2020 jazgill. All rights reserved.
//

#import "AssignmentCell.h"
#import "User.h"

@implementation AssignmentCell

- (void)setCellValues{
    
    // TODO: set checkbox based on user selection
    
    // TODO: parse out first name!!!
    self.userLabel.text = self.user.name;
}

@end
