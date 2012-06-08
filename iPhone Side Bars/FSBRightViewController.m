//
//  FSBRightViewController.m
//  iPhone Side Bars
//
//  Created by Riley Wiebe on 12-06-07.
//  Copyright (c) 2012 Fliew. All rights reserved.
//

#import "FSBRightViewController.h"

@interface FSBRightViewController ()

@end

@implementation FSBRightViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Change background to black
    [self.view setBackgroundColor:[UIColor blackColor]];
    
	// Create label
    UILabel* rightLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 20, 300, 40)];
    [rightLabel setText:@"Right View"];
    [rightLabel setTextColor:[UIColor whiteColor]];
    [rightLabel setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:rightLabel];
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
