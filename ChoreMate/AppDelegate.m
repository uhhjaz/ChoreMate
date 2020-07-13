//
//  AppDelegate.m
//  ChoreMate
//
//  Created by Jasdeep Gill on 7/13/20.
//  Copyright © 2020 jazgill. All rights reserved.
//

#import "AppDelegate.h"
#import <Parse/Parse.h>


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    ParseClientConfiguration *configuration = [ParseClientConfiguration configurationWithBlock:^(id<ParseMutableClientConfiguration> configuration) {
      configuration.applicationId = @"myAppId";
      configuration.server = @"https://jaz-choremate.herokuapp.com/parse";
        
    }];
    [Parse initializeWithConfiguration:configuration];
    
    /*
    ----ONE TIME TASK CREATION TEST (will remove later)----
    PFObject *newTask = [PFObject objectWithClassName:@"Task"];
    NSDate *theDate = [NSDate date];
    NSLog(@"this is the date: %@", theDate);
    newTask[@"type"] = @"rotational-test";
    newTask[@"created"] = theDate;
    newTask[@"due_date"] = theDate;
    newTask[@"start_date"] = theDate;
    newTask[@"end_date"] = theDate;
    newTask[@"repeats"] = @"monthly";
    newTask[@"description"] = @"this is the description";
    newTask[@"completed"] = @YES;
    
    [newTask saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
      if (succeeded) {
         NSLog(@"TASK Object saved!");
      } else {
         NSLog(@"Error: %@", error.description);
      }
    }];
    */
    
    return YES;
}


#pragma mark - UISceneSession lifecycle


- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
}


- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions {
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
}


@end
