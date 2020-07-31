//
//  TaskCell.m
//  ChoreMate
//
//  Created by Jasdeep Gill on 7/20/20.
//  Copyright © 2020 jazgill. All rights reserved.
//

#import "TaskCell.h"
#import "AssigneeNameCell.h"
#import "Completed.h"
#import "CMColor.h"

@implementation TaskCell 

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    // user selection layout
    UICollectionViewFlowLayout *collectionViewFlowLayout = [[UICollectionViewFlowLayout alloc] init];
    [collectionViewFlowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    self.collectionView.collectionViewLayout = collectionViewFlowLayout;
    
    [self refreshCollection];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}


- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    CGFloat totalCellWidth = 50 * self.taskAssignees.count;
    CGFloat totalSpacingWidth = 10 * (((float)self.taskAssignees.count - 1) < 0 ? 0 :self.taskAssignees.count - 1);
    CGFloat leftInset = (self.taskContainerView.bounds.size.width - (totalCellWidth + totalSpacingWidth)) / 2;
    CGFloat rightInset = leftInset;
    UIEdgeInsets sectionInset = UIEdgeInsetsMake(0, 0, 0, rightInset);
    return sectionInset;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(50, 15);
}


- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    AssigneeNameCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"AssigneeNameCell" forIndexPath:indexPath];
    cell.user = self.taskAssignees[indexPath.item];
    cell.task = self.task;
    [cell setAssignee];
    

    
    return cell;

}


- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section {
    return self.taskAssignees.count;
}



- (void) setTaskValues{
    self.taskDescriptionLabel.text = self.task.taskDescription;
    
    self.taskContainerView.layer.cornerRadius =  15;
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy/MM/dd"];
    NSDate *date = [dateFormat dateFromString:self.task.dueDate];
    [dateFormat setDateFormat:@"MM/dd/yyyy"];
    NSString* dateStr = [dateFormat stringFromDate:date];
    self.taskDueDateLabel.text = dateStr;
    
    
    // TODO: create file for colors, create getters for commonly used colors
    [Completed getCompletedFromTask:self.task AndDate:self.task.dueDate completionHandler:^(Completed * _Nonnull completedObject) {
        if (!completedObject.isCompleted){
            if([self.task.type  isEqual: @"one_time"]){
                self.taskContainerView.backgroundColor = [CMColor oneTimeTaskColor];
            }
            else if([self.task.type  isEqual: @"recurring"]){
                self.taskContainerView.backgroundColor = [CMColor recurringTaskColor];
            }
            else if([self.task.type  isEqual: @"rotational"]){
                self.taskContainerView.backgroundColor = [CMColor rotationalTaskColor];

            }
        }
        else {
            self.taskContainerView.backgroundColor = [CMColor completedTaskColor];
        }
    }];
    
    
    [self.taskCompletedButton addTarget:self
                         action:@selector(updateCheck:)
          forControlEvents:UIControlEventTouchUpInside];
    self.taskCompletedButton.frame = CGRectMake(10.0, 100.0, 30.0, 30.0);

    UIImage *unselected = [UIImage imageNamed:@"uncheckedbox.png"];
    UIImage *selected = [UIImage imageNamed:@"checked.png"];

    [self.taskCompletedButton setImage:unselected forState:UIControlStateNormal];
    [self.taskCompletedButton setImage:selected forState:UIControlStateSelected];
    
    [self.task checkIfHouseHoldMemberCompletedTask:self.task :[User currentUser] completionHandler:^(BOOL housemateCompletedTask) {
        if(housemateCompletedTask){
            self.taskCompletedButton.selected = YES;
            
        }
        else{
            self.taskCompletedButton.selected = NO;
        }
    }];

}


