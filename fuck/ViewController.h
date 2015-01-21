//
//  ViewController.h
//  fuck
//
//  Created by kittiphong xayasane on 2014-11-17.
//  Copyright (c) 2014 Kittiphong Xayasane. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyTableViewCell.h"
#import <CoreData/CoreData.h>
#import <iAd/iAd.h>


@interface ViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout, NSFetchedResultsControllerDelegate, UIPickerViewDataSource, UIPickerViewDelegate, ADBannerViewDelegate>
{
    NSMutableArray *anArray;
    #define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
    //NSMutableArray *colorArray;
    NSMutableArray *optionsArray;
    NSMutableArray *sortOptionsArray;
    NSMutableArray *autoSortOptionsArray;
    NSMutableArray *repeatArray;
    NSFetchedResultsController *fetchedResultsController;
    NSManagedObjectContext *managedObjectContext;
}

#pragma mark - Application Badge
@property (nonatomic, assign) NSInteger activeItems;

#pragma mark - Boolean Values
@property (nonatomic, assign) BOOL modifying;
@property (nonatomic, assign) BOOL lightMode;
@property (nonatomic, assign) BOOL didSelect;
@property (nonatomic, assign) BOOL checkLightMode;


#pragma mark - Top Main
@property (strong, nonatomic) IBOutlet UITextField *textField;
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;
@property (strong, nonatomic) IBOutlet UIButton *editButton;
@property (strong, nonatomic) IBOutlet UIButton *modeButton;
@property (strong, nonatomic) IBOutlet UIButton *modeLabel;
- (IBAction)editButton:(UIButton *)sender;
- (IBAction)modeButton:(id)sender;

#pragma mark - Main Table View
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UITableView *firstTableView;
@property (nonatomic, assign) NSInteger lastModified;
@property (strong, nonatomic) NSMutableArray *colorArray;
@property (nonatomic, assign) NSIndexPath *longPressIndexPath;
@property (nonatomic, assign) MyTableViewCell* longPressCell;

- (IBAction)textReturn:(id)sender;

#pragma mark - Accessory View
@property (strong, nonatomic) IBOutlet UIButton *colorButton;
@property (strong, nonatomic) IBOutlet UIButton *reminderButton;
@property (assign, nonatomic) NSInteger selectedColor;
@property (assign, nonatomic) BOOL doRemind;
@property (strong, nonatomic) IBOutlet UIDatePicker *pickerView;
@property (strong, nonatomic) IBOutlet UIPickerView * repeatPickerView;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) IBOutlet  UIView * collectionView2;
@property (strong, nonatomic) IBOutlet UICollectionViewFlowLayout *collectionFlowLayout;
@property (strong, nonatomic) UIToolbar *inputAccView;

#pragma mark - Option View
@property (strong, nonatomic) IBOutlet UIView *optionView;
@property (strong, nonatomic) IBOutlet UITableView *secondTableView;
@property (strong, nonatomic) IBOutlet UIVisualEffectView *blurView;
@property (nonatomic, strong) UITextField *pickerViewTextField;
@property (strong, nonatomic) UIPickerView *sortPickerView;
@property (nonatomic, strong) UISegmentedControl *readingModeSegmentControl;
@property (nonatomic, strong) UISwitch *autoReadingModeSwitch;
@property (nonatomic, strong) UISwitch *autoSortSwitch;
@property (nonatomic, assign) NSInteger pickerMode;
@property (nonatomic, assign) NSMutableArray *pickerArray;
- (IBAction)doneOptionsButton:(UIButton *)sender;

#pragma mark - iAD
@property (strong, nonatomic) IBOutlet ADBannerView *banner;


#pragma mark - Core Data
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, assign) NSInteger itemCount;
@property (nonatomic, assign) BOOL userDrivenDataModelChange;

@end