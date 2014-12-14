//
//  OTAVideoListViewController_new.h
//  Off The Ave
//
//  Created by Kyle Parker on 11/16/12.
//  Copyright (c) 2012 North Avenue Studios. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>
#import "VideoListTableViewController.h"
#import "VideoEntryViewController.h"

@class VideoListViewController;

@protocol VideoListViewControllerDelegate <NSObject>
- (void)setSharedAdView:(ADBannerView *)adView;
@end

@interface VideoListViewController : UIViewController <ADBannerViewDelegate> {
    IBOutlet VideoListTableViewController* tableViewController;
    IBOutlet UITableView* tableView;
    IBOutlet UIView* bannerContainer;
    IBOutlet NSLayoutConstraint* bannerConstraint;
    
@public
    int filterByGenre;
    ADBannerView* bannerView;
}

@property (atomic, strong) IBOutlet VideoListTableViewController* tableViewController;
@property (nonatomic, strong) id <VideoListViewControllerDelegate> delegate;

@end
