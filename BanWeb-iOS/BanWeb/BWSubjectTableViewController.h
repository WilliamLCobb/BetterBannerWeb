//
//  BWCourseTableViewController.h
//  BanWeb
//
//  Created by Will Cobb on 3/5/16.
//  Copyright © 2016 Will Cobb. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BWYear;
@class BWTeacher;
@interface BWSubjectTableViewController : UITableViewController

@property (nonatomic) BWYear    *year;
@property BWTeacher             *teacher;
@property UINavigationController *navigationController;
@end