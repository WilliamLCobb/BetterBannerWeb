//
//  BWClassesTableViewController.h
//  
//
//  Created by Will Cobb on 3/5/16.
//
//

#define kCellHeight 70

#import <UIKit/UIKit.h>
@class BWSubject;
@class BWTeacher;
@interface BWCourseTableViewController : UITableViewController

@property BWSubject                 *subject;
@property BWTeacher                 *teacher;


- (NSArray *)coursesForIndexPath:(NSIndexPath *)indexPath;

@end
