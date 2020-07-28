//
//  CMColor.h
//  ChoreMate
//
//  Created by Jasdeep Gill on 7/27/20.
//  Copyright © 2020 jazgill. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CMColor : UIColor

+ (UIColor *)oneTimeTaskColor;
+ (UIColor *)recurringTaskColor;
+ (UIColor *)rotationalTaskColor;
+ (UIColor *)completedTaskColor;

@end

NS_ASSUME_NONNULL_END
