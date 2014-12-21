//
//  ViewController.m
//  fuck
//
//  Created by kittiphong xayasane on 2014-11-17.
//  Copyright (c) 2014 Kittiphong Xayasane. All rights reserved.
//

#import "ViewController.h"
#import "Item.h"
#import "MyTableViewCell.h"
#import "OptionsTableViewCell.h"
#import "AppDelegate.h"
#import <CoreData/CoreData.h>


static NSString *CellIdentifier = @"Cell";

@interface ViewController ()

@end

@implementation ViewController

@synthesize managedObjectContext = _managedObjectContext;
@synthesize fetchedResultsController;

- (void)viewDidLoad {
    [super viewDidLoad];
    AppDelegate* appDelegate = [[UIApplication sharedApplication] delegate];
    self.managedObjectContext = [appDelegate managedObjectContext];
    
    
    self.lightMode = YES;
    [self setNeedsStatusBarAppearanceUpdate];
    self.didSelect = NO;
    self.colorArray = [NSMutableArray arrayWithObjects:
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
    
    self.selectedColor = 7;
    
    
    //Add accessory view (bar on top of keyboard)
    self.inputAccView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, [[UIScreen mainScreen] bounds].size.width, 50.0)];
    [self.inputAccView setBackgroundColor:[UIColor lightGrayColor]];
    //[self.inputAccView setAlpha: 0.8];
    
    //Create keyboard Button programmically
    UIButton *keyboardButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    keyboardButton.frame = CGRectMake(10, CGRectGetMaxY(self.inputAccView.bounds)/2 - 40/2, 40, 40);
    [keyboardButton setBackgroundColor:[UIColor darkGrayColor]];
    [keyboardButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [keyboardButton addTarget:self action:@selector(pickKeyboard:) forControlEvents:UIControlEventTouchUpInside];
    [self.inputAccView addSubview:keyboardButton];
    //self.textField.inputAccessoryView = self.inputAccView;
    
    
    //Create date Button programmically
    UIButton *dateButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    dateButton.frame = CGRectMake(60, CGRectGetMaxY(self.inputAccView.bounds)/2 - 40/2, 40, 40);
    [dateButton setBackgroundColor:[UIColor darkGrayColor]];
    [dateButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [dateButton addTarget:self action:@selector(pickDate:) forControlEvents:UIControlEventTouchUpInside];
    [self.inputAccView addSubview:dateButton];
    //self.textField.inputAccessoryView = self.inputAccView;
    
    //Create color Button programmically
    self.colorButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.colorButton.frame = CGRectMake(110, CGRectGetMaxY(self.inputAccView.bounds)/2 - 40/2, 40, 40);
    [self.colorButton setBackgroundColor:[UIColor darkGrayColor]];
    [self.colorButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.colorButton addTarget:self action:@selector(pickColor:) forControlEvents:UIControlEventTouchUpInside];

    [self.inputAccView addSubview:self.colorButton];
    //self.textField.inputAccessoryView = self.inputAccView;
    
    //Create finish Button programmically
    UIButton *finishButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    finishButton.frame = CGRectMake(self.inputAccView.bounds.size.width - 50, CGRectGetMaxY(self.inputAccView.bounds)/2 - 40/2, 40, 40);
    [finishButton setBackgroundColor:[UIColor darkGrayColor]];
    [finishButton setTitle:@"Done" forState:UIControlStateNormal];
    [finishButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [finishButton addTarget:self action:@selector(textReturn:) forControlEvents:UIControlEventTouchUpInside];
    [self.inputAccView addSubview:finishButton];
    self.textField.inputAccessoryView = self.inputAccView;
    
    
    // Add date to top label
    NSString *formatString = [NSDateFormatter dateFormatFromTemplate:@"EdMMM" options:0 locale:[NSLocale currentLocale]];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:formatString];
    NSString *todayString = [dateFormatter stringFromDate:[NSDate date]];
    NSLog(@"todayString: %@", todayString);
    self.dateLabel.text = todayString;
    
    //Init array of items
    anArray = [[NSMutableArray alloc] init];
    optionsArray = [[NSMutableArray alloc] init];

    
    //add swipe detection to tableview
    UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(didSwipe:)];
    swipeGesture.direction = UISwipeGestureRecognizerDirectionRight;
    [self.tableView addGestureRecognizer:swipeGesture];
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(didPressLong:)];
    [self.tableView addGestureRecognizer:longPress];
    
    //Initalize datepicker stuff
    self.pickerView = [[UIDatePicker alloc] init];
    
    //Initalize collectionview
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(keyboardOnScreen:) name:UIKeyboardDidShowNotification object:nil];
    
    //add options (temporary)
    [optionsArray addObject: @"Reading Mode"];
    [optionsArray addObject: @"Sort"];
    [optionsArray addObject: @"Remove Completed"];
    [optionsArray addObject: @"Auto Reading Mode"];
    [optionsArray addObject: @"Remove All"];
    [optionsArray addObject: @"Auto Sort"];
    //Set up picker view for options
    self.pickerViewTextField = [[UITextField alloc] initWithFrame:CGRectZero];
    [self.view addSubview:self.pickerViewTextField];

    self.sortPickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    self.sortPickerView.showsSelectionIndicator = YES;
    self.sortPickerView.dataSource = self;
    self.sortPickerView.delegate = self;

    self.pickerViewTextField.inputView = self.sortPickerView;
    
    // add a toolbar with Cancel & Done button
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    toolBar.barStyle = UIBarStyleDefault;
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneTouched:)];
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelTouched:)];
    
    // the middle button is to make the Done button align to right
    [toolBar setItems:[NSArray arrayWithObjects:cancelButton, [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil], doneButton, nil]];
    self.pickerViewTextField.inputAccessoryView = toolBar;

    
    
    #pragma mark -Core data loads data
    //fill array with core data records
    NSEntityDescription *entitydesc = [NSEntityDescription entityForName:@"Item" inManagedObjectContext:self.managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entitydesc];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"TRUEPREDICATE"];
    [request setPredicate:predicate];
    NSError *error;
    NSArray *matchingData = [self.managedObjectContext executeFetchRequest:request error:&error];
    
    if (matchingData.count == 0) {
        NSLog(@"Nothing in core database");
    }
    else{
        for (NSManagedObject *obj in matchingData) {
            NSLog(@"%@", [obj valueForKey:@"itemText"]);
            NSLog(@"%@", [obj valueForKey:@"itemDate"]);
            NSLog(@"%@", [obj valueForKey:@"itemColor"]);
            NSString *itemText = [obj valueForKey:@"itemText"];
            NSDate *itemDate = [obj valueForKey:@"itemDate"];
            NSInteger itemColor = [[obj valueForKey:@"itemColor"] integerValue];
            NSInteger itemPid = [[obj valueForKey:@"itemPid"] integerValue];
            Item * i = [[Item alloc] initWithNameAndColorAndDateAndPid:itemText withColor:itemColor withDate:itemDate withPid:itemPid];
            [anArray insertObject:i atIndex:anArray.count];

            [self.tableView reloadData];
        }
    }
    
    
    self.tableView.delegate = self;
    self.secondTableView.delegate = self;
    self.secondTableView.dataSource = self;
}

