//
//  BWClassesViewController.h
//  BanWeb
//
//  Created by Will Cobb on 3/6/16.
//  Copyright © 2016 Will Cobb. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CAPSPageMenu;
@class NetworkController;
@interface BWClassesViewController : UIViewController {
    NetworkController *networkController;
    NSMutableArray *controllerArray;
}

@property (nonatomic) CAPSPageMenu  *pageMenu;
@property BOOL hideSearchBar;

- (void)loadPageMenu;

@end
