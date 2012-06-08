//
//  FSBLeftViewController.m
//  iPhone Side Bars
//
//  Created by Riley Wiebe on 12-06-07.
//  Copyright (c) 2012 Fliew. All rights reserved.
//

#import "FSBLeftViewController.h"

@interface FSBLeftViewController ()

@end

@implementation FSBLeftViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Change background to black
    [self.view setBackgroundColor:[UIColor blackColor]];
    
    // Create label
    UILabel* leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 300, 40)];
    [leftLabel setText:@"Left View"];
    [leftLabel setTextColor:[UIColor whiteColor]];
    [leftLabel setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:leftLabel];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
