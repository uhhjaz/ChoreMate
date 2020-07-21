//
//  TaskCell.m
//  ChoreMate
//
//  Created by Jasdeep Gill on 7/20/20.
//  Copyright © 2020 jazgill. All rights reserved.
//

#import "TaskCell.h"
#import "AssigneeNameCell.h"

@implementation TaskCell 

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    // user selection layout
    UICollectionViewFlowLayout *collectionViewFlowLayout = [[UICollectionViewFlowLayout alloc] init];
    [collectionViewFlowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    self.collectionView.collectionViewLayout = collectionViewFlowLayout;
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



- (void) setTaskValues{
    self.taskDescriptionLabel.text = self.task.taskDescription;
    
    self.taskContainerView.layer.cornerRadius =  15;
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy/MM/dd --- HH:mm"];
    NSDate *date = [dateFormat dateFromString:self.task.dueDate];
    [dateFormat setDateFormat:@"MM/dd/yyyy"];
    NSString* dateStr = [dateFormat stringFromDate:date];
    self.taskDueDateLabel.text = dateStr;
    
    
    if([self.task.type  isEqual: @"one_time"]){
        self.taskContainerView.backgroundColor = [UIColor colorWithRed: 0.60 green: 0.73 blue: 0.93 alpha: 1.00];
    }
    else if([self.task.type  isEqual: @"recurring"]){
        self.taskContainerView.backgroundColor = [UIColor colorWithRed: 0.65 green: 0.85 blue: 0.78 alpha: 1.00];
    }
    else if([self.task.type  isEqual: @"rotational"]){
        self.taskContainerView.backgroundColor = [UIColor colorWithRed: 0.92 green: 0.69 blue: 0.69 alpha: 1.00];
    }
    
    
    
    // check if the button should be selected or not????
    [self.taskCompletedButton addTarget:self
                         action:@selector(updateCheck:)
          forControlEvents:UIControlEventTouchUpInside];
    self.taskCompletedButton.frame = CGRectMake(10.0, 100.0, 30.0, 30.0);

    UIImage *unselected = [UIImage imageNamed:@"uncheckedbox.png"];
    UIImage *selected = [UIImage imageNamed:@"checked.png"];

    [self.taskCompletedButton setImage:unselected forState:UIControlStateNormal];
    [self.taskCompletedButton setImage:selected forState:UIControlStateSelected];

    //self.checkButton.selected = NO;
}


-(void)getTasksAssignees {

    PFRelation *relation = [self.task relationForKey:@"assignedTo"];

    // generate a query based on that relation
    PFQuery *query = [relation query];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *assignees, NSError *error) {
        if (assignees != nil) {
            NSLog(@"Successfully got assigned task members");
        
            self.taskAssignees = assignees;
            [self.collectionView reloadData];
        
        } else {
            NSLog(@"there was an error i guess");
            NSLog(@"%@", error.localizedDescription);
        }
    }];
    
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

    User *currUser = [User currentUser];
    [self.task addObject:currUser.objectId forKey:@"currentCompletionStatus"];
    [self.task saveInBackground];
    
    NSArray *completedBy = [self.task objectForKey:@"currentCompletionStatus"];
    
    NSLog(@"the completion array is: %@", completedBy);
    
    if(completedBy.count == self.taskAssignees.count){
        //TASK IS FULLY COMPLETED BY ALL USERS
    }
    [self.collectionView reloadData];
}


- (void)uncompleteAssignment {
     
    NSArray *completedBy = [self.task objectForKey:@"currentCompletionStatus"];
    if(completedBy.count == self.taskAssignees.count){
        //TASK WAS COMPLETED BY ALL USERS BEFORE THIS AND NOW IT ISNT
    }
    
    User *currUser = [User currentUser];
    [self.task removeObject:currUser.objectId forKey:@"currentCompletionStatus"];
    [self.task saveInBackground];

    [self.collectionView reloadData];
}



@end
