//
//  UIImage+Utilities.m
//  ShoutOut
//
//  Created by Will Cobb on 7/15/15.
//  Copyright (c) 2015 Will Cobb. All rights reserved.
//

#import "UISearchController+Utilities.h"

#import "BWSearchView.h"
#import "AppDelegate.h"

@implementation UISearchController (Utilities)

+ (UISearchController *)createBWSearchControllerForViewController:(UIViewController *)viewController 
{
    /*  Create Search Bar and Controller */
    BWSearchView        *searchView = [[BWSearchView alloc] init];
    UISearchController  *searchDisplayController = [[UISearchController alloc] initWithSearchResultsController:searchView];
    searchView.searchController = searchDisplayController;
    searchView.navigationController = viewController.navigationController;
    
    searchDisplayController.delegate = searchView;
    searchDisplayController.hidesNavigationBarDuringPresentation = NO;
    searchDisplayController.active = YES;
    searchDisplayController.searchResultsUpdater = searchView;
    
    /*  Configure Search Bar  */
    searchDisplayController.searchBar.delegate = searchView;
    searchDisplayController.searchBar.searchBarStyle = UISearchBarStyleMinimal;
    searchDisplayController.searchBar.placeholder = NSLocalizedString(@"Search", nil);
    searchDisplayController.searchBar.tintColor = [UIColor whiteColor];
    
    /*  Set Colors  */
    [searchDisplayController.searchBar setImage:[[UIImage imageNamed:@"search"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
    for (UIView *v in searchDisplayController.searchBar.subviews)
    {
        for(id subview in v.subviews)
        {
            if ([subview isKindOfClass:[UITextField class]])
            {
                UITextField *searchField = subview;
                searchField.textColor = [UIColor whiteColor];
                searchField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Search" attributes:@{NSForegroundColorAttributeName: kNavBarDisabledColor}];
                
                UIImageView *imageView = (UIImageView *)searchField.leftView;
                imageView.tintColor = kNavBarDisabledColor;
                imageView.frame = CGRectMake(10, 10, 18, 18);
                
                searchField.textAlignment = NSTextAlignmentLeft;
            }
        }
    }
    
    /*  Configure Receiving view */
    viewController.navigationItem.titleView = searchDisplayController.searchBar;
    viewController.definesPresentationContext = YES;
    
    
    
    return searchDisplayController;
}

@end
