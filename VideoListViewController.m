//
//  OTAVideoListViewController_new.m
//  Off The Ave
//
//  Created by Kyle Parker on 11/16/12.
//  Copyright (c) 2012 North Avenue Studios. All rights reserved.
//

#import "VideoListViewController.h"

@implementation VideoListViewController
@synthesize tableViewController;

float originalTableHeight;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Videos";
    tableViewController->parent = self;
    tableViewController->isPaginated = true;
    
    if (filterByGenre != 0)
    {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPlay target:tableViewController action:@selector(playAll)];
        [tableViewController refreshWithUrl:[self.tableViewController->feed_url stringByAppendingFormat:@"&genreID=%i", filterByGenre]];
    }
    else
    {
        [tableViewController refresh];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:false animated:true];
}

- (void)viewDidAppear:(BOOL)animated
{
    originalTableHeight = tableView.bounds.size.height;
}

- (void)bannerViewDidLoadAd:(ADBannerView *)banner
{
    [self layoutAnimated:YES];
}

- (void)layoutAnimated:(BOOL)animated
{
    if (!bannerView.bannerLoaded)
    {
        tableHeightConstraint.constant = originalTableHeight + bannerView.frame.size.height;
    }
    else
    {
        tableHeightConstraint.constant = originalTableHeight;
    }
    [self.view updateConstraintsIfNeeded];
    [self.view layoutIfNeeded];
}


- (BOOL)bannerViewActionShouldBegin:(ADBannerView *)banner willLeaveApplication:(BOOL)willLeave
{
    BOOL shouldExecuteAction = true;
    if (!willLeave && shouldExecuteAction)
    {
        // insert code here to suspend any services that might conflict with the advertisement
    }
    return shouldExecuteAction;
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    [self layoutAnimated:YES];
}

@end
