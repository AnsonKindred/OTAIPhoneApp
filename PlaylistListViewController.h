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

@interface PlaylistListViewController : UIViewController
{
    IBOutlet PlaylistListTableViewController *tableViewController;
    IBOutlet UITableView* tableView;
    IBOutlet ADBannerView* bannerView;
    IBOutlet NSLayoutConstraint* tableHeightConstraint;
}

@property (atomic, strong) IBOutlet PlaylistListTableViewController* tableViewController;

@end