//Set up the collection view to be the same size as keyboard view
-(void)keyboardOnScreen:(NSNotification *)notification
{
    NSDictionary *info  = notification.userInfo;
    NSValue      *value = info[UIKeyboardFrameEndUserInfoKey];
    
    CGRect rawFrame      = [value CGRectValue];
    CGRect keyboardFrame = [self.view convertRect:rawFrame fromView:nil];
    
    NSLog(@"keyboardFrame: %@", NSStringFromCGRect(keyboardFrame));
    if (self.collectionFlowLayout == nil) {
        self.collectionFlowLayout = [[UICollectionViewFlowLayout alloc] init];
        self.collectionFlowLayout.minimumInteritemSpacing = self.collectionFlowLayout.minimumLineSpacing = 10;
        UIView *collView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMinX(keyboardFrame), CGRectGetMinY(keyboardFrame), CGRectGetWidth(keyboardFrame), CGRectGetHeight(keyboardFrame) - 50)];
        self.collectionView = [[UICollectionView alloc] initWithFrame:collView.frame collectionViewLayout:self.collectionFlowLayout];
        [self.collectionView setDataSource:self];
        [self.collectionView setDelegate:self];
        [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"Cell"];
        [self.collectionView setBackgroundColor:[UIColor grayColor]];
    }
    
    
    
    
}

- (void)pickKeyboard:(UIButton*)button
{
    NSLog(@"Keyboard button clicked.");
    [self.textField resignFirstResponder];
    self.textField.inputView = nil;
    [self.textField becomeFirstResponder];
    
}


- (void)pickDate:(UIButton*)button
{
    NSLog(@"Date button clicked.");
    [self.textField resignFirstResponder];
    self.textField.inputView = self.pickerView;
    [self.textField becomeFirstResponder];
    
}



- (void)pickColor:(UIButton*)button
{
    NSLog(@"Color button clicked.");
    [self.textField resignFirstResponder];
    self.textField.inputView = self.collectionView;
    [self.textField becomeFirstResponder];
    
}



#pragma mark - UICollectionView

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 7;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
        cell.backgroundColor = [self.colorArray objectAtIndex:indexPath.row];
    return cell;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(115, 50);
}



- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    // If you need to use the touched cell, you can retrieve it like so
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    if (cell.backgroundColor == nil) {
        NSLog(@"cell background is nil!");
        self.selectedColor = 7;
    }
    self.didSelect = YES;
    self.selectedColor = indexPath.row;
    self.colorButton.backgroundColor = [self.colorArray objectAtIndex:self.selectedColor];
    [cell setHighlighted:YES];
}


- (void)collectionView:(UICollectionView *)colView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell* cell = [colView cellForItemAtIndexPath:indexPath];
    
    //cell.backgroundColor = [UIColor blueColor];
    
}



- (void)collectionView:(UICollectionView *)colView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell* cell = [colView cellForItemAtIndexPath:indexPath];
    
    //cell.backgroundColor = nil;
    
}


#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [anArray count];
}

#pragma mark - UIPickerViewDelegate
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *item = [[anArray objectAtIndex:row] name];
    
    return item;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    // perform some action
}


- (void)cancelTouched:(UIBarButtonItem *)sender
{
    // hide the picker view
    [self.pickerViewTextField resignFirstResponder];
}

- (void)doneTouched:(UIBarButtonItem *)sender
{
    // hide the picker view
    [self.pickerViewTextField resignFirstResponder];
    
    NSString *testString = [[anArray objectAtIndex:[self.sortPickerView selectedRowInComponent:0]] name];
    
    NSLog(@"%@", testString);
    // perform some action
}


#pragma mark - UITableView Datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"%lu",(unsigned long)[anArray count]);
    if (tableView == self.firstTableView) {
        return [anArray count];
    }
    else{
        return [optionsArray count];
    }
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)widthOfString:(NSString *)string {
    UIFont *font = [UIFont systemFontOfSize: 12.0];
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, nil];
    return [[[NSAttributedString alloc] initWithString:string attributes:attributes] size].width;
}




-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath  *)indexPath
{
    NSLog(@"cellForRowAtIndexPath");
    static NSString *CellIdentifier = @"Cell";
    
    if (tableView == self.firstTableView) {
        MyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        cell.backgroundColor = [self.colorArray objectAtIndex:11];
        [cell.titleLabel setText:[NSString stringWithFormat:@"Row %li in Section %li", (long)[indexPath row], (long)[indexPath section]]];
        
        
        if (cell == nil) {
            cell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:CellIdentifier];
        }
        
        cell.titleLabel.text = [[anArray objectAtIndex:indexPath.row] name];
        cell.descriptionLabel.text = [[anArray objectAtIndex:indexPath.row] returnDate];
        if ([self.colorArray objectAtIndex:[[anArray objectAtIndex:indexPath.row] buttonColor]] != nil) {
            cell.colorButton.backgroundColor = [self.colorArray objectAtIndex:[[anArray objectAtIndex:indexPath.row] buttonColor]];
            cell.colorNumber = [[anArray
                                 objectAtIndex:indexPath.row] buttonColor];
        }
        cell.contentView.backgroundColor = [self.colorArray objectAtIndex:11];
        cell.titleLabel.textColor = [self.colorArray objectAtIndex:7];
        return cell;
    }
    else {
        
        //second tableview
        OptionsTableViewCell *optionsCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (optionsCell == nil) {
                optionsCell = [[OptionsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:CellIdentifier];
            //[optionsArray addObject: @"Reading Mode"];
    
        }
        //optionsCell.optionsLabel.text = @"Label1";
        
        //Reading Mode Cell
        if (indexPath.row == 0) {
            UILabel *readingModeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 200, optionsCell.frame.size.height)];
            readingModeLabel.text = @"Reading Mode";
            [optionsCell addSubview:readingModeLabel];
            
            
            NSArray *itemArray = [NSArray arrayWithObjects: @"Light", @"Dark", nil];
            UISegmentedControl *readingModeSegmentControl = [[UISegmentedControl alloc] initWithItems:itemArray];
            
            [optionsCell addSubview:readingModeSegmentControl];
            readingModeSegmentControl.frame = CGRectMake(self.view.frame.size.width - 110, 5, 100, 30);
            [readingModeSegmentControl addTarget:self action:@selector(ReadingModeSegmentControlAction:) forControlEvents:UIControlEventValueChanged];
            readingModeSegmentControl.selectedSegmentIndex = 0;
            
        }
        //Sort
        else if (indexPath.row == 1){
            UILabel *readingModeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 200, optionsCell.frame.size.height)];
            readingModeLabel.text = @"Sort";
            [optionsCell addSubview:readingModeLabel];
            
            UIButton *sortButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            sortButton.frame = CGRectMake(self.view.frame.size.width - 110, 5, 100, 30);
            [sortButton setTitle:@"Sort" forState:UIControlStateNormal];
            [sortButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [sortButton addTarget:self action:@selector(sortAction:) forControlEvents:UIControlEventTouchUpInside];
            [optionsCell addSubview:sortButton];
        }
        //Remove Completed
        else if (indexPath.row == 2){
            UILabel *readingModeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 200, optionsCell.frame.size.height)];
            readingModeLabel.text = @"Remove Completed";
            [optionsCell addSubview:readingModeLabel];
            
            UIButton *removeButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            removeButton.frame = CGRectMake(self.view.frame.size.width - 110, 5, 100, 30);
            [removeButton setTitle:@"Remove" forState:UIControlStateNormal];
            [removeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [removeButton addTarget:self action:@selector(removeAllCompletedAction:) forControlEvents:UIControlEventTouchUpInside];
            [optionsCell addSubview:removeButton];
            
        }
        else if (indexPath.row == 3){
            UILabel *autoReadingModeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 200, optionsCell.frame.size.height)];
            autoReadingModeLabel.text = @"Auto Reading Mode";
            [optionsCell addSubview:autoReadingModeLabel];
        }
        else if (indexPath.row == 4){
            UILabel *removeAllLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 200, optionsCell.frame.size.height)];
            removeAllLabel.text = @"Remove All";
            [optionsCell addSubview:removeAllLabel];
            
            UIButton *removeAllButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            removeAllButton.frame = CGRectMake(self.view.frame.size.width - 110, 5, 100, 30);
            [removeAllButton setTitle:@"Remove" forState:UIControlStateNormal];
            [removeAllButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [removeAllButton addTarget:self action:@selector(removeAllAction:) forControlEvents:UIControlEventTouchUpInside];
            [optionsCell addSubview:removeAllButton];
        }
        else if (indexPath.row == 5){
            UILabel *autoSortLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 200, optionsCell.frame.size.height)];
            autoSortLabel.text = @"Auto Sort";
            [optionsCell addSubview:autoSortLabel];
        }
        optionsCell.optionsLabel.text = [optionsArray objectAtIndex:indexPath.row];
        //[optionsCell.optionsControl addTarget:self action:@selector(yourSegmentPicked:) forControlEvents:UIControlEventTouchUpInside];
        return optionsCell;
    }

}

