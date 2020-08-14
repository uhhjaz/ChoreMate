//
//  OnceTimeTaskViewController.m
//  ChoreMate
//
//  Created by Jasdeep Gill on 7/16/20.
//  Copyright © 2020 jazgill. All rights reserved.
//

#import "OneTimeTaskViewController.h"
#import "AssignmentCell.h"
#import <Parse/Parse.h>
#import "User.h"
#import "Task.h"
#import "RotationalTaskViewController.h"
#import "Completed.h"
#import "NSDate+CMDate.h"
#import <CMPopTipView.h>


@interface OneTimeTaskViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, CMPopTipViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *descriptionField;
@property (weak, nonatomic) IBOutlet UIButton *dueDateButton;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, retain) NSDateFormatter * formatter;
@property (nonatomic, retain) NSDate * curDate;
@property (nonatomic, retain) NSString * theSelectedDate;
@property (strong, nonatomic) NSMutableArray *taskAssignees;
@property (strong, nonatomic) NSArray *household;
@property (strong, nonatomic) NSMapTable *map;
@property (weak, nonatomic) IBOutlet UIView *assignView;
@property (strong, nonatomic) CMPopTipView *viewPopTipView;

@end

@implementation OneTimeTaskViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    orderNum = 0;
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
    [_formatter setDateFormat:@"yyyy/MM/dd"];
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
            
            [self calculateChoresForEachHousemate];
            
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}



- (IBAction)didTapAddTask:(id)sender {
    
    [self getAssignedMembers];
    
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

- (void) calculateChoresForEachHousemate {
    self.map = [NSMapTable mapTableWithKeyOptions:NSMapTableStrongMemory valueOptions:NSMapTableStrongMemory];
    
    dispatch_group_t group = dispatch_group_create();
    for (User *householdMember in self.household) {
        __block NSMutableArray *houseMemberDueDates = [[NSMutableArray alloc] init];
        PFQuery *query = [PFQuery queryWithClassName:@"Task"];
        [query whereKey:@"assignedTo" containsString:householdMember.objectId];
        
        dispatch_group_enter(group);
        [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
            for(Task *taskFromDB in objects) {
                if([taskFromDB.type isEqual:@"one_time"]){
                    
                    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                    [dateFormatter setDateFormat:@"yyyy/MM/dd"];
                    NSDate *dueDate = [dateFormatter dateFromString:taskFromDB.dueDate];
                    [houseMemberDueDates addObject:dueDate];

                    NSLog(@"the dates are: %@",houseMemberDueDates);
                } else if([taskFromDB.type isEqual:@"recurring"]){
                    [self getRecurringRotationalTasksDates:taskFromDB :householdMember.objectId completionHandler:^(NSArray *datesOfRecurringRotationalTasks) {
                        [houseMemberDueDates addObjectsFromArray:datesOfRecurringRotationalTasks];
                         NSLog(@"the dates are: %@",houseMemberDueDates);
                    }];
                
                } else if([taskFromDB.type isEqual:@"rotational"]){
                    [self getRecurringRotationalTasksDates:taskFromDB :householdMember.objectId completionHandler:^(NSArray *datesOfRecurringRotationalTasks) {
                        [houseMemberDueDates addObjectsFromArray:datesOfRecurringRotationalTasks];
                         NSLog(@"the dates are: %@",houseMemberDueDates);
                    }];
                }
            }
            dispatch_group_leave(group);
        }];
        dispatch_group_notify(group,dispatch_get_main_queue(), ^ {
            NSSortDescriptor *sorter = [[NSSortDescriptor alloc] initWithKey:@"" ascending:YES];
            [houseMemberDueDates sortUsingDescriptors:[NSArray arrayWithObject:sorter]];
            [self.map setObject:houseMemberDueDates forKey:householdMember.objectId];
            NSLog(@"the map is: %@", self.map);
        });
    }
}



- (void) getRecurringRotationalTasksDates:(Task *)taskFromDB :(NSString *)housemateId completionHandler:(void (^)(NSArray *datesOfRecurringRotationalTasks))completionHandler{
    __block NSArray *allTheDatesForThisHousemate = [[NSArray alloc] init];
    
    [self findDates:taskFromDB :housemateId WithCompletionHandler:^(NSArray *foundTaskDates) {
        if(foundTaskDates != nil) {
            allTheDatesForThisHousemate = foundTaskDates;
            completionHandler(allTheDatesForThisHousemate);
        }
    }];
}


- (void) findDates:(Task *)taskFromDB :(NSString *)housemateID WithCompletionHandler:(void (^)(NSArray *foundTaskDates))completionHandler{
    
    NSMutableArray *rawTasksFromDB = [[NSMutableArray alloc] init];
    NSArray *taskDueDates = [self getArrayOfDueDates:taskFromDB];
    if([taskFromDB.type isEqual:@"rotational"]) {
        for (NSDate *date in taskDueDates) {

            NSString * assignedUser;
            NSDate *newDate = [date dateWithHour:00 minute:00 second:00];
            assignedUser = [self getRotationalAssigneeForTheDate:taskFromDB :newDate];
            [rawTasksFromDB addObject:newDate];
        }
    } else {
        [rawTasksFromDB addObjectsFromArray:taskDueDates];
    }
    completionHandler((NSArray *)rawTasksFromDB);
}


