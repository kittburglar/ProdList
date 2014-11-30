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


static NSString *CellIdentifier = @"CellIdentifier";

@interface ViewController ()

@end

@implementation ViewController


- (void)viewDidLoad { 
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //Add accessory view (bar on top of keyboard)
    self.inputAccView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, [[UIScreen mainScreen] bounds].size.width, 50.0)];
    [self.inputAccView setBackgroundColor:[UIColor lightGrayColor]];
    [self.inputAccView setAlpha: 0.8];
    
    
    //Create keyboard Button programmically
    UIButton *keyboardButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    keyboardButton.frame = CGRectMake(10, CGRectGetMaxY(self.inputAccView.bounds)/2 - 40/2, 40, 40);
    [keyboardButton setBackgroundColor:[UIColor darkGrayColor]];
    [keyboardButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [keyboardButton addTarget:self action:@selector(pickKeyboard:) forControlEvents:UIControlEventTouchUpInside];
    [self.inputAccView addSubview:keyboardButton];
    self.textField.inputAccessoryView = self.inputAccView;
    
    
    //Create date Button programmically
    UIButton *dateButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    dateButton.frame = CGRectMake(60, CGRectGetMaxY(self.inputAccView.bounds)/2 - 40/2, 40, 40);
    [dateButton setBackgroundColor:[UIColor darkGrayColor]];
    [dateButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [dateButton addTarget:self action:@selector(pickDate:) forControlEvents:UIControlEventTouchUpInside];
    [self.inputAccView addSubview:dateButton];
    self.textField.inputAccessoryView = self.inputAccView;
    
    //Create color Button programmically
    UIButton *colorButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    colorButton.frame = CGRectMake(110, CGRectGetMaxY(self.inputAccView.bounds)/2 - 40/2, 40, 40);
    [colorButton setBackgroundColor:[UIColor darkGrayColor]];
    [colorButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [colorButton addTarget:self action:@selector(pickColor:) forControlEvents:UIControlEventTouchUpInside];
    [self.inputAccView addSubview:colorButton];
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
    
    
    
    
    
    
    
    
    
    
    self.tableView.delegate = self;
    
}


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
        [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cellIdentifier"];
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
    return 8;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"cellIdentifier" forIndexPath:indexPath];
    if (indexPath.row == 0) {
        cell.backgroundColor = [UIColor blueColor];
    }
    else if (indexPath.row == 1){
        cell.backgroundColor = [UIColor redColor];
    }
    else if (indexPath.row == 2){
        cell.backgroundColor = [UIColor redColor];
    }
    else if (indexPath.row == 3){
        cell.backgroundColor = [UIColor greenColor];
    }
    else if (indexPath.row == 4){
        cell.backgroundColor = [UIColor purpleColor];
    }
    else if (indexPath.row == 5){
        cell.backgroundColor = [UIColor brownColor];
    }
    else if (indexPath.row == 6){
        cell.backgroundColor = [UIColor yellowColor];
    }
    else if (indexPath.row == 7){
        cell.backgroundColor = [UIColor orangeColor];
    }
    //cell.backgroundColor=[UIColor greenColor];
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
    if (indexPath.row == 0) {
        NSLog(@"selected 0");
        self.selectedColor = [UIColor blueColor];
    }
    else if (indexPath.row == 1){
        self.selectedColor = [UIColor redColor];
    }
    else if (indexPath.row == 2){
        self.selectedColor = [UIColor redColor];
    }
    else if (indexPath.row == 3){
        self.selectedColor = [UIColor greenColor];
    }
    else if (indexPath.row == 4){
        self.selectedColor = [UIColor purpleColor];
    }
    else if (indexPath.row == 5){
        self.selectedColor = [UIColor brownColor];
    }
    else if (indexPath.row == 6){
        self.selectedColor = [UIColor yellowColor];
    }
    else if (indexPath.row == 7){
        self.selectedColor = [UIColor orangeColor];
    }
    [cell setHighlighted:YES];
}


- (void)collectionView:(UICollectionView *)colView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell* cell = [colView cellForItemAtIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor blueColor];
    
}



- (void)collectionView:(UICollectionView *)colView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell* cell = [colView cellForItemAtIndexPath:indexPath];
    
    cell.backgroundColor = nil;
    
}


#pragma mark - UITableView Datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"%lu",(unsigned long)[anArray count]);
    return [anArray count];
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




