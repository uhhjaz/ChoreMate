//
//  JoinHouseholdViewController.m
//  ChoreMate
//
//  Created by Jasdeep Gill on 7/28/20.
//  Copyright © 2020 jazgill. All rights reserved.
//

#import "JoinHouseholdViewController.h"
#import <Parse/Parse.h>
#import "JoinHouseholdCell.h"
#import "popUpJoinHouseholdViewController.h"
#import <HWPopController/HWPop.h>
#import <MBProgressHUD.h>

@interface JoinHouseholdViewController () <UITableViewDelegate,UITableViewDataSource, UISearchBarDelegate, popUpJoinHouseholdControllerDelegate>
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *allHouseholds;
@property (nonatomic, strong) NSArray *filteredHouseholds;

@end

@implementation JoinHouseholdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.searchBar.delegate = self;
    [self getAllHouseholds];
}

-(void) getAllHouseholds{
    PFQuery *query = [PFQuery queryWithClassName:@"Household"];

    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable allHouseholds, NSError * _Nullable error) {
        self.allHouseholds = allHouseholds;
        self.filteredHouseholds = self.allHouseholds;
        //NSLog(@"The household array is %@", self.filteredHouseholds);
        [self.tableView reloadData];
        [self.tableView setHidden:YES];
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.filteredHouseholds.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JoinHouseholdCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"JoinHouseholdCell"];
    cell.household = self.filteredHouseholds[indexPath.row];
    [cell setHouseCells];

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Household * thisHousehold = self.filteredHouseholds[indexPath.row];
    self.searchBar.text = thisHousehold.objectId;
    
    PFQuery *query = [PFUser query];
    
    // query for household members of the user
    [query whereKey:@"household_id" equalTo:thisHousehold.objectId];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [query findObjectsInBackgroundWithBlock:^(NSArray *householdMembers, NSError *error) {
        if (householdMembers != nil) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            NSLog(@"Successfully got household members");
            
            popUpJoinHouseholdViewController *centerViewController = [popUpJoinHouseholdViewController new];
            centerViewController.householdMembers = householdMembers;
            centerViewController.household = thisHousehold;
            centerViewController.delegate = self;
            HWPopController *popController = [[HWPopController alloc] initWithViewController:centerViewController];
            popController.popPosition = HWPopPositionCenter;
            popController.popType = HWPopTypeGrowIn;
            popController.dismissType = HWDismissTypeShrinkOut;
            popController.shouldDismissOnBackgroundTouch = YES;
            [popController presentInViewController:self];
            
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}


- (void)didJoinHousehold{
    [self dismissViewControllerAnimated:true completion:^{
        [self.delegate didJoinHousehold];
    }];
}

-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    [self.tableView setHidden:NO];
    return YES;
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [self.tableView setHidden:NO];
    self.filteredHouseholds = ([searchText isEqualToString:@""])? self.allHouseholds : [self filterArrayUsingSearchText:searchText];
    [self.tableView reloadData];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    searchBar.showsCancelButton = YES;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    searchBar.showsCancelButton = NO;
    searchBar.text = @"";
    [self.tableView setHidden:YES];
    [searchBar resignFirstResponder];
}


-(NSArray *) filterArrayUsingSearchText:(NSString*) searchText
{
    NSPredicate *resultPredicate = [NSPredicate
                                    predicateWithFormat:@"objectId contains[c] %@",
                                    searchText];

    return [self.allHouseholds filteredArrayUsingPredicate:resultPredicate];
}

- (IBAction)didTapCancel:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
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
