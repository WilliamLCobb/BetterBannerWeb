//
//  DWProfileTableTableViewController.m
//  BanWeb
//
//  Created by Will Cobb on 3/14/16.
//  Copyright © 2016 Will Cobb. All rights reserved.
//

#import "BWProfileViewController.h"

#import "AppDelegate.h"
#import "NetworkController.h"
#import "BWTeacher.h"
#import "CAPSPageMenu.h"

#import "BWYear.h"

#import "BWSubjectTableViewController.h"

@interface BWProfileViewController () <CAPSPageMenuDelegate, UIScrollViewDelegate> {
    NetworkController   *networkController;
    UIScrollView        *scrollView;
    UIView              *headerView;
}

@end

@implementation BWProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    networkController = [NetworkController sharedInstance];
    
    /* Hide nav line */
    UINavigationBar *navigationBar = self.navigationController.navigationBar;
    
    [navigationBar setBackgroundImage:[UIImage new]
                       forBarPosition:UIBarPositionAny
                           barMetrics:UIBarMetricsDefault];
    
    [navigationBar setShadowImage:[UIImage new]];
    
    /*  Scroll View  */
    scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    scrollView.backgroundColor = kNavBarColor;
    scrollView.delegate = self;
    scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:scrollView];
    
    /*  Header View  */
    headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 250)];
    headerView.backgroundColor = kNavBarColor;
    
    UIImageView *teacherImage = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2 - 75, 10, 150, 150)];
    teacherImage.layer.cornerRadius = teacherImage.frame.size.width/2;
    teacherImage.clipsToBounds = YES;
    teacherImage.backgroundColor = [UIColor colorWithWhite:190 alpha:1];
    teacherImage.image = self.teacher.image;
    [headerView addSubview:teacherImage];
    
    [scrollView addSubview:headerView];
    
    /*  Load Classes View  */
    NSMutableArray *controllerArray = [NSMutableArray array];
    for (NSString *yearName in [self.teacher.yearNames reverseObjectEnumerator]) {
        NSLog(@"YN %@", yearName);
        BWYear *year = self.teacher.years[yearName];
        BWSubjectTableViewController *controller = [[BWSubjectTableViewController alloc] initWithStyle:UITableViewStylePlain];
        controller.year = year;
        controller.teacher = self.teacher;
        controller.title = yearName;
        controller.navigationController = self.navigationController;
        controller.tableView.scrollEnabled = NO;
        [controllerArray addObject:controller];
    }
    
    NSDictionary *parameters = @{CAPSPageMenuOptionMenuItemSeparatorPercentageHeight: @(0.1),
                                 CAPSPageMenuOptionMenuHeight: @(40.0),
                                 CAPSPageMenuOptionScrollMenuBackgroundColor: kGray
                                 };
    
    // Initialize page menu with controller array, frame, and optional parameters
    self.pageMenu = [[CAPSPageMenu alloc] initWithViewControllers:controllerArray frame:CGRectMake(0.0, headerView.frame.size.height, self.view.frame.size.width, self.view.frame.size.height) options:parameters];
    [self.pageMenu moveToPage:controllerArray.count-1 animate:NO];
    self.pageMenu.delegate = self;
    [self addChildViewController:self.pageMenu];
    [scrollView addSubview:self.pageMenu.view];
    [self.pageMenu didMoveToParentViewController:self];
    self.pageMenu.menuScrollView.layer.zPosition = 10;
    scrollView.contentSize = CGSizeMake(self.view.frame.size.width, headerView.frame.size.height + self.pageMenu.view.frame.size.height);
}

- (void)viewWillAppear:(BOOL)animated
{
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    self.navigationItem.title = self.teacher.name;
    
    [self.navigationController.navigationBar setBarTintColor:kNavBarColor];
}

- (void)willMoveToPage:(BWSubjectTableViewController *)controller index:(NSInteger)index
{
    NSLog(@"Moving to page: %ld", index);
}

#pragma mark - Scroll View Delegate

- (void)scrollViewDidScroll:(UIScrollView *)ascrollView
{
    CGFloat menuY = headerView.frame.size.height - scrollView.contentOffset.y;
    if (menuY < 0) {
        CGRect menuFrame = self.pageMenu.menuScrollView.frame;
        menuFrame.origin.y = -menuY;
        self.pageMenu.menuScrollView.frame = menuFrame;
    } else if (self.pageMenu.menuScrollView.frame.origin.y > 0) {
        CGRect menuFrame = self.pageMenu.menuScrollView.frame;
        menuFrame.origin.y = 0;
        self.pageMenu.menuScrollView.frame = menuFrame;
    }
}


@end
