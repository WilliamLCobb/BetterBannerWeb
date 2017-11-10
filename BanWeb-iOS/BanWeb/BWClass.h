//
//  BWClass.h
//  BanWeb
//
//  Created by Will Cobb on 3/15/16.
//  Copyright © 2016 Will Cobb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BWClass : NSObject

@property NSString  *days;
@property NSString  *location;
@property NSString  *professor;
@property NSString  *professorProbability;
@property NSString  *startTime;
@property NSString  *endTime;
@property NSString  *startDate;
@property NSString  *endDate;
@property NSString  *type;

- (id)initWithDictionary:(NSDictionary *)classData;

@end
