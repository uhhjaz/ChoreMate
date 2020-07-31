//
//  HouseMateTaskCell.m
//  ChoreMate
//
//  Created by Jasdeep Gill on 7/31/20.
//  Copyright © 2020 jazgill. All rights reserved.
//

#import "HouseMateTaskCell.h"
#import "CMColor.h"
#import "AssigneeNameCell.h"

@implementation HouseMateTaskCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    // user selection layout
    UICollectionViewFlowLayout *collectionViewFlowLayout = [[UICollectionViewFlowLayout alloc] init];
    [collectionViewFlowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    self.collectionView.collectionViewLayout = collectionViewFlowLayout;
    
   // [self refreshCollection];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
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



- (void) getTasksAssignees {

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


- (void) setTaskValues{
    self.taskDescriptionLabel.text = self.task.taskDescription;
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy/MM/dd"];
    NSDate *date = [dateFormat dateFromString:self.task.dueDate];
    [dateFormat setDateFormat:@"MM/dd/yyyy"];
    NSString* dateStr = [dateFormat stringFromDate:date];
    self.dateLabel.text = dateStr;
    
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


@end
