//
//  BWClassesTableViewController.m
//  
//
//  Created by Will Cobb on 3/5/16.
//
//

#import "BWCourseTableViewController.h"
#import "BWSubject.h"

#import "NetworkController.h"
#import <KVOController/FBKVOController.h>

#import "BWCourseTableViewCell.h"
#import "BWCourse.h"
#import "BWTeacher.h"


@interface BWCourseTableViewController () {
    NSInteger       presentingRow;
    NSInteger       presentingNumberOfItems;
    NSInteger       presentingCellNumber;
}

@end

@implementation BWCourseTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClass:[BWCourseTableViewCell class] forCellReuseIdentifier:@"Course"];
    self.tableView.tableFooterView = [UIView new];
    presentingRow = -1;
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationItem.title = self.subject.name;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSArray *)coursesForIndexPath:(NSIndexPath *)indexPath
{
    NSString *courseName = self.subject.courseNames[indexPath.row];
    return self.subject.courses[courseName];
}

#pragma mark - Table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BWCourseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Course"];
    if (!cell) {
        cell = [[BWCourseTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Course"];
    }
    cell.frame = CGRectMake(0, 0, self.view.frame.size.width, kCellHeight);
    cell.courses = [self coursesForIndexPath:indexPath];
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.subject.courseNames.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *courseName = self.subject.courseNames[indexPath.row];
    if (self.teacher) {
        BOOL teacherFound = NO;
        for (BWCourse *course in self.subject.courses[courseName]) {
            teacherFound |= [self.teacher.name isEqualToString:course.teacherName];
        }
        if (!teacherFound) {
            return 0;
        }
    }
    if (indexPath.row == presentingRow) {
        if (presentingCellNumber < presentingNumberOfItems && presentingRow != -1) {
            presentingCellNumber++;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [tableView beginUpdates];
                [tableView endUpdates];
                BWCourseTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
                CGFloat bottomY = cell.frame.origin.y - tableView.contentOffset.y - tableView.frame.size.height + cell.frame.size.height;
                if (bottomY > -15) {
                    [tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
                }
            });
        }
        return kCellHeight * presentingCellNumber + 60;
    }
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    BWCourseTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (indexPath.row != presentingRow) { //Show new row
        BWCourseTableViewCell *oldCell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:presentingRow inSection:0]];
        oldCell.presenting = NO;
        
        presentingRow = indexPath.row;
        presentingNumberOfItems = [[self coursesForIndexPath:indexPath] count];
        presentingCellNumber = 0;
        [tableView beginUpdates];
        [tableView endUpdates];
        cell.presenting = YES;
        
        
    } else { //Touched same row again
        presentingRow = -1;
        [tableView beginUpdates];
        [tableView endUpdates];
        cell.presenting = NO;
    }
}


@end
