//
//  RecurringTaskViewController.m
//  ChoreMate
//
//  Created by Jasdeep Gill on 7/16/20.
//  Copyright © 2020 jazgill. All rights reserved.
//

#import "RecurringTaskViewController.h"
#import "AssignmentCell.h"
#import <Parse/Parse.h>
#import "User.h"
#import "Task.h"
#import "NSDate+CMDate.h"

#import "DailyTimePickViewController.h"
#import "WeeklyDayPickViewController.h"
#import "MonthlyTimePickViewController.h"
#import "EndPickerWithDateViewController.h"
#import "EndPickerWithOccurrenceViewController.h"
#import "RotationalTaskViewController.h"

@interface RecurringTaskViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UIView *monthlyTimeContainer;
@property (weak, nonatomic) IBOutlet UIView *weeklyDayContainer;
@property (weak, nonatomic) IBOutlet UIView *dailyTimeContainer;
@property (weak, nonatomic) IBOutlet UIView *endDateContainer;
@property (weak, nonatomic) IBOutlet UIView *endOccurrenceContainer;

@property (strong, nonatomic) DailyTimePickViewController * dailyTimePickController;
@property (strong, nonatomic) WeeklyDayPickViewController * weeklyDayPickController;
@property (strong, nonatomic) MonthlyTimePickViewController * monthlyTimePickController;
@property (strong, nonatomic) EndPickerWithDateViewController * endPickerWithDateController;
@property (strong, nonatomic) EndPickerWithOccurrenceViewController * endPickerWithOccurrenceController;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UITextField *descriptionField;

@property (weak, nonatomic) IBOutlet UISegmentedControl *repeatMethodSegmentControl;
@property (weak, nonatomic) IBOutlet UISegmentedControl *endMethodSegmentControl;

@property (strong, nonatomic) NSMutableArray *taskAssignees;
@property (strong, nonatomic) NSArray *household;

@property (strong, nonatomic) NSString *chosenRepeat;
@property (strong, nonatomic) NSNumber *chosenWhenToRepeat;
@property (strong, nonatomic) NSString *chosenEndMethod;
@property (strong, nonatomic) NSNumber *chosenOccurrences;

@end

static NSString * const DAILY = @"daily";
static NSString * const WEEKLY = @"weekly";
static NSString * const MONTHLY = @"monthly";
static NSString * const BY_DATE = @"date";
static NSString * const BY_OCCURRENCE = @"occurrence";

@implementation RecurringTaskViewController

int const DAY_TIME_CHOSEN = 0;
int const WEEK_DAY_CHOSEN = 1;
int const MONTH_DAY_CHOSEN = 2;
int const DATE_CHOSEN = 0;
int const OCCURRENCES_CHOSEN = 1;
int const SHOW_VIEW = 1;
int const DO_NOT_SHOW_VIEW = 0;


