//
//  FSBRootViewController.m
//  iPhone Side Bars
//
//  Created by Riley Wiebe on 12-06-07.
//  Copyright (c) 2012 Fliew. All rights reserved.
//

#import "FSBRootViewController.h"

@interface FSBRootViewController ()

@end

@implementation FSBRootViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    // Set background to white
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    // Create label
    UILabel* rootLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 300, 40)];
    [rootLabel setText:@"Root View"];
    [self.view addSubview:rootLabel];
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
