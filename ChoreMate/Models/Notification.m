//
//  Notification.m
//  ChoreMate
//
//  Created by Jasdeep Gill on 8/3/20.
//  Copyright © 2020 jazgill. All rights reserved.
//

#import "Notification.h"

@implementation Notification

@dynamic fromHousemate;
@dynamic toHousemate;
@dynamic type;
@dynamic chore;
@dynamic seen;
@dynamic choreDescription;
@dynamic dueDate;

+ (nonnull NSString *)parseClassName {
    return @"Notification";
}

+ (void) postNotification: (NSString * _Nullable)type
                     From: (User *)fromHousemate
                       To: (User *)toHousemate
                 ForChore: (Task *)chore
           withCompletion: (PFBooleanResultBlock  _Nullable)completion {
    
    Notification *newNotif = [Notification objectWithClassName:@"Notification"];
    
    [newNotif setObject:chore.taskDatabaseId forKey:@"chore"];
    [newNotif setObject:fromHousemate forKey:@"fromHousemate"];
    [newNotif setObject:toHousemate forKey:@"toHousemate"];
    [newNotif setObject:@NO forKey:@"seen"];
    [newNotif setObject:chore.completedObject.endDate forKey:@"dueDate"];
    [newNotif setObject:chore.taskDescription forKey:@"choreDescription"];
    [newNotif saveInBackground];
    
}


@end