- (void)viewDidLoad {
    [super viewDidLoad];
    orderNum = 0;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.chosenRepeat = DAILY;
    self.chosenEndMethod = BY_DATE;
    
    [self getHousehold];
    
    // user selection layout
    UICollectionViewFlowLayout *collectionViewFlowLayout = [[UICollectionViewFlowLayout alloc] init];
    [collectionViewFlowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    self.collectionView.collectionViewLayout = collectionViewFlowLayout;
    
    // dismisses keyboard for task description input
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    
    [self setChildViewControllers];
}

- (void) setChildViewControllers{
    self.dailyTimePickController = [self.childViewControllers objectAtIndex:0];
    self.weeklyDayPickController = [self.childViewControllers objectAtIndex:1];
    self.monthlyTimePickController = [self.childViewControllers objectAtIndex:2];
    self.endPickerWithDateController = [self.childViewControllers objectAtIndex:3];
    self.endPickerWithOccurrenceController = [self.childViewControllers objectAtIndex:4];
    self.dailyTimePickController.type =
    self.weeklyDayPickController.type =
    self.monthlyTimePickController.type =
    self.endPickerWithDateController.type =
    self.endPickerWithOccurrenceController.type = @"recurring";
}


- (void) getHousehold{

    User *curr = [User currentUser];
    PFQuery *query = [PFUser query];
    
    // query for household members of the current user
    [query whereKey:@"household_id" equalTo:curr.household_id];
    [query findObjectsInBackgroundWithBlock:^(NSArray *users, NSError *error) {
        if (users != nil) {
            NSLog(@"Successfully got household members");
            
            self.household = users;
            [self.collectionView reloadData];
            
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}


- (void) getAssignedMembers {
    
    // populate array with household members selected for the task
    self.taskAssignees = [[NSMutableArray alloc] init];
    for (int i = 0; i < self.household.count; i++){
        
        
        UIButton *check = (UIButton *)[self.view viewWithTag:i+1];
        
        if ([check isSelected]){
            [self.taskAssignees addObject:self.household[i]];
            
        }
    }
}


-(void)dismissKeyboard {
    [self.descriptionField resignFirstResponder];
}


#pragma mark - Task Assignee Collection View

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    CGFloat totalCellWidth = 80 * self.household.count;
    CGFloat totalSpacingWidth = 10 * (((float)self.household.count - 1) < 0 ? 0 :self.household.count - 1);
    CGFloat leftInset = (self.view.bounds.size.width - (totalCellWidth + totalSpacingWidth)) / 2;
    CGFloat rightInset = leftInset;
    UIEdgeInsets sectionInset = UIEdgeInsetsMake(0, leftInset/4, 0, rightInset);
    return sectionInset;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(100, 80);
}


- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    AssignmentCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"AssignmentCell" forIndexPath:indexPath];
    cell.user = self.household[indexPath.row];
    cell.type = @"recurring";
    [cell setCellValues];
    cell.checkButton.tag = indexPath.row + 1;
    return cell;
}


- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section {
    return self.household.count;
}


#pragma mark - SegmentControlContainers

- (IBAction)showContainer:(UISegmentedControl *)sender {
    
    switch (sender.selectedSegmentIndex) {
        case DAY_TIME_CHOSEN: {
            [UIView animateWithDuration:0.2 animations:^{
                self.dailyTimeContainer.alpha = SHOW_VIEW;
                self.weeklyDayContainer.alpha = DO_NOT_SHOW_VIEW;
                self.monthlyTimeContainer.alpha = DO_NOT_SHOW_VIEW;
            }];
            self.chosenRepeat = DAILY;
            break;
        }
        case WEEK_DAY_CHOSEN: {
            [UIView animateWithDuration:0.2 animations:^{
                self.dailyTimeContainer.alpha = DO_NOT_SHOW_VIEW;
                self.weeklyDayContainer.alpha = SHOW_VIEW;
                self.monthlyTimeContainer.alpha = DO_NOT_SHOW_VIEW;
            }];
            self.chosenRepeat = WEEKLY;
            break;
        }
        case MONTH_DAY_CHOSEN: {
            [UIView animateWithDuration:0.2 animations:^{
                self.dailyTimeContainer.alpha = DO_NOT_SHOW_VIEW;
                self.weeklyDayContainer.alpha = DO_NOT_SHOW_VIEW;
                self.monthlyTimeContainer.alpha = SHOW_VIEW;
            }];
            self.chosenRepeat = MONTHLY;
            break;
        }
        default:
            break;
    }

}


- (IBAction)showEndContainer:(UISegmentedControl *)sender {
    
    switch (sender.selectedSegmentIndex) {
        case DATE_CHOSEN: {
            [UIView animateWithDuration:0.2 animations:^{
                self.endDateContainer.alpha = SHOW_VIEW;
                self.endOccurrenceContainer.alpha = DO_NOT_SHOW_VIEW;
            }];
            self.chosenEndMethod = BY_DATE;
            break;
        }
        case OCCURRENCES_CHOSEN: {
            [UIView animateWithDuration:0.2 animations:^{
                self.endDateContainer.alpha = DO_NOT_SHOW_VIEW;
                self.endOccurrenceContainer.alpha = SHOW_VIEW;
            }];
            self.chosenEndMethod = BY_OCCURRENCE;
            break;
        }
        default:
            break;
    }
}


#pragma mark - Set User Configured Values

- (NSArray *) setOccurrences {
    if([self.chosenEndMethod isEqual:BY_DATE]){
        
        NSDate *endDate = self.endPickerWithDateController.pickedDate;
        
        if([self.chosenRepeat isEqual:DAILY]){
            return [NSDate datesDaysAppear:(NSInteger)[self.chosenWhenToRepeat intValue] Til:endDate];
        } else if ([self.chosenRepeat isEqual:WEEKLY]) {
            return [NSDate datesWeeksAppear:(NSInteger)[self.chosenWhenToRepeat intValue] Til:endDate];
        } else if ([self.chosenRepeat isEqual:MONTHLY]) {
            return [NSDate datesMonthsAppear:(NSInteger)[self.chosenWhenToRepeat intValue] Til:endDate];
        }
    }
//    } else if ([self.chosenEndMethod isEqual:BY_OCCURRENCE]){
//        return self.endPickerWithOccurrenceController.numOfOccurences;
//    }
    return nil;
}



#pragma mark - Navigation

- (IBAction)addTaskTapped:(id)sender {
    
    if ([self.chosenRepeat isEqual:DAILY]){
        self.chosenWhenToRepeat = @([self.dailyTimePickController.pickedTime intValue]);
    } else if ([self.chosenRepeat isEqual:WEEKLY]) {
        self.chosenWhenToRepeat = @([self.weeklyDayPickController.pickedDay intValue]);
    } else if ([self.chosenRepeat isEqual:MONTHLY]) {
        self.chosenWhenToRepeat = @([self.monthlyTimePickController.pickedDay intValue]);
    }
    
    NSArray *endDates = [self setOccurrences];
    self.chosenOccurrences = @(endDates.count);

    [self getAssignedMembers];
    NSDate *endDate = self.endPickerWithDateController.pickedDate;
    
    NSLog(@"the task description is: %@",self.descriptionField.text);
    NSLog(@"the repeat is: %@",self.chosenRepeat);
    NSLog(@"the when to repeat is: %@",self.chosenWhenToRepeat);
    NSLog(@"the num of occurrences is: %@",self.chosenOccurrences);
    NSLog(@"the task is assigned to: %@",self.taskAssignees);
    
    
    [Task postTask:self.descriptionField.text OfType:@"recurring" WithRepeatType:self.chosenRepeat Point:self.chosenWhenToRepeat NumOfTimes:self.chosenOccurrences Ending:endDate Assignees:self.taskAssignees DueDates:endDates RotationalOrder:nil withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
        
        if(succeeded){
            NSLog(@"posting reoccuring task success");
            self.descriptionField.text = @"";
            [self performSegueWithIdentifier:@"added_RE_Task" sender:sender];
        }
        else{
            NSLog(@"Error posting image: %@", error.localizedDescription);
        }
    }];
}


@end
