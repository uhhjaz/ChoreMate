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


+ (void) postTask: (NSString * _Nullable)description
           OfType: (NSString * _Nullable)type
         WithDate: (NSString * _Nullable )dueDate
        Assignees:(NSArray *)assignees
   withCompletion: (PFBooleanResultBlock  _Nullable)completion {
    


    Task *newTask = [Task new];
    PFRelation *relation = [newTask relationForKey:@"assignedTo"];
    for(User * eachAssignee in assignees){
        NSLog(@"the assignees are: %@", eachAssignee);
        [relation addObject:eachAssignee];
    }
    
    [newTask saveInBackground];

    
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy/MM/dd --- HH:mm"];
    NSString *theDate = [dateFormatter stringFromDate:[NSDate date]];
    NSLog(@"this is the date: %@", theDate);
    newTask.type = type;
    newTask.createdDate = theDate;
    newTask.startDate = theDate;
    newTask.dueDate = dueDate ;
    newTask.endDate = dueDate;
    newTask.completed = FALSE;
    newTask.taskDescription = description;
    [newTask saveInBackgroundWithBlock: completion];
}


- (BOOL)checkIfHouseHoldMemberCompletedTask:(Task *)task :(User *)housemate {
    
    NSArray *completionMembers = [task objectForKey:@"currentCompletionStatus"];

    if (completionMembers != nil ) {

        if ([completionMembers containsObject:housemate.objectId]) {
            NSLog(@"THE USER HAS COMPLETED THE TASK!! %@", housemate.name);
            return YES;

        }
        else {
            NSLog(@"THE USER HAS NOT COMPLETED THE TASK!! %@", housemate.name);
            return NO;

        }
    }
    return NO;
}


@end
