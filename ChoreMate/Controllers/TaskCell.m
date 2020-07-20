//
//  TaskCell.m
//  ChoreMate
//
//  Created by Jasdeep Gill on 7/20/20.
//  Copyright © 2020 jazgill. All rights reserved.
//

#import "TaskCell.h"

@implementation TaskCell

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
    [dateFormat setDateFormat:@"yyyy/MM/dd --- HH:mm"];
    NSDate *date = [dateFormat dateFromString:self.task.dueDate];
    [dateFormat setDateFormat:@"MM/dd/yyyy"];
    NSString* dateStr = [dateFormat stringFromDate:date];
    self.taskDueDateLabel.text = dateStr;
    
    
    if([self.task.type  isEqual: @"one_time"]){
        self.taskContainerView.backgroundColor = [UIColor colorWithRed: 0.60 green: 0.73 blue: 0.93 alpha: 1.00];
    }
    else if([self.task.type  isEqual: @"recurring"]){
        self.taskContainerView.backgroundColor = [UIColor colorWithRed: 0.65 green: 0.85 blue: 0.78 alpha: 1.00];
    }
    else if([self.task.type  isEqual: @"rotational"]){
        self.taskContainerView.backgroundColor = [UIColor colorWithRed: 0.92 green: 0.69 blue: 0.69 alpha: 1.00];
    }
}

@end
