//
//  BWSearchClassesViewController.m
//  BanWeb
//
//  Created by Will Cobb on 3/29/16.
//  Copyright © 2016 Will Cobb. All rights reserved.
//

#import "BWSearchClassesViewController.h"

#import "BWSearchClassTableViewController.h"
#import "CAPSPageMenu.h"
#import "NetworkController.h"
#import "AppDelegate.h"

@interface BWSearchClassesViewController () <CAPSPageMenuDelegate> {
    BWSearchClassTableViewController *lastController;
}

@end

@implementation BWSearchClassesViewController

- (void)viewDidLoad
{
    self.hideSearchBar = YES;
    [super viewDidLoad];
}

- (void)loadPageMenu
{
    dispatch_async(dispatch_get_main_queue(), ^{
        controllerArray = [NSMutableArray array];
        
        for (NSString *year in [networkController.yearNames reverseObjectEnumerator]) {
            BWSearchClassTableViewController *controller = [[BWSearchClassTableViewController alloc] initWithStyle:UITableViewStylePlain];
            controller.title = year;
            controller.year = networkController.years[year];
            controller.navigationController = self.navigationController;
            [controllerArray addObject:controller];
        }
        
        NSDictionary *parameters = @{CAPSPageMenuOptionMenuItemSeparatorPercentageHeight: @(0.1),
                                     CAPSPageMenuOptionMenuHeight: @(40.0),
                                     CAPSPageMenuOptionScrollMenuBackgroundColor: kGray
                                     };
        [[controllerArray lastObject] setActive:YES];
        // Initialize page menu with controller array, frame, and optional parameters
        self.pageMenu = [[CAPSPageMenu alloc] initWithViewControllers:controllerArray frame:CGRectMake(0.0, 0.0, self.view.frame.size.width, self.view.frame.size.height) options:parameters];
        [self.pageMenu moveToPage:controllerArray.count-1 animate:NO];
        //[self.view addSubview:self.pageMenu.view];
        self.pageMenu.delegate = self;
        [self addChildViewController:self.pageMenu];
        self.pageMenu.view.frame = self.view.bounds;
        [self.view addSubview:self.pageMenu.view];
        [self.pageMenu didMoveToParentViewController:self];
    });
}

- (void)willMoveToPage:(BWSearchClassTableViewController *)controller index:(NSInteger)index
{
    NSLog(@"Moving to page: %ld", index);
    lastController.active = NO;
    controller.active = YES;
}

- (void)setSearchText:(NSString *)searchText
{
    for (BWSearchClassTableViewController *table in controllerArray) {
        table.searchText = searchText;
    }
}

@end
