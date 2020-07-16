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

@interface OnceTimeTaskViewController () <UICollectionViewDataSource, UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *descriptionField;
@property (weak, nonatomic) IBOutlet UIButton *dueDateButton;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) NSArray *household;

@end

@implementation OnceTimeTaskViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    [self getHousehold];
}

- (void) getHousehold{
    NSLog(@"Inside getting a household");
    User *curr = [User currentUser];
    
    NSLog(@"the curr user is: %@", curr);
    
    PFQuery *query = [PFUser query];
    [query whereKey:@"household_id" equalTo:curr.household_id]; // find all the women
    [query findObjectsInBackgroundWithBlock:^(NSArray *users, NSError *error) {
        if (users != nil) {
            
            NSLog(@"Successfully got household members");
            self.household = users;
            
            NSLog(@"the household is: %@",users);
            
            [self.collectionView reloadData];
            
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}


// set cells to choose who the task is assigned to
- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    AssignmentCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"AssignmentCell" forIndexPath:indexPath];
    cell.user = self.household[indexPath.row];
    [cell setCellValues];
    return cell;
}


- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.household.count;
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
