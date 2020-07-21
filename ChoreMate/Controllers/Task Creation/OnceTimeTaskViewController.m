//
//  OnceTimeTaskViewController.m
//  ChoreMate
//
//  Created by Jasdeep Gill on 7/16/20.
//  Copyright © 2020 jazgill. All rights reserved.
//

#import "OnceTimeTaskViewController.h"
#import "AssignmentCell.h"
#import <Parse/Parse.h>
#import "User.h"
#import "Task.h"

@interface OnceTimeTaskViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UITextField *descriptionField;
@property (weak, nonatomic) IBOutlet UIButton *dueDateButton;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) NSArray *household;
@property (nonatomic, retain) NSDate * curDate;
@property (nonatomic, retain) NSDateFormatter * formatter;
@property (nonatomic, retain) NSString * theSelectedDate;
@property (strong, nonatomic) NSMutableArray *taskAssignees;

@end

@implementation OnceTimeTaskViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    [self getHousehold];
    
    // user selection layout
    UICollectionViewFlowLayout *collectionViewFlowLayout = [[UICollectionViewFlowLayout alloc] init];
    [collectionViewFlowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    self.collectionView.collectionViewLayout = collectionViewFlowLayout;
    
    // dismisses keyboard for task description input
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    
    // sets and refreshes the date picker
    self.curDate = [NSDate date];
    self.formatter = [[NSDateFormatter alloc] init];
    [_formatter setDateFormat:@"yyyy/MM/dd --- HH:mm"];
    //[self.dueDateButton.titleLabel setTextAlignment:NSTextAlignmentCenter];
    self.dueDateButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self refreshTitle];
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



- (IBAction)didTapAddTask:(id)sender {
    
    [self getAssignedMembers];
    
    //NSLog(@"the users assigned to the task are: %@", self.taskAssignees);
    
    // call Task class methods to post the task and segue to task screen
    [Task postTask:self.descriptionField.text OfType:@"one_time" WithDate:self.theSelectedDate Assignees:self.taskAssignees withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
        if(succeeded){
            NSLog(@"posting task success");
            self.descriptionField.text = @"";
            [self performSegueWithIdentifier:@"added_OT_Task" sender:sender];
        }
        else{
            NSLog(@"Error posting image: %@", error.localizedDescription);
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
    [cell setCellValues];
    cell.checkButton.tag = indexPath.row + 1;
    return cell;
}


- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section {
    return self.household.count;
}


-(void)dismissKeyboard {
    [self.descriptionField resignFirstResponder];
}


-(void)refreshTitle {
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy/MM/dd --- HH:mm"];
    NSDate *date = [dateFormat dateFromString:self.theSelectedDate];
    [dateFormat setDateFormat:@"MM/dd/yyyy"];
    //NSString* dateStr = [dateFormat stringFromDate:date];
    [self.dueDateButton setTitle:(self.theSelectedDate ? [dateFormat stringFromDate:date] : @"No date selected") forState:UIControlStateNormal];
    
}


- (IBAction)dateButtonTouched:(id)sender {
    if(!self.datePicker)
        self.datePicker = [THDatePickerViewController datePicker];
        self.datePicker.date = self.curDate;
        self.datePicker.delegate = self;
        [self.datePicker setDateTimeZoneWithName:@"UTC"];
        [self.datePicker setAllowClearDate:YES];
        [self.datePicker setClearAsToday:YES];
        [self.datePicker setAutoCloseOnSelectDate:YES];
        [self.datePicker setAllowSelectionOfSelectedDate:YES];
        [self.datePicker setDisableYearSwitch:YES];
        [self.datePicker setDaysInHistorySelection:200];
        [self.datePicker setDaysInFutureSelection:200];
        [self.datePicker setAutoCloseCancelDelay:1.0];
        [self.datePicker setSelectedBackgroundColor:[UIColor colorWithRed:125/255.0 green:208/255.0 blue:0/255.0 alpha:1.0]];
        [self.datePicker setCurrentDateColor:[UIColor colorWithRed:242/255.0 green:121/255.0 blue:53/255.0 alpha:1.0]];
        [self.datePicker setCurrentDateColorSelected:[UIColor yellowColor]];
        
        //[self.datePicker slideUpInView:self.view withModalColor:[UIColor lightGrayColor]];
        [self presentSemiViewController:self.datePicker withOptions:@{
                                                                      KNSemiModalOptionKeys.pushParentBack    : @(NO),
                                                                      KNSemiModalOptionKeys.animationDuration : @(.7),
                                                                      KNSemiModalOptionKeys.shadowOpacity     : @(0.3),
                                                                      }];
    [self refreshTitle];
}


#pragma mark - THDatePickerDelegate

- (void)datePickerCancelPressed:(THDatePickerViewController *)datePicker {
    [self refreshTitle];
    
}

- (void)datePickerDonePressed:(THDatePickerViewController *)datePicker {
    [self refreshTitle];
    
}

- (void)datePicker:(THDatePickerViewController *)datePicker selectedDate:(NSDate *)selectedDate {
    NSLog(@"Date selected: %@",[_formatter stringFromDate:selectedDate]);
    self.theSelectedDate = [_formatter stringFromDate:selectedDate];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/





@end
