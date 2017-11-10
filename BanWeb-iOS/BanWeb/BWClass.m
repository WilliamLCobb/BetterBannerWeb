//
//  BWClass.m
//  BanWeb
//
//  Created by Will Cobb on 3/15/16.
//  Copyright © 2016 Will Cobb. All rights reserved.
//

#import "BWClass.h"

@implementation BWClass

- (id)initWithDictionary:(NSDictionary *)classData
{
    if (self = [super init]) {
        // Add all json data into class variables
        for (NSString *key in classData) {
            NSString *function = [NSString stringWithFormat:@"set%@:", [self capitalize:key]];
            SEL setSelector = NSSelectorFromString(function);
            if ([self respondsToSelector:setSelector]) {
                [self performSelector:setSelector withObject:classData[key]];
            }
        }
    }
    return self;
}

- (NSString *)capitalize:(NSString *)s
{
    NSString *first = [s substringToIndex:1];
    NSString *follow = [s substringFromIndex:1];
    return [NSString stringWithFormat:@"%@%@", [first uppercaseString], follow];
}

@end
