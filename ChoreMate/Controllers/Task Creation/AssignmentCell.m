//
//  AssignmentCell.m
//  ChoreMate
//
//  Created by Jasdeep Gill on 7/16/20.
//  Copyright © 2020 jazgill. All rights reserved.
//

#import "AssignmentCell.h"
#import "User.h"
#import "RotationalTaskViewController.h"

@implementation AssignmentCell

- (void)setCellValues{
    
    
    NSArray* firstLastStrings = [self.user.name componentsSeparatedByString:@" "];
    self.userLabel.text = [NSString stringWithFormat:@"%@",[firstLastStrings objectAtIndex:0]];
    
    [self.checkButton addTarget:self
                         action:@selector(updateCheck:)
          forControlEvents:UIControlEventTouchUpInside];
    self.checkButton.frame = CGRectMake(10.0, 100.0, 30.0, 30.0);

    UIImage *unselected = [UIImage imageNamed:@"uncheckedbox.png"];
    UIImage *selected = [self getSelectedNumber:orderNum];

    [self.checkButton setImage:unselected forState:UIControlStateNormal];
    [self.checkButton setImage:selected forState:UIControlStateSelected];

}


- (void)updateCheck:(UIButton *)btn{
    if(btn.selected){
        btn.selected = NO;
        if([self.type isEqual:@"rotational"]){
            
            NSString *key = [@(orderNum) stringValue];
            selectedHouseMembers[key] = nil;
            orderNum--;
        }
    }
    else {
        btn.selected = YES;
        if([self.type isEqual:@"rotational"]){
            orderNum++;
            
            NSString *key = [@(orderNum) stringValue];
            User *myObject = self.user;
            selectedHouseMembers[key] = myObject;
        }

        UIImage *selected = [self getSelectedNumber:orderNum];
        [self.checkButton setImage:selected forState:UIControlStateSelected];
    }
}


- (UIImage *) getSelectedNumber:(int)number {
    NSLog(@"setting selected Number %d", number);
    UIImage *selected;
    switch (number) {
        case 1:
            selected = [UIImage imageNamed:@"oneCheck.png"];
            break;
        case 2:
            selected = [UIImage imageNamed:@"twoCheck.png"];
            break;
        case 3:
            selected = [UIImage imageNamed:@"threeCheck.png"];
            break;
        case 4:
            selected = [UIImage imageNamed:@"fourCheck.png"];
            break;
        case 5:
            selected = [UIImage imageNamed:@"fiveCheck.png"];
            break;
        case 6:
            selected = [UIImage imageNamed:@"sixCheck.png"];
            break;
        default:
            selected = [UIImage imageNamed:@"checked.png"];
            break;
    }
    return selected;
        
}



@end