- (void)sortAction:(UIButton *)button{
    NSLog(@"sortAction pressed");
    [self.pickerViewTextField becomeFirstResponder];
}





- (void)removeAllCompletedAction:(UIButton *)button{
    NSLog(@"removeAllCompletedAction pressed");
    /*
    for (Item *object in anArray) {
            }
    */
    NSMutableIndexSet *indexesToDelete = [NSMutableIndexSet indexSet];
    for (int i = 0; i < anArray.count; i++) {
        Item *object = [anArray objectAtIndex:i];
        if ([object finishedBool] == YES) {
            NSLog(@"Going to remove item with name: %@", [object name]);
            
            //remove from core data
            Item *item = [anArray objectAtIndex:i];
            NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"Item" inManagedObjectContext:self.managedObjectContext];
            
            NSFetchRequest *request = [[NSFetchRequest alloc] init];
            [request setEntity:entityDesc];
            
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"itemPid == %ld", (long)[item pid]];
            [request setPredicate:predicate];
            
            NSError *error;
            
            NSManagedObject *obj = [[self.managedObjectContext executeFetchRequest:request error:&error] objectAtIndex:0];
            
            [self.managedObjectContext deleteObject:obj];
            [self.managedObjectContext save:&error];
            
            
            //record index of object to delete
            [indexesToDelete addIndex:i];
        }
    }
    [anArray removeObjectsAtIndexes:indexesToDelete];
    [self.tableView reloadData];
    
}


- (void)removeAllAction:(UIButton *)button{
    NSLog(@"removeAllAction pressed");

    [anArray removeAllObjects];
    
    NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"Item" inManagedObjectContext:self.managedObjectContext];
            
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDesc];
            
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"TRUEPREDICATE"];
        [request setPredicate:predicate];
            
        NSError *error;
    
        NSArray *matchingData = [self.managedObjectContext executeFetchRequest:request error:&error];
            
    if (matchingData.count <=0) {
        NSLog(@"NO data to delete");
    }
    else{
        for (NSManagedObject *obj in matchingData) {
            [self.managedObjectContext deleteObject:obj];
        }
    }
    
    [self.managedObjectContext save:&error];
            
    [self.tableView reloadData];
}

