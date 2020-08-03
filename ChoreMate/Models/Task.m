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
    [dateFormatter setDateFormat:@"yyyy/MM/dd"];
    NSString *theDate = [dateFormatter stringFromDate:[NSDate date]];

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
  RotationalOrder: (NSDictionary * _Nullable)rotation
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
    [dateFormatter setDateFormat:@"yyyy/MM/dd"];
    NSString *theDate = [dateFormatter stringFromDate:[NSDate date]];

    newTask.type = type;
    newTask.createdDate = theDate;
    newTask.dueDate = [dateFormatter stringFromDate:ending];
    newTask.endDate = [dateFormatter stringFromDate:ending];
    newTask.taskDescription = description;
    newTask.repeats = repeat;
    newTask.repetitionPoint = whenToRepeat;
    newTask.taskDescription = description;
    newTask.occurrences = occurrences;
    if([type isEqual:@"rotational"]){
        newTask.rotationalOrder = rotation;
    }
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
    [dateFormatter setDateFormat:@"yyyy/MM/dd"];
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
    taskCopy.reproduced = YES;
    taskCopy.taskDatabaseId = taskID;
    dispatch_group_t group2 = dispatch_group_create();
    dispatch_group_enter(group2);
    [Completed createCompletedFromTask:realTask AndDate:[dateFormatter stringFromDate:ending] completionHandler:^(Completed * _Nonnull completedObject) {
        taskCopy.completedObject = completedObject;
        dispatch_group_leave(group2);
        
    }];
    dispatch_group_notify(group2,dispatch_get_main_queue(), ^ {
        completionHandler(taskCopy);
    });
}

- (void)isTaskFullyCompleted:(Task *)task completionHandler:(void (^)(BOOL allTasksCompleted))completionHandler {
    
    [Completed getCompletedFromTask:task AndDate:task.dueDate completionHandler:^(Completed * _Nonnull completedObject) {
        completionHandler(completedObject.isCompleted);
    }];
}

- (void)isTaskWithDateFullyCompleted:(Task *)task :(NSDate *)dueDate completionHandler:(void (^)(BOOL allTasksCompleted))completionHandler {
    
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy/MM/dd"];
    
    [Completed getCompletedFromTask:task AndDate:[dateFormatter stringFromDate:dueDate] completionHandler:^(Completed * _Nonnull completedObject) {
        NSLog(@"the completed Object is: %@", completedObject);
        completionHandler(completedObject.isCompleted);
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

+ (void) getTaskFromObjectId:(NSString *)taskObjectId completionHandler:(void (^)(Task *chore))completionHandler {

    PFQuery *query = [PFQuery queryWithClassName:@"Task"];
    [query whereKey:@"objectId" equalTo:taskObjectId];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
        if(object != nil){
            Task *theChore = (Task *)object;
            completionHandler(theChore);
        }
    }];
}

@end
