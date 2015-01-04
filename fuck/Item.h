//
//  Item.h
//  fuck
//
//  Created by kittiphong xayasane on 2014-11-26.
//  Copyright (c) 2014 Kittiphong Xayasane. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Item : NSObject

@property (nonatomic, strong) NSString * name;

@property (nonatomic, assign) NSInteger buttonColor;

@property (nonatomic, strong) NSDate * date;

@property (nonatomic, assign) NSInteger pid;

@property (nonatomic, assign) BOOL finishedBool;

-(id)initWithName:(NSString *)name;

-(id)initWithNameAndColor:(NSString *)name withColor:(NSInteger)buttonColor;

-(id)initWithNameAndDate:(NSString *)name withDate:(NSDate *)date;

-(id)initWithNameAndColorAndDate:(NSString *)name withColor:(NSInteger)buttonColor withDate:(NSDate *)date;

-(id)initWithNameAndColorAndDateAndPid:(NSString *)name withColor:(NSInteger)color withDate:(NSDate *)date withPid:(NSInteger)pid;

-(id)initWithNameAndColorAndDateAndPidAndBool:(NSString *)name withColor:(NSInteger)color withDate:(NSDate *)date withPid:(NSInteger)pid withBool:(BOOL)isFinished;

-(NSString *)returnDate;


@end
