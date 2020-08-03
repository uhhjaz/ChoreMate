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
@dynamic createdDate;
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
    
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy/MM/dd"];
    NSString *theDate = [dateFormatter stringFromDate:[NSDate date]];
    
    NSLog(@"the chore is: %@", chore.taskDatabaseId);
    
    [newNotif setObject:chore.taskDatabaseId forKey:@"chore"];
    [newNotif setObject:fromHousemate forKey:@"fromHousemate"];
    [newNotif setObject:toHousemate forKey:@"toHousemate"];
    [newNotif setObject:@NO forKey:@"seen"];
    [newNotif setObject:theDate forKey:@"createdDate"];
    [newNotif setObject:chore.completedObject.endDate forKey:@"dueDate"];
    [newNotif setObject:chore.taskDescription forKey:@"choreDescription"];
    [newNotif saveInBackground];
    
}


@end
