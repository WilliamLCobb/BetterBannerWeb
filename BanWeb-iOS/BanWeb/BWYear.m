//
//  BWYear.m
//  BanWeb
//
//  Created by Will Cobb on 3/6/16.
//  Copyright © 2016 Will Cobb. All rights reserved.
//

#import "BWYear.h"
#import "BWSubject.h"
#import "BWTeacher.h"
@implementation BWYear

- (id)initWithName:(NSString *)name
{
    if (self = [super init]) {
        self.name = name;
        self.subjects = [NSMutableDictionary new];
        self.allCourses = [NSMutableDictionary new];
        self.allCourseNames = [NSMutableArray new];
    }
    return self;
}

- (void)updateFromJson:(NSDictionary *)json
{
    NSMutableDictionary *newSubjects = [NSMutableDictionary dictionary];
    NSMutableDictionary *newTeachers = [NSMutableDictionary dictionary];
    for (NSString *subjectName in json) {
        /* Create subject */
        BWSubject *subject = self.subjects[subjectName];
        if (!subject) {
            subject = [[BWSubject alloc] initWithName:subjectName];
        }
        [subject updateFromJson:json[subjectName]];
        newSubjects[subjectName] = subject;
        
    }
    self.subjects = newSubjects; // Removes old subjects
    
    self.subjectNames = [[self.subjects allKeys] sortedArrayUsingComparator:^NSComparisonResult(NSString *a, NSString *b) {
        return [a compare:b];
    }];
    
    [self.allCourses removeAllObjects];
    [self.allCourseNames removeAllObjects];
    for (BWSubject *subject in self.subjects.objectEnumerator) {
        [self.allCourses addEntriesFromDictionary:subject.courses];
        [self.allCourseNames addObjectsFromArray:subject.courseNames];
    }
}

#pragma mark - Compare

- (NSDate *)courseDate
{
    NSString *myDate = [self.name stringByReplacingOccurrencesOfString:@"Spring" withString:@"April"];
    myDate = [myDate stringByReplacingOccurrencesOfString:@"Fall" withString:@"October"];
    myDate = [myDate stringByReplacingOccurrencesOfString:@"Summer" withString:@"July"];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMMM yyyy"];
    return [dateFormatter dateFromString:myDate];
}

- (NSComparisonResult)compare:(BWYear *)other;
{
    return [other.courseDate compare:self.courseDate];
}

@end
