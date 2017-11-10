//
//  BWSubject.h
//  BanWeb
//
//  Created by Will Cobb on 3/5/16.
//  Copyright © 2016 Will Cobb. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BWTeacher;
@class BWCourse;
@interface BWSubject : NSObject

@property NSString *shortName;
@property NSString *name;

@property NSMutableDictionary   *courses;

@property NSArray               *courseNames;
@property NSMutableArray        *crns;

- (id)initWithName:(NSString *)subject;
- (void)updateFromJson:(NSDictionary *)json;
- (NSArray *)coursesForTeacher:(BWTeacher *)teacher;
@end
