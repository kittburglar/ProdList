//
//  OptionsTableViewCell.h
//  fuck
//
//  Created by kittiphong xayasane on 2014-12-05.
//  Copyright (c) 2014 Kittiphong Xayasane. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OptionsTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *optionsLabel;
@property (strong, nonatomic) IBOutlet UISegmentedControl *optionsControl;
- (IBAction)optionsChanged:(UISegmentedControl *)sender;

@end
