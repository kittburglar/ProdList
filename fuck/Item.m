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
    self.finishedBool = NO;
    return self;
}

-(id)initWithNameAndColorAndDateAndPidAndBool:(NSString *)name withColor:(NSInteger)color withDate:(NSDate *)date withPid:(NSInteger)pid withBool:(BOOL)isFinished{
    self = [super init];
    self.name = name;
    self.buttonColor = color;
    self.date = date;
    self.pid = pid;
    self.finishedBool = isFinished;
    return self;
}

-(id)initWithNameAndColorAndDateAndPidAndBoolAndInterval:(NSString *)name withColor:(NSInteger)color withDate:(NSDate *)date withPid:(NSInteger)pid withBool:(BOOL)isFinished withInterval:(NSInteger)interval{
    self = [super init];
    self.name = name;
    self.buttonColor = color;
    self.date = date;
    self.pid = pid;
    self.finishedBool = isFinished;
    self.remindInterval = interval;
    return self;
}

-(id)initWithNameAndColorAndDateAndPidAndBoolAndIntervalAndReminder:(NSString *)name withColor:(NSInteger)color withDate:(NSDate *)date withPid:(NSInteger)pid withBool:(BOOL)isFinished withInterval:(NSInteger)interval withReminder:(BOOL)reminder{
    self = [super init];
    self.name = name;
    self.buttonColor = color;
    self.date = date;
    self.pid = pid;
    self.finishedBool = isFinished;
    self.remindInterval = interval;
    self.reminder = reminder;
    return self;
}

-(NSString *)returnDate{
    //Set up first date string (hours,minutes)
    NSString *formatString = [NSDateFormatter dateFormatFromTemplate:@"hh-mm" options:0 locale:[NSLocale currentLocale]];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:formatString];
    NSString *todayString;
    todayString = [dateFormatter stringFromDate:self.date];
    
    //Set up second date string (day,week,month)
    NSString *formatString2 = [NSDateFormatter dateFormatFromTemplate:@"EdMMM" options:0 locale:[NSLocale currentLocale]];
    NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc] init];
    [dateFormatter2 setDateFormat:formatString2];
    NSString *todayString2;
    
    //Check if date is today
    BOOL today = [[NSCalendar currentCalendar] isDateInToday:self.date];
    
    if(today){
        todayString2 = @"Today";
    }
    else{
        todayString2 = [dateFormatter2 stringFromDate:self.date];
    }
    
    //Check if date is less
    NSDate *todayDate = [NSDate date];
    NSComparisonResult result;
    result = [todayDate compare:self.date]; // comparing two dates
    
    NSString *finalString;
    if(result == NSOrderedDescending){
        finalString = @"Today";
    }
    else{
        finalString = [NSString stringWithFormat:@"%@ at %@", todayString2, todayString];
    }
    
    return finalString;
}



@end
