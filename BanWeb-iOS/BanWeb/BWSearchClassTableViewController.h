//
//  BWSearchClassTableViewController.h
//  BanWeb
//
//  Created by Will Cobb on 3/28/16.
//  Copyright © 2016 Will Cobb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BWCourseTableViewController.h"

@class BWYear;
@interface BWSearchClassTableViewController : BWCourseTableViewController

@property UINavigationController    *navigationController;

@property (nonatomic) NSString      *searchText;
@property BWYear                    *year;

@property BOOL  active;

@end
