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

@interface HouseholdViewController () <UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIView *noHouseholdContainer;
@property (strong, nonatomic) NoHouseholdViewController * noHouseholdViewController;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSArray *houseMembers;

@end

@implementation HouseholdViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupLeftMenuButton];
    
    User * currUser = [User currentUser];
    if(currUser.household_id == nil){
        self.noHouseholdContainer.alpha = 1;
        self.noHouseholdViewController = [self.childViewControllers objectAtIndex:0];
    }
    else{
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.noHouseholdContainer.alpha = 0;
        [self getHousehold];
    }
}


- (void)getHousehold {

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

@end
