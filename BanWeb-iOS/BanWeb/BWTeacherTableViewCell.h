//
//  BWTeacherTableViewCell.h
//  BanWeb
//
//  Created by Will Cobb on 3/6/16.
//  Copyright © 2016 Will Cobb. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BWTeacher;
@interface BWTeacherTableViewCell : UITableViewCell

@property (nonatomic, weak) BWTeacher   *teacher;
@property (nonatomic) BOOL              presenting;

@end
