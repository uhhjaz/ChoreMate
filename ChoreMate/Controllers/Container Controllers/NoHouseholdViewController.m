//
//  NoHouseholdViewController.m
//  ChoreMate
//
//  Created by Jasdeep Gill on 7/27/20.
//  Copyright © 2020 jazgill. All rights reserved.
//

#import "NoHouseholdViewController.h"
#import "CreateHouseholdViewController.h"
#import "HouseholdViewController.h"
#import "JoinHouseholdViewController.h"

@interface NoHouseholdViewController ()

@end

@implementation NoHouseholdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"joinHousehold"]) {
        JoinHouseholdViewController *joinHouseholdController = [segue destinationViewController];
        joinHouseholdController.delegate = (id)self.delegate;
    }
    else if ([segue.identifier isEqualToString:@"createHousehold"]) {
        CreateHouseholdViewController *createHouseholdController = [segue destinationViewController];
        createHouseholdController.delegate = (id)self.delegate;
    }
}


@end
