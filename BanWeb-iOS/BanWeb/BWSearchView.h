//
//  BWSearchView.h
//  BanWeb
//
//  Created by Will Cobb on 3/20/16.
//  Copyright © 2016 Will Cobb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BWSearchView : UIViewController <UISearchResultsUpdating, UISearchBarDelegate, UISearchControllerDelegate>

@property UISearchController *searchController;
@property UINavigationController *navigationController;

- (void)showTeachers;
- (void)showClasses;

@end
