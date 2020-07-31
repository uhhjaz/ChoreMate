//
//  Completed.m
//  ChoreMate
//
//  Created by Jasdeep Gill on 7/26/20.
//  Copyright © 2020 jazgill. All rights reserved.
//

#import "Completed.h"


@implementation Completed

@dynamic task;
@dynamic isCompleted;
@dynamic endDate;
@dynamic currentCompletionStatus;

+ (nonnull NSString *)parseClassName {
    return @"Completed";
}

+ (void) getCompletedFromTask:(Task *)task AndDate:(NSString *)dueDate completionHandler:(void (^)(Completed *completedObject))completionHandler {
    
    if(task.reproduced){

        completionHandler(task.completedObject);
        return;
    }
    else if (task.completedObject != nil) {
        completionHandler(task.completedObject);
        return;
    }
    else {
        PFQuery *query = [PFQuery queryWithClassName:@"Completed"];
        [query whereKey:@"task" equalTo:task];
    
        [query getFirstObjectInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
            if(error){
                NSLog(@"there is an error: %@", error.localizedDescription);
            }
            if(object != nil){
                completionHandler((Completed *)object);
            }
        }];
    }
}


+ (void) createCompletedFromTask:(Task *)task AndDate:(NSString *)dueDate completionHandler:(void (^)(Completed *completedObject))completionHandler {
    PFQuery *query = [PFQuery queryWithClassName:@"Completed"];
    [query whereKey:@"task" equalTo:task];
    [query whereKey:@"endDate" equalTo:dueDate];

    // add date query from task for when doing the recurring task to narrow the search
    [query getFirstObjectInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
        if(error){
            NSLog(@"there is an error: %@", error.localizedDescription);
        }
        if(object != nil){
            completionHandler((Completed *)object);
        }
    }];
}

@end