- (void)ReadingModeSegmentControlAction:(UISegmentedControl *)segment{
    if (segment.selectedSegmentIndex == 1) {
        self.colorArray = [NSMutableArray arrayWithObjects:
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
        self.lightMode = NO;
        //UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        //self.blurView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        
        
    }
    //Light Mode
    else{
        self.colorArray = [NSMutableArray arrayWithObjects:
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
        self.lightMode = YES;
        //UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        //self.blurView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    }
    //self.selectedColor = 7;
    self.longPressCell.contentView.backgroundColor = [self.colorArray objectAtIndex:11];
    self.view.backgroundColor = [self.colorArray objectAtIndex:11];
    [self.view setNeedsDisplay];
    [self.tableView reloadRowsAtIndexPaths:[self.tableView indexPathsForVisibleRows]
                                              withRowAnimation:UITableViewRowAnimationNone];
    self.textField.backgroundColor = [self.colorArray objectAtIndex:8];
    self.dateLabel.textColor = [self.colorArray objectAtIndex:7];
    [self.editButton setTitleColor:[self.colorArray objectAtIndex:5] forState:UIControlStateNormal];
    [self.editButton setTitleColor:[self.colorArray objectAtIndex:7] forState:UIControlStateSelected];
    [self.modeButton setTitleColor:[self.colorArray objectAtIndex:5] forState:UIControlStateNormal];
    [self.modeButton setTitleColor:[self.colorArray objectAtIndex:7] forState:UIControlStateSelected];
    [self.collectionView reloadData];
    [self.tableView reloadData];
    [self setNeedsStatusBarAppearanceUpdate];
    [self.blurView setNeedsDisplay];
}

-(void)yourSegmentPicked:(UISegmentedControl*)sender{
    NSLog(@"yourSegmentPicked");
}

//find parent cell
-(UITableViewCell *)parentCellForView:(id)theView
{
    id viewSuperView = [theView superview];
    while (viewSuperView != nil) {
        if ([viewSuperView isKindOfClass:[UITableViewCell class]]) {
            return (UITableViewCell *)viewSuperView;
        }
        else {
            viewSuperView = [viewSuperView superview];
        }
    }
    return nil;
}

-(void)yourButtonClicked:(UIButton*)sender
{
    UIButton *butn = (UIButton *)sender;
    UITableViewCell *cell = [self parentCellForView:butn];
    if (cell != nil) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        butn.tag = indexPath.row;
        NSLog(@"show detail for item at row %ld", (long)indexPath.row);
        NSLog(@"button tag is: %lu", butn.tag);
    }
    
    
    /*
    if (sender.tag == 0)
    {
        //Here your coding.
        
    }
    */
}

- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewRowAction *moreAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"Modify" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
        
        // maybe show an action sheet with more options
        NSLog(@"Modify pressed");
        [self setModifying:YES];
        [self setLastModified:indexPath.row];
        MyTableViewCell *cell = (MyTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
        self.textField.text = cell.titleLabel.text;
        cell.contentView.backgroundColor = [self.colorArray objectAtIndex:10];
        [self.textField becomeFirstResponder];
        [self.tableView setEditing:NO];
    }];
    moreAction.backgroundColor = [UIColor lightGrayColor];
       UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"Delete" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
           //Remove Core data entry
           Item *item = [anArray objectAtIndex:indexPath.row];
           NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"Item" inManagedObjectContext:self.managedObjectContext];
           
           NSLog(@"itemPid of item you want to delete is: %ld with itemName: %@", (long)[item pid], [item name]);
           
           NSFetchRequest *request = [[NSFetchRequest alloc] init];
           [request setEntity:entityDesc];
           
           NSPredicate *predicate = [NSPredicate predicateWithFormat:@"itemPid == %ld", (long)[item pid]];
           [request setPredicate:predicate];
           
           NSError *error;
          
           NSManagedObject *obj = [[self.managedObjectContext executeFetchRequest:request error:&error] objectAtIndex:0];
           NSLog(@"obj itemPid is: %@",[obj valueForKey:@"itemPid"]);
           if (obj == nil) {
               NSLog(@"No match for pid");
           }
           else{
               NSLog(@"Match for pid");
           }
           [self.managedObjectContext deleteObject:obj];
           
           [self.managedObjectContext save:&error];
        //Remove array entry
        [anArray removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }];
    return @[deleteAction, moreAction];
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [anArray removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

-(void)tableView:(UITableView *)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Editing ended for row %lu", indexPath.row);
}



- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return YES;
    
}


- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    
    self.userDrivenDataModelChange = YES;
    
    NSLog(@"moveRowAtIndexPath called");
    
    Item *itemSource = [anArray objectAtIndex:sourceIndexPath.row];
    
    Item *itemDest = [anArray objectAtIndex:destinationIndexPath.row];
    
    
    
    
    
    
    
    [anArray removeObjectAtIndex:sourceIndexPath.row];
    [anArray insertObject:itemSource atIndex:destinationIndexPath.row];
    
    
    
    self.userDrivenDataModelChange = NO;
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Touch Functions

