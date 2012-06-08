//
//  FSideMenusViewController.m
//  iPhone Side Bars
//
//  Created by Riley Wiebe on 12-04-20.
//  Copyright (c) 2012 Fliew. All rights reserved.
//

#import "FSideBarViewController.h"

NSString* const toggleLeftRevealNotification = @"FSideBarViewControllerToggleLeftReveal";
NSString* const toggleRightRevealNotification = @"FSideBarViewControllerToggleRightReveal";
NSString* const showRootViewControllerNotification = @"FSideBarViewControllerShowRootViewController";

NSString* const leftViewDidRevealNotification = @"FSideBarViewControllerLeftViewDidRevealNotification";
NSString* const rightViewDidRevealNotification = @"FSideBarViewControllerRightViewDidRevealNotification";
NSString* const sideBarDidHideNotification = @"FSideBarViewControllerSideBarDidHideNotification";

NSString* const disablePanGestureNotification = @"FSideBarViewControllerDisablePanGestureNotification";

typedef enum
{
    left,
    right,
    center
} FSideBarStates;

@interface FSideBarViewController ()
{
    UIViewController* _rootViewController;
    UIViewController* _leftViewController;
    UIViewController* _rightViewController;
    
    CGFloat leftMargin;
    CGFloat rightMargin;
    CGFloat rootPosition;
    CGFloat rootOrigin;
    
    CGFloat finalLeft;
    CGFloat finalRight;
    
    CGFloat swipeVelocity;
    
    FSideBarStates rootViewState;
    
    UIPanGestureRecognizer* panGesture;
    UITapGestureRecognizer* tapGesture;
    UIPanGestureRecognizer* dummyPanGesture;
    
    BOOL callingProtocol;
    
    UIView* dummyView;
}
@end

@implementation FSideBarViewController

@synthesize disablePanGesture;
@synthesize disableTapGesture;
@synthesize disableRootViewWhenHidden;
@synthesize animationDuration;

