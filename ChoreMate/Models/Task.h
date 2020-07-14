/**
 * Task.h
 * ChoreMate
 *
 * Description: Interface declaration of the general Task Class as a subclass of PFObject
 *
 * Created by Jasdeep Gill on 7/13/20.
 * Copyright © 2020 jazgill. All rights reserved.
 */

#import <Parse/Parse.h>
#import "User.h"

NS_ASSUME_NONNULL_BEGIN


@interface Task : PFObject<PFSubclassing>
@property (nonatomic, strong) NSString *postID;
@property (nonatomic, strong) NSString *userID;
@property (nonatomic, strong) User *author;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *taskDescription;
@property (nonatomic, strong) NSArray *assignedTo;
@property (nonatomic, strong) NSString *createdDate;
@property (nonatomic, strong) NSString *dueDate;
@property (nonatomic, assign) BOOL completed; // not sure what the difference is between assign and strong
@property (nonatomic, strong) NSString *startDate;
@property (nonatomic, strong) NSString *endDate;
@property (nonatomic, strong) NSArray *rotationalOrder;
@property (nonatomic, strong) NSString *repeats;


@end

NS_ASSUME_NONNULL_END
