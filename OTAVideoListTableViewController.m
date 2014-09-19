//
//  OTAVideoListViewController.m
//  Off The Ave
//
//  Created by Kyle Parker on 11/15/12.
//  Copyright (c) 2012 North Avenue Studios. All rights reserved.
//

#import "OTAVideoListTableViewController.h"

@implementation OTAVideoListTableViewController

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    EntrySession* entry;
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        entry = [self.filteredEntries objectAtIndex:indexPath.row];
    }
    else
    {
        entry = [entries objectAtIndex:indexPath.row];
    }

    OTAVideoEntryViewController *controller = [[OTAVideoEntryViewController alloc] initWithNibName:@"OTAVideoEntryViewController" bundle:[NSBundle mainBundle]];
	controller.entry = entry;
	[[parent navigationController] pushViewController:controller animated:YES];
}

- (void)playAll
{
    OTAPlaylistPlayAllViewController *controller = [[OTAPlaylistPlayAllViewController alloc] initWithNibName:@"OTAPlaylistPlayAllViewController" bundle:[NSBundle mainBundle]];
    controller.playlist = entries;
	[[parent navigationController] pushViewController:controller animated:YES];
//    NSString* playlistCSV;
//    NSString* firstVideo = [entries[0] videoID];
//    
//    playlistCSV = [entries[1] videoID];
//    for(int i = 2; i < [entries count]; i++)
//    {
//        playlistCSV = [playlistCSV stringByAppendingFormat:@",%@", [entries[i] videoID]];
//    }
//
//    NSString* videoHTML = @"\
//    <!DOCTYPE html>\
//    <html>\
//    <head>\
//    <style>\
//    body { margin:0px 0px 0px 0px; }\
//    </style>\
//    </head>\
//    <body>\
//    <div id=\"player\"></div>\
//    <script>\
//    var tag = document.createElement('script');\
//    tag.src = \"http://www.youtube.com/player_api\";\
//    var firstScriptTag = document.getElementsByTagName('script')[0];\
//    firstScriptTag.parentNode.insertBefore(tag, firstScriptTag);\
//    var player;\
//    function onYouTubePlayerAPIReady() {\
//    player = new YT.Player('player', {\
//    width:'%0.0f',\
//    height:'%0.0f',\
//    videoId:'%@',\
//    playerVars: { 'playlist': '%@' },\
//    events: {\
//    'onReady': onPlayerReady,\
//    }\
//    });\
//    }\
//    function onPlayerReady(event) {\
//    event.target.playVideo();\
//    }\
//    </script>\
//    </body>\
//    </html>";
//    
//    videoHTML = [NSString stringWithFormat:videoHTML, 0.0f, 380.0f, firstVideo, playlistCSV];
//    UIWebView *videoView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 320, 300)];
//    
//    videoView.hidden = true;
//    videoView.backgroundColor = [UIColor clearColor];
//    videoView.opaque = NO;
//    [self.view addSubview:videoView];
//    
//    videoView.mediaPlaybackRequiresUserAction = NO;
//    [videoView loadHTMLString:videoHTML baseURL:[[NSBundle mainBundle] resourceURL]];
}

@end