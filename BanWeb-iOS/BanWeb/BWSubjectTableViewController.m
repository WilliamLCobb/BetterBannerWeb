//
//  BWCourseTableViewController.m
//  BanWeb
//
//  Created by Will Cobb on 3/5/16.
//  Copyright © 2016 Will Cobb. All rights reserved.
//

#import "BWSubjectTableViewController.h"

#import "NetworkController.h"
#import <KVOController/FBKVOController.h>

#import "BWYear.h"

#import "BWSubjectTableViewCell.h"
#import "BWSubject.h"

#import "BWCourseTableViewController.h"

@interface BWSubjectTableViewController () {
    NetworkController *networkController;
    FBKVOController *KVOController;
}

@end

@implementation BWSubjectTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClass:[BWSubjectTableViewCell class] forCellReuseIdentifier:@"Subject"];
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    
}

- (void)setYear:(BWYear *)year
{
    _year = year;
    [self.tableView reloadData];
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BWSubjectTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Subject"];
    if (!cell) {
        cell = [[BWSubjectTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Subject"];
    }
    NSString *subjectName = self.year.subjectNames[indexPath.row];
    cell.subject = self.year.subjects[subjectName];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    BWSubjectTableViewCell *subjectCell = [self.tableView cellForRowAtIndexPath:indexPath];
    BWSubject *subject = subjectCell.subject;
    
    BWCourseTableViewController *courseTable = [[BWCourseTableViewController alloc] initWithStyle:UITableViewStylePlain];
    courseTable.subject = subject;
    if (self.teacher) {
        courseTable.teacher = self.teacher;
    }
    [self.navigationController pushViewController:courseTable animated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Filter by teacher
    if (self.teacher) {
        NSString *subjectName = self.year.subjectNames[indexPath.row];
        BWSubject *subject = self.year.subjects[subjectName];
        if ([subject coursesForTeacher:self.teacher].count == 0) {
            return 0;
        }
    }
    return 44;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.year.subjectNames.count;
}

@end
