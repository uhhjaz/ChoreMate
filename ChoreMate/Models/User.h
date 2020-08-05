/**
 * User.h
 * ChoreMate
 *
 * Description: Interface declaration of the User Model Class as a subclass of PFUser
 *
 * Created by Jasdeep Gill on 7/13/20.
 * Copyright © 2020 jazgill. All rights reserved.
 */

#import <Parse/Parse.h>

NS_ASSUME_NONNULL_BEGIN

@import Parse;

@interface User : PFUser

// MARK: Properties
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) PFFileObject *profileImageView;
@property (nonatomic, strong) NSString *household_id;
@property (nonatomic, assign) BOOL fb_authenticated;

// MARK: Methods
+ (User *)user;
+ (BOOL)isLoggedIn;
+ (void) updateUserProfileImage: ( UIImage * _Nullable )image withCompletion: (PFBooleanResultBlock  _Nullable)completion;
+ (PFFileObject *)getPFFileFromImage: (UIImage * _Nullable)image;
+ (void) getUserFromObjectId:(NSString *)userObjectId completionHandler:(void (^)(User *user))completionHandler;
@end

NS_ASSUME_NONNULL_END
