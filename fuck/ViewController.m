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
    
    

    /*
    NSEntityDescription *entitydesc3 = [NSEntityDescription entityForName:@"Option" inManagedObjectContext:self.managedObjectContext];
    NSFetchRequest *request3 = [[NSFetchRequest alloc] init];
    [request2 setEntity:entitydesc3];
    NSPredicate *predicate3 = [NSPredicate predicateWithFormat:@"(optionId == %d) AND (optionData == NO)", [[NSNumber numberWithInt:1] integerValue]];
    [request2 setPredicate:predicate3];
    NSError *error3;
    
    NSArray *matchingData3 = [self.managedObjectContext executeFetchRequest:request3 error:&error3];

    if (matchingData3.count <= 0) {
        
        NSLog(@"No Reading Mode data set");
        
    }
    else{
        NSLog(@"Found NO for Reading mode on startup");
        [self.autoReadingModeSwitch setOn:YES animated:YES];
        NSLog(@"The value of the switch is: %@", [NSNumber numberWithBool:self.autoReadingModeSwitch.on]);
        [self autoReadingModeAction:self.autoReadingModeSwitch];
        NSLog(@"Reading Mode data found");
        
    }
    */
    
    
    //Add accessory view (bar on top of keyboard
    
    self.inputAccView = [[UIToolbar alloc] initWithFrame:CGRectMake(0.0, 0.0, [[UIScreen mainScreen] bounds].size.width, 50.0)];
    self.inputAccView.barStyle = UIBarStyleDefault;

    
    //Create keyboard Button programmically
    
    UIButton *keyboardButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    keyboardButton.frame = CGRectMake(10, CGRectGetMaxY(self.inputAccView.bounds)/2 - 40/2, 40, 40);
    //[keyboardButton setBackgroundColor:[UIColor darkGrayColor]];
    UIImage *keyboardImage = [UIImage imageNamed:@"Keyboard"];
    [keyboardButton setBackgroundImage:keyboardImage forState:UIControlStateNormal];
    [keyboardButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [keyboardButton addTarget:self action:@selector(pickKeyboard:) forControlEvents:UIControlEventTouchUpInside];
    [self.inputAccView addSubview:keyboardButton];
    //self.textField.inputAccessoryView = self.inputAccView;
    
    
    //Create date Button programmically
    
    UIButton *dateButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    dateButton.frame = CGRectMake(60, CGRectGetMaxY(self.inputAccView.bounds)/2 - 40/2, 40, 40);
    UIImage *calendarImage = [UIImage imageNamed:@"Calendar"];
    [dateButton setImage:[calendarImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    
    //[dateButton setBackgroundColor:[UIColor darkGrayColor]];
    [dateButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [dateButton addTarget:self action:@selector(pickDate:) forControlEvents:UIControlEventTouchUpInside];
    [self.inputAccView addSubview:dateButton];
    //self.textField.inputAccessoryView = self.inputAccView;
    
    /*
    //Create repeat button programmatically
    UIButton *repeatButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    repeatButton.frame = CGRectMake(110, CGRectGetMaxY(self.inputAccView.bounds)/2 - 40/2, 40, 40);
    UIImage *repeatImage = [UIImage imageNamed:@"Return"];
    [repeatButton setImage:[repeatImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [repeatButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [repeatButton addTarget:self action:@selector(pickRepeat:) forControlEvents:UIControlEventTouchUpInside];
    [self.inputAccView addSubview:repeatButton];
    */
    
    //Create color Button programmically
    self.colorButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.colorButton.frame = CGRectMake(110, CGRectGetMaxY(self.inputAccView.bounds)/2 - 40/2, 40, 40);
    [self.colorButton setBackgroundColor:[UIColor darkGrayColor]];
    [self.colorButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.colorButton addTarget:self action:@selector(pickColor:) forControlEvents:UIControlEventTouchUpInside];

    [self.inputAccView addSubview:self.colorButton];
    
    //Make reminder button
    self.reminderButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.reminderButton.frame = CGRectMake(160, CGRectGetMaxY(self.inputAccView.bounds)/2 - 40/2, 40, 40);
    [self.reminderButton setBackgroundColor:[UIColor darkGrayColor]];
    [self.reminderButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.reminderButton addTarget:self action:@selector(pickReminder:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.inputAccView addSubview:self.reminderButton];
    
    
    //self.textField.inputAccessoryView = self.inputAccView;
    
    //Create finish Button programmically
    UIButton *finishButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    finishButton.frame = CGRectMake(self.inputAccView.bounds.size.width - 50, CGRectGetMaxY(self.inputAccView.bounds)/2 - 40/2, 40, 40);
    //[finishButton setBackgroundColor:[UIColor darkGrayColor]];
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
    sortOptionsArray = [[NSMutableArray alloc] init];
    autoSortOptionsArray = [[NSMutableArray alloc] init];
    repeatArray = [[NSMutableArray alloc] init];
    
    //add swipe detection to tableview
    UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(didSwipe:)];
    swipeGesture.direction = UISwipeGestureRecognizerDirectionRight;
    [self.tableView addGestureRecognizer:swipeGesture];
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGestureRecognized:)];
    [self.tableView addGestureRecognizer:longPress];
    
    //Initalize datepicker stuff
    self.pickerView = [[UIDatePicker alloc] init];
    [self.pickerView addTarget:self action:@selector(pickerViewChanged:) forControlEvents:UIControlEventValueChanged];
    
    //Initialize repeatPicker Stuff
    self.repeatPickerView = [[UIPickerView alloc] init];
    self.repeatPickerView.delegate = self;
    
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
    
    //add sortOptions array
    [sortOptionsArray addObject: @"Name"];
    [sortOptionsArray addObject: @"Color"];
    [sortOptionsArray addObject: @"Due Date"];
    
    //add autoSortOptions
    [autoSortOptionsArray addObject:@"None"];
    [autoSortOptionsArray addObject: @"Name"];
    [autoSortOptionsArray addObject: @"Color"];
    [autoSortOptionsArray addObject: @"Due Date"];
    
    //add repeatArray
    [repeatArray addObject:@"None"];
    [repeatArray addObject:@"Daily"];
    [repeatArray addObject:@"Weekly"];
    [repeatArray addObject:@"Monthly"];
    [repeatArray addObject:@"Yearly"];
    
    
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
            NSLog(@"itemText %@", [obj valueForKey:@"itemText"]);
            NSLog(@"itemDate %@", [obj valueForKey:@"itemDate"]);
            NSLog(@"itemColor %@", [obj valueForKey:@"itemColor"]);
            NSLog(@"itemPid %@", [obj valueForKey:@"itemPid"]);
            NSLog(@"itemFinished %@", [obj valueForKey:@"itemFinished"]);
            NSLog(@"itemInterval %@", [obj valueForKey:@"itemInterval"]);
            NSLog(@"itemReminder %@", [obj valueForKey:@"itemReminder"]);
            
            NSString *itemText = [obj valueForKey:@"itemText"];
            NSDate *itemDate = [obj valueForKey:@"itemDate"];
            NSInteger itemColor = [[obj valueForKey:@"itemColor"] integerValue];
            NSInteger itemPid = [[obj valueForKey:@"itemPid"] integerValue];
            BOOL itemFinished = [[obj valueForKey:@"itemFinished"] boolValue];
            NSLog(@"Itemfinished is %d", itemFinished);
            NSInteger itemInterval = [[obj valueForKey:@"itemInterval"] integerValue];
            BOOL itemReminder = [[obj valueForKey:@"itemReminder"] boolValue];
            
            Item * i = [[Item alloc] initWithNameAndColorAndDateAndPidAndBoolAndIntervalAndReminder:itemText withColor:itemColor withDate:itemDate withPid:itemPid withBool:itemFinished withInterval:itemInterval withReminder:itemReminder];
            [anArray insertObject:i atIndex:anArray.count];

            [self.tableView reloadData];
        }
    }
    
    //Register notification for entering background
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillResignActive) name:UIApplicationWillResignActiveNotification object:nil];
    self.activeItems = [self numberofActiveItems];

    
    
    self.tableView.delegate = self;
    self.secondTableView.delegate = self;
    self.secondTableView.dataSource = self;
}

