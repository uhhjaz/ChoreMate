//
//  popUpHouseholdCodeController.h
//  ChoreMate
//
//  Created by Jasdeep Gill on 8/2/20.
//  Copyright © 2020 jazgill. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Household.h"

NS_ASSUME_NONNULL_BEGIN

@protocol popUpHouseholdCodeControllerDelegate

// MARK: Methods
- (void)didCreateHousehold;

@end

@interface popUpHouseholdCodeController : UIViewController

@property (nonatomic, weak) id<popUpHouseholdCodeControllerDelegate> delegate;

@property (strong, nonatomic) NSString *householdCode;
@property (strong, nonatomic) NSString *householdName;

@end

NS_ASSUME_NONNULL_END
