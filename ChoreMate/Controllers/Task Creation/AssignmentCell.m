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
    
    
    NSArray* firstLastStrings = [self.user.name componentsSeparatedByString:@" "];
    self.userLabel.text = [NSString stringWithFormat:@"%@",[firstLastStrings objectAtIndex:0]];
    
    [self.checkButton addTarget:self
                    action:@selector(aMethod1:)
          forControlEvents:UIControlEventTouchUpInside];
    self.checkButton.frame = CGRectMake(10.0, 100.0, 30.0, 30.0);

        UIImage *unselected = [UIImage imageNamed:@"uncheckedbox.png"];
        UIImage *selected = [UIImage imageNamed:@"checked.png"];

    [self.checkButton setImage:unselected forState:UIControlStateNormal];
    [self.checkButton setImage:selected forState:UIControlStateSelected];

    self.checkButton.selected = NO;

}

- (void)aMethod1:(UIButton *)btn{
    btn.selected = !btn.selected;
}


@end