- (id)initWithRootViewController:(UIViewController*)rootViewController
              leftViewController:(UIViewController*)leftViewController
             rightViewController:(UIViewController*)rightViewController
{
    self = [super init];
    
    if (self)
    {
        CGFloat defaultMargin = 45;
        animationDuration = 0.15;
        
        _rootViewController = rootViewController;
        _leftViewController = leftViewController;
        _rightViewController = rightViewController;
        
        leftMargin = defaultMargin;
        rightMargin = defaultMargin;
        
        swipeVelocity = 900;
        
        rootViewState = center;
        
        disableRootViewWhenHidden = YES;
        disableTapGesture = NO;
        disablePanGesture = NO;
        
        callingProtocol = NO;
        
        dummyView = [[UIView alloc] init];
        [dummyView setBackgroundColor:[UIColor brownColor]];
    }
    
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setLeftMargin:(CGFloat)margin
{
    leftMargin = margin;
}

- (void)setRightMargin:(CGFloat)margin
{
    rightMargin = margin;
}

- (void)calculateFinalMagins
{
    if (_leftViewController != nil && _rightViewController != nil)
    {
        finalLeft = leftMargin - self.view.frame.size.width;
        finalRight = self.view.frame.size.width - rightMargin;
    }
    else if (_leftViewController != nil && _rightViewController == nil)
    {
        finalLeft = leftMargin - self.view.frame.size.width;
        finalRight = self.view.frame.origin.x;
    }
    else if (_leftViewController == nil && _rightViewController != nil)
    {
        finalLeft = self.view.frame.origin.x;
        finalRight = self.view.frame.size.width - rightMargin;
    }
    else
    {
        finalLeft = self.view.frame.origin.x;
        finalRight = self.view.frame.origin.x;
    }
}

#pragma mark - Actions

- (void)disableRootViewUserInteraction
{
    for (UIView* view in _rootViewController.view.subviews)
    {
        [view setUserInteractionEnabled:NO];
    }
}

- (void)enableRootViewUserInteraction
{
    for (UIView* view in _rootViewController.view.subviews)
    {
        [view setUserInteractionEnabled:YES];
    }
}

#pragma mark - Protocol Calls

- (void)leftViewDidReveal
{
    if (callingProtocol == NO)
    {
        callingProtocol = YES;
        
        // Send notification
        [[NSNotificationCenter defaultCenter] postNotificationName:leftViewDidRevealNotification object:nil];
        
        if ([_rootViewController respondsToSelector:@selector(leftViewDidReveal)])
        {
            [_rootViewController performSelector:@selector(leftViewDidReveal)];
        }
        
        if ([_leftViewController respondsToSelector:@selector(leftViewDidReveal)])
        {
            [_leftViewController performSelector:@selector(leftViewDidReveal)];
        }
        
        if ([_rightViewController respondsToSelector:@selector(leftViewDidReveal)])
        {
            [_rightViewController performSelector:@selector(leftViewDidReveal)];
        }
    }
}

- (void)rightViewDidReveal
{
    if (callingProtocol == NO)
    {
        callingProtocol = YES;
        
        // Send notification
        [[NSNotificationCenter defaultCenter] postNotificationName:rightViewDidRevealNotification object:nil];
        
        if ([_rootViewController respondsToSelector:@selector(rightViewDidReveal)])
        {
            [_rootViewController performSelector:@selector(rightViewDidReveal)];
        }
        
        if ([_leftViewController respondsToSelector:@selector(rightViewDidReveal)])
        {
            [_leftViewController performSelector:@selector(rightViewDidReveal)];
        }
        
        if ([_rightViewController respondsToSelector:@selector(rightViewDidReveal)])
        {
            [_rightViewController performSelector:@selector(rightViewDidReveal)];
        }
    }
}

- (void)sideBarDidHide
{
    if (callingProtocol == NO)
    {
        callingProtocol = YES;
        
        // Send notification
        [[NSNotificationCenter defaultCenter] postNotificationName:sideBarDidHideNotification object:nil];
        
        if ([_rootViewController respondsToSelector:@selector(sideBarDidHide)])
        {
            [_rootViewController performSelector:@selector(sideBarDidHide)];
        }
        
        if ([_leftViewController respondsToSelector:@selector(sideBarDidHide)])
        {
            [_leftViewController performSelector:@selector(sideBarDidHide)];
        }
        
        if ([_rightViewController respondsToSelector:@selector(sideBarDidHide)])
        {
            [_rightViewController performSelector:@selector(sideBarDidHide)];
        }
    }
}

#pragma mark - Animations

- (void)hideAllAnimation
{
    [self.view endEditing:YES];
    
    // Call side bar did hide
    [self sideBarDidHide];
    callingProtocol = NO;
    
    [_rootViewController.view removeGestureRecognizer:tapGesture];
    
    rootViewState = center;
    [UIView beginAnimations:@"revealLeft" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationDelegate:self];
    CGPoint center = CGPointMake(self.view.center.x, _rootViewController.view.center.y);
    [_rootViewController.view setCenter:center];
    [_leftViewController.view setCenter:center];
    [_rightViewController.view setCenter:center];
    [UIView commitAnimations];
    
    if (disableRootViewWhenHidden)
    {
        [self enableRootViewUserInteraction];
    }
}

- (void)revealLeftAnimation
{
    [self.view endEditing:YES];
    
    [self leftViewDidReveal];
    callingProtocol = NO;
    
    // Alert view that the left view has been revealed.    
    [_leftViewController.view setHidden:NO];
    [_rightViewController.view setHidden:YES];
    
    if (disableTapGesture == NO)
    {
        [_rootViewController.view addGestureRecognizer:tapGesture];
    }
    
    rootViewState = right;
    [UIView beginAnimations:@"revealLeft" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationDelegate:self];
    CGPoint center = CGPointMake(finalRight + self.view.center.x, _rootViewController.view.center.y);
    [_rootViewController.view setCenter:center];
    [UIView commitAnimations];
    
    if (disableRootViewWhenHidden)
    {
        [self disableRootViewUserInteraction];
    }
}

- (void)revealRightAnimation
{
    [self.view endEditing:YES];
    
    [self rightViewDidReveal];
    callingProtocol = NO;
    
    [_leftViewController.view setHidden:YES];
    [_rightViewController.view setHidden:NO];
    
    if (disableTapGesture == NO)
    {
        [_rootViewController.view addGestureRecognizer:tapGesture];
    }
    
    rootViewState = left;
    [UIView beginAnimations:@"revealLeft" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationDelegate:self];
    CGPoint center = CGPointMake(finalLeft + self.view.center.x, _rootViewController.view.center.y);
    [_rootViewController.view setCenter:center];
    [UIView commitAnimations];
    
    if (disableRootViewWhenHidden)
    {
        [self disableRootViewUserInteraction];
    }
}

- (void)showRootViewController
{
    [self hideAllAnimation];
}

#pragma mark - Toggle

- (void)toggleLeftReveal
{
    if (rootViewState == center)
    {
        CGPoint hiddenCenter = CGPointMake(finalRight + self.view.center.x, _rootViewController.view.center.y);
        CGPoint shownCenter = CGPointMake(self.view.center.x, _rootViewController.view.center.y);
        [_rightViewController.view setCenter:hiddenCenter];
        [_leftViewController.view setCenter:shownCenter];
        // It will only toggle if the left is not empty
        [self revealLeftAnimation];
    }
    else
    {
        [self hideAllAnimation];
    }
}

- (void)toggleRightReveal
{
    if (rootViewState == center)
    {
        CGPoint hiddenCenter = CGPointMake(finalLeft + self.view.center.x, _rootViewController.view.center.y);
        CGPoint shownCenter = CGPointMake(self.view.center.x, _rootViewController.view.center.y);
        [_leftViewController.view setCenter:hiddenCenter];
        [_rightViewController.view setCenter:shownCenter];
        [self revealRightAnimation];
    }
    else
    {
        [self hideAllAnimation];
    }
}

#pragma mark - Gesture

- (void)revealGesture:(UIPanGestureRecognizer*)recognizer
{
    // Calculate points needed
    CGPoint translatedPoint = [recognizer translationInView:self.view];
    CGPoint centerPoint = CGPointMake(self.view.center.x, [recognizer.view center].y);
    
    // Did the gesture begin?
    if ([recognizer state] == UIGestureRecognizerStateBegan)
    {
        // Set the root position and root origin
        rootPosition = [recognizer.view center].x;
        rootOrigin = recognizer.view.frame.origin.x;
    }
    
    // Calculate the origin
    CGFloat newOrigin = rootOrigin + translatedPoint.x;
    
    // Check if we are at the margin
    CGPoint newCenter = CGPointMake(rootPosition + translatedPoint.x, [recognizer.view center].y);
    
    // If the view is between the margin ranges the root view can be moved
    if (newOrigin >= finalLeft && newOrigin <= finalRight)
    {
        if (newCenter.x >= centerPoint.x && _rightViewController != nil)
        {
            // Moving the root view right, so hide the right view controller.
            [_rightViewController.view setHidden:YES];
            [self leftViewDidReveal];
        }
        else
        {
            // Moving the root view controller left sho show the right view
            [_rightViewController.view setHidden:NO];
        }
        
        if (newCenter.x <= centerPoint.x && _leftViewController != nil)
        {
            // Moving the root view controller right so show the left view
            [_leftViewController.view setHidden:YES];
            [self rightViewDidReveal];
        }
        else
        {
            // Moving the root view right so hide the root view
            [_leftViewController.view setHidden:NO];
        }
        
        // Update the root view position
        [recognizer.view setCenter:newCenter];
    }
    else
    {
        // Force to edge
        if (newOrigin < finalLeft)
        {
            CGPoint newCenter = CGPointMake(finalLeft + centerPoint.x, [recognizer.view center].y);
            [recognizer.view setCenter:newCenter];
        }
        else if (newOrigin > finalRight)
        {
            CGPoint newCenter = CGPointMake(finalRight + centerPoint.x, [recognizer.view center].y);
            [recognizer.view setCenter:newCenter];
        }
    }
    
    if ([recognizer state] == UIGestureRecognizerStateEnded)
    {
        if ([recognizer velocityInView:self.view].x > swipeVelocity)
        {
            // Swipe right, reveal left
            if (rootViewState == left)
            {
                [self hideAllAnimation];
            }
            else if (rootViewState == center)
            {
                [self revealLeftAnimation];
            }
        }
        else if ([recognizer velocityInView:self.view].x < -swipeVelocity)
        {
            // Swipe left, reveal left
            if (rootViewState == right)
            {
                [self hideAllAnimation];
            }
            else if (rootViewState == center)
            {
                [self revealRightAnimation];
            }
        }
        else
        {
            // Slow swipe
            // Animate to final state
            CGFloat animateLeft = self.view.frame.size.width/16;
            CGFloat animateRight = self.view.frame.size.width - animateLeft;
            
            if (newCenter.x < animateLeft)
            {
                [self revealRightAnimation];
            }
            else if (newCenter.x > animateRight)
            {
                [self revealLeftAnimation];
            }
            else
            {
                [self hideAllAnimation];
            }
        }
    }
}

- (void)tapGesture:(UITapGestureRecognizer*)recognizer
{
    if (rootViewState == left || rootViewState == right)
    {
        [self hideAllAnimation];
    }
}

#pragma mark - Notifications

- (void)setDisableTapGestureTo:(NSNotification*)notification
{
    disablePanGesture = [[notification object] boolValue];
    
    if (disablePanGesture)
    {
        // Disable
        [_rootViewController.view removeGestureRecognizer:panGesture];
    }
    else
    {
        [_rootViewController.view addGestureRecognizer:panGesture];
    }
}

- (void)registerNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(toggleLeftReveal) name:toggleLeftRevealNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(toggleRightReveal) name:toggleRightRevealNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showRootViewController) name:showRootViewControllerNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setDisableTapGestureTo:) name:disablePanGestureNotification object:nil];
}

