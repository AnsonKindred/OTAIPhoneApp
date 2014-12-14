//
//  OTAPlaylistViewController.h
//  Off The Ave
//
//  Created by Kyle Parker on 2/9/13.
//  Copyright (c) 2013 North Avenue Studios. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>
#import "PlaylistListTableViewController.h"
#import "VideoListViewController.h"

@class PlaylistListViewController;

@protocol PlaylistListViewControllerDelegate <NSObject>
- (void)setSharedAdView:(ADBannerView *)adView;
@end

@interface PlaylistListViewController : UIViewController <ADBannerViewDelegate, VideoListViewControllerDelegate>
{
    IBOutlet PlaylistListTableViewController *tableViewController;
    IBOutlet UITableView* tableView;
    IBOutlet UIView* bannerContainer;
    IBOutlet NSLayoutConstraint* bannerConstraint;

@public
    ADBannerView* bannerView;
}

@property (atomic, strong) IBOutlet PlaylistListTableViewController* tableViewController;
@property (nonatomic, strong) id <PlaylistListViewControllerDelegate> delegate;

@end
