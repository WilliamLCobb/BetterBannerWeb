//
//  BWSearchView.m
//  BanWeb
//
//  Created by Will Cobb on 3/20/16.
//  Copyright © 2016 Will Cobb. All rights reserved.
//

#import "BWSearchView.h"

#import "NetworkController.h"

#import "BWSearchClassesViewController.h"
#import "AppDelegate.h"

#import "CAPSPageMenu.h"
#import <KVOController/FBKVOController.h>

@interface BWSearchView () <CAPSPageMenuDelegate> {
    NetworkController   *networkController;
    NSArray             *searchResults;
    NSMutableDictionary *searchItems;
    NSString            *searchText;
    CAPSPageMenu        *pageMenu;
    
    BWSearchClassesViewController *classController;
    BWSearchClassesViewController *classControllerTest;
}
@end


@implementation BWSearchView

- (void)viewDidLoad
{
    [self loadPageMenu];
}

- (void)showClasses
{
    [pageMenu moveToPage:0 animate:NO];
}

- (void)showTeachers
{
    [pageMenu moveToPage:1 animate:NO];
}

- (void)loadPageMenu
{
    
    /*  Classes */
    classController = [[BWSearchClassesViewController alloc] init];
    //controller.year = networkController.years[year];
    classController.title = @"Classes";
    classController.navigationController = self.navigationController;
    
    /*  Teacher  */
    classControllerTest = [[BWSearchClassesViewController alloc] init];
    //controller.year = networkController.years[year];
    classControllerTest.title = @"Teachers";
    classControllerTest.navigationController = self.navigationController;
    
    
    NSDictionary *parameters = @{CAPSPageMenuOptionMenuItemSeparatorPercentageHeight: @(0.1),
                                 CAPSPageMenuOptionMenuHeight: @(40.0),
                                 CAPSPageMenuOptionScrollMenuBackgroundColor: kNavBarColor,
                                 CAPSPageMenuOptionUseMenuLikeSegmentedControl: @(YES),
                                 CAPSPageMenuOptionAddBottomMenuHairline: @(NO),
                                 CAPSPageMenuOptionUnselectedMenuItemLabelColor: [UIColor colorWithWhite:0.9 alpha:1],
                                 CAPSPageMenuOptionMenuItemSeparatorColor: kNavBarDisabledColor,
                                 };
    
    // Initialize page menu with controller array, frame, and optional parameters
    pageMenu = [[CAPSPageMenu alloc] initWithViewControllers:@[classController, classControllerTest] frame:CGRectMake(0.0, 0.0, self.view.frame.size.width, self.view.frame.size.height) options:parameters];
    pageMenu.menuScrollView.scrollEnabled = NO;
    pageMenu.controllerScrollView.scrollEnabled = NO;
    //[pageMenu moveToPage:controllerArray.count-1 animate:NO];
    pageMenu.delegate = self;
    [self addChildViewController:pageMenu];
    pageMenu.view.frame = self.view.bounds;
    [self.view addSubview:pageMenu.view];
    [pageMenu didMoveToParentViewController:self];
}

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.searchController.searchResultsController.view.hidden = NO;
    });
}


#pragma mark - UISearchControllerDelegate

- (void)willPresentSearchController:(UISearchController *)searchController
{
    dispatch_async(dispatch_get_main_queue(), ^{
        searchController.searchResultsController.view.hidden = NO;
        /* Hide nav line */
        UINavigationBar *navigationBar = self.navigationController.navigationBar;
        
        [navigationBar setBackgroundImage:[UIImage new]
                           forBarPosition:UIBarPositionAny
                               barMetrics:UIBarMetricsDefault];
        
        [navigationBar setShadowImage:[UIImage new]];
    });
}

- (void)willDismissSearchController:(UISearchController *)searchController
{
    dispatch_async(dispatch_get_main_queue(), ^{
        searchController.searchResultsController.view.hidden = NO;
        /* Show nav line */
        
    });
}


#pragma mark - UISearchResultsUpdating



#pragma mark - UISearchBarDelegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchString
{
    searchText = searchString;
    [classController setSearchText:searchString];
}

@end





