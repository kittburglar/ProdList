//
//  MyInputAccessoryView.m
//  fuck
//
//  Created by kittiphong xayasane on 2014-11-28.
//  Copyright (c) 2014 Kittiphong Xayasane. All rights reserved.
//

#import "MyInputAccessoryView.h"

@implementation MyInputAccessoryView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithRect:(CGRect)someRect
{
    if (self = [super initWithFrame:someRect]) {
        
        NSLog(@"SUP");
        // your init stuff here
        [self setBackgroundColor:[UIColor lightGrayColor]];
        [self setAlpha: 0.8];
        UIButton *dateButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        dateButton.frame = CGRectMake(10, CGRectGetMaxY(self.bounds)/2 - 30/2, 30, 30);
        [dateButton setBackgroundColor:[UIColor darkGrayColor]];
        [dateButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        //[dateButton setTitle:@"Button x" forState:UIControlStateNormal];
        [dateButton addTarget:self action:@selector(pickDate:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:dateButton];
    }
    return self;
}

- (void)pickDate:(UIButton*)button
{
    NSLog(@"Button  clicked.");
}

@end
