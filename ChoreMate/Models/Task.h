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

NS_ASSUME_NONNULL_BEGIN



@import Parse;

@interface Task : PFObject<PFSubclassing>

@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *taskDescription;
@property (nonatomic, assign) BOOL completed;
@property (nonatomic, strong) PFRelation *assignedTo;
@property (nonatomic, strong) NSString *createdDate;
@property (nonatomic, strong) NSString *dueDate;
@property (nonatomic, strong) NSString *endDate;
@property (nonatomic, strong) NSArray *rotationalOrder;
@property (nonatomic, strong) NSString *repeats;
@property (nonatomic, strong) NSNumber *repetitionPoint;
@property (nonatomic, strong) NSNumber *occurrences;
@property (nonatomic, strong) NSArray *currentCompletionStatus;

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
        Assignees: (NSArray *)assignees
   withCompletion: (PFBooleanResultBlock  _Nullable)completion;

- (BOOL)checkIfHouseHoldMemberCompletedTask:(Task *)task :(User *)housemate;

@end

NS_ASSUME_NONNULL_END