#pragma mark - Notifaction stuffs

-(void)appWillResignActive{
    NSLog(@"appWillResignActive");
    
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    NSLog(@"numberofActiveItems is: %ld", (long)[self numberofActiveItems]);
    
    localNotification.applicationIconBadgeNumber = [self numberofActiveItems];// set here the value of badge
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
}

-(NSInteger)numberofActiveItems{
    NSInteger activeItems = 0;
    for (Item *obj in anArray) {
        if (![obj finishedBool]) {
            activeItems++;
        }
    }
    self.activeItems = activeItems;
    return activeItems;
}


#pragma mark - input accessory view buttons
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
        [self.collectionView setBackgroundColor:UIBarStyleDefault];
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

- (void)pickRepeat:(UIButton*)button
{
    NSLog(@"Repeat button clicked.");
    [self.textField resignFirstResponder];
    self.pickerArray = repeatArray;
    //[self.repeatPickerView reloadAllComponents];
    self.textField.inputView = self.repeatPickerView;
    [self.textField becomeFirstResponder];
    
}


- (void)pickColor:(UIButton*)button
{
    NSLog(@"Color button clicked.");
    [self.textField resignFirstResponder];
    self.textField.inputView = self.collectionView;
    [self.textField becomeFirstResponder];
    
}

- (void)pickReminder:(UIButton *)button
{
    NSLog(@"Reminder button clicked.");
    
    self.doRemind = !self.doRemind;
    if (self.doRemind) {
        self.reminderButton.backgroundColor = [UIColor greenColor];
    }
    else{
        self.reminderButton.backgroundColor = [UIColor darkGrayColor];
    }
    NSLog(@"Reminder Button is at %d", self.doRemind);
}

#pragma mark - Shake event
- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event{
    if (event.type == UIEventSubtypeMotionShake) {
        NSLog(@"shook the phone!");
        [self removeAllCompletedAction:nil];
    }
}

- (BOOL)canBecomeFirstResponder{
    return YES;
}

#pragma mark - UICollectionView

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 9;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    if (indexPath.row == 8) {
        cell.backgroundColor = [self.colorArray objectAtIndex:11];
    }
    else{
        cell.backgroundColor = [self.colorArray objectAtIndex:indexPath.row];
    }
    return cell;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake([[UIScreen mainScreen] bounds].size.width/3 - 20, self.collectionView.bounds.size.height/3 - 20);
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
    
    if (indexPath.row == 8) {
        self.selectedColor = 11;
    }
    else{
        self.selectedColor = indexPath.row;
    }
    
    
    self.colorButton.backgroundColor = [self.colorArray objectAtIndex:self.selectedColor];
    [cell setHighlighted:YES];
}


- (void)collectionView:(UICollectionView *)colView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell* cell = [colView cellForItemAtIndexPath:indexPath];
    
    //cell.backgroundColor = [UIColor blueColor];
    
}

- (UIEdgeInsets)collectionView:
(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(20, 20, 20, 20);
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
    NSLog(@"numberOfRowsInComponent pickerView");
    
    return [self.pickerArray count];
}

#pragma mark - UIPickerViewDelegate
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [self.pickerArray objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    // perform some action
    NSLog(@"pickerView didselectrow");
}