-(void)getTasksAssignees {

    // populate TaskAssignees with User Objects
    NSArray *userIds = [self.task objectForKey:@"assignedTo"];
    
    self.taskAssignees = [[NSMutableArray alloc] init];
    [self getArrayOfTaskAssignees:userIds completionHandler:^(NSArray * _Nonnull allAssignees) {
        self.taskAssignees = allAssignees;
        [self.collectionView reloadData];
    }];

}


- (void) getArrayOfTaskAssignees:(NSArray *)usersIds completionHandler:(void (^)(NSArray *allAssignees))completionHandler {

    NSMutableArray *gettingAssignees = [[NSMutableArray alloc] init];
    
    dispatch_group_t group4 = dispatch_group_create();
    
    for(NSString *userId in usersIds){
        
        dispatch_group_enter(group4);
        
        [User getUserFromObjectId:userId completionHandler:^(User * _Nonnull user) {
            [gettingAssignees addObject:user];
            dispatch_group_leave(group4);
        }];
        
    }
    
    dispatch_group_notify(group4,dispatch_get_main_queue(), ^ {
        completionHandler((NSArray*)gettingAssignees);
    });
}


- (void)updateCheck:(UIButton *)btn{
    if (self.taskCompletedButton.isSelected ==  true) {
        self.taskCompletedButton.selected = NO;
        [self uncompleteAssignment];
        
    }else {
        self.taskCompletedButton.selected = YES;
        [self completeAssignment];
        
    }
}

- (void)completeAssignment {
    
    dispatch_group_t group5 = dispatch_group_create();
    
    dispatch_group_enter(group5);
    [Completed getCompletedFromTask:self.task AndDate:self.task.dueDate completionHandler:^(Completed * _Nonnull completedObject) {
        
        User *currUser = [User currentUser];
        [completedObject addObject:currUser.objectId forKey:@"currentCompletionStatus"];
        [completedObject saveInBackground];
        
        NSArray *completedBy = [completedObject objectForKey:@"currentCompletionStatus"];
        
        if(completedBy.count == self.taskAssignees.count){
            completedObject.isCompleted = @YES;
            [completedObject saveInBackground];
            //TASK IS FULLY COMPLETED BY ALL USERS

            self.taskContainerView.backgroundColor = [CMColor completedTaskColor];
        }
        dispatch_group_leave(group5);
    }];

    dispatch_group_notify(group5,dispatch_get_main_queue(), ^ {
        [self performSelectorOnMainThread:@selector(refreshCollection) withObject:self.collectionView waitUntilDone:YES];
    });
}


-(void)refreshCollection {
    [self.collectionView reloadData];
}


- (void)uncompleteAssignment {
    
    dispatch_group_t group6 = dispatch_group_create();
    
    dispatch_group_enter(group6);
    [Completed getCompletedFromTask:self.task AndDate:self.task.dueDate completionHandler:^(Completed * _Nonnull completedObject) {
         
        NSArray *completedBy = [completedObject objectForKey:@"currentCompletionStatus"];
         
        if(completedBy.count == self.taskAssignees.count){
            completedObject.isCompleted = false;
            [completedObject saveInBackground];
            //TASK IS FULLY COMPLETED BY ALL USERS

            if([self.task.type  isEqual: @"one_time"]){
                self.taskContainerView.backgroundColor = [CMColor oneTimeTaskColor];
            }
            else if([self.task.type  isEqual: @"recurring"]){
                self.taskContainerView.backgroundColor = [CMColor recurringTaskColor];
            }
            else if([self.task.type  isEqual: @"rotational"]){
                self.taskContainerView.backgroundColor = [CMColor rotationalTaskColor];
            }
        }
        
        User *currUser = [User currentUser];
        [completedObject removeObject:currUser.objectId forKey:@"currentCompletionStatus"];
        [completedObject saveInBackground];
        dispatch_group_leave(group6);
    }];

    dispatch_group_notify(group6,dispatch_get_main_queue(), ^ {
        [self performSelectorOnMainThread:@selector(refreshCollection) withObject:self.collectionView waitUntilDone:YES];
    });
}



@end
