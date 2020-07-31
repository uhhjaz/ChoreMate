//
//  HouseMateTaskCell.m
//  ChoreMate
//
//  Created by Jasdeep Gill on 7/31/20.
//  Copyright © 2020 jazgill. All rights reserved.
//

#import "HouseMateTaskCell.h"
#import "CMColor.h"

@implementation HouseMateTaskCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) setTaskValues{
    self.taskDescriptionLabel.text = self.task.taskDescription;
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy/MM/dd"];
    NSDate *date = [dateFormat dateFromString:self.task.dueDate];
    [dateFormat setDateFormat:@"MM/dd/yyyy"];
    NSString* dateStr = [dateFormat stringFromDate:date];
    self.dateLabel.text = dateStr;
    
    if([self.task.type  isEqual: @"one_time"]){
        self.taskContainerView.backgroundColor = [CMColor oneTimeTaskColor];
    }
    else if([self.task.type  isEqual: @"recurring"]){
        self.taskContainerView.backgroundColor = [CMColor recurringTaskColor];
    }
    else if([self.task.type  isEqual: @"rotational"]){
        self.taskContainerView.backgroundColor = [CMColor rotationalTaskColor];
    }

}


@end
