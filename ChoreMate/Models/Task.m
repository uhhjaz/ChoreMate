/**
 * Task.h
 * ChoreMate
 *
 * Description: implementation of the general Task Class as a subclass of PFObject
 *
 * Created by Jasdeep Gill on 7/13/20.
 * Copyright © 2020 jazgill. All rights reserved.
 */

#import "Task.h"


@implementation Task
@dynamic postID;
@dynamic userID;
@dynamic author;
@dynamic type;
@dynamic taskDescription;
@dynamic assignedTo;
@dynamic createdDate;
@dynamic dueDate;
@dynamic completed;
@dynamic startDate;
@dynamic endDate;
@dynamic rotationalOrder;
@dynamic repeats;


+ (nonnull NSString *)parseClassName {
    return @"Task";
}

+ (void) postTaskwithCompletion: (PFBooleanResultBlock  _Nullable)completion {
    
//
//    Task *newTask = [Task new];
//    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
//    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//    NSString *theDate = [dateFormatter stringFromDate:[NSDate date]];
//    NSLog(@"this is the date: %@", theDate);
//    newTask.type = @"one-time-test";
//    newTask.createdDate = theDate;
//    newTask.dueDate = theDate;
//    newTask.startDate = theDate;
//    newTask.endDate = theDate;
//    newTask.taskDescription = @"this would be the description";
//    [newTask saveInBackgroundWithBlock: completion];
}

@end
