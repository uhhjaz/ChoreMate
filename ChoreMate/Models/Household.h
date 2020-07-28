//
//  Household.h
//  ChoreMate
//
//  Created by Jasdeep Gill on 7/27/20.
//  Copyright © 2020 jazgill. All rights reserved.
//

#import <Parse/Parse.h>


NS_ASSUME_NONNULL_BEGIN

@import Parse;


@interface Household : PFObject<PFSubclassing>

@property (nonatomic, strong) NSString *name;

+ (void) postNewHousehold:(NSString *)name  completionHandler:(void (^)(NSString * householdID))completionHandler;

@end

NS_ASSUME_NONNULL_END
