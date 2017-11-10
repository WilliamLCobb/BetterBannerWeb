//
//  BWYear.h
//  BanWeb
//
//  Created by Will Cobb on 3/6/16.
//  Copyright © 2016 Will Cobb. All rights reserved.
//

#import <Foundation/Foundation.h>
@class BWSubject;
@class BWTeacher;
@interface BWYear : NSObject

@property NSString              *name;

@property NSMutableDictionary   *subjects;

@property NSArray               *subjectNames;

@property NSMutableDictionary   *allCourses;
@property NSMutableArray        *allCourseNames;


- (id)initWithName:(NSString *)name;
- (void)updateFromJson:(NSDictionary *)json;
- (BOOL)compare;
- (NSDate *)courseDate;
@end
