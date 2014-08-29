//
//  OTAPlaylistViewController.h
//  Off The Ave
//
//  Created by Kyle Parker on 2/10/13.
//  Copyright (c) 2013 North Avenue Studios. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GDataEntryYouTubePlaylist.h"
#import "OTAPlaylistTableViewController.h"

@interface OTAPlaylistViewController : UIViewController
{
    GDataEntryYouTubePlaylist* entry;
    IBOutlet OTAPlaylistTableViewController *tableViewController;
}

@property (retain) GDataEntryYouTubePlaylist* entry;

@end