- (IBAction)pickerViewChanged:(id)sender {
    NSLog(@"pickerViewCHanged");
    NSDate *today = [NSDate date];
    NSComparisonResult result;
    result = [today compare:self.pickerView.date];
    if(result==NSOrderedDescending) {
        NSLog(@"newDate is less");
        [self.pickerView setDate:today];
    }
}


- (void)cancelTouched:(UIBarButtonItem *)sender
{
    // hide the picker view
    [self.pickerViewTextField resignFirstResponder];
}

- (void)sortArray:(NSString *)key{
    NSSortDescriptor *sortDescriptor;
    sortDescriptor = [[NSSortDescriptor alloc] initWithKey:key
                                                 ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    anArray = [[anArray sortedArrayUsingDescriptors:sortDescriptors] mutableCopy];
}

- (void)doneTouched:(UIBarButtonItem *)sender
{
    // hide the picker view
    [self.pickerViewTextField resignFirstResponder];
    
    NSString *testString = [self.pickerArray objectAtIndex:[self.sortPickerView selectedRowInComponent:0]];
    
    
    
    NSLog(@"%@", testString);
    // perform some action
    if ([self.pickerArray isEqualToArray:sortOptionsArray]) {
        switch ([self.sortPickerView selectedRowInComponent:0]) {
                        //Name
                    case 0:
                    {
                        NSLog(@"sort by namme");
                        [self sortArray:@"name"];
                        [self.tableView reloadData];
                        [self saveAllData];
                        break;
                    }
                    case 1:
                    {
                        NSLog(@"sort by buttonColor");
                        [self sortArray:@"buttonColor"];
                        [self.tableView reloadData];
                        [self saveAllData];
                        break;
                    }
                    case 2:
                    {
                        NSLog(@"sort by date");
                        [self sortArray:@"date"];
                        [self.tableView reloadData];
                        [self saveAllData];
                        break;
                    }
                    default:
                        break;
        }
    }
    else if ([self.pickerArray isEqualToArray:autoSortOptionsArray]){
        switch ([self.sortPickerView selectedRowInComponent:0]) {
            //Name
            case 0:
            {
                break;
            }
            case 1:
            {
                NSLog(@"auto sort by name");
                [self sortArray:@"name"];
                [self.tableView reloadData];
                [self saveAllData];
                break;
            }
            case 2:
            {
                NSLog(@"auto sort by buttonColor");
                [self sortArray:@"buttonColor"];
                [self.tableView reloadData];
                [self saveAllData];
                break;
            }
            case 3:
            {
                NSLog(@"autosort by date");
                [self sortArray:@"date"];
                [self.tableView reloadData];
                [self saveAllData];
                break;
            }
            default:
                break;
        }
    }
}


#pragma mark - UITableView Datasource



- (void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //NSLog(@"willDisplayCell");
    for (UIView * view in cell.subviews) {
        if ([NSStringFromClass([view class]) rangeOfString: @"Reorder"].location != NSNotFound) {
            for (UIView * subview in view.subviews) {
                // Creates a new subview the size of the entire cell
                UIView *movedReorderControl = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetMaxX(view.frame), CGRectGetMaxY(view.frame))];
                // Adds the reorder control view to our new subview
                //[movedReorderControl setBackgroundColor:[UIColor redColor]];
                [movedReorderControl addSubview:view];
                // Adds our new subview to the cell
                [cell addSubview:movedReorderControl];
                /*
                // CGStuff to move it to the left
                CGSize moveLeft = CGSizeMake(movedReorderControl.frame.size.width - view.frame.size.width, movedReorderControl.frame.size.height - view.frame.size.height);
                CGAffineTransform transform = CGAffineTransformIdentity;
                transform = CGAffineTransformTranslate(transform, -moveLeft.width, -moveLeft.height);
                // Performs the transform
                [movedReorderControl setTransform:transform];
                 */
                CGSize sizeDifference = CGSizeMake(movedReorderControl.frame.size.width - view.frame.size.width, movedReorderControl.frame.size.height - view.frame.size.height);
                CGSize transformRatio = CGSizeMake(movedReorderControl.frame.size.width / view.frame.size.width, movedReorderControl.frame.size.height / view.frame.size.height);
                
                //	Original transform
                CGAffineTransform transform = CGAffineTransformIdentity;
                
                //	Scale custom view so grip will fill entire cell
                transform = CGAffineTransformScale(transform, transformRatio.width, transformRatio.height);
                
                //	Move custom view so the grip's top left aligns with the cell's top left
                transform = CGAffineTransformTranslate(transform, -sizeDifference.width / 2.0, -sizeDifference.height / 2.0);
                
                [movedReorderControl setTransform:transform];
                
                //remove the grip image
                for(UIImageView* cellGrip in view.subviews)
                {
                    if([cellGrip isKindOfClass:[UIImageView class]])
                        [cellGrip setImage:nil];
                }
            }
            
        }
    }
    
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
        
        //Remove notification
        [self cancelLocalNotification:[NSString stringWithFormat: @"%ld", (long)[item pid]]];
        
        
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

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}


- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleNone;
    //return UITableViewCellEditingStyleInsert;
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

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.firstTableView) {
        return YES;
    }
    else{
        return NO;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.firstTableView) {
        NSLog(@"didSelectRowAtIndex %ld", (long)indexPath.row);
        self.longPressCell.contentView.backgroundColor = [self.colorArray objectAtIndex:11];
        //CGPoint swipeLocation = [gestureRecognizer locationInView:self.tableView];
    
        //NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.longPressIndexPath.row inSection:0];
        [self.tableView scrollToRowAtIndexPath:indexPath
                          atScrollPosition:UITableViewScrollPositionTop
                                  animated:YES];
    
        //self.longPressIndexPath = [self.tableView indexPathForRowAtPoint:swipeLocation];
    
        self.longPressCell = (MyTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    
    
        //Reload the values of the item in each view
        self.colorButton.backgroundColor = self.longPressCell.colorButton.backgroundColor;
        [self.pickerView setDate:[[anArray objectAtIndex:indexPath.row] date]];
        self.doRemind = [[anArray objectAtIndex:indexPath.row] reminder];
        NSLog(@"didSelectRowAtIndex doRemind is:,%d", self.doRemind);
        if (self.doRemind) {
            self.reminderButton.backgroundColor = [UIColor greenColor];
        }
        else{
            self.reminderButton.backgroundColor = [UIColor darkGrayColor];
        }
        self.pickerArray = repeatArray;
        [self.repeatPickerView selectRow:[[anArray objectAtIndex:indexPath.row] interval] inComponent:0 animated:YES];
        [self setModifying:YES];
        [self setLastModified:indexPath.row];
        MyTableViewCell *cell = (MyTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
        cell.contentView.backgroundColor = [self.colorArray objectAtIndex:10];
        self.textField.text = cell.titleLabel.text;
        //[myDatePicker reloadInputViews];
        [self.textField becomeFirstResponder];
        [self.tableView setEditing:NO];
    }
    
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


- (void)strikeoutLabels{
    
}

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
        
        //Tableview cell delte button
        cell.deleteButton.tag = indexPath.row;
        [cell.deleteButton addTarget:self action:@selector(tableCellDeleteClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        //Set delete cell image
        if (self.lightMode) {
            UIImage *deleteImage = [UIImage imageNamed:@"Trash_dark"];
            [cell.deleteButton setBackgroundImage:deleteImage forState:UIControlStateNormal];
            [cell.deleteButton setTitleColor:[self.colorArray objectAtIndex:10] forState:UIControlStateNormal];
        }
        else{
            UIImage *deleteImage = [UIImage imageNamed:@"Trash_light"];
            [cell.deleteButton setBackgroundImage:deleteImage forState:UIControlStateNormal];
            [cell.deleteButton setTitleColor:[self.colorArray objectAtIndex:10] forState:UIControlStateNormal];
        }
        
        //Remove Selection style
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
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
        
        NSDictionary* attributes = @{
                                     NSStrikethroughStyleAttributeName: [NSNumber numberWithInt:NSUnderlineStyleSingle]
                                     };
        
        NSAttributedString* attrText = [[NSAttributedString alloc] initWithString:cell.titleLabel.text attributes:attributes];
        NSAttributedString* attrText2 = [[NSAttributedString alloc] initWithString:cell.titleLabel.text attributes:nil];
        
        if ([[anArray objectAtIndex:indexPath.row] finishedBool]) {
            //NSLog(@"the row %ld was finished", (long)indexPath.row);
            cell.titleLabel.attributedText = attrText;
            cell.deleteButton.hidden = NO;
        }
        else{
            //NSLog(@"the row %ld was no finished", (long)indexPath.row);
            cell.titleLabel.attributedText = attrText2;
            cell.deleteButton.hidden = YES;
            
        }
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
            self.readingModeSegmentControl = [[UISegmentedControl alloc] initWithItems:itemArray];
            
            [optionsCell addSubview:self.readingModeSegmentControl];
            self.readingModeSegmentControl.frame = CGRectMake(self.view.frame.size.width - 110, 5, 100, 30);
            [self.readingModeSegmentControl addTarget:self action:@selector(ReadingModeSegmentControlAction:) forControlEvents:UIControlEventValueChanged];
            self.readingModeSegmentControl.selectedSegmentIndex = 0;
            
            //Set Reading Mode switch to it's last value
            NSEntityDescription *entitydesc2 = [NSEntityDescription entityForName:@"Option" inManagedObjectContext:self.managedObjectContext];
            NSFetchRequest *request2 = [[NSFetchRequest alloc] init];
            [request2 setEntity:entitydesc2];
            NSPredicate *predicate2 = [NSPredicate predicateWithFormat:@"(optionId == %d) AND (optionData == YES)", [[NSNumber numberWithInt:1] integerValue]];
            [request2 setPredicate:predicate2];
            NSError *error2;
            
            NSArray *matchingData2 = [self.managedObjectContext executeFetchRequest:request2 error:&error2];
            
            if (matchingData2.count <= 0) {
                
                NSLog(@"No Reading Mode data set");
                
            }
            else{
                NSLog(@"Found YES for Reading Mode on startup");
                //[self.autoReadingModeSwitch setOn:YES animated:YES];
                NSLog(@"The value of the switch is: %@", [NSNumber numberWithBool:self.autoReadingModeSwitch.on]);
                //[self autoReadingModeAction:self.autoReadingModeSwitch];
                NSLog(@"Reading mode data found");
                self.readingModeSegmentControl.selectedSegmentIndex = 1;
                [self ReadingModeSegmentControlAction:self.readingModeSegmentControl];
            }
            
            
            
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
        //Auto Reading Mode
        else if (indexPath.row == 3){
            UILabel *autoReadingModeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 200, optionsCell.frame.size.height)];
            autoReadingModeLabel.text = @"Auto Reading Mode";
            [optionsCell addSubview:autoReadingModeLabel];
            
            if (self.autoReadingModeSwitch == nil) {
                self.autoReadingModeSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 80, 5, 70, 30)];
            }
            
            //Set Auto Reading Mode switch to it's last value
            NSEntityDescription *entitydesc2 = [NSEntityDescription entityForName:@"Option" inManagedObjectContext:self.managedObjectContext];
            NSFetchRequest *request2 = [[NSFetchRequest alloc] init];
            [request2 setEntity:entitydesc2];
            NSPredicate *predicate2 = [NSPredicate predicateWithFormat:@"(optionId == %d) AND (optionData == YES)", [[NSNumber numberWithInt:0] integerValue]];
            [request2 setPredicate:predicate2];
            NSError *error2;
            
            NSArray *matchingData2 = [self.managedObjectContext executeFetchRequest:request2 error:&error2];
            
            if (matchingData2.count <= 0) {
                
                NSLog(@"No autoReadingMode data set");
                
            }
            else{
                NSLog(@"Found YES for autoReadingMode on startup");
                
                NSLog(@"The value of the switch is: %@", [NSNumber numberWithBool:self.autoReadingModeSwitch.on]);
                [self autoReadingModeAction:self.autoReadingModeSwitch];
                NSLog(@"autoReadingMode data found");
                
            }
            [self.autoReadingModeSwitch addTarget:self action:@selector(autoReadingModeAction:) forControlEvents:UIControlEventValueChanged];
            [optionsCell addSubview:self.autoReadingModeSwitch];
        }
        //Remove All
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
        //Auto Sort
        /*
        else if (indexPath.row == 5){
            UILabel *autoSortLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 200, optionsCell.frame.size.height)];
            autoSortLabel.text = @"Auto Sort";
            [optionsCell addSubview:autoSortLabel];
            
            UIButton *sortButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            sortButton.frame = CGRectMake(self.view.frame.size.width - 110, 5, 100, 30);
            [sortButton setTitle:@"Sort" forState:UIControlStateNormal];
            [sortButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [sortButton addTarget:self action:@selector(autoSortAction:) forControlEvents:UIControlEventTouchUpInside];
            [optionsCell addSubview:sortButton];
        }
        */
        

        //[optionsCell.optionsControl addTarget:self action:@selector(yourSegmentPicked:) forControlEvents:UIControlEventTouchUpInside];
        return optionsCell;
    }

}