- (NSArray *) getArrayOfDueDates: (Task*)taskFromDB{
    
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy/MM/dd"];
    NSDate *endingDate = [dateFormatter dateFromString:taskFromDB.endDate];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString * endingDateStr = [dateFormatter stringFromDate:endingDate];
    endingDate = [dateFormatter dateFromString:endingDateStr];
    
    NSArray *dates = [[NSMutableArray alloc] init];
    if ([taskFromDB.repeats isEqual:@"daily"]){
        dates = [NSDate datesDaysAppearInStringFormat:taskFromDB.repetitionPoint.intValue Til:endingDate];
    }
    else if ([taskFromDB.repeats isEqual:@"weekly"]){
        dates = [NSDate datesWeeksAppearInStringFormat:taskFromDB.repetitionPoint.intValue Til:endingDate];
    }
    else if ([taskFromDB.repeats isEqual:@"monthly"]){
        dates = [NSDate datesMonthsAppearInStringFormat:taskFromDB.repetitionPoint.intValue Til:endingDate];
    }

    return dates;
}


- (NSString *) getRotationalAssigneeForTheDate: (Task*)taskFromDB :(NSDate *)date {

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy/MM/dd"];
    NSDate *startDate = [dateFormatter dateFromString:taskFromDB.createdDate];
    NSDate *dueDate = date;
    NSDictionary *rotationalOrder = taskFromDB.rotationalOrder;

    NSString * repeatType = taskFromDB.repeats;
    
    int taskNumber = 0;
    
    if ([repeatType isEqual:@"daily"]){
        taskNumber = [NSDate whichNumberDayOccurrence:taskFromDB.repetitionPoint.intValue From:startDate Til:dueDate];
    }
    else if ([repeatType isEqual:@"weekly"]){
        taskNumber = [NSDate whichNumberWeekOccurrence:taskFromDB.repetitionPoint.intValue From:startDate Til:dueDate];
    }
    else if ([repeatType isEqual:@"monthly"]){
        taskNumber = [NSDate whichNumberMonthOccurrence:taskFromDB.repetitionPoint.intValue From:startDate Til:dueDate];
    }
    
    NSString *taskNumToString = [@((((taskNumber)%rotationalOrder.count)+1)) stringValue];
    User *houseMember = rotationalOrder[taskNumToString];

    return houseMember.objectId;
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
    [dateFormat setDateFormat:@"yyyy/MM/dd"];
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


- (User *) calculateSuggestion:(NSString *)date {
    int minCount = INT_MAX;
    NSLog(@"int max is : %d", minCount);
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy/MM/dd"];
    NSDate *dueDateFormatted = [dateFormatter dateFromString:date];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setDay:3];
    NSDate *threeDaysForward = [calendar dateByAddingComponents:comps toDate:dueDateFormatted options:0];
    [comps setDay:-3];
    NSDate *threeDaysBack = [calendar dateByAddingComponents:comps toDate:dueDateFormatted options:0];
    
    NSLog(@"threeDaysBack: %@", threeDaysBack);
    NSLog(@"currentDay: %@", dueDateFormatted);
    NSLog(@"threeDaysForward: %@", threeDaysForward);
    
    NSString *minUser = @"";
    NSEnumerator *enumerator = [self.map keyEnumerator];
    NSString *key;
    
    while ((key = [enumerator nextObject])) {
        NSLog(@"the key is : %@", key);
        
        NSArray *value = [self.map objectForKey:key];
        
        NSLog(@"the value is : %@", value);
        
        int taskCount = 0;
        for(NSDate *taskDate in value){
            if(taskDate.timeIntervalSince1970 >= threeDaysBack.timeIntervalSince1970
               && taskDate.timeIntervalSince1970 <= threeDaysForward.timeIntervalSince1970) {
                taskCount++;
            }
        }
        
        NSLog(@"taskCount is currently %d for %@", taskCount, key);
        if(minCount > taskCount){
            minCount = taskCount;
            minUser = key;
        }
    }
    
    NSLog(@"the minUser is: %@", minUser);
    
    for (User *householdMember in self.household) {
        if(minUser == householdMember.objectId){
            return householdMember;
        }
    }
    return nil;
}


#pragma mark - THDatePickerDelegate

- (void)datePickerCancelPressed:(THDatePickerViewController *)datePicker {
    [self refreshTitle];
    
}


- (void)datePickerDonePressed:(THDatePickerViewController *)datePicker {
    NSLog(@"done pressed");
    [self refreshTitle];
    
    //User * suggestedHousemate = [self calculateSuggestions];
    
    User * suggestedHousemate = [self calculateSuggestion:self.theSelectedDate];
    
    NSLog(@"the suggestion is: %@", suggestedHousemate.name);
    
    NSString *suggestionPrompt = [NSString stringWithFormat:@"Based on the selected due date, we suggest you assign this chore to %@", suggestedHousemate.name];
    
    self.viewPopTipView = [[CMPopTipView alloc] initWithMessage:suggestionPrompt];
    self.viewPopTipView.preferredPointDirection = PointDirectionUp;
    self.viewPopTipView.delegate = self;
    [self.viewPopTipView presentPointingAtView:self.collectionView inView:self.view animated:YES];
    
}


- (void)datePicker:(THDatePickerViewController *)datePicker selectedDate:(NSDate *)selectedDate {
    NSLog(@"Date selected: %@",[_formatter stringFromDate:selectedDate]);
    self.theSelectedDate = [_formatter stringFromDate:selectedDate];
}


- (void)popTipViewWasDismissedByUser:(CMPopTipView *)popTipView {
    
}



@end
