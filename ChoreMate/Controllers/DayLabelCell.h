//
//  DayLabelCell.h
//  ChoreMate
//
//  Created by Jasdeep Gill on 8/6/20.
//  Copyright © 2020 jazgill. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DayLabelCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *dayDateLabel;
@property (weak, nonatomic) NSString *dateString;

- (void) setDate;

@end

NS_ASSUME_NONNULL_END