-(void)didPressLong:(UIGestureRecognizer *)gestureRecognizer {
    /*
    CGPoint swipeLocation = [gestureRecognizer locationInView:self.tableView];
    NSIndexPath *swipedIndexPath = [self.tableView indexPathForRowAtPoint:swipeLocation];
    MyTableViewCell* swipedCell = (MyTableViewCell *)[self.tableView cellForRowAtIndexPath:swipedIndexPath];
    */
    
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        
        NSLog(@"Holding Begins");
        self.longPressCell.contentView.backgroundColor = [self.colorArray objectAtIndex:11];
        CGPoint swipeLocation = [gestureRecognizer locationInView:self.tableView];
        
        
        self.longPressIndexPath = [self.tableView indexPathForRowAtPoint:swipeLocation];
        
        self.longPressCell = (MyTableViewCell *)[self.tableView cellForRowAtIndexPath:[self longPressIndexPath]];
        /*
        self.longPressCell.titleLabel.text = [anArray[self.longPressIndexPath.row] returnDate];
         */
        
        self.colorButton.backgroundColor = self.longPressCell.colorButton.backgroundColor;
        
        [self setModifying:YES];
        [self setLastModified:self.longPressIndexPath.row];
        MyTableViewCell *cell = (MyTableViewCell *)[self.tableView cellForRowAtIndexPath:self.longPressIndexPath];
        cell.contentView.backgroundColor = [self.colorArray objectAtIndex:10];
        self.textField.text = cell.titleLabel.text;
        [self.textField becomeFirstResponder];
        [self.tableView setEditing:NO];
        
    }
    else if ((gestureRecognizer.state == UIGestureRecognizerStateEnded) || (gestureRecognizer.state == UIGestureRecognizerStateCancelled)){
        NSLog(@"Tap Ends");
        /*
        self.longPressCell.titleLabel.text = [anArray[self.longPressIndexPath.row] name];
         */
    }
}


-(void)didSwipe:(UIGestureRecognizer *)gestureRecognizer {
    NSLog(@"Swiped!");
    
    if ((gestureRecognizer.state == UIGestureRecognizerStateEnded) && !self.tableView.editing) {
        CGPoint swipeLocation = [gestureRecognizer locationInView:self.tableView];
        NSIndexPath *swipedIndexPath = [self.tableView indexPathForRowAtPoint:swipeLocation];
        MyTableViewCell* swipedCell = (MyTableViewCell *)[self.tableView cellForRowAtIndexPath:swipedIndexPath];
        // ...
        //NSString *text = [[swipedCell textLabel] text];
        if (anArray.count != 0) {
            NSDictionary* attributes = @{
                                         NSStrikethroughStyleAttributeName: [NSNumber numberWithInt:NSUnderlineStyleSingle]
                                         };
            
            NSAttributedString* attrText = [[NSAttributedString alloc] initWithString:[anArray[swipedIndexPath.row] name] attributes:attributes];
            NSAttributedString* attrText2 = [[NSAttributedString alloc] initWithString:[anArray[swipedIndexPath.row] name] attributes:nil];
            if ([swipedCell.titleLabel.attributedText isEqualToAttributedString:(attrText)]) {
                NSLog(@"Swiped crossed out word");
                swipedCell.titleLabel.attributedText = attrText2;
                [[anArray objectAtIndex:swipedIndexPath.row] setFinishedBool:NO];
            }
            else{
                NSLog(@"Swiped regular word");
                swipedCell.titleLabel.attributedText = attrText;
                [[anArray objectAtIndex:swipedIndexPath.row] setFinishedBool:YES];
            }
        }
    }
    
}



#pragma mark - Core Data Stuffs

-(void)saveAllData{
    //for (int i = 0; i < anArray.count; i++) {
        NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"Item" inManagedObjectContext:self.managedObjectContext];
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        [request setEntity:entityDesc];
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"TRUEPREDICATE"];
        [request setPredicate:predicate];
        NSError *error;
        NSArray *matchingData = [self.managedObjectContext executeFetchRequest:request error:&error];
        
        if (matchingData.count <=0) {
            NSLog(@"No data to save");
        }
        else{
            for (int i = 0; i < matchingData.count; i++) {
                NSManagedObject *obj = [matchingData objectAtIndex:i];
                [obj setValue:[[anArray objectAtIndex:i] name] forKey:@"itemText"];
                [obj setValue:[NSNumber numberWithInteger:[[anArray objectAtIndex:i] buttonColor]] forKey:@"itemColor"];
                [obj setValue:[[anArray objectAtIndex:i] date] forKey:@"itemDate"];
            }
            //[self.managedObjectContext save:&error];
        }
        /*
        NSLog(@"looking for pid: %d",i);
        
        NSManagedObject *obj = [[self.managedObjectContext executeFetchRequest:request error:&error] objectAtIndex:0];
        
        [obj setValue:[[anArray objectAtIndex:i] name] forKey:@"itemText"];
        [obj setValue:[NSNumber numberWithInteger:[[anArray objectAtIndex:i] buttonColor]] forKey:@"itemColor"];
        [obj setValue:[[anArray objectAtIndex:i] date] forKey:@"itemDate"];
        //[obj setValue:[NSNumber numberWithInteger:[[anArray objectAtIndex:i] pid]]  forKey:@"itemPid"];
        */
        [self.managedObjectContext save:&error];
        
    //}
}


