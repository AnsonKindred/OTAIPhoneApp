//
//  OTAPlaylistViewController.h
//  Off The Ave
//
//  Created by Kyle Parker on 2/9/13.
//  Copyright (c) 2013 North Avenue Studios. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OTAPlaylistListTableViewController.h"

@interface OTAPlaylistListViewController : UIViewController
{
    IBOutlet OTAPlaylistListTableViewController *tableViewController;
}

@property (atomic, strong) IBOutlet OTAPlaylistListTableViewController* tableViewController;

@end
