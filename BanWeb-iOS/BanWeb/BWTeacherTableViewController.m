//
//  BWTeachersCollectionViewController.m
//  BanWeb
//
//  Created by Will Cobb on 3/6/16.
//  Copyright © 2016 Will Cobb. All rights reserved.
//

#import "BWTeacherTableViewController.h"

#import "AppDelegate.h"

#import "BWYear.h"
#import "BWTeacher.h"

#import "BWProfileViewController.h"
#import "UISearchController+Utilities.h"

#import "NetworkController.h"
#import <KVOController/FBKVOController.h>

#import "BWTeacherTableViewCell.h"

//http://stackoverflow.com/questions/30191940/blur-and-vibrancy-effects-on-uitableview

@interface BWTeacherTableViewController () <UISearchControllerDelegate, UISearchBarDelegate> {
    NetworkController *networkController;
    FBKVOController *KVOController;
    BWTeacher *shownTeacher;
    UISearchController *searchDisplayController;;
}

@end

@implementation BWTeacherTableViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClass:[BWTeacherTableViewCell class] forCellReuseIdentifier:@"Teacher"];
    networkController = [NetworkController sharedInstance];
    
    KVOController = [FBKVOController controllerWithObserver:self];
    [KVOController observe:networkController keyPath:@"lastCourseUpdateTime" options:NSKeyValueObservingOptionNew block:^(id observer, id object, NSDictionary *change) {
        [self.tableView reloadData];
    }];
    
    [self.navigationController.navigationBar setBarTintColor:kNavBarColor];
    
    searchDisplayController = [UISearchController createBWSearchControllerForViewController:self];
    
    self.definesPresentationContext = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BWTeacherTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Teacher"];
    if (!cell) {
        cell = [[BWTeacherTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Teacher"];
    }
    NSString *teacherName = networkController.currentTeacherNames[indexPath.row];
    cell.teacher = networkController.teachers[teacherName]; // Should handle the array here
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return networkController.currentTeacherNames.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *teacherName = networkController.currentTeacherNames[indexPath.row];
    
    BWProfileViewController *profileController = [[BWProfileViewController alloc] init];
    profileController.teacher = networkController.teachers[teacherName];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.navigationController pushViewController:profileController animated:YES];
    });
}

@end
