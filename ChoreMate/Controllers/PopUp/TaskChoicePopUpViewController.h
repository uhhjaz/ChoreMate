//
//  TaskChoicePopUpViewController.h
//  ChoreMate
//
//  Created by Jasdeep Gill on 7/16/20.
//  Copyright © 2020 jazgill. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OnceTimeTaskViewController.h"

NS_ASSUME_NONNULL_BEGIN

@protocol TaskChoiceControllerDelegate

// MARK: Methods
- (void)didChoose:(NSString *)type;

@end

@interface TaskChoicePopUpViewController : UIViewController

@property (nonatomic, weak) id<TaskChoiceControllerDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
