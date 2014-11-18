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
    
    anArray = [[NSMutableArray alloc] init];
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
    return cell;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    [self.tableView insertRowsAtIndexPaths:@[indexPath]withRowAnimation:UITableViewRowAnimationBottom];
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

@end
