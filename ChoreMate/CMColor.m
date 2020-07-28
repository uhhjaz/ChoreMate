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
    return [UIColor colorWithRed: 0.00 green: 0.61 blue: 0.41 alpha: 1.00];
}

+ (UIColor *)rotationalTaskColor {
    return [UIColor colorWithRed: 0.92 green: 0.69 blue: 0.69 alpha: 1.00];
}

+ (UIColor *)completedTaskColor {
    return [UIColor colorWithRed: 0.00 green: 0.33 blue: 0.05 alpha: 1.00];
}

+ (UIColor *)greyButtonColor {
    return [UIColor colorWithRed: 0.00 green: 0.33 blue: 0.05 alpha: 1.00];
}



@end