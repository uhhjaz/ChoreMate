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


@dynamic taskDatabaseId;
@dynamic reproduced;
@dynamic completedObject;


+ (nonnull NSString *)parseClassName {
    return @"Task";
}


+ (void) postTask: (NSString * _Nullable)description
           OfType: (NSString * _Nullable)type
         WithDate: (NSString * _Nullable )dueDate
        Assignees: (NSArray *)assignees
   withCompletion: (PFBooleanResultBlock  _Nullable)completion {
    
    
    Task *newTask = [Task objectWithClassName:@"Task"];
    
    for(User * eachAssignee in assignees){
        [newTask addObject:eachAssignee.objectId forKey:@"assignedTo"];
        [newTask saveInBackground];
    }
    

    PFRelation *relation = [newTask relationForKey:@"completed"];
    int i = 0;
    while(i != 1){
        
        PFObject *taskCompletionOccurrence = [PFObject objectWithClassName:@"Completed"];
        [taskCompletionOccurrence setObject:newTask forKey:@"task"];
        [taskCompletionOccurrence setObject:@[] forKey:@"currentCompletionStatus"];
        [taskCompletionOccurrence setObject:dueDate forKey:@"endDate"];
        [taskCompletionOccurrence setObject:@NO forKey:@"isCompleted"];
        [taskCompletionOccurrence saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            if(succeeded){
                [relation addObject:taskCompletionOccurrence];
                [newTask saveInBackground];
            }
        }];
        i++;
    }

    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy/MM/dd --- HH:mm"];
    NSString *theDate = [dateFormatter stringFromDate:[NSDate date]];
    NSLog(@"this is the date: %@", theDate);
    newTask.type = type;
    newTask.createdDate = theDate;
    newTask.dueDate = dueDate;
    newTask.endDate = dueDate;
    newTask.taskDescription = description;
    [newTask saveInBackgroundWithBlock: completion];
}


+ (void) postTask: (NSString * _Nullable)description
           OfType: (NSString * _Nullable)type
   WithRepeatType: (NSString * _Nullable)repeat
            Point: (NSNumber * _Nullable)whenToRepeat
       NumOfTimes: (NSNumber * _Nullable)occurrences
           Ending: (NSDate * _Nullable)ending
        Assignees: (NSArray *)assignees
         DueDates: (NSArray *)dueDates
   withCompletion: (PFBooleanResultBlock  _Nullable)completion {
    
    
    Task *newTask = [Task objectWithClassName:@"Task"];
    
    for(User * eachAssignee in assignees){
        [newTask addObject:eachAssignee.objectId forKey:@"assignedTo"];
        [newTask saveInBackground];
    }
    

    PFRelation *relation = [newTask relationForKey:@"completed"];
    int i = 0;
    while(i != occurrences.intValue){
        
        PFObject *taskCompletionOccurrence = [PFObject objectWithClassName:@"Completed"];
        [taskCompletionOccurrence setObject:newTask forKey:@"task"];
        [taskCompletionOccurrence setObject:@[] forKey:@"currentCompletionStatus"];
        [taskCompletionOccurrence setObject:dueDates[i] forKey:@"endDate"];
        [taskCompletionOccurrence setObject:@NO forKey:@"isCompleted"];
        [taskCompletionOccurrence saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            if(succeeded){
                [relation addObject:taskCompletionOccurrence];
                [newTask saveInBackground];
            }
        }];
        i++;
    }

    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy/MM/dd --- HH:mm"];
    NSString *theDate = [dateFormatter stringFromDate:[NSDate date]];
    NSLog(@"this is the date: %@", theDate);
    newTask.type = type;
    newTask.createdDate = theDate;
    newTask.dueDate = [dateFormatter stringFromDate:ending];
    newTask.endDate = [dateFormatter stringFromDate:ending];
    newTask.taskDescription = description;
    newTask.repeats = repeat;
    newTask.repetitionPoint = whenToRepeat;
    newTask.taskDescription = description;
    newTask.occurrences = occurrences;
    [newTask saveInBackgroundWithBlock: completion];
    
 
}


+ (void) createTaskCopy: (NSString * _Nullable)taskID
                     From: (Task *)realTask
                      For: (NSString * _Nullable)description
                   OfType: (NSString * _Nullable)type
           WithRepeatType: (NSString * _Nullable)repeat
                    Point: (NSNumber * _Nullable)whenToRepeat
               NumOfTimes: (NSNumber * _Nullable)occurrences
                   Ending: (NSDate * _Nullable)ending
                Assignees: (NSArray *)assignees
        completionHandler: (void (^)(Task * _Nonnull newTask))completionHandler {
   
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
    taskCopy.taskDescription = description;
    taskCopy.occurrences = occurrences;
    taskCopy.assignedTo = (NSArray*)assigneesArr;
    taskCopy.dueDate = [dateFormatter stringFromDate:ending];
    taskCopy.endDate = [dateFormatter stringFromDate:ending];
    
    taskCopy.taskDatabaseId = taskID;
    taskCopy.reproduced = YES;

    
    [Completed getCompletedFromTask:realTask AndDate:[dateFormatter stringFromDate:ending] completionHandler:^(Completed * _Nonnull completedObject) {
        taskCopy.completedObject = completedObject;
        completionHandler(taskCopy);
    }];
}



- (void)checkIfHouseHoldMemberCompletedTask:(Task *)task :(User *)housemate completionHandler:(void (^)(BOOL housemateCompletedTask))completionHandler {
    
    [Completed getCompletedFromTask:task AndDate:task.dueDate completionHandler:^(Completed * _Nonnull completedObject) {
        NSArray *completionMembers = [completedObject objectForKey:@"currentCompletionStatus"];
        if (completionMembers != nil ) {

            if ([completionMembers containsObject:housemate.objectId]) {
                //NSLog(@"THE USER HAS COMPLETED THE TASK!! %@", housemate.name);
                completionHandler(YES);

            }
            else {
                //NSLog(@"THE USER HAS NOT COMPLETED THE TASK!! %@", housemate.name);
                completionHandler(NO);

            }
        }
    }];
}


@end
