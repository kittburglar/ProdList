//
//  OptionsTableViewCell.m
//  fuck
//
//  Created by kittiphong xayasane on 2014-12-05.
//  Copyright (c) 2014 Kittiphong Xayasane. All rights reserved.
//

#import "OptionsTableViewCell.h"
#import "ViewController.h"

@implementation OptionsTableViewCell

- (void)awakeFromNib {
    self.firstViewController = [[ViewController alloc] initWithNibName:@"ViewController" bundle:nil];
    // Initialization code
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    self.firstViewController = (ViewController *)window.rootViewController;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)optionsChanged:(UISegmentedControl *)sender {
        NSLog(@"yourSegmentPicked");
    
    
    NSLog(@"%@",[self.optionsControl titleForSegmentAtIndex:self.optionsControl.selectedSegmentIndex]);
    if ([[self.optionsControl titleForSegmentAtIndex:self.optionsControl.selectedSegmentIndex]  isEqual: @"Second"]) {
        self.firstViewController.colorArray = [NSMutableArray arrayWithObjects:
                          UIColorFromRGB(0xcc6666),
                          UIColorFromRGB(0xde935f),
                          UIColorFromRGB(0xf0c674),
                          UIColorFromRGB(0xb5bd68),
                          UIColorFromRGB(0x8abeb7),
                          UIColorFromRGB(0x81a2be),
                          UIColorFromRGB(0xb294bb),
                          UIColorFromRGB(0xc5c8c6),
                          UIColorFromRGB(0x969896),
                          UIColorFromRGB(0x373b41),
                          UIColorFromRGB(0x282a2e),
                          UIColorFromRGB(0x1d1f21),nil];
        //[self.firstViewController.modeLabel setTitle:@"Dark" forState:UIControlStateNormal];
        self.firstViewController.lightMode = NO;
            
            
    }
    else{
        self.firstViewController.colorArray = [NSMutableArray arrayWithObjects:
                          UIColorFromRGB(0xc82829),
                          UIColorFromRGB(0xf5871f),
                          UIColorFromRGB(0xeab700),
                          UIColorFromRGB(0x718c00),
                          UIColorFromRGB(0x3e999f),
                          UIColorFromRGB(0x4271ae),
                          UIColorFromRGB(0x8959a8),
                          UIColorFromRGB(0x4d4d4c),
                          UIColorFromRGB(0x8e908c),
                          UIColorFromRGB(0xd6d6d6),
                          UIColorFromRGB(0xefefef),
                          UIColorFromRGB(0xffffff),nil];
        //[self.firstViewController.modeLabel setTitle:@"Light" forState:UIControlStateNormal];
        self.firstViewController.lightMode = YES;
        
    }
    //self.selectedColor = 7;
    self.firstViewController.longPressCell.contentView.backgroundColor = [self.firstViewController.colorArray objectAtIndex:11];
    self.firstViewController.view.backgroundColor = [self.firstViewController.colorArray objectAtIndex:11];
    [self.firstViewController.view setNeedsDisplay];
    [self.firstViewController.tableView reloadRowsAtIndexPaths:[self.firstViewController.tableView indexPathsForVisibleRows]
                              withRowAnimation:UITableViewRowAnimationNone];
    self.firstViewController.textField.backgroundColor = [self.firstViewController.colorArray objectAtIndex:8];
    self.firstViewController.dateLabel.textColor = [self.firstViewController.colorArray objectAtIndex:7];
    [self.firstViewController.editButton setTitleColor:[self.firstViewController.colorArray objectAtIndex:5] forState:UIControlStateNormal];
    [self.firstViewController.editButton setTitleColor:[self.firstViewController.colorArray objectAtIndex:7] forState:UIControlStateSelected];
    [self.firstViewController.modeButton setTitleColor:[self.firstViewController.colorArray objectAtIndex:5] forState:UIControlStateNormal];
    [self.firstViewController.modeButton setTitleColor:[self.firstViewController.colorArray objectAtIndex:7] forState:UIControlStateSelected];
    [self.firstViewController.collectionView reloadData];
    [self.firstViewController.tableView reloadData];
    [self.firstViewController setNeedsStatusBarAppearanceUpdate];
    
}
@end
