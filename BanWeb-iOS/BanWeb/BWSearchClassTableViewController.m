//
//  BWSearchClassTableViewController.m
//  BanWeb
//
//  Created by Will Cobb on 3/28/16.
//  Copyright © 2016 Will Cobb. All rights reserved.
//

#import "BWSearchClassTableViewController.h"
#import "NetworkController.h"

#import "BWCourse.h"
#import "BWYear.h"
#import "BWSubject.h"
#import "BWCourseTableViewCell.h"

NSMutableArray *recentSearches;

@interface BWSearchClassTableViewController () {
    NetworkController   *networkController;
    NSMutableArray      *searchResultCourseNames;
    NSString            *_searchText;
}

@end

@implementation BWSearchClassTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    networkController = [NetworkController sharedInstance];
    searchResultCourseNames = [NSMutableArray array];
    
    [self.tableView registerClass:[BWCourseTableViewCell class] forCellReuseIdentifier:@"Course"];
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [self loadRecents];
}

- (void)setActive:(BOOL)active
{
    _active = active;
    if (active) {
        [self setSearchText:_searchText];
    }
}

- (void)loadRecents
{
    if (!recentSearches) {
        recentSearches = [[[NSUserDefaults standardUserDefaults] arrayForKey:@"recentSearches"] mutableCopy];
        if (!recentSearches) {
            recentSearches = [NSMutableArray new];
            [self saveRecents];
        }
    }
}

- (void)saveRecents
{
    [[NSUserDefaults standardUserDefaults] setObject:recentSearches forKey:@"recentSearches"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setSearchText:(NSString *)searchText
{
    _searchText = searchText;
    NSLog(@"Maybe Searching");
    if (searchText.length > 0 && self.active) {
        NSLog(@"Searching");
        NSMutableArray *searchResults = [NSMutableArray new];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            for (NSString *courseName in self.year.allCourseNames) {
                if ([courseName rangeOfString:searchText].location != NSNotFound) {
                    [searchResults addObject:courseName];
                } else {
                    NSArray *courses = self.year.allCourses[courseName];
                    for (BWCourse *course in courses) {
                        if (course.teacherName.length > 0 && [course.teacherName rangeOfString:searchText].location != NSNotFound) {
                            [searchResults addObject:courseName];
                        } else if (course.courseNumber > 0 && [[NSString stringWithFormat:@"%ld", course.courseNumber] isEqualToString:searchText]) {
                            [searchResults addObject:courseName];
                        } else if ([course.subject.name rangeOfString:searchText].location != NSNotFound) {
                            [searchResults addObject:courseName];
                        } else if (course.attributes.length > 0 && [course.attributes rangeOfString:searchText].location != NSNotFound) {
                            [searchResults addObject:courseName];
                        } else if (course.crn > 0 && [[NSString stringWithFormat:@"%ld", course.crn] isEqualToString:searchText]) {
                            [searchResults addObject:courseName];
                        } else {
                            continue;
                        }
                        break;
                    }
                }
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                searchResultCourseNames = searchResults;
                NSLog(@"Setting %@ from %@", searchResults, searchText);
                [self.tableView reloadData];
            });
        });
    } else if (self.active) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }
}

//#pragma mark - Table view data source
- (NSArray *)coursesForIndexPath:(NSIndexPath *)indexPath
{
    NSString *courseName = _searchText.length == 0 ? self.year.allCourseNames[indexPath.row] : searchResultCourseNames[indexPath.row];
    return self.year.allCourses[courseName];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"Rows: %ld", _searchText.length == 0 ? self.year.allCourseNames.count : searchResultCourseNames.count);
    return _searchText.length == 0 ? self.year.allCourseNames.count : searchResultCourseNames.count;
}


@end














