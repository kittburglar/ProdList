//
//  ViewController.h
//  fuck
//
//  Created by kittiphong xayasane on 2014-11-17.
//  Copyright (c) 2014 Kittiphong Xayasane. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyTableViewCell.h"


@interface ViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    NSMutableArray *anArray;
}
@property (strong, nonatomic) IBOutlet UITextField *textField;
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, assign) BOOL modifying;
@property (nonatomic, assign) NSInteger lastModified;
@property (nonatomic, assign) NSIndexPath *longPressIndexPath;
@property (nonatomic, assign) MyTableViewCell* longPressCell;

@property (nonatomic, strong) IBOutlet UIView *accessoryView;
- (IBAction)editButton:(UIButton *)sender;
- (IBAction)textReturn:(id)sender;
@end