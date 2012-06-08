//
//  FAppDelegate.m
//  iPhone Side Bars
//
//  Created by Riley Wiebe on 12-06-07.
//  Copyright (c) 2012 Fliew. All rights reserved.
//

#import "FSBAppDelegate.h"

// Examples
#import "FSBRootViewController.h"
#import "FSBRightViewController.h"
#import "FSBLeftViewController.h"

@implementation FSBAppDelegate

@synthesize window = _window;
@synthesize sideBarViewController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    
    // Example view setup
    FSBRootViewController* rootViewController = [[FSBRootViewController alloc] init];
    FSBRightViewController* rightViewController = [[FSBRightViewController alloc] init];
    FSBLeftViewController* leftViewController = [[FSBLeftViewController alloc] init];
    
    // Side bar setup
    sideBarViewController = [[FSideBarViewController alloc] initWithRootViewController:rootViewController
                                                                    leftViewController:leftViewController
                                                                   rightViewController:rightViewController];
    
    // Set the frame
    [sideBarViewController.view setFrame:CGRectMake(0, 0, self.window.frame.size.width, self.window.frame.size.height)];
    
    // Add View
    [self.window addSubview:sideBarViewController.view];
    
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
