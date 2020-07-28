//
//  popUpJoinHouseholdViewController.h
//  ChoreMate
//
//  Created by Jasdeep Gill on 7/28/20.
//  Copyright © 2020 jazgill. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Household.h"

NS_ASSUME_NONNULL_BEGIN

@protocol popUpJoinHouseholdControllerDelegate

// MARK: Methods
- (void)didJoinHousehold;

@end

@interface popUpJoinHouseholdViewController : UIViewController

@property (nonatomic, weak) id<popUpJoinHouseholdControllerDelegate> delegate;

@property (strong, nonatomic) NSArray *householdMembers;
@property (strong, nonatomic) Household *household;

@end

NS_ASSUME_NONNULL_END
