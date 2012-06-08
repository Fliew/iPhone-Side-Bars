//
//  FSideMenusViewController.h
//  iPhone Side Bars
//
//  Created by Riley Wiebe on 12-04-20.
//  Copyright (c) 2012 Fliew. All rights reserved.
//

#import <UIKit/UIKit.h>

// Notification Constants

// Toggle notifications
extern NSString* const toggleLeftRevealNotification;
extern NSString* const toggleRightRevealNotification;
extern NSString* const showRootViewControllerNotification;

// View shown notifications
extern NSString* const leftViewDidRevealNotification;
extern NSString* const rightViewDidRevealNotification;
extern NSString* const sideBarDidHideNotification;

extern NSString* const disablePanGestureNotification;

@protocol FSideBarViewControllerItem;

@interface FSideBarViewController : UIViewController
{
    BOOL disablePanGesture;
    BOOL disableTapGesture;
    BOOL disableRootViewWhenHidden;
    CGFloat animationDuration;
}

/**
 * Disable the pan gesture
 */
@property (readwrite) BOOL disablePanGesture;

/**
 * Disable the tap geture
 */
@property (readwrite) BOOL disableTapGesture;

/**
 * Disable user interaction with the root view when it is not the focus
 */
@property (readwrite) BOOL disableRootViewWhenHidden;

/**
 * The speed of the animation
 */
@property (readwrite) CGFloat animationDuration;

/**
 * Create a new side bar controller
 */
- (id)initWithRootViewController:(UIViewController*)rootViewController
              leftViewController:(UIViewController*)leftViewController
             rightViewController:(UIViewController*)rightViewController;

/**
 * Set how much can be seen on the left
 */
- (void)setLeftMargin:(CGFloat)margin;

/**
 * Set how much can be seen on the right
 */
- (void)setRightMargin:(CGFloat)margin;

/**
 * Toggles the right view
 */
- (void)toggleLeftReveal;

/**
 * Toggles the left view
 */
- (void)toggleRightReveal;

/**
 * Shows the root view
 */
- (void)showRootViewController;

@end

@interface UIViewController (FSideBarViewControllerItem)

/**
 * Used for buttons which toggle the left reveal
 */
- (void)toggleLeftReveal;

/**
 * Used for buttons which toggle the right reveal
 */
- (void)toggleRightReveal;

/**
 * Show the root view controller
 */
- (void)showRootViewController;

/**
 * Disable the pan gesture. This will override the initial setting
 */
- (void)disablePanGesture:(BOOL)value;

@end

@protocol FSideBarViewControllerItem <NSObject>

@optional
/**
 * Called when the left view is revealed
 */
- (void)leftViewDidReveal;

/**
 * Called when the right view is revealed
 */
- (void)rightViewDidReveal;

/**
 * Called when either side view is hidden
 */
- (void)sideBarDidHide;

@end