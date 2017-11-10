//
//  NetworkController.h
//  BanWeb
//
//  Created by Will Cobb on 3/5/16.
//  Copyright © 2016 Will Cobb. All rights reserved.
//

#import <Foundation/Foundation.h>
@class BWCourse;
@class BWSubject;
@class BWTeacher;
@interface NetworkController : NSObject

@property CFTimeInterval                lastCourseUpdateTime;
@property NSMutableDictionary           *years;
@property NSMutableDictionary           *teachers;
@property NSMutableDictionary           *courses;

@property NSArray                       *yearNames; // Used as an ordered lookup
@property NSArray                       *teacherNames;
@property NSMutableArray                *currentTeacherNames;

@property NSMutableArray                *allCourseNames;
@property NSMutableArray                *allCourseCRNs;

+ (id)sharedInstance;
- (void)updateCourses;
@end
