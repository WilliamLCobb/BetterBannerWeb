//
//  BWCourse.m
//  BanWeb
//
//  Created by Will Cobb on 3/5/16.
//  Copyright © 2016 Will Cobb. All rights reserved.
//

#import "BWCourse.h"
#import "BWTeacher.h"
#import "BWClass.h"
#import "NetworkController.h"
@interface BWCourse () {
    NetworkController *networkController;
}

@end

@implementation BWCourse

- (id)initWithDictionary:(NSDictionary *)courseData
{
    if (self = [super init]) {
        self.name = courseData[@"name"];
        if (!self.name) {
            //NSLog(@"Error, course has no name");
            //NSLog(@"%@", courseData);
            return nil;
        }
        //NSLog(@"%@", courseData);
        self.teacherName = [self teacherNameFromData:courseData];
        self.crn = [courseData[@"crn"] integerValue];
        self.courseNumber = [courseData[@"courseNumber"] integerValue];
        networkController = [NetworkController sharedInstance];
        
        // Load other info
        NSArray *attributes = @[@"courseSubNumber", @"attributes", @"credits", @"startDate", @"endDate", @"level"];
        for (NSString *key in courseData) {
            if (![attributes containsObject:key])
                continue;
            // this is actually pretty unsafe because a bad json file could set any variable it wants.
            // hopefully no one will notice...
            NSString *function = [NSString stringWithFormat:@"set%@:", [self capitalize:key]];
            SEL setSelector = NSSelectorFromString(function);
            if ([self respondsToSelector:setSelector]) {
                [self performSelector:setSelector withObject:courseData[key]];
            }
        }
        
        //Load Classes
        self.classes = [NSMutableArray new];
        NSMutableArray *classes = [courseData[@"classes"] mutableCopy];
        [classes addObjectsFromArray:courseData[@"labs"]];
        for (NSDictionary *classData in classes) {
            [self.classes addObject:[[BWClass alloc] initWithDictionary:classData]];
        }
    }
    return self;
}

- (NSString *)teacherNameFromData:(NSDictionary *)courseData
{
    for (NSDictionary *class in courseData[@"classes"]) {
        NSString *teacherName = [BWTeacher teacherNameFromClass:class];
        if (teacherName)
            return teacherName;
    }
    for (NSDictionary *class in courseData[@"labs"]) {
        NSString *teacherName = [BWTeacher teacherNameFromClass:class];
        if (teacherName)
            return teacherName;
    }
    //NSLog(@"Error, no teachers found for course: %@", self.name);
    return nil;
}

- (NSString *)capitalize:(NSString *)s
{
    NSString *first = [s substringToIndex:1];
    NSString *follow = [s substringFromIndex:1];
    return [NSString stringWithFormat:@"%@%@", [first uppercaseString], follow];
}

@end
