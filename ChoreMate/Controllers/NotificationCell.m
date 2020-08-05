//
//  NotificationCell.m
//  ChoreMate
//
//  Created by Jasdeep Gill on 8/3/20.
//  Copyright © 2020 jazgill. All rights reserved.
//

#import "NotificationCell.h"
#import "Task.h"
#import "CMColor.h"

@implementation NotificationCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) setNotificationData {
    
    if(!self.notification.seen){
        self.unseenLabel.alpha = 1;
        self.contentView.backgroundColor = [CMColor unseenNotifColor];
    } else {
        self.unseenLabel.alpha = 0;
        self.contentView.backgroundColor = [UIColor whiteColor];
    }
    
    [Task getTaskFromObjectId:self.notification.chore completionHandler:^(Task * _Nonnull chore) {
        if ([chore.type isEqual:@"one_time"]){
            self.choreBackgroundView.backgroundColor = [CMColor oneTimeTaskColor];
            self.notificationImageView.tintColor = [CMColor oneTimeTaskColor];
        }
        else if ([chore.type isEqual:@"recurring"]){
            self.choreBackgroundView.backgroundColor = [CMColor recurringTaskColor];
            self.notificationImageView.tintColor = [CMColor recurringTaskColor];
        }
        else if ([chore.type isEqual:@"rotational"]){
            self.choreBackgroundView.backgroundColor = [CMColor rotationalTaskColor];
            self.notificationImageView.tintColor = [CMColor rotationalTaskColor];
        }
        else{
            NSLog(@"no chore type configured");
        }
    }];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy/MM/dd"];
    NSDate *date = [dateFormat dateFromString:self.notification.dueDate];
    [dateFormat setDateFormat:@"MM/dd/yyyy"];
    NSString* dateStr = [dateFormat stringFromDate:date];
    self.notificationTextLabel.text = [NSString stringWithFormat:@"Your housemate nudged you to complete this chore before the due date on %@:",dateStr];
    self.choreLabel.text = [NSString stringWithFormat:@"Chore: %@",self.notification.choreDescription];
}
@end
