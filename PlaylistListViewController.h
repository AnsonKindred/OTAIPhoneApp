//
//  OTAPlaylistViewController.h
//  Off The Ave
//
//  Created by Kyle Parker on 2/9/13.
//  Copyright (c) 2013 North Avenue Studios. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlaylistListTableViewController.h"

@interface PlaylistListViewController : UIViewController
{
    IBOutlet PlaylistListTableViewController *tableViewController;
}

@property (atomic, strong) IBOutlet PlaylistListTableViewController* tableViewController;

@end