-(void)incrementItemsCount{
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Items" inManagedObjectContext:self.managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"TRUEPREDICATE"];
    [request setPredicate:predicate];
    NSError *error;
    NSArray *matchingData = [self.managedObjectContext executeFetchRequest:request error:&error];
    
    if (matchingData.count <=0) {
        //Add to core data
        NSLog(@"NO Items entity. Must create one.");
        //NSEntityDescription *entitydesc = [NSEntityDescription entityForName:@"" inManagedObjectContext:self.managedObjectContext];
        NSManagedObject *newItem = [[NSManagedObject alloc]initWithEntity:entity insertIntoManagedObjectContext:self.managedObjectContext];
        [newItem setValue:0 forKey:@"count"];
        NSError *error;
        [self.managedObjectContext save:&error];
    }
    else{
    
    NSManagedObject *obj = [[self.managedObjectContext executeFetchRequest:request error:&error] objectAtIndex:0];
    NSNumber *itemCount = [obj valueForKey:@"count"];
    int value = [itemCount intValue];
    itemCount = [NSNumber numberWithInt:value + 1];
    [obj setValue:itemCount forKey:@"count"];
    NSLog(@"item Count is: %@", [obj valueForKey:@"count"]);
    [self.managedObjectContext save:&error];
    }
}

- (IBAction)textReturn:(id)sender {
    
    NSLog(@"textReturn!");
    //self.didSelect = NO;
    //check for whitespace entry or empty textfield
    NSCharacterSet *whitespace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSString *trimmed = [self.textField.text stringByTrimmingCharactersInSet:whitespace];
    
    if ([trimmed length] == 0) {
        
    }
    //Add add to core data and list
    else if ([self modifying]) {
        NSLog(@"textReturn while modifying!");
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[self lastModified] inSection:0];
        MyTableViewCell *cell = (MyTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
        cell.titleLabel.textColor = [self.colorArray objectAtIndex:7];
        
        if (![self didSelect]) {
            self.selectedColor = cell.colorNumber;
        }
        
        NSLog(@"creating item with pid %ld", (long)[[anArray objectAtIndex:[self lastModified]] pid]);
        
        Item * i = [[Item alloc] initWithNameAndColorAndDateAndPid:self.textField.text withColor:self.selectedColor withDate:[self.pickerView date] withPid:[[anArray objectAtIndex:[self lastModified]] pid]];
        
        [anArray removeObjectAtIndex:[self lastModified]];
        //Item * i = [[Item alloc] initWithNameAndColorAndDate:self.textField.text withColor:self.selectedColor withDate:[self.pickerView date]];
        //Item * i = [[Item alloc] initWithNameAndColorAndDateAndPid:self.textField.text withColor:self.selectedColor withDate:[self.pickerView date] withPid:[[anArray objectAtIndex:[self lastModified]] pid]];
        
        [anArray insertObject:i atIndex:[self lastModified]];
        
        //Edit core data record
        //Item *item = [anArray objectAtIndex:[self lastModified]];
        
        NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"Item" inManagedObjectContext:self.managedObjectContext];
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        [request setEntity:entityDesc];
        
        
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"itemPid == %ld", (long)[i pid]];
        [request setPredicate:predicate];
        NSError *error;
        
        NSLog(@"looking for pid: %ld",(long)[i pid]);
        
        NSManagedObject *obj = [[self.managedObjectContext executeFetchRequest:request error:&error] objectAtIndex:0];
        
        [obj setValue:[i name] forKey:@"itemText"];
        [obj setValue:[NSNumber numberWithInteger:[i buttonColor]] forKey:@"itemColor"];
        [obj setValue:[i date] forKey:@"itemDate"];
        [obj setValue:[NSNumber numberWithInteger:[i pid]]  forKey:@"itemPid"];
        
        [self.tableView reloadData];
        [self.managedObjectContext save:&error];
        [self setModifying:NO];
        
    }
    else{
        
        [self incrementItemsCount];
        //fetch core data stuff
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Items" inManagedObjectContext:self.managedObjectContext];
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        [request setEntity:entity];
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"TRUEPREDICATE"];
        [request setPredicate:predicate];
        NSError *error;
        
        NSManagedObject *obj = [[self.managedObjectContext executeFetchRequest:request error:&error] objectAtIndex:0];
        //NSNumber *itemCount = [obj valueForKey:@"count"];
        //
        
        
        //Item * i = [[Item alloc] initWithNameAndColorAndDate:self.textField.text withColor:self.selectedColor withDate:[self.pickerView date]];
        
        Item * i = [[Item alloc] initWithNameAndColorAndDateAndPid:self.textField.text withColor:self.selectedColor withDate:[self.pickerView date] withPid:[[obj valueForKey:@"count"] integerValue]];
        
        [anArray addObject: i];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:([anArray count] - 1) inSection:0];
        [self.tableView beginUpdates];
        [self.tableView insertRowsAtIndexPaths:@[indexPath]withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.tableView endUpdates];
        
        //Add to core data
        NSEntityDescription *entitydesc = [NSEntityDescription entityForName:@"Item" inManagedObjectContext:self.managedObjectContext];
        NSManagedObject *newItem = [[NSManagedObject alloc]initWithEntity:entitydesc insertIntoManagedObjectContext:self.managedObjectContext];
        [newItem setValue:[i name] forKey:@"itemText"];
        [newItem setValue:[NSNumber numberWithInteger:[i buttonColor]] forKey:@"itemColor"];
        [newItem setValue:[i date] forKey:@"itemDate"];
        [newItem setValue:[NSNumber numberWithInteger:[i pid]] forKey:@"itemPid"];
        NSError *error2;
        [self.managedObjectContext save:&error2];
        
        
        
    }
    self.textField.text = nil;
    
    //Change this!
    self.selectedColor = 7;
    self.colorButton.backgroundColor = [UIColor darkGrayColor];
    self.didSelect = NO;
    //[sender resignFirstResponder];
    [self.textField resignFirstResponder];
}

