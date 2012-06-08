//
//  FAppDelegate.h
//  iPhone Side Bars
//
//  Created by Riley Wiebe on 12-06-07.
//  Copyright (c) 2012 Fliew. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSideBarViewController.h"

@interface FSBAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, retain) FSideBarViewController* sideBarViewController;

@end
