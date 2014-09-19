//
//  OTAPlaylistPlayAllViewController.m
//  Off The Ave
//
//  Created by Kyle Parker on 2/16/13.
//  Copyright (c) 2013 North Avenue Studios. All rights reserved.
//

#import "OTAPlaylistPlayAllViewController.h"
#import <objc/message.h>
#import <MediaPlayer/MediaPlayer.h>
#import <JavaScriptCore/JavaScriptCore.h>

@implementation OTAPlaylistPlayAllViewController

@synthesize webView, playlistCSV, firstVideo, playlist;
int currentPlayerState, playlistIndex;
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationController setNavigationBarHidden:true animated:true];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playerExited:)
                                                 name:@"UIMoviePlayerControllerDidExitFullscreenNotification"
                                               object:nil];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    playlistIndex = 0;
    
    firstVideo = [playlist[0] videoID];
    if ([playlist count] > 1)
    {
        playlistCSV = [playlist[1] videoID];
        for(int i = 2; i < [playlist count]; i++)
        {
            playlistCSV = [playlistCSV stringByAppendingFormat:@",%@", [playlist[i] videoID]];
        }
    }
    else
    {
        playlistCSV = @"";
    }
    
    [self updateVideoView];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    // Register the setPlayerState method to be callable from the webview's javascript context
    JSContext *context = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"]; // Undocumented access
    context[@"setPlayerState"] = ^(NSNumber *state) {
        [self setPlayerState:[state intValue]];
    };
}

-(void)setPlayerState:(int)state
{
    // Keep track of the video player state so that we know
    // whether or not to go back to the previous view when the player exits
    currentPlayerState = state;
}

-(void)playerExited:(NSNotification*)notification
{
    // 2 == PAUSED
    // When the user intentionally exits the player the state is always set to paused
    // When the player automatically closes to open the next song (fuck you apple) it is not paused
    // If the user intentionally exited, go back to the previous view.
    NSLog(@"playerState: %i", currentPlayerState);
    if (currentPlayerState == 2 || (currentPlayerState == 0 && playlistIndex == [playlist count] - 1))
    {
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        playlistIndex++;
    }
}

- (void) updateVideoView
{
    NSString* videoHTML = @"\
        <!DOCTYPE html>\
        <html>\
            <head>\
                <style>\
                    body { margin:0px 0px 0px 0px; }\
                </style>\
            </head>\
            <body>\
                <div id=\"player\"></div>\
                <script>\
                    var tag = document.createElement('script');\
                    tag.src = \"http://www.youtube.com/player_api\";\
                    var firstScriptTag = document.getElementsByTagName('script')[0];\
                    firstScriptTag.parentNode.insertBefore(tag, firstScriptTag);\
                    var player;\
                    function onYouTubePlayerAPIReady() {\
                        player = new YT.Player('player', {\
                            width:'%0.0f',\
                            height:'%0.0f',\
                            videoId:'%@',\
                            playerVars: { 'playlist': '%@' },\
                            events: {\
                                'onReady': onPlayerReady,\
                                'onStateChange': onStateChange\
                            }\
                        });\
                    }\
                    function onPlayerReady(event) {\
                        event.target.playVideo();\
                    }\
                    function onStateChange(event) {\
                        setPlayerState(event.data);\
                    }\
                </script>\
            </body>\
       </html>";
    videoHTML = [NSString stringWithFormat:videoHTML, webView.frame.size.width, 380.0f, firstVideo, playlistCSV];
    
    [webView loadHTMLString:videoHTML baseURL:[[NSBundle mainBundle] resourceURL]];
}


@end
