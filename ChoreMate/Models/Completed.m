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
    else {
        PFQuery *query = [PFQuery queryWithClassName:@"Completed"];
        [query whereKey:@"task" equalTo:task];
    
        // add date query from task for when doing the recurring task to narrow the search
    
        [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
            if(objects[0] != nil){
                //NSLog(@"the completion obejct gotten with task %@ is user: %@",task.objectId, objects[0]);
                completionHandler(objects[0]);
            }
        }];
    }
}

@end