-(MyTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath  *)indexPath
{
    NSLog(@"cellForRowAtIndexPath");
    static NSString *CellIdentifier = @"Cell";
    
    MyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    [cell.titleLabel setText:[NSString stringWithFormat:@"Row %li in Section %li", (long)[indexPath row], (long)[indexPath section]]];
    
    
    if (cell == nil) {
        cell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:CellIdentifier];
        
    }
    
    cell.titleLabel.text = [[anArray objectAtIndex:indexPath.row] name];
    cell.descriptionLabel.text = [[anArray objectAtIndex:indexPath.row] returnDate];
    if ([[anArray objectAtIndex:indexPath.row] color] != nil) {
        cell.colorButton.backgroundColor = [[anArray objectAtIndex:indexPath.row] color];
    }
    
     /*
    UILabel *label = (UILabel *)[cell.contentView viewWithTag:10];
    [label setText:[NSString stringWithFormat:@"Hello"]];
    
    cell.textLabel.text = [[anArray objectAtIndex:indexPath.row] name];
    
    NSLog(@"cell textlabel is %@", cell.textLabel.text);
    cell.backgroundColor = [UIColor clearColor];
    
    UIButton *editButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    //editButton.frame = CGRectMake(CGRectGetWidth(cell.bounds) - 80, 0, 40, CGRectGetHeight(cell.bounds));
    //editButton.frame = CGRectMake(CGRectGetMinX(cell.bounds), CGRectGetMinY(cell.bounds), CGRectGetHeight(cell.bounds), CGRectGetHeight(cell.bounds));
    editButton.backgroundColor = [UIColor redColor];
    [editButton setTitle:@"Hello" forState:UIControlStateNormal];
    //editButton.tag = indexPath.row;
    [cell.contentView addSubview:editButton];
    */
    return cell;
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
        cell.titleLabel.textColor = [UIColor redColor];
        self.textField.text = cell.titleLabel.text;
        [self.textField becomeFirstResponder];
        [self.tableView setEditing:NO];
    }];
    moreAction.backgroundColor = [UIColor lightGrayColor];
       UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"Delete" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
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
    
    NSLog(@"moveRowAtIndexPath called");
    //NSString *stringToMove = [anArray objectAtIndex:sourceIndexPath.row];
    
    Item *itemToMove = [anArray objectAtIndex:sourceIndexPath.row];
    
    [anArray removeObjectAtIndex:sourceIndexPath.row];
    
    //[anArray insertObject:stringToMove atIndex:destinationIndexPath.row];
    
    [anArray insertObject:itemToMove atIndex:destinationIndexPath.row];
    
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




-(void)didPressLong:(UIGestureRecognizer *)gestureRecognizer {
    /*
    CGPoint swipeLocation = [gestureRecognizer locationInView:self.tableView];
    NSIndexPath *swipedIndexPath = [self.tableView indexPathForRowAtPoint:swipeLocation];
    MyTableViewCell* swipedCell = (MyTableViewCell *)[self.tableView cellForRowAtIndexPath:swipedIndexPath];
    */
    
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        
        NSLog(@"Holding Begins");
        CGPoint swipeLocation = [gestureRecognizer locationInView:self.tableView];
        
        self.longPressIndexPath = [self.tableView indexPathForRowAtPoint:swipeLocation];
        /*
        self.longPressCell = (MyTableViewCell *)[self.tableView cellForRowAtIndexPath:[self longPressIndexPath]];
        self.longPressCell.titleLabel.text = [anArray[self.longPressIndexPath.row] returnDate];
         */
        [self setModifying:YES];
        [self setLastModified:self.longPressIndexPath.row];
        MyTableViewCell *cell = (MyTableViewCell *)[self.tableView cellForRowAtIndexPath:self.longPressIndexPath];
        cell.titleLabel.textColor = [UIColor redColor];
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
            }
            else{
                NSLog(@"Swiped regular word");
                swipedCell.titleLabel.attributedText = attrText;
            }
        }
    }
    
}


- (IBAction)textReturn:(id)sender {
    
    NSLog(@"textReturn!");
    
    //check for whitespace entry or empty textfield
    NSCharacterSet *whitespace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSString *trimmed = [self.textField.text stringByTrimmingCharactersInSet:whitespace];
    
    if ([trimmed length] == 0) {
        //Do nothing
    }
    //Add add to core data and list
    else if ([self modifying]) {
        NSLog(@"textReturn while modifying!");
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[self lastModified] inSection:0];
        MyTableViewCell *cell = (MyTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
        cell.titleLabel.textColor = [UIColor blackColor];
        [anArray removeObjectAtIndex:[self lastModified]];
        
        //Item * i = [[Item alloc] initWithName:self.textField.text];
        
        //Item * i = [[Item alloc] initWithNameAndDate:self.textField.text withDate:[self.pickerView date]];
        
        Item * i = [[Item alloc] initWithNameAndColorAndDate:self.textField.text withColor:self.selectedColor withDate:[self.pickerView date]];
        
        
        [anArray insertObject:i atIndex:[self lastModified]];
        
        [self.tableView reloadData];
        [self setModifying:NO];
    }
    else{
        //Item * i = [[Item alloc] initWithName:self.textField.text];
        
        //Item * i = [[Item alloc] initWithNameAndDate:self.textField.text withDate:[self.pickerView date]];
        
        Item * i = [[Item alloc] initWithNameAndColorAndDate:self.textField.text withColor:self.selectedColor withDate:[self.pickerView date]];
        
        [anArray addObject: i];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:([anArray count] - 1) inSection:0];
        //NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    
        //UITableView *tv = (UITableView *)self.tableView;
        [self.tableView beginUpdates];
        [self.tableView insertRowsAtIndexPaths:@[indexPath]withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.tableView endUpdates];
    }
    self.textField.text = nil;
    [sender resignFirstResponder];
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


    
- (IBAction)editButton:(UIButton *)sender {
    [self.tableView setEditing:!self.tableView.editing animated:true];
    
}
- (IBAction)testButtonPressed:(UIButton *)sender {
}
@end
