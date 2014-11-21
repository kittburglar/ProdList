//
//  ViewController.m
//  fuck
//
//  Created by kittiphong xayasane on 2014-11-17.
//  Copyright (c) 2014 Kittiphong Xayasane. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad { 
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
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
    UISwipeGestureRecognizer *gesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(didSwipe:)];
    gesture.direction = UISwipeGestureRecognizerDirectionRight;
    [self.tableView addGestureRecognizer:gesture];
    
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


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath  *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:cellIdentifier];
        
    }
    
    cell.textLabel.text = [anArray objectAtIndex:indexPath.row];
    cell.backgroundColor = [UIColor clearColor];
    
    UIButton *editButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    editButton.frame = CGRectMake(CGRectGetWidth(cell.bounds) - 70, 0,
                                  40,
                                  CGRectGetHeight(cell.bounds));
    editButton.backgroundColor = [UIColor redColor];
    [editButton setTitle:@"Hello" forState:UIControlStateNormal];
    
    //editButton.tag = indexPath.row;
    [cell addSubview:editButton];
    [editButton addTarget:self action:@selector(yourButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
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
        NSLog(@"show detail for item at row %ld", (long)indexPath.row);
    }
    /*
    if (sender.tag == 0)
    {
        //Here your coding.
        
    }
    */
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"delete pressed!");
    [anArray removeObjectAtIndex:indexPath.row];
    
    [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    
}



- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {

    return YES;
    
}


- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    
    NSString *stringToMove = [anArray objectAtIndex:sourceIndexPath.row];
    
    [anArray removeObjectAtIndex:sourceIndexPath.row];
    
    [anArray insertObject:stringToMove atIndex:destinationIndexPath.row];
    
    
    
}

- (NSIndexPath *)tableView:(UITableView *)tableView

targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath

       toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath {
    
    NSDictionary *section = [anArray objectAtIndex:sourceIndexPath.section];
    
    NSUInteger sectionCount = [[section valueForKey:@"content"] count];
    
    if (sourceIndexPath.section != proposedDestinationIndexPath.section) {
        
        NSUInteger rowInSourceSection =
        
        (sourceIndexPath.section > proposedDestinationIndexPath.section) ?
        
        0 : sectionCount - 1;
        
        return [NSIndexPath indexPathForRow:rowInSourceSection inSection:sourceIndexPath.section];
        
    } else if (proposedDestinationIndexPath.row >= sectionCount) {
        
        return [NSIndexPath indexPathForRow:sectionCount - 1 inSection:sourceIndexPath.section];
        
    }
    
    // Allow the proposed destination.
    
    return proposedDestinationIndexPath;
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)didSwipe:(UIGestureRecognizer *)gestureRecognizer {
    NSLog(@"Swiped!");
    
    if ((gestureRecognizer.state == UIGestureRecognizerStateEnded) && !self.tableView.editing) {
        CGPoint swipeLocation = [gestureRecognizer locationInView:self.tableView];
        NSIndexPath *swipedIndexPath = [self.tableView indexPathForRowAtPoint:swipeLocation];
        UITableViewCell* swipedCell = [self.tableView cellForRowAtIndexPath:swipedIndexPath];
        // ...
        //NSString *text = [[swipedCell textLabel] text];
        if (anArray.count != 0) {
            NSDictionary* attributes = @{
                                         NSStrikethroughStyleAttributeName: [NSNumber numberWithInt:NSUnderlineStyleSingle]
                                         };
            
            NSAttributedString* attrText = [[NSAttributedString alloc] initWithString:anArray[swipedIndexPath.row] attributes:attributes];
            NSAttributedString* attrText2 = [[NSAttributedString alloc] initWithString:anArray[swipedIndexPath.row] attributes:nil];
            if ([swipedCell.textLabel.attributedText isEqualToAttributedString:(attrText)]) {
                NSLog(@"Swiped crossed out word");
                swipedCell.textLabel.attributedText = attrText2;
            }
            else{
                NSLog(@"Siped regular word");
                swipedCell.textLabel.attributedText = attrText;
            }
        }
    }
    
}


- (IBAction)textReturn:(id)sender {
    
    NSLog(@"textReturn!");
    //Add add to core data and list
    
    //NSString *item = self.textField.text;
    [anArray addObject: self.textField.text];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:([anArray count] - 1) inSection:0];
    //NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    
    //UITableView *tv = (UITableView *)self.tableView;
    [self.tableView beginUpdates];
    [self.tableView insertRowsAtIndexPaths:@[indexPath]withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.tableView endUpdates];
    
    self.textField.text = nil;
    //Get rid of keyboard
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
