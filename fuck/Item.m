//
//  Item.m
//  fuck
//
//  Created by kittiphong xayasane on 2014-11-26.
//  Copyright (c) 2014 Kittiphong Xayasane. All rights reserved.
//

#import "Item.h"

@implementation Item

-(id)initWithName:(NSString *)name {
    self = [super init];
    self.name = name;
    self.buttonColor = 7;
    self.date = [[NSDate alloc] init];
    
    return self;
}

-(id)initWithNameAndColor:(NSString *)name withColor:(NSInteger)color{
    self = [super init];
    self.name = name;
    self.buttonColor = 7;
    self.date = [[NSDate alloc] init];
    
    return self;
}

-(id)initWithNameAndDate:(NSString *)name withDate:(NSDate *)date{
    self = [super init];
    self.name = name;
    self.buttonColor = 7;
    self.date = date;
    
    return self;
}


-(id)initWithNameAndColorAndDate:(NSString *)name withColor:(NSInteger)color withDate:(NSDate *)date{
    self = [super init];
    self.name = name;
    self.buttonColor = color;
    self.date = date;
    return self;
}

-(id)initWithNameAndColorAndDateAndPid:(NSString *)name withColor:(NSInteger)color withDate:(NSDate *)date withPid:(NSInteger)pid{
    self = [super init];
    self.name = name;
    self.buttonColor = color;
    self.date = date;
    self.pid = pid;
    return self;
}


-(NSString *)returnDate{
    //Days
    NSString *formatString = [NSDateFormatter dateFormatFromTemplate:@"EdMMMhh-mm" options:0 locale:[NSLocale currentLocale]];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:formatString];
    NSString *todayString = [dateFormatter stringFromDate:self.date];
    
    return todayString;
}



@end
