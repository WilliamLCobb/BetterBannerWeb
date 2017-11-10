//
//  DWProfileTableTableViewController.h
//  BanWeb
//
//  Created by Will Cobb on 3/14/16.
//  Copyright © 2016 Will Cobb. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BWTeacher;
@class CAPSPageMenu;
@interface BWProfileViewController : UIViewController

@property BWTeacher *teacher;
@property (nonatomic) CAPSPageMenu *pageMenu;

@end
