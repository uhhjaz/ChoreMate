//
//  NSDate+CMDate.m
//  ChoreMate
//
//  Created by Jasdeep Gill on 7/30/20.
//  Copyright © 2020 jazgill. All rights reserved.
//

#import "NSDate+CMDate.h"

@implementation NSDate (CMDate)

-(NSDate *) dateWithHour:(NSInteger)hour
                  minute:(NSInteger)minute
                  second:(NSInteger)second
{
   NSCalendar *calendar = [NSCalendar currentCalendar];
   NSDateComponents *components = [calendar components: NSCalendarUnitYear|
                                                        NSCalendarUnitMonth|
                                                        NSCalendarUnitDay
                                              fromDate:self];
    [components setHour:hour];
    [components setMinute:minute];
    [components setSecond:second];
    NSDate *newDate = [calendar dateFromComponents:components];
    return newDate;
}


+ (NSMutableArray*) datesDaysAppear: (NSInteger)chosenTime Til: (NSDate *)endDate {
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *findMatchingDayComponents = [[NSDateComponents alloc] init];
    findMatchingDayComponents.hour = chosenTime;
    NSMutableArray *dailyDates = [[NSMutableArray alloc] init];
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy/MM/dd"];
    
    __block int dateCount = 0;
    [calendar enumerateDatesStartingAfterDate:[NSDate date]
                          matchingComponents:findMatchingDayComponents
                                     options:NSCalendarMatchPreviousTimePreservingSmallerUnits
                                  usingBlock:^(NSDate *date, BOOL exactMatch, BOOL *stop) {
        if (date.timeIntervalSince1970 >= endDate.timeIntervalSince1970) {
            *stop = YES;
        }
        else {
            dateCount++;
            [dailyDates addObject:[dateFormatter stringFromDate:date]];
        }
    }];
    
    return dailyDates;
}

+ (NSMutableArray*) datesWeeksAppear: (NSInteger)weekDayChosen Til: (NSDate *)endDate {
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *findMatchingDayComponents = [[NSDateComponents alloc] init];
    findMatchingDayComponents.weekday = weekDayChosen;
    NSMutableArray *weeklyDates = [[NSMutableArray alloc] init];
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy/MM/dd"];
    
    __block int dateCount = 0;
    [calendar enumerateDatesStartingAfterDate:[NSDate date]
                          matchingComponents:findMatchingDayComponents
                                     options:NSCalendarMatchPreviousTimePreservingSmallerUnits
                                  usingBlock:^(NSDate *date, BOOL exactMatch, BOOL *stop) {
        if (date.timeIntervalSince1970 >= endDate.timeIntervalSince1970) {
            *stop = YES;
        }
        else {
            dateCount++;
            [weeklyDates addObject:[dateFormatter stringFromDate:date]];
        }
    }];
    
    return weeklyDates;
}

+ (NSMutableArray*) datesMonthsAppear:(NSInteger )dayChosen Til:(NSDate *)endDate {
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *findMatchingDayComponents = [[NSDateComponents alloc] init];
    findMatchingDayComponents.day = dayChosen;
    NSMutableArray *monthlyDates = [[NSMutableArray alloc] init];
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy/MM/dd"];
    
    __block int dateCount = 0;
    [calendar enumerateDatesStartingAfterDate:[NSDate date]
                          matchingComponents:findMatchingDayComponents
                                     options:NSCalendarMatchPreviousTimePreservingSmallerUnits
                                  usingBlock:^(NSDate *date, BOOL exactMatch, BOOL *stop) {
        if (date.timeIntervalSince1970 >= endDate.timeIntervalSince1970) {
            *stop = YES;
        }
        else {
            dateCount++;
            [monthlyDates addObject:[dateFormatter stringFromDate:date]];
        }
    }];
    return monthlyDates;
}


+ (int) whichNumberDayOccurrence:(NSInteger)chosenTime From:(NSDate *)startDate Til:(NSDate *)endDate {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *findMatchingDayComponents = [[NSDateComponents alloc] init];
    findMatchingDayComponents.hour = chosenTime;
    
    __block int dateCount = 0;
    [calendar enumerateDatesStartingAfterDate:startDate
                           matchingComponents:findMatchingDayComponents
                                      options:NSCalendarMatchPreviousTimePreservingSmallerUnits
                                   usingBlock:^(NSDate *date, BOOL exactMatch, BOOL *stop) {
        if (date.timeIntervalSince1970 == endDate.timeIntervalSince1970) {
            *stop = YES;
        }
        else {
            dateCount++;
        }
    }];
    return dateCount;
}


+ (int) whichNumberWeekOccurrence:(NSInteger)chosenDay From:(NSDate *)startDate Til:(NSDate *)endDate {
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *findMatchingDayComponents = [[NSDateComponents alloc] init];
    findMatchingDayComponents.weekday = chosenDay;
    
    __block int dateCount = 0;
    [calendar enumerateDatesStartingAfterDate:startDate
                           matchingComponents:findMatchingDayComponents
                                      options:NSCalendarMatchPreviousTimePreservingSmallerUnits
                                   usingBlock:^(NSDate *date, BOOL exactMatch, BOOL *stop) {

        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy/MM/dd"];
        NSString *dateStr = [dateFormatter stringFromDate:date];
        [dateFormatter setDateFormat:@"yyyy/MM/dd"];
        date = [dateFormatter dateFromString:dateStr];
        
        if (date.timeIntervalSince1970 == endDate.timeIntervalSince1970) {
            *stop = YES;
        }
        else {
            dateCount++;
        }
    }];
    
    return dateCount;
}


+ (int) whichNumberMonthOccurrence:(NSInteger)chosenDay From:(NSDate *)startDate Til:(NSDate *)endDate {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *findMatchingDayComponents = [[NSDateComponents alloc] init];
    findMatchingDayComponents.day = chosenDay;
    
    __block int dateCount = 0;
    [calendar enumerateDatesStartingAfterDate:startDate
                           matchingComponents:findMatchingDayComponents
                                      options:NSCalendarMatchPreviousTimePreservingSmallerUnits
                                   usingBlock:^(NSDate *date, BOOL exactMatch, BOOL *stop) {
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy/MM/dd"];
        NSString *dateStr = [dateFormatter stringFromDate:date];
        [dateFormatter setDateFormat:@"yyyy/MM/dd"];
        date = [dateFormatter dateFromString:dateStr];
        
        if (date.timeIntervalSince1970 == endDate.timeIntervalSince1970) {
            *stop = YES;
        }
        else {
            dateCount++;
        }
    }];
    return dateCount;
}

@end
