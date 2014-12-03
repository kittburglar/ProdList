//
//  MyTableViewCell.h
//  fuck
//
//  Created by kittiphong xayasane on 2014-11-26.
//  Copyright (c) 2014 Kittiphong Xayasane. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyTableViewCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *subtitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (nonatomic, weak) IBOutlet UIButton *colorButton;
@property (nonatomic, assign) NSInteger colorNumber;

@end
