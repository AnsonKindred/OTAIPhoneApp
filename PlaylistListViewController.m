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
@synthesize delegate;

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
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:false animated:true];
    
    if (bannerView == nil)
    {
        NSLog(@"creating new banner view");
        bannerView = [[ADBannerView alloc] initWithFrame:CGRectZero];
    }
    bannerView.delegate = self;
    [bannerContainer addSubview:bannerView];
    
    [self layoutAnimated:YES];
}

-(void) viewWillDisappear:(BOOL)animated
{
    bannerView.delegate = nil;
    [bannerView removeFromSuperview];
    if ([self.navigationController.viewControllers indexOfObject:self]==NSNotFound)
    {
        // back button was pressed.  We know this is true because self is no longer
        // in the navigation stack.
        [self.delegate setSharedAdView:bannerView];
    }
    bannerView = nil;
    [super viewWillDisappear:animated];
}

- (void)bannerViewDidLoadAd:(ADBannerView *)banner
{
    [self layoutAnimated:YES];
}

- (void)layoutAnimated:(BOOL)animated
{
    if (!bannerView.bannerLoaded)
    {
        bannerConstraint.constant = -bannerContainer.frame.size.height;
    }
    else
    {
        bannerConstraint.constant = 0;
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

- (void)setSharedAdView:(ADBannerView *)adView
{
    bannerView.delegate = nil;
    bannerView = adView;
    bannerView.delegate = self;
}


@end
