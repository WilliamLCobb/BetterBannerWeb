//
//  NetworkController.m
//  BanWeb
//
//  Created by Will Cobb on 3/5/16.
//  Copyright © 2016 Will Cobb. All rights reserved.
//

#import "NetworkController.h"

#import "BWYear.h"
#import "BWSubject.h"
#import "BWCourse.h"
#import "BWTeacher.h"

#import "AFNetworking.h"

#define kBaseURL @"10.0.1.16"

@interface NetworkController () {
    NSTimer     *updateTimer;
    BOOL        classesLoaded;
}

@end

@implementation NetworkController

+ (id)sharedInstance {
    static NetworkController * sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            /* Load Courses */
            NSString *filePath = [[NSBundle mainBundle] pathForResource:@"courseInfo" ofType:@"json"];
            NSData *data = [NSData dataWithContentsOfFile:filePath];
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            [sharedMyManager loadCoursesFromJson:json];
        });
    });
    return sharedMyManager;
}

- (id)init
{
    if (self = [super init]) {
        /* Initialize variables */
        self.years = [NSMutableDictionary dictionary];
        self.yearNames = [NSMutableArray new];
        self.teachers = [NSMutableDictionary dictionary];
        self.teacherNames = [NSMutableArray new];
        
        
        /* Monitor Network Changes */
        [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            NSLog(@"Reachability: %@", AFStringFromNetworkReachabilityStatus(status));
        }];
        [[AFNetworkReachabilityManager sharedManager] startMonitoring];
        
        //load initial courses in background
        
    }
    return self;
}

- (void)loadCoursesFromJson:(NSDictionary *)json
{
    CFTimeInterval now = CACurrentMediaTime();
    NSMutableDictionary *newYears = [NSMutableDictionary new];
    NSMutableDictionary *yearNameFromId = [NSMutableDictionary new];
    NSMutableDictionary *newTeachers = [NSMutableDictionary dictionary];
    for (NSString *yearName in json) {
        NSLog(@"%@", yearName);
        NSDictionary *yearInfo = json[yearName];
        BWYear *year = self.years[yearName];
        if (!year) {
            year = [[BWYear alloc] initWithName:yearName];
        }
        [year updateFromJson:yearInfo[@"subjects"]];
        newYears[yearName] = year;
        yearNameFromId[yearName] = yearName;
        
        // Teachers
        NSDictionary *subjects = yearInfo[@"subjects"];
        for (NSString *subjectName in subjects) {
            //NSLog(@"YI %@", yearInfo);
            /* Create Teachers */
            for (NSDictionary *courseInfo in subjects[subjectName]) {
                for (NSDictionary *class in courseInfo[@"classes"]) {
                    BWTeacher *teacher = [self teacherFromClass:class inDict:newTeachers];
                    if (!teacher)
                        return;
                    newTeachers[teacher.name] = teacher;
                    if (teacher)
                        newTeachers[teacher.name] = teacher;
                    [teacher addYear:year];
                }
                for (NSDictionary *class in courseInfo[@"labs"]) {
                    BWTeacher *teacher = [self teacherFromClass:class inDict:newTeachers];
                    if (!teacher)
                        return;
                    newTeachers[teacher.name] = teacher;
                    if (teacher) {
                        newTeachers[teacher.name] = teacher;
                        [teacher addYear:year];
                    }
                }
            }
        }
    }
    self.years = newYears;
    self.yearNames = [[self.years allKeys] sortedArrayUsingComparator:^NSComparisonResult(NSString *a, NSString *b) {
        return [self.years[a] compare:self.years[b]];
    }];
    
    self.teachers = newTeachers;
    self.teacherNames = [[self.teachers allKeys] sortedArrayUsingComparator:^NSComparisonResult(NSString *a, NSString *b) {
        return [a compare:b];
    }];
    
    for (NSString *teacherName in self.teachers) {
        BWTeacher *teacher = self.teachers[teacherName];
        [teacher finalizeYears];
    }
    
    self.currentTeacherNames = [NSMutableArray new];
    for (NSString *name in self.teacherNames) {
        BWTeacher *t = self.teachers[name];
        if ([t.yearNames containsObject:self.yearNames[0]]) {
            [self.currentTeacherNames addObject:name];
        }
    }
    
    //Update
    self.lastCourseUpdateTime = CACurrentMediaTime();
    NSLog(@"UD: %f", CACurrentMediaTime() - now);
}

- (void)updateCourses
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.lastCourseUpdateTime = CACurrentMediaTime(); //Testing
    });
    /*AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:@"http://example.com/resources.json" parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    [manager POST]*/
}

- (BWTeacher *)teacherFromClass:(NSDictionary *)class inDict:(NSDictionary *)teacherDict
{
    NSString *teacherName = [BWTeacher teacherNameFromClass:class];
    if (!teacherName) {
        return nil;
    }
    BWTeacher *teacher = teacherDict[teacherName];
    if (!teacher) {
        teacher = [[BWTeacher alloc] initWithName:teacherName];
    }
    return teacher;
}



@end