//If user touches anywhere else then close keyboard
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"touchesBegan!");
    UITouch *touch = [[event allTouches] anyObject];
    if ([_textField isFirstResponder] && [touch view] != _textField) {
        [_textField resignFirstResponder];
    }
    [super touchesBegan:touches withEvent:event];
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    NSLog(@"controllerWillChangeContent");
    if (self.userDrivenDataModelChange) return;
}
- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    NSLog(@"controllerdidChangeObject");
    if (self.userDrivenDataModelChange) return;
}
- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    NSLog(@"controllerDidChangeContent");
    if (self.userDrivenDataModelChange) return;
}


#pragma mark -IBActions

- (IBAction)enterButton:(UIButton *)sender {
    /*
    [optionsArray addObject: @"Label1"];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:([optionsArray count] - 1) inSection:0];
    [self.secondTableView beginUpdates];
    [self.secondTableView insertRowsAtIndexPaths:@[indexPath]withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.secondTableView endUpdates];
     */
}

- (IBAction)doneOptionsButton:(UIButton *)sender {
    [UIView animateWithDuration:0.2 animations:^() {
        self.optionView.alpha = 0.0;
    }];
}

- (IBAction)editButton:(UIButton *)sender {
    [self saveAllData];
    [self.tableView setEditing:!self.tableView.editing animated:true];
    
}
- (IBAction)testButtonPressed:(UIButton *)sender {
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    if ([self lightMode]) {
        return UIStatusBarStyleDefault;
    }
    
    else if(![self lightMode]){
        return UIStatusBarStyleLightContent;
    }
    else{
        return UIStatusBarStyleDefault;
    }
}


- (IBAction)modeButton:(id)sender {
    [UIView animateWithDuration:0.2 animations:^() {
        self.optionView.alpha = 1.0;
    }];
    /*
    if (self.lightMode) {
        colorArray = [NSMutableArray arrayWithObjects:
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
        [self.modeLabel setTitle:@"Dark" forState:UIControlStateNormal];
        self.lightMode = NO;
        
        
    }
    else{
        colorArray = [NSMutableArray arrayWithObjects:
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
        [self.modeLabel setTitle:@"Light" forState:UIControlStateNormal];
        self.lightMode = YES;
    }
    //self.selectedColor = 7;
    self.longPressCell.contentView.backgroundColor = [colorArray objectAtIndex:11];
    self.view.backgroundColor = [colorArray objectAtIndex:11];
    [self.view setNeedsDisplay];
    [self.tableView reloadRowsAtIndexPaths:[self.tableView indexPathsForVisibleRows]
                          withRowAnimation:UITableViewRowAnimationNone];
    self.textField.backgroundColor = [colorArray objectAtIndex:8];
    self.dateLabel.textColor = [colorArray objectAtIndex:7];
    [self.editButton setTitleColor:[colorArray objectAtIndex:5] forState:UIControlStateNormal];
    [self.editButton setTitleColor:[colorArray objectAtIndex:7] forState:UIControlStateSelected];
    [self.modeButton setTitleColor:[colorArray objectAtIndex:5] forState:UIControlStateNormal];
    [self.modeButton setTitleColor:[colorArray objectAtIndex:7] forState:UIControlStateSelected];
    [self.collectionView reloadData];
    [self.tableView reloadData];
    [self setNeedsStatusBarAppearanceUpdate];
     */
}
@end
