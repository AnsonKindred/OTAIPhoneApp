//
//  OTAVideoListViewController_new.m
//  Off The Ave
//
//  Created by Kyle Parker on 11/16/12.
//  Copyright (c) 2012 North Avenue Studios. All rights reserved.
//

#import "OTAVideoListViewController.h"

@implementation OTAVideoListViewController
@synthesize tableViewController;

- (void)viewDidLoad
{
    [self.navigationController setNavigationBarHidden:false animated:true];
    
    self.title = @"Videos";
    self.tableViewController->parent = self;
    
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:false animated:true];
}

@end
