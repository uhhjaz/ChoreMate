//
//  Completed.h
//  ChoreMate
//
//  Created by Jasdeep Gill on 7/26/20.
//  Copyright © 2020 jazgill. All rights reserved.
//



#import <Parse/Parse.h>
#import "Task.h"
#import "User.h"


NS_ASSUME_NONNULL_BEGIN

@import Parse;

@class Task;

@interface Completed : PFObject<PFSubclassing>

@property (nonatomic, strong) Task *task;
@property (nonatomic, strong) NSArray *currentCompletionStatus;
@property (nonatomic, strong) NSString *endDate;
@property (nonatomic, assign) BOOL isCompleted;

+ (void) getCompletedFromTask:(Task *)task AndDate:(NSString *)dueDate completionHandler:(void (^)(Completed *completedObject))completionHandler;
+ (void) createCompletedFromTask:(Task *)task AndDate:(NSString *)dueDate completionHandler:(void (^)(Completed *completedObject))completionHandler;
@end

NS_ASSUME_NONNULL_END
