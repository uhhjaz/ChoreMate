/**
 * HouseholdViewController.m
 * ChoreMate
 *
 * Description:
 *
 * Created by Jasdeep Gill on 7/13/20.
 * Copyright © 2020 jazgill. All rights reserved.
 */

#import "HouseholdViewController.h"
#import "MMDrawerBarButtonItem.h"
#import "UIViewController+MMDrawerController.h"
#import "User.h"
#import "NoHouseholdViewController.h"
#import "HouseholdMemberCell.h"
#import "Household.h"
#import "CreateHouseholdViewController.h"
#import "JoinHouseholdViewController.h"
#import "HouseMemberTaskViewController.h"
#import "HouseMateTaskCell.h"
#import <Parse/Parse.h>

@interface HouseholdViewController () <UITableViewDelegate,UITableViewDataSource,CreateHouseholdControllerDelegate, JoinHouseholdControllerDelegate, NoHouseholdControllerDelegate>

@property (weak, nonatomic) IBOutlet UIView *noHouseholdContainer;
@property (strong, nonatomic) NoHouseholdViewController * noHouseholdViewController;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *householdNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *householdCodeLabel;

@property (weak, nonatomic) IBOutlet Household *household;
@property (strong, nonatomic) NSArray *houseMembers;

@end

@implementation HouseholdViewController

-(void)viewWillAppear:(BOOL)animated{
    
    User * currUser = [User currentUser];
    if(currUser.household_id == nil){
        self.noHouseholdContainer.alpha = 1;
        self.noHouseholdViewController = [self.childViewControllers objectAtIndex:0];
        self.noHouseholdViewController.delegate = self;
    }
    else{
        self.noHouseholdContainer.alpha = 0;
        [self getHousehold];
        [self getHouseholdMembers];
        
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupLeftMenuButton];
    
    User * currUser = [User currentUser];
    if(currUser.household_id == nil){
        self.noHouseholdContainer.alpha = 1;
        self.noHouseholdViewController = [self.childViewControllers objectAtIndex:0];
        self.noHouseholdViewController.delegate = self;
    }
    else{
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.noHouseholdContainer.alpha = 0;
        [self getHousehold];
        [self getHouseholdMembers];
        
    }
}

- (void)didFinishGettingAHousehold {
    
}

- (void)setHeaderLabels{
    
    self.householdNameLabel.text = self.household.name;
    self.householdCodeLabel.text = [@"Code: " stringByAppendingString:self.household.objectId];
}

- (void)getHousehold{
    User *currentHouseholdMember = [User currentUser];
    PFQuery *query = [PFQuery queryWithClassName:@"Household"];
    [query whereKey:@"objectId" containsString:currentHouseholdMember.household_id];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
        if(object){
            self.household = (Household*)object;
            [self setHeaderLabels];
        }
    }];
}

- (void)getHouseholdMembers {

    User *curr = [User currentUser];
        
    PFQuery *query = [PFUser query];
        
    // query for household members of the user
    [query whereKey:@"household_id" equalTo:curr.household_id];
    [query whereKey:@"objectId" notEqualTo:curr.objectId];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *users, NSError *error) {
        if (users != nil) {
            NSLog(@"Successfully got household members");
                
            self.houseMembers = users;
            [self.tableView reloadData];
                
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.houseMembers.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
     
    HouseholdMemberCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HouseholdMemberCell"];
    cell.houseMember = self.houseMembers[indexPath.row];
    [cell setHouseMembersData];
    return cell;
}


- (void)setupLeftMenuButton {
    MMDrawerBarButtonItem *leftDrawerButton = [[MMDrawerBarButtonItem alloc] initWithTarget:self action:@selector(leftDrawerButtonPress:)];
    [self.navigationItem setLeftBarButtonItem:leftDrawerButton];
}


- (void)leftDrawerButtonPress:(id)leftDrawerButtonPress {
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

- (void)didCreateHousehold {
    self.noHouseholdContainer.alpha = 0;
    [self getHousehold];
    [self getHouseholdMembers];
    [self.tableView reloadData];
}

- (void)didJoinHousehold {
    self.noHouseholdContainer.alpha = 0;
    [self getHousehold];
    [self getHouseholdMembers];
    [self.tableView reloadData];
}


// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqual:@"toHouseMateTasks"]){

        // get correct house mate from cell
        UITableViewCell *tappedCell = sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:tappedCell];
        User *houseMate = self.houseMembers[indexPath.row];
    
        // sends housemember to next view
        HouseMemberTaskViewController *houseMemberViewController = [segue destinationViewController];
        houseMemberViewController.houseMate = houseMate;
    }
}


@end
