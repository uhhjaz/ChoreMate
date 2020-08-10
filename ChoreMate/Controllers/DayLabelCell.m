//
//  DayLabelCell.m
//  ChoreMate
//
//  Created by Jasdeep Gill on 8/6/20.
//  Copyright © 2020 jazgill. All rights reserved.
//

#import "DayLabelCell.h"

@implementation DayLabelCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) setDate{
    // Convert string to date object
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy/MM/dd"];
    NSDate *date = [dateFormat dateFromString:self.dateString];
    
    NSDateFormatter *weekday = [[NSDateFormatter alloc] init];
    [weekday setDateFormat: @"EEEE"];
    NSDateFormatter *month = [[NSDateFormatter alloc] init];
    [month setDateFormat:@"MMMM dd"];

    self.dayDateLabel.text = [NSString stringWithFormat:@"  %@ -- %@  ", [weekday stringFromDate:date], [month stringFromDate:date]];
    self.dayDateLabel.numberOfLines = 1;
    
}

@end
