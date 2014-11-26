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
    self.color = nil;
    
    return self;
}

-(id)initWithNameAndColor:(NSString *)name withColor:(UIColor *)color{
    self = [super init];
    self.name = name;
    self.color = color;
    
    return self;
}

@end
