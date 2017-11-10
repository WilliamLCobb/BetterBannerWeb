//
//  BWTabController.m
//  BanWeb
//
//  Created by Will Cobb on 3/14/16.
//  Copyright © 2016 Will Cobb. All rights reserved.
//

#import "BWTabController.h"

@interface BWTabController ()

@end

@implementation BWTabController

- (void)viewDidLoad {
    [super viewDidLoad];
    // CUrrently does not invoke view has loaded
    //dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        for (id controller in self.viewControllers) {
//            if ([controller isKindOfClass:[UINavigationController class]]) {
//                UINavigationController *nav = (UINavigationController *)controller;
//                [[nav.viewControllers objectAtIndex:0] loadViewIfNeeded];
//            } else {
//                [controller loadViewIfNeeded];
//            }
            
        }
    //});
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
