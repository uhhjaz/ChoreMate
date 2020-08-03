//
//  popUpNudgeHouseMateViewController.h
//  ChoreMate
//
//  Created by Jasdeep Gill on 8/3/20.
//  Copyright © 2020 jazgill. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Task.h"
#import "User.h"

NS_ASSUME_NONNULL_BEGIN

@protocol popUpNudgeControllerDelegate

// MARK: Methods
- (void)didNudge:(Task *)forChore;

@end

@interface popUpNudgeHouseMateViewController : UIViewController

@property (nonatomic, weak) id<popUpNudgeControllerDelegate> delegate;

@property (strong, nonatomic) User *houseMate;
@property (strong, nonatomic) Task *task;

@end

NS_ASSUME_NONNULL_END
