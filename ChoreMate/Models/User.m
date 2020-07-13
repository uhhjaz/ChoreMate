/**
 * User.h
 * ChoreMate
 *
 * Description: implementation of the User Model Class as a subclass of PFUser
 *
 * Created by Jasdeep Gill on 7/13/20.
 * Copyright © 2020 jazgill. All rights reserved.
 */


#import "User.h"

@implementation User

@dynamic name;
@dynamic profileImageView;
@dynamic household_id;

+ (User *)user {
    return (User *)[PFUser user];
}

+ (BOOL)isLoggedIn
{
    return [User currentUser] ? YES: NO;
}

@end
