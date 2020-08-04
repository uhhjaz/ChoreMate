//
//  Notification.h
//  ChoreMate
//
//  Created by Jasdeep Gill on 8/3/20.
//  Copyright © 2020 jazgill. All rights reserved.
//

#import <Parse/Parse.h>
#import "User.h"
#import "Task.h"

NS_ASSUME_NONNULL_BEGIN

@import Parse;

@interface Notification : PFObject<PFSubclassing>

@property (nonatomic, strong) User *fromHousemate;
@property (nonatomic, strong) User *toHousemate;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *chore;
@property (nonatomic, strong) NSString *choreDescription;
@property (nonatomic, assign) BOOL seen;
@property (nonatomic, strong) NSString *dueDate;


+ (void) postNotification: (NSString * _Nullable)type
                     From: (User *)fromHousemate
                       To: (User *)toHousemate
                 ForChore: (Task *)chore
           withCompletion: (PFBooleanResultBlock  _Nullable)completion;

@end

NS_ASSUME_NONNULL_END
