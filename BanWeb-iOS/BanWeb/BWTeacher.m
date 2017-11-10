//
//  BWTeacher.m
//  BanWeb
//
//  Created by Will Cobb on 3/5/16.
//  Copyright © 2016 Will Cobb. All rights reserved.
//

#import "BWTeacher.h"
#import "BWYear.h"

@interface BWTeacher () {
    NSMutableDictionary *addedYears;
}

@end

@implementation BWTeacher

- (id)initWithName:(NSString *)name
{
    if (self = [super init]) {
        self.name = name;
        self.years = [NSMutableDictionary new];
    }
    return self;
}

- (void)addYear:(BWYear *)year
{
    if (!addedYears) {
        addedYears = [NSMutableDictionary new];
    }
    addedYears[year.name] = year;
}

- (void)finalizeYears
{
    self.years = addedYears;
    addedYears = nil;
    
    self.yearNames = [[self.years allKeys] sortedArrayUsingComparator:^NSComparisonResult(NSString *a, NSString *b) {
        return [self.years[a] compare:self.years[b]];
    }];
}

- (UIImage *)image
{
    if (!_image) {
        NSArray *nameComponents = [self.name componentsSeparatedByString:@" "];
        NSString *lastName = [nameComponents[nameComponents.count-1] lowercaseString];
        NSString *firstLetter = [[self.name substringToIndex:1] lowercaseString];
        NSString *imageName = [NSString stringWithFormat:@"%@%@.jpeg", lastName, firstLetter];
        _image = [UIImage imageNamed:imageName];
        if (!_image) {
            // maybe a default image
        }
    }
    return _image;
}

+ (NSString *)teacherNameFromClass:(NSDictionary *)aclass
{
    NSString *teacherName = aclass[@"professor"];
    if (!teacherName) {
        teacherName = @"error";
    }
    if ([teacherName isEqualToString:@"TBA"])
        return nil;
    return teacherName;
}

@end