#pragma mark - Gestures

- (void)setupGestures
{
    // Allocate the tap gesture
    tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
    
    // Add pan gesture to the root view controller
    panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(revealGesture:)];
    
    if (disablePanGesture == NO)
    {
        [_rootViewController.view addGestureRecognizer:panGesture];
    }
}

#pragma mark - View

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self registerNotifications];
    [self calculateFinalMagins];
    [self setupGestures];
    
    [_leftViewController.view setCenter:_rootViewController.view.center];
    [_rightViewController.view setCenter:_rootViewController.view.center];
    
    [self.view addSubview:_leftViewController.view];
    [self.view addSubview:_rightViewController.view];
    [self.view addSubview:_rootViewController.view];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end

@implementation UIViewController (FSideBarViewControllerItem)

- (void)toggleLeftReveal
{
    [[NSNotificationCenter defaultCenter] postNotificationName:toggleLeftRevealNotification object:nil];
}

- (void)toggleRightReveal
{
    [[NSNotificationCenter defaultCenter] postNotificationName:toggleRightRevealNotification object:nil];
}

- (void)showRootViewController
{
    [[NSNotificationCenter defaultCenter] postNotificationName:showRootViewControllerNotification object:nil];
}

- (void)disablePanGesture:(BOOL)value
{
    NSNumber* newValue = [NSNumber numberWithBool:value];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:disablePanGestureNotification object:newValue];
}

@end