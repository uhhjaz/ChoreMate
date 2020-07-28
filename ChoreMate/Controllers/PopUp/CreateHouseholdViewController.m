//
//  CreateHouseholdViewController.m
//  ChoreMate
//
//  Created by Jasdeep Gill on 7/27/20.
//  Copyright © 2020 jazgill. All rights reserved.
//

#import "CreateHouseholdViewController.h"
#import "Household.h"
#import "User.h"



@interface CreateHouseholdViewController ()
@property (weak, nonatomic) IBOutlet UITextField *householdNameField;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *createButton;

@end

@implementation CreateHouseholdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)didTapCancel:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}


- (IBAction)didTapCreate:(id)sender {
    [Household postNewHousehold:self.householdNameField.text completionHandler:^(NSString * _Nonnull householdId) {
        User* currentHouseMember = [User currentUser];
        NSLog(@"the household_id for after createing household is: %@",householdId);
        currentHouseMember.household_id = householdId;
        [currentHouseMember saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            if(succeeded){
                [self dismissViewControllerAnimated:true completion:^{
                    [self.delegate didCreateHousehold];
                }];
            }
        }];
    }];
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
