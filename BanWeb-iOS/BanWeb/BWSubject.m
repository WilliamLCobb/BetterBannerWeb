//
//  BWSubject.m
//  BanWeb
//
//  Created by Will Cobb on 3/5/16.
//  Copyright © 2016 Will Cobb. All rights reserved.
//

#import "BWSubject.h"
#import "BWCourse.h"
#import "BWTeacher.h"

@implementation BWSubject

- (id)initWithName:(NSString *)subject
{
    if (self = [super init]) {
        self.name = subject;
        self.shortName = subject;
        self.courses = [NSMutableDictionary dictionary];
        self.crns = [NSMutableArray new];
    }
    return self;
}

- (void)updateFromJson:(NSDictionary *)json
{
    NSMutableDictionary *newCourses = [NSMutableDictionary dictionary];
    NSMutableArray *courseNames = [NSMutableArray new];
    [self.crns removeAllObjects];
    for (NSDictionary *courseInfo in json) {
        NSString *crn = courseInfo[@"crn"];
        NSString *name = courseInfo[@"name"];
        if (!name || !crn) {
            //NSLog(@"Error, no name or crn");
            name = @"Error";
            crn = @"0";
        }
        [self.crns addObject:crn];
        BWCourse *course = self.courses[crn];
        if (!course) {
            course = [[BWCourse alloc] initWithDictionary:courseInfo];
        }
        if (!course) {
            continue;
        }
        course.subject = self;
        
        newCourses[crn] = course;
        
        if (!newCourses[name]) {
            newCourses[name] = [NSMutableArray array];
            [courseNames addObject:name];
        }
        NSMutableArray *courseList = newCourses[name];
        [courseList insertObject:course atIndex:0];
        
    }
    self.courses = newCourses;
    
    self.courseNames = [courseNames sortedArrayUsingComparator:^NSComparisonResult(NSString *a, NSString *b) {
        return [self.courses[a][0] courseNumber] > [self.courses[b][0] courseNumber];
    }];
}

- (NSArray *)coursesForTeacher:(BWTeacher *)teacher
{
    NSMutableArray *courses = [NSMutableArray new];
    for (NSNumber *number in self.crns.objectEnumerator) {
        BWCourse *course = self.courses[number];
        if ([course.teacherName isEqualToString:teacher.name]) {
            [courses addObject:course];
        }
    }
    
    return courses;
}

@end
