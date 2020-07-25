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
@dynamic type;
@dynamic taskDescription;
@dynamic assignedTo;
@dynamic completed;
@dynamic createdDate;
@dynamic dueDate;
@dynamic endDate;
@dynamic rotationalOrder;
@dynamic repeats;
@dynamic repetitionPoint;
@dynamic occurrences;
@dynamic currentCompletionStatus;


+ (nonnull NSString *)parseClassName {
    return @"Task";
}


+ (void) postTask: (NSString * _Nullable)description
           OfType: (NSString * _Nullable)type
         WithDate: (NSString * _Nullable )dueDate
        Assignees: (NSArray *)assignees
   withCompletion: (PFBooleanResultBlock  _Nullable)completion {
    
    
    Task *newTask = [Task new];
    for(User * eachAssignee in assignees){
        [newTask addObject:eachAssignee.objectId forKey:@"assignedTo"];
        [newTask saveInBackground];
    }
    

    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy/MM/dd --- HH:mm"];
    NSString *theDate = [dateFormatter stringFromDate:[NSDate date]];
    NSLog(@"this is the date: %@", theDate);
    newTask.type = type;
    newTask.createdDate = theDate;
    newTask.dueDate = dueDate;
    newTask.endDate = dueDate;
    newTask.completed = FALSE;
    newTask.taskDescription = description;
    newTask.currentCompletionStatus = @[];
    [newTask saveInBackgroundWithBlock: completion];
}


+ (void) postTask: (NSString * _Nullable)description
           OfType: (NSString * _Nullable)type
   WithRepeatType: (NSString * _Nullable)repeat
            Point: (NSNumber * _Nullable)whenToRepeat
       NumOfTimes: (NSNumber * _Nullable)occurrences
           Ending: (NSDate * _Nullable)ending
        Assignees: (NSArray *)assignees
   withCompletion: (PFBooleanResultBlock  _Nullable)completion {
    
    Task *newTask = [Task new];
    
    for(User * eachAssignee in assignees){
        [newTask addObject:eachAssignee.objectId forKey:@"assignedTo"];
        [newTask saveInBackground];
    }

    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy/MM/dd --- HH:mm"];
    NSString *theDate = [dateFormatter stringFromDate:[NSDate date]];
    newTask.type = type;
    newTask.createdDate = theDate;
    newTask.repeats = repeat;
    newTask.repetitionPoint = whenToRepeat;
    newTask.completed = FALSE;
    newTask.taskDescription = description;
    newTask.occurrences = occurrences;
    newTask.endDate = [dateFormatter stringFromDate:ending];;
    newTask.currentCompletionStatus = @[];
    
    [newTask saveInBackgroundWithBlock: completion];
 }


+ (Task *) createTaskCopy: (NSString * _Nullable)taskID
                      For: (NSString * _Nullable)description
                   OfType: (NSString * _Nullable)type
           WithRepeatType: (NSString * _Nullable)repeat
                    Point: (NSNumber * _Nullable)whenToRepeat
               NumOfTimes: (NSNumber * _Nullable)occurrences
                   Ending: (NSDate * _Nullable)ending
                Assignees: (NSArray *)assignees {
   
    Task *taskCopy = [Task new];

    
    NSMutableArray *assigneesArr = [[NSMutableArray alloc] init];
    for(User * eachAssignee in assignees){
        [assigneesArr addObject:eachAssignee.objectId];
    }

    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy/MM/dd --- HH:mm"];
    NSString *theDate = [dateFormatter stringFromDate:[NSDate date]];
    taskCopy.type = type;
    taskCopy.createdDate = theDate;
    taskCopy.repeats = repeat;
    taskCopy.repetitionPoint = whenToRepeat;
    taskCopy.completed = FALSE;
    taskCopy.taskDescription = description;
    taskCopy.occurrences = occurrences;
    taskCopy.assignedTo = (NSArray*)assigneesArr;
    taskCopy.endDate = [dateFormatter stringFromDate:ending];;
    taskCopy.currentCompletionStatus = @[];
   
    return taskCopy;
}


- (BOOL)checkIfHouseHoldMemberCompletedTask:(Task *)task :(User *)housemate {
    
    NSArray *completionMembers = [task objectForKey:@"currentCompletionStatus"];

    if (completionMembers != nil ) {

        if ([completionMembers containsObject:housemate.objectId]) {
            //NSLog(@"THE USER HAS COMPLETED THE TASK!! %@", housemate.name);
            return YES;

        }
        else {
            //NSLog(@"THE USER HAS NOT COMPLETED THE TASK!! %@", housemate.name);
            return NO;

        }
    }
    return NO;
}


@end
