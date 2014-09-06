//
//  RootViewController.m
//  OffTheApp
//
//  Created by Zeb Long on 11/7/12.
//  Copyright (c) 2012 North Avenue Studios. All rights reserved.
//
#import "OTAArtistListViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "OTAGlobals.h"

@implementation OTAArtistListViewController
@synthesize tableViewController;
#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad
{
    [self.navigationController setNavigationBarHidden:false animated:true];
    [super viewDidLoad];
	
    self.title = @"Artists";
    self.tableViewController->parent = self;
    self.tableViewController->isPaginated = true;
    OTAGlobals* global = [OTAGlobals getInstance];
    [tableViewController refreshWithUrl:[global.wordpressDomain stringByAppendingFormat:@"getArtists.php?posts_per_page=%i", 20]];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:false animated:true];
}

@end

