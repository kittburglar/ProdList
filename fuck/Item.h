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

@property (nonatomic, strong) UIColor * color;

@property (nonatomic, strong) NSDate * date;

-(id)initWithName:(NSString *)name;

-(id)initWithNameAndColor:(NSString *)name withColor:(UIColor *)color;

-(NSString *)returnDate;

@end
