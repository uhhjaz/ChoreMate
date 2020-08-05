//
//  CMColor.m
//  ChoreMate
//
//  Created by Jasdeep Gill on 7/27/20.
//  Copyright © 2020 jazgill. All rights reserved.
//

#import "CMColor.h"

@implementation CMColor

+ (UIColor *)oneTimeTaskColor {
    return [UIColor colorWithRed: 0.45 green: 0.58 blue: 0.80 alpha: 1.00];
}

+ (UIColor *)recurringTaskColor {
    return [UIColor colorWithRed: 0.00 green: 0.66 blue: 0.44 alpha: 1.00];
}

+ (UIColor *)rotationalTaskColor {
    return [UIColor colorWithRed: 0.93 green: 0.73 blue: 0.00 alpha: 1.00];
}

+ (UIColor *)completedTaskColor {
    return [UIColor colorWithRed: 0.00 green: 0.33 blue: 0.05 alpha: 1.00];
}

+ (UIColor *)greyButtonColor {
    return [UIColor colorWithRed: 0.00 green: 0.33 blue: 0.05 alpha: 1.00];
}

+ (UIColor *)unseenNotifColor {
    return [UIColor colorWithRed: 0.87 green: 0.94 blue: 0.98 alpha: 1.00];
}




@end
