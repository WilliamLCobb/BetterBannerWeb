//
//  BWClassesViewController.m
//  BanWeb
//
//  Created by Will Cobb on 3/6/16.
//  Copyright © 2016 Will Cobb. All rights reserved.
//

#import "BWClassesViewController.h"

#import "AppDelegate.h"

#import "NetworkController.h"
#import "BWSubjectTableViewController.h"
#import "CAPSPageMenu.h"
#import <KVOController/FBKVOController.h>
#import "UISearchController+Utilities.h"

@interface BWClassesViewController () <CAPSPageMenuDelegate> {
    FBKVOController *KVOController;
    UISearchController  *searchController;
}

@end

@implementation BWClassesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    networkController = [NetworkController sharedInstance];
    if (networkController.lastCourseUpdateTime > 0) {
        [self loadPageMenu];
    } else {
        NSLog(@"Class data not loaded yet, waiting");
    }
    
    KVOController = [FBKVOController controllerWithObserver:self];
    [KVOController observe:networkController keyPath:@"lastCourseUpdateTime" options:NSKeyValueObservingOptionNew block:^(id observer, id object, NSDictionary *change) {
        if (!self.pageMenu) {
            [self loadPageMenu];
        };
    }];
    if (!self.hideSearchBar) {
        searchController = [UISearchController createBWSearchControllerForViewController:self];
    }
}

- (void)loadPageMenu
{
    dispatch_async(dispatch_get_main_queue(), ^{

        controllerArray = [NSMutableArray array];
        
        for (NSString *year in [networkController.yearNames reverseObjectEnumerator]) {
            BWSubjectTableViewController *controller = [[BWSubjectTableViewController alloc] initWithStyle:UITableViewStylePlain];
            controller.year = networkController.years[year];
            controller.title = year;
            controller.navigationController = self.navigationController;
            [controllerArray addObject:controller];
        }
        
        NSDictionary *parameters = @{CAPSPageMenuOptionMenuItemSeparatorPercentageHeight: @(0.1),
                                     CAPSPageMenuOptionMenuHeight: @(40.0),
                                     CAPSPageMenuOptionScrollMenuBackgroundColor: kGray
                                     };
        
        // Initialize page menu with controller array, frame, and optional parameters
        self.pageMenu = [[CAPSPageMenu alloc] initWithViewControllers:controllerArray frame:CGRectMake(0.0, 0.0, self.view.frame.size.width, self.view.frame.size.height) options:parameters];
        [self.pageMenu moveToPage:controllerArray.count-1 animate:NO];
        //[self.view addSubview:self.pageMenu.view];
        self.pageMenu.delegate = self;
        [self addChildViewController:self.pageMenu];
        self.pageMenu.view.frame = self.view.bounds;
        [self.view addSubview:self.pageMenu.view];
        [self.pageMenu didMoveToParentViewController:self];
        
        [controllerArray makeObjectsPerformSelector:@selector(viewWillDisappear:) withObject:@(YES)];
    });
}


- (void)viewWillAppear:(BOOL)animated
{
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    self.navigationItem.title = @"Classes";
    
    [self.navigationController.navigationBar setBarTintColor:kNavBarColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