-(void)tableCellDeleteClicked:(UIButton*)sender
{
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:buttonPosition];
    
    //Remove Core data entry
    Item *item = [anArray objectAtIndex:indexPath.row];
    NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"Item" inManagedObjectContext:self.managedObjectContext];
    
    //Remove notification
    [self cancelLocalNotification:[NSString stringWithFormat: @"%ld", (long)[item pid]]];
    
    
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
    //[self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    [anArray removeObjectAtIndex:indexPath.row];
    [self.tableView reloadData];
}


- (void)autoReadingModeAction:(UISwitch *)mySwitch{
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Option" inManagedObjectContext:self.managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"optionId == %d", [[NSNumber numberWithInt:0] integerValue]];
    [request setPredicate:predicate];
    NSError *error;
    NSArray *matchingData = [self.managedObjectContext executeFetchRequest:request error:&error];
    
    if (matchingData.count <=0) {
        //Add to core data
        NSLog(@"No options entites. Must create them.");
        //NSEntityDescription *entitydesc = [NSEntityDescription entityForName:@"" inManagedObjectContext:self.managedObjectContext];
        NSManagedObject *newItem = [[NSManagedObject alloc]initWithEntity:entity insertIntoManagedObjectContext:self.managedObjectContext];
        [newItem setValue:[NSNumber numberWithInt:0] forKey:@"optionId"];
        [newItem setValue:[NSNumber numberWithBool:self.autoReadingModeSwitch.on] forKey:@"optionData"];
        
        [self.managedObjectContext save:&error];
    }
    else{
        if (self.autoReadingModeSwitch.on) {
            NSLog(@"autoReadingModeAction switch is on");
            NSDateComponents *components = [[NSCalendar currentCalendar] components:NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit fromDate:[NSDate date]];
            NSInteger currentHour = [components hour];
            NSInteger currentMinute = [components minute];
            NSInteger currentSecond = [components second];
            
            self.checkLightMode = YES;
            
            
            if (currentHour < 7 || (currentHour > 21 || (currentHour == 21 && (currentMinute > 0 || currentSecond > 0)))) {
                self.readingModeSegmentControl.selectedSegmentIndex = 1;
                [self ReadingModeSegmentControlAction:self.readingModeSegmentControl];
            }
            //Light Mode
            else{
                self.readingModeSegmentControl.selectedSegmentIndex = 0;
                [self ReadingModeSegmentControlAction:self.readingModeSegmentControl];
            }
            
        }
        
        else{
            NSLog(@"autoReadingModeAction switch is off");
            self.checkLightMode = NO;
        }
        for (NSManagedObject *obj in matchingData) {
            [obj setValue:[NSNumber numberWithBool:self.autoReadingModeSwitch.on] forKey:@"optionData"];
        }
        
        [self.managedObjectContext save:&error];
    }

    
}

#pragma mark - Nofications

-(void) scheduleNotificationForDate:(NSDate *)date AlertBody:(NSString *)alertBody ActionButtonTitle:(NSString *)actionButtonTitle NotificationID:(NSString *)notificationID NotificationInterval:(NSInteger)notificationInterval{

    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    localNotification.fireDate = date;
    localNotification.timeZone = [NSTimeZone localTimeZone];
    localNotification.alertBody = alertBody;
    localNotification.alertAction = actionButtonTitle;
    
    switch (notificationInterval) {
            //Name
        case 0:
        {
            NSLog(@"None");
            localNotification.repeatInterval = 0;
            break;
        }
        case 1:
        {
            NSLog(@"Daily");
            localNotification.repeatInterval = NSCalendarUnitDay;
            break;
        }
        case 2:
        {
            NSLog(@"Weekly");
            localNotification.repeatInterval = NSCalendarUnitWeekOfYear;
            break;
        }
        case 3:
        {
            NSLog(@"Monthly");
            localNotification.repeatInterval = NSCalendarUnitMonth;
            break;
        }
        case 4:
        {
            NSLog(@"Yearly");
            localNotification.repeatInterval = NSCalendarUnitYear;
            break;
        }
        default:
            break;
    }

    //localNotification.soundName = @"yourSound.wav";
    
    NSDictionary *infoDict = [NSDictionary dictionaryWithObject:notificationID forKey:notificationID];
    localNotification.userInfo = infoDict;
    
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
}

