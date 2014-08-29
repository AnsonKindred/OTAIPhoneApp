//
//  RootViewController.m
//  OffTheApp
//
//  Created by Zeb Long on 11/7/12.
//  Copyright (c) 2012 North Avenue Studios. All rights reserved.
//
#import "OTAArtistListViewController.h"
#import <QuartzCore/QuartzCore.h>


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
    lastEntryCount = 0;
    page = 1;
    [tableViewController refreshWithUrl:@"http://www.offtheavenue.tv/?feed=rss2&posts_per_page=10&orderby=title&order=asc&paged=1&cat=163"];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:false animated:true];
}

- (void)requestFinished
{
    if([tableViewController.entries count] > lastEntryCount)
    {
        page++;
        lastEntryCount = [tableViewController.entries count];
        [tableViewController refreshWithUrl:[@"http://www.offtheavenue.tv/?feed=rss2&posts_per_page=10&orderby=title&order=asc&cat=163&paged=" stringByAppendingString:[NSString stringWithFormat:@"%d", page]]];
    }
}


@end

