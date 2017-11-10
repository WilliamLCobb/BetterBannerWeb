//
//  BWCourse.h
//  BanWeb
//
//  Created by Will Cobb on 3/5/16.
//  Copyright © 2016 Will Cobb. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BWTeacher;
@class BWSubject;
@interface BWCourse : NSObject

@property NSString  *name;
@property NSString  *teacherName;
@property NSInteger  crn;
@property NSInteger courseNumber;
@property NSString  *courseSubNumber;
@property NSString  *attributes;
@property NSString  *credits;
@property NSString  *startDate;
@property NSString  *endDate;
@property NSString  *level;
@property BWSubject *subject;

@property NSMutableArray   *classes;


- (id)initWithDictionary:(NSDictionary *)courseData;
- (void)updateWithDictionary:(NSDictionary *)courseData;
@end
