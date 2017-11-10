//
//  BWTeacher.h
//  BanWeb
//
//  Created by Will Cobb on 3/5/16.
//  Copyright © 2016 Will Cobb. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class BWYear;
@interface BWTeacher : NSObject

@property NSString              *name;
@property NSMutableDictionary   *years;
@property (nonatomic) UIImage   *image;

@property NSArray        *yearNames;

- (id)initWithName:(NSString *)name;
- (void)addYear:(BWYear *)year;
- (void)finalizeYears;

+ (NSString *)teacherNameFromClass:(NSDictionary *)aclass;
@end
