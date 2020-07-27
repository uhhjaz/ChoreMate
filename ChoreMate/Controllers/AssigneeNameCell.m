//
//  AssigneeNameCell.m
//  ChoreMate
//
//  Created by Jasdeep Gill on 7/20/20.
//  Copyright © 2020 jazgill. All rights reserved.
//

#import "AssigneeNameCell.h"
#import <Parse/Parse.h>
#import "Completed.h"

@implementation AssigneeNameCell


- (void) setAssignee{
    NSArray* firstLastStrings = [self.user.name componentsSeparatedByString:@" "];
    self.nameLabel.text = [NSString stringWithFormat:@"%@",[firstLastStrings objectAtIndex:0]];
    self.nameLabel.textColor = [UIColor redColor];
    
    [Completed getCompletedFromTask:self.task AndDate:self.task.dueDate completionHandler:^(Completed * _Nonnull completedObject) {
        NSArray *completionMembers = [completedObject objectForKey:@"currentCompletionStatus"];
        if (completionMembers != nil ) {

            if ([completionMembers containsObject:self.user.objectId]) {
                [self setNameForCompletion];
                //NSLog(@"THE USER HAS COMPLETED THE TASK!! %@", self.user.name);
            }
            else {
                [self setNameForNotYetCompleted];
                //NSLog(@"THE USER HAS NOT COMPLETED THE TASK!! %@", self.user.name);
            }
        }
    }];
}


- (void) setNameForCompletion{
    self.nameLabel.textColor = [UIColor greenColor];

//    NSDictionary* attributes = @{
//      NSStrikethroughStyleAttributeName: [NSNumber numberWithInt:NSUnderlineStyleSingle]
//    };
//
//    NSAttributedString* attrText = [[NSAttributedString alloc] initWithString:self.nameLabel.text attributes:attributes];
//    self.nameLabel.attributedText = attrText;
}

- (void) setNameForNotYetCompleted{
    
    self.nameLabel.textColor = [UIColor redColor];
//    self.nameLabel.attributedText = [[NSAttributedString alloc] initWithString:self.nameLabel.text attributes:nil];
}

@end
