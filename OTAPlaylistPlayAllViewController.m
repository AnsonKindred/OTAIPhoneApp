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
#import "OTAGlobals.h"
#import "ASIHTTPRequest.h"

@implementation OTAPlaylistPlayAllViewController

@synthesize webView, playlistCSV, firstVideo, playlist;

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
    
    if (playlist == NULL)
    {
        // No playlist, grab a random one from the server
        queue = [[NSOperationQueue alloc] init];
        
        OTAGlobals* global = [OTAGlobals getInstance];
        NSURL *url = [NSURL URLWithString:[global.wordpressDomain stringByAppendingString:@"/getRandomPlaylist.php"]];
        ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
        
        [request setDelegate:self];
        
        //[request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
        [queue addOperation:request];
    }
    else
    {
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
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSData* returnedData = [request responseData];
    NSLog(@"%@", [[NSString alloc] initWithData:returnedData encoding:NSUTF8StringEncoding]);
    NSError *error = nil;
    id object = [NSJSONSerialization
                 JSONObjectWithData:returnedData
                 options:0
                 error:&error];
    
    if (error)
    {
        /* JSON was malformed, act appropriately here */
        NSLog(error.description);
    }
    
    if ([object isKindOfClass:[NSArray class]])
    {
        NSArray *results = object;
        firstVideo = results[0];
        if ([results count] > 1)
        {
            playlistCSV = results[1];
            for(int i = 2; i < [results count]; i++)
            {
                playlistCSV = [playlistCSV stringByAppendingFormat:@",%@", results[i]];
            }
        }
        NSLog(@"%@", playlistCSV);
        [self updateVideoView];
    }
    else
    {
        /* there's no guarantee that the outermost object in a JSON packet will be a dictionary; */
        NSLog(@"ERROR ERROR");
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSLog(@"web view finished loading");
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
    NSLog(@"also here");
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
    webView.mediaPlaybackRequiresUserAction = NO;
    [webView loadHTMLString:videoHTML baseURL:[[NSBundle mainBundle] resourceURL]];
}


@end
