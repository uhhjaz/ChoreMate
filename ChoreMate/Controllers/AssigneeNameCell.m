//
//  AssigneeNameCell.m
//  ChoreMate
//
//  Created by Jasdeep Gill on 7/20/20.
//  Copyright © 2020 jazgill. All rights reserved.
//

#import "AssigneeNameCell.h"
#import <Parse/Parse.h>

@implementation AssigneeNameCell


- (void) setAssignee{
    NSArray* firstLastStrings = [self.user.name componentsSeparatedByString:@" "];
    self.nameLabel.text = [NSString stringWithFormat:@"%@",[firstLastStrings objectAtIndex:0]];
    self.nameLabel.textColor = [UIColor redColor];

    NSArray *completionMembers = [self.task objectForKey:@"currentCompletionStatus"];
    
    if (completionMembers != nil ) {

        if ([completionMembers containsObject:self.user.objectId]) {
            [self setNameForCompletion];
            NSLog(@"THE USER HAS COMPLETED THE TASK!! %@", self.user.name);
        }
        else {
            [self setNameForNotYetCompleted];
            NSLog(@"THE USER HAS NOT COMPLETED THE TASK!! %@", self.user.name);
        }
    }
}


- (void) setNameForCompletion{
    self.nameLabel.textColor = [UIColor greenColor];
}

- (void) setNameForNotYetCompleted{
    self.nameLabel.textColor = [UIColor redColor];
}

@end
