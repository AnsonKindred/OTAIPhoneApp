//
//  OTAPlaylistViewController.m
//  Off The Ave
//
//  Created by Kyle Parker on 2/9/13.
//  Copyright (c) 2013 North Avenue Studios. All rights reserved.
//

#import "PlaylistListViewController.h"

@implementation PlaylistListViewController
@synthesize tableViewController;

float originalTableHeight;

- (void)viewDidLoad
{
    [self.navigationController setNavigationBarHidden:false animated:true];
    [super viewDidLoad];
	
    self.title = @"Playlists";
    self.tableViewController->parent = self;
    self.tableViewController->isPaginated = true;
    Globals* global = [Globals getInstance];
    [tableViewController refreshWithUrl:[global.wordpressDomain stringByAppendingFormat:@"getGenres.php?posts_per_page=%i", 20]];
}

- (void)viewWillAppear:(BOOL)animated
{
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
