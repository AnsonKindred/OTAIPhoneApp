//
//  OTAPlaylistVideoViewController.h
//  Off The Ave
//
//  Created by Kyle Parker on 2/11/13.
//  Copyright (c) 2013 North Avenue Studios. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OTARSSEntry.h"
#import "OTAVideoEntryViewController.h"
#import "GDataEntryYouTubePlaylist.h"

@interface OTAPlaylistVideoViewController : OTAVideoEntryViewController
{
    GDataEntryYouTubePlaylist* playlistEntry;
}

- (void) fetchVideoMetaData;
- (void) loadPlaylistData:(ASIHTTPRequest *)request;
@property (strong) GDataEntryYouTubePlaylist* playlistEntry;

@end