- (void)cancelLocalNotification:(NSString*)notificationID {
    //loop through all scheduled notifications and cancel the one we're looking for
    UILocalNotification *cancelThisNotification = nil;
    BOOL hasNotification = NO;
    
    for (UILocalNotification *someNotification in [[UIApplication sharedApplication] scheduledLocalNotifications]) {
        if([[someNotification.userInfo objectForKey:notificationID] isEqualToString:notificationID]) {
            cancelThisNotification = someNotification;
            hasNotification = YES;
            break;
        }
    }
    if (hasNotification == YES) {
        NSLog(@"%@ ",cancelThisNotification);
        [[UIApplication sharedApplication] cancelLocalNotification:cancelThisNotification];
    }
}

#pragma mark - Options Stuffs

- (void)sortAction:(UIButton *)button{
    NSLog(@"sortAction pressed");
    [self setPickerMode:0];
    self.pickerArray = sortOptionsArray;
    [self.pickerViewTextField becomeFirstResponder];
    [self.sortPickerView reloadAllComponents];
    
}

- (void)autoSortAction:(UIButton *)button{
    NSLog(@"autoSortAction pressed");
    [self setPickerMode:1];
    self.pickerArray = autoSortOptionsArray;
    [self.pickerViewTextField becomeFirstResponder];
    [self.sortPickerView reloadAllComponents];
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
    
    [self saveAllData];
}


- (void)removeAllAction:(UIButton *)button{
    NSLog(@"removeAllAction pressed");
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Warning!" message:@"Are you sure you want to delete everything?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Yes", nil];
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    [alert setTag:1];
    [alert show];
    
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 1) { //Remove All Alert!
        if (buttonIndex == 0) {
            NSLog(@"pressed button 0");
        }
        else{
            NSLog(@"pressed button 1");
            [anArray removeAllObjects];
            
            //Remove all data from core data
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
    }
}

- (void)ReadingModeSegmentControlAction:(UISegmentedControl *)segment{
    //[self.autoReadingModeSwitch setOn:NO animated:YES];
    //change core data
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Option" inManagedObjectContext:self.managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"optionId == %d", [[NSNumber numberWithInt:1] integerValue]];
    [request setPredicate:predicate];
    NSError *error;
    NSArray *matchingData = [self.managedObjectContext executeFetchRequest:request error:&error];
    
    if (matchingData.count <=0) {
        //Add to core data
        NSLog(@"No options entites. Must create them.");
        //NSEntityDescription *entitydesc = [NSEntityDescription entityForName:@"" inManagedObjectContext:self.managedObjectContext];
        NSManagedObject *newItem = [[NSManagedObject alloc]initWithEntity:entity insertIntoManagedObjectContext:self.managedObjectContext];
        [newItem setValue:[NSNumber numberWithInt:1] forKey:@"optionId"];
        [newItem setValue:[NSNumber numberWithBool:self.self.readingModeSegmentControl.selectedSegmentIndex] forKey:@"optionData"];
        
        [self.managedObjectContext save:&error];
    }
    else{
        for (NSManagedObject *obj in matchingData) {
            [obj setValue:[NSNumber numberWithBool:self.readingModeSegmentControl.selectedSegmentIndex] forKey:@"optionData"];
        }
        
        [self.managedObjectContext save:&error];
    }
    
    
    //change colour scheme
    if (self.readingModeSegmentControl.selectedSegmentIndex == 1) {
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
        //self.inputAccView.barStyle = UIBarStyleBlack;
        
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
        self.inputAccView.barStyle = UIBarStyleDefault;
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
    //[self.autoReadingModeSwitch setOn:NO animated:YES];
    
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
        NSLog(@"button tag is: %lu", (long)butn.tag);
    }
    
    
    /*
    if (sender.tag == 0)
    {
        //Here your coding.
        
    }
    */
}






- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Touch Functions

- (IBAction)longPressGestureRecognized:(id)sender {
    
    UILongPressGestureRecognizer *longPress = (UILongPressGestureRecognizer *)sender;
    UIGestureRecognizerState state = longPress.state;
    
    CGPoint location = [longPress locationInView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:location];
    
    // More coming soon...
    static UIView       *snapshot = nil;        ///< A snapshot of the row user is moving.
    static NSIndexPath  *sourceIndexPath = nil; ///< Initial index path, where gesture begins.
    
    switch (state) {
        case UIGestureRecognizerStateBegan: {
            if (indexPath) {
                sourceIndexPath = indexPath;
                
                UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
                
                // Take a snapshot of the selected row using helper method.
                snapshot = [self customSnapshotFromView:cell];
                
                // Add the snapshot as subview, centered at cell's center...
                __block CGPoint center = cell.center;
                snapshot.center = center;
                snapshot.alpha = 0.0;
                [self.tableView addSubview:snapshot];
                [UIView animateWithDuration:0.25 animations:^{
                    
                    // Offset for gesture location.
                    center.y = location.y;
                    snapshot.center = center;
                    snapshot.transform = CGAffineTransformMakeScale(1.05, 1.05);
                    snapshot.alpha = 0.98;
                    
                    // Fade out.
                    cell.alpha = 0.0;
                    
                } completion:^(BOOL finished) {
                    
                    cell.hidden = YES;
                    
                }];
            }
            break;
        }
            // More coming soon...
        case UIGestureRecognizerStateChanged: {
            CGPoint center = snapshot.center;
            center.y = location.y;
            snapshot.center = center;
            
            // Is destination valid and is it different from source?
            if (indexPath && ![indexPath isEqual:sourceIndexPath]) {
                
                // ... update data source.
                [anArray exchangeObjectAtIndex:indexPath.row withObjectAtIndex:sourceIndexPath.row];
                
                // ... move the rows.
                [self.tableView moveRowAtIndexPath:sourceIndexPath toIndexPath:indexPath];
                
                // ... and update source so it is in sync with UI changes.
                sourceIndexPath = indexPath;
                
                
            }
            break;
        }
            // More coming soon...
        default: {
            // Clean up.
            UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:sourceIndexPath];
            cell.hidden = NO;
            cell.alpha = 0.0;
            [UIView animateWithDuration:0.25 animations:^{
                
                snapshot.center = cell.center;
                snapshot.transform = CGAffineTransformIdentity;
                snapshot.alpha = 0.0;
                
                // Undo fade out.
                cell.alpha = 1.0;
                
            } completion:^(BOOL finished) {
                
                sourceIndexPath = nil;
                [snapshot removeFromSuperview];
                snapshot = nil;
                [self saveAllData];
            }];
            break;
        }
    }
}

