/**
 * Task.h
 * ChoreMate
 *
 * Description: Interface declaration of the general Task Class as a subclass of PFObject
 *
 * Created by Jasdeep Gill on 7/13/20.
 * Copyright © 2020 jazgill. All rights reserved.
 */

#import <Parse/Parse.h>
#import "User.h"
#import "Completed.h"

NS_ASSUME_NONNULL_BEGIN

@class Completed;

@import Parse;

@interface Task : PFObject<PFSubclassing>


@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *taskDescription;
@property (nonatomic, strong) NSArray *assignedTo;
@property (nonatomic, strong) NSString *createdDate;
@property (nonatomic, strong) NSString *dueDate;
@property (nonatomic, strong) NSString *endDate;
@property (nonatomic, strong) NSDictionary *rotationalOrder;
@property (nonatomic, strong) NSString *repeats;
@property (nonatomic, strong) NSNumber *repetitionPoint;
@property (nonatomic, strong) NSNumber *occurrences;
@property (nonatomic, strong) PFRelation *completed;

// task copy properties
@property (nonatomic, strong) NSString *taskDatabaseId;
@property (nonatomic, assign) BOOL reproduced;
@property (nonatomic, assign) Completed *completedObject;


+ (void) postTask: (NSString * _Nullable)description
           OfType: (NSString * _Nullable)type
         WithDate: (NSString * _Nullable)dueDate
        Assignees: (NSArray *)assignees
   withCompletion: (PFBooleanResultBlock  _Nullable)completion;

+ (void) postTask: (NSString * _Nullable)description
           OfType: (NSString * _Nullable)type
   WithRepeatType: (NSString * _Nullable)repeat
            Point: (NSNumber * _Nullable)whenToRepeat
       NumOfTimes: (NSNumber * _Nullable)occurrences
           Ending: (NSDate * _Nullable)ending
        Assignees: (NSArray *)assignees
         DueDates: (NSArray *)dueDates
  RotationalOrder: (NSDictionary * _Nullable)rotation
   withCompletion: (PFBooleanResultBlock  _Nullable)completion;


+ (void) createTaskCopy: (NSString * _Nullable)taskID
                   From: (Task *)realTask
                    For: (NSString * _Nullable)description
                 OfType: (NSString * _Nullable)type
         WithRepeatType: (NSString * _Nullable)repeat
                  Point: (NSNumber * _Nullable)whenToRepeat
             NumOfTimes: (NSNumber * _Nullable)occurrences
                 Ending: (NSDate * _Nullable)ending
              Assignees: (NSArray *)assignees
      completionHandler: (void (^)(Task * _Nonnull newTask))completionHandler;


- (void)checkIfHouseHoldMemberCompletedTask:(Task *)task :(User *)housemate completionHandler:(void (^)(BOOL housemateCompletedTask))completionHandler;

- (void)isTaskFullyCompleted:(Task *)task completionHandler:(void (^)(BOOL allTasksCompleted))completionHandler;
- (void)isTaskWithDateFullyCompleted:(Task *)task :(NSDate *)dueDate completionHandler:(void (^)(BOOL allTasksCompleted))completionHandler;
@end

NS_ASSUME_NONNULL_END
