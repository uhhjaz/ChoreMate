//
//  NotificationsViewController.h
//  ChoreMate
//
//  Created by Jasdeep Gill on 8/3/20.
//  Copyright © 2020 jazgill. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NotificationsViewController : UIViewController

@property (strong, nonatomic) NSNumber *unseenNotifs;
- (void) getNewNotifCountWithCompletionHandler:(void (^)(int count))completionHandler;
@end

NS_ASSUME_NONNULL_END
