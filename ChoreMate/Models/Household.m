//
//  Household.m
//  ChoreMate
//
//  Created by Jasdeep Gill on 7/27/20.
//  Copyright © 2020 jazgill. All rights reserved.
//

#import "Household.h"

@implementation Household

@dynamic name;

+ (nonnull NSString *)parseClassName {
    return @"Household";
}

+ (void) postNewHousehold:(NSString *)name  completionHandler:(void (^)(NSString * householdID))completionHandler{
    Household *newHousehold = [Household objectWithClassName:@"Household"];
    
    newHousehold.name = name;
    [newHousehold saveInBackground];
    
    completionHandler(newHousehold.objectId);
}


@end