- (UIView *)customSnapshotFromView:(UIView *)inputView {
    
    // Make an image from the input view.
    UIGraphicsBeginImageContextWithOptions(inputView.bounds.size, NO, 0);
    [inputView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    // Create an image view.
    UIView *snapshot = [[UIImageView alloc] initWithImage:image];
    snapshot.layer.masksToBounds = NO;
    snapshot.layer.cornerRadius = 0.0;
    snapshot.layer.shadowOffset = CGSizeMake(-5.0, 0.0);
    snapshot.layer.shadowRadius = 5.0;
    snapshot.layer.shadowOpacity = 0.4;
    
    return snapshot;
}

-(void)didPressLong:(UIGestureRecognizer *)gestureRecognizer {
    /*
    CGPoint swipeLocation = [gestureRecognizer locationInView:self.tableView];
    NSIndexPath *swipedIndexPath = [self.tableView indexPathForRowAtPoint:swipeLocation];
    MyTableViewCell* swipedCell = (MyTableViewCell *)[self.tableView cellForRowAtIndexPath:swipedIndexPath];
    */
    
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        
        NSLog(@"Holding Begins");
        /*
        //self.longPressCell.contentView.backgroundColor = [self.colorArray objectAtIndex:11];
        CGPoint swipeLocation = [gestureRecognizer locationInView:self.tableView];
        
        
        self.longPressIndexPath = [self.tableView indexPathForRowAtPoint:swipeLocation];
        
        //Slide tableview to tableview cell that is being held
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.longPressIndexPath.row inSection:0];
        [self.tableView scrollToRowAtIndexPath:indexPath
                             atScrollPosition:UITableViewScrollPositionTop
                                     animated:YES];
        
        self.longPressCell = (MyTableViewCell *)[self.tableView cellForRowAtIndexPath:[self longPressIndexPath]];
        
        
        //Reload the values of the item in each view
        self.colorButton.backgroundColor = self.longPressCell.colorButton.backgroundColor;
        [self.pickerView setDate:[[anArray objectAtIndex:self.longPressIndexPath.row] date]];
        self.pickerArray = repeatArray;
        [self.repeatPickerView selectRow:[[anArray objectAtIndex:self.longPressIndexPath.row] interval] inComponent:0 animated:NO];
        [self setModifying:YES];
        [self setLastModified:self.longPressIndexPath.row];
        MyTableViewCell *cell = (MyTableViewCell *)[self.tableView cellForRowAtIndexPath:self.longPressIndexPath];
        cell.contentView.backgroundColor = [self.colorArray objectAtIndex:10];
        self.textField.text = cell.titleLabel.text;
        //[myDatePicker reloadInputViews];
        [self.textField becomeFirstResponder];
        [self.tableView setEditing:NO];
         */
        
        [self.tableView setEditing:!self.tableView.editing animated:true];
        [self.tableView reloadData];
        
        
        
        
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
                swipedCell.deleteButton.hidden = NO;
                
                swipedCell.titleLabel.attributedText = attrText2;
                [[anArray objectAtIndex:swipedIndexPath.row] setFinishedBool:NO];
                Item *swipedItem = [anArray objectAtIndex:swipedIndexPath.row];
                
                //re-add local notifcation
                
                if (swipedItem.reminder) {
                    NSLog(@"scheduling with pid %ld", (long)[swipedItem pid]);
                    [self scheduleNotificationForDate:[swipedItem date] AlertBody:[swipedItem name] ActionButtonTitle:[swipedItem name] NotificationID:[NSString stringWithFormat: @"%ld", (long)[swipedItem pid]] NotificationInterval:[swipedItem interval]];
                }
                
                
                //Move item to the beginning of the data source
                [anArray removeObjectAtIndex:swipedIndexPath.row];
                [anArray insertObject:swipedItem atIndex:0];
                
                //Move uncrossed item to the top of the tableview
                [self.tableView beginUpdates];
                [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:swipedIndexPath] withRowAnimation:UITableViewRowAnimationTop];
                [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationBottom];
                [self.tableView endUpdates];
                
                [self saveAllData];
            }
            else{
                NSLog(@"Swiped regular word");
                swipedCell.deleteButton.hidden = YES;
                swipedCell.titleLabel.attributedText = attrText;
                [[anArray objectAtIndex:swipedIndexPath.row] setFinishedBool:YES];
                
                Item *swipedItem = [anArray objectAtIndex:swipedIndexPath.row];
                
                //Remove notification
                NSLog(@"removing with pid %ld", (long)[swipedItem pid]);
                
                [self cancelLocalNotification:[NSString stringWithFormat: @"%ld", (long)[swipedItem pid]]];

                //Move item in datasource
                [anArray removeObjectAtIndex:swipedIndexPath.row];
                [anArray insertObject:swipedItem atIndex: [anArray count]];
                
                
                //Move crossed out word to bottom
                
                [self.tableView beginUpdates];
                [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:swipedIndexPath] withRowAnimation:UITableViewRowAnimationBottom];
                [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:[anArray count]-1 inSection:0]] withRowAnimation:UITableViewRowAnimationTop];
                [self.tableView endUpdates];
                
                MyTableViewCell *cell = (MyTableViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:[anArray count]-1 inSection:0]];
                
                
                
                cell.titleLabel.attributedText = attrText;
                [self saveAllData];
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
                [obj setValue:[NSNumber numberWithBool:[[anArray objectAtIndex:i] finishedBool]] forKey:@"itemFinished"];
                [obj setValue:[NSNumber numberWithInteger:[[anArray objectAtIndex:i] interval]] forKey:@"itemInterval"];
                [obj setValue:[NSNumber numberWithBool:[[anArray objectAtIndex:i] reminder]] forKey:@"itemReminder"];
                
                //Fix local nofications
                [self cancelLocalNotification:[NSString stringWithFormat: @"%ld", (long)[[anArray objectAtIndex:i] pid]]];
                
                if (![[obj valueForKey:@"itemFinished"] boolValue]) {
                    if ([[obj valueForKey:@"itemReminder"] boolValue]) {
                        [self scheduleNotificationForDate:[[anArray objectAtIndex:i] date] AlertBody:[[anArray objectAtIndex:i] name] ActionButtonTitle:[[anArray objectAtIndex:i] name] NotificationID:[NSString stringWithFormat: @"%ld", (long)[[anArray objectAtIndex:i] pid]] NotificationInterval:[[anArray objectAtIndex:i] interval]];
                    }
                }
                
                
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
        NSLog(@"didSelectRowAtIndex doRemind is:,%d", self.doRemind);
        Item * i = [[Item alloc] initWithNameAndColorAndDateAndPidAndBoolAndIntervalAndReminder:self.textField.text withColor:self.selectedColor withDate:[self.pickerView date] withPid:[[anArray objectAtIndex:[self lastModified]] pid] withBool:[[anArray objectAtIndex:indexPath.row] finishedBool] withInterval:[self.repeatPickerView selectedRowInComponent:0] withReminder:self.doRemind];
        
        
        
        //Remove noficiation
        Item *removedItem = [anArray objectAtIndex:[self lastModified]];
        [self cancelLocalNotification:[NSString stringWithFormat: @"%ld", (long)[removedItem pid]]];
        
        
        [anArray removeObjectAtIndex:[self lastModified]];
        
        [anArray insertObject:i atIndex:[self lastModified]];
        
        if (![i finishedBool]) {
            if ([i reminder]) {
                NSLog(@"Editing a non strikedout word");
                [self scheduleNotificationForDate:[i date] AlertBody:[i name] ActionButtonTitle:[i name] NotificationID:[NSString stringWithFormat: @"%ld", (long)[i pid]] NotificationInterval:[i interval]];
            }
            
        }
        NSLog(@"scheduling with pid %ld", (long)[i pid]);
        
        
        
        
        //Edit core data record
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
        [obj setValue:[NSNumber numberWithBool:[i finishedBool]] forKey:@"itemFinished"];
        [obj setValue:[NSNumber numberWithInteger:[i interval]] forKey:@"itemInterval"];
        [obj setValue:[NSNumber numberWithBool:[i reminder]] forKey:@"itemReminder"];
        
        [self.tableView reloadData];
        [self.managedObjectContext save:&error];
        [self setModifying:NO];
        
    }
    else{
        
        [self incrementItemsCount];
        
        //Fetch core data stuff
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Items" inManagedObjectContext:self.managedObjectContext];
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        [request setEntity:entity];
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"TRUEPREDICATE"];
        [request setPredicate:predicate];
        NSError *error;
        
        NSManagedObject *obj = [[self.managedObjectContext executeFetchRequest:request error:&error] objectAtIndex:0];
        
        
        //Create item and add it to array
        Item * i = [[Item alloc] initWithNameAndColorAndDateAndPidAndBoolAndIntervalAndReminder:self.textField.text withColor:self.selectedColor withDate:[self.pickerView date] withPid:[[obj valueForKey:@"count"] integerValue] withBool:NO withInterval:[self.repeatPickerView selectedRowInComponent:0] withReminder:self.doRemind];
        
        [anArray addObject: i];
        
        
        
        
        if (i.reminder) {
            NSLog(@"scheduling with pid %ld", (long)[i pid]);
            [self scheduleNotificationForDate:[i date] AlertBody:[i name] ActionButtonTitle:[i name] NotificationID:[NSString stringWithFormat: @"%ld", (long)[i pid]] NotificationInterval:[i interval]];
        }
        
        //Add to tableView
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
        [newItem setValue:[NSNumber numberWithBool:[i finishedBool]] forKey:@"itemFinished"];
        [newItem setValue:[NSNumber numberWithInteger:[i interval]] forKey:@"itemInterval"];
        [newItem setValue:[NSNumber numberWithBool:[i reminder]] forKey:@"itemReminder"];
        
        NSError *error2;
        [self.managedObjectContext save:&error2];
        
        
        
    }
    self.textField.text = nil;
    
    //Change this!
    self.selectedColor = 7;
    self.doRemind = NO;
    self.colorButton.backgroundColor = [UIColor darkGrayColor];
    self.reminderButton.backgroundColor = [UIColor darkGrayColor];
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
    [self.tableView reloadData];
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
