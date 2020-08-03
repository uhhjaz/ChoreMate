//
//  CreateHouseholdViewController.m
//  ChoreMate
//
//  Created by Jasdeep Gill on 7/27/20.
//  Copyright © 2020 jazgill. All rights reserved.
//

#import "CreateHouseholdViewController.h"
#import "popUpHouseholdCodeController.h"
#import "Household.h"
#import "User.h"
#import <Parse/Parse.h>
#import <HWPopController/HWPop.h>
#import <MBProgressHUD.h>



@interface CreateHouseholdViewController () <popUpHouseholdCodeControllerDelegate>
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
    NSString *householdName = self.householdNameField.text;
    [Household postNewHousehold:self.householdNameField.text completionHandler:^(NSString * _Nonnull householdId) {
        User* currentHouseMember = [User currentUser];
        currentHouseMember.household_id = householdId;
        [currentHouseMember saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            if(succeeded){
                
                popUpHouseholdCodeController *centerViewController = [popUpHouseholdCodeController new];
                centerViewController.householdName = householdName;
                centerViewController.householdCode = householdId;
                centerViewController.delegate = self;
                HWPopController *popController = [[HWPopController alloc] initWithViewController:centerViewController];
                popController.popPosition = HWPopPositionCenter;
                popController.popType = HWPopTypeGrowIn;
                popController.dismissType = HWDismissTypeShrinkOut;
                popController.shouldDismissOnBackgroundTouch = YES;
                [popController presentInViewController:self];
                
            }
        }];
    }];
}


- (void) didCreateHousehold {
    NSLog(@"did create houehold in createhouseholdviewcontroller");
    [self dismissViewControllerAnimated:true completion:^{
        [self.delegate didCreateHousehold];
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
