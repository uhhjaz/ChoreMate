//
//  NSDate+CMDate.h
//  ChoreMate
//
//  Created by Jasdeep Gill on 7/30/20.
//  Copyright © 2020 jazgill. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDate (CMDate)

-(NSDate *) dateWithHour:(NSInteger)hour
                  minute:(NSInteger)minute
                  second:(NSInteger)second;

+ (NSMutableArray*) datesDaysAppear:(NSInteger)chosenTime Til: (NSDate *)endDate;
+ (NSMutableArray*) datesWeeksAppear:(NSInteger)weekDayChosen Til: (NSDate *)endDate;
+ (NSMutableArray*) datesMonthsAppear:(NSInteger )dayChosen Til:(NSDate *)endDate;


+ (NSMutableArray*) datesDaysAppearInStringFormat:(NSInteger)chosenTime Til: (NSDate *)endDate;
+ (NSMutableArray*) datesWeeksAppearInStringFormat:(NSInteger)weekDayChosen Til: (NSDate *)endDate;
+ (NSMutableArray*) datesMonthsAppearInStringFormat:(NSInteger )dayChosen Til:(NSDate *)endDate;


+ (int) whichNumberDayOccurrence:(NSInteger)chosenTime From:(NSDate *)startDate Til:(NSDate *)endDate;
+ (int) whichNumberWeekOccurrence:(NSInteger)chosenDay From:(NSDate *)startDate Til:(NSDate *)endDate;
+ (int) whichNumberMonthOccurrence:(NSInteger)chosenDay From:(NSDate *)startDate Til:(NSDate *)endDate;

@end

NS_ASSUME_NONNULL_END
