//
//  NotificationCell.h
//  ChoreMate
//
//  Created by Jasdeep Gill on 8/3/20.
//  Copyright © 2020 jazgill. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Notification.h"

NS_ASSUME_NONNULL_BEGIN

@interface NotificationCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *notificationImageView;
@property (weak, nonatomic) IBOutlet UILabel *notificationTextLabel;
@property (weak, nonatomic) IBOutlet UIView *choreBackgroundView;
@property (weak, nonatomic) IBOutlet UILabel *choreLabel;

@property (strong, nonatomic) Notification *notification;

- (void) setNotificationData;

@end

NS_ASSUME_NONNULL_END
