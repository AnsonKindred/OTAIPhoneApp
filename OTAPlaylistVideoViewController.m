//
//  OTAPlaylistVideoViewController.m
//  Off The Ave
//
//  Created by Kyle Parker on 2/11/13.
//  Copyright (c) 2013 North Avenue Studios. All rights reserved.
//

#import "OTAPlaylistVideoViewController.h"
#import "OTAYouTube.h"

@implementation OTAPlaylistVideoViewController
@synthesize playlistEntry;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:@"OTAVideoEntryViewController" bundle:nibBundleOrNil];
    if (self) {
        playlistEntry = nil;
    }
    return self;
}

- (void)viewDidLoad
{
    queue = [[NSOperationQueue alloc] init];
    
    [self.navigationController setNavigationBarHidden:false animated:true];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(youTubeVideoExit:)
                                                 name:@"UIMoviePlayerControllerDidExitFullscreenNotification"
                                               object:nil];
    
    infoLabelView.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"labelBackground.png"]];
    commentLabelView.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"labelBackground.png"]];
    videosLabelView.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"labelBackground.png"]];
    
    if(playlistEntry != nil)
    {
        NSArray* playlistIDparts = [playlistEntry.identifier componentsSeparatedByString:@":"];
        NSString* playlistID = playlistIDparts[[playlistIDparts count] - 1];
        NSString* urlString = [[@"https://gdata.youtube.com/feeds/api/playlists/" stringByAppendingString:playlistID] stringByAppendingString:@"?v=2&orderby=title"];
        NSURL* url = [NSURL URLWithString:urlString];
        
        ASIHTTPRequest* request = [ASIHTTPRequest requestWithURL:url];
        
        [request setDelegate:self];
        [request setDidFinishSelector:@selector(loadPlaylistData:)];
        
        [queue addOperation:request];
    }
    else
    {
        [self fetchVideoMetaData];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
}

- (void) fetchVideoMetaData
{
    // Grab the rest of the video meta data from youtube
//    GDataServiceGoogleYouTube* service = OTAYouTube.youTubeServiceGData;
//    service.authorizer = nil;
//    NSString* urlString = [@"https://gdata.youtube.com/feeds/api/videos/" stringByAppendingString:entry.youtubeVideoID];
//    
//    [service fetchEntryWithURL:[NSURL URLWithString:urlString] completionHandler:^(GDataServiceTicket *ticket, GDataEntryBase *video, NSError *error)
//     {
//         GDataEntryYouTubeVideo* videoEntry = (GDataEntryYouTubeVideo*)video;
//         entry.description = videoEntry.mediaGroup.mediaDescription.stringValue;
//         descriptionLabel.text = entry.description;
//         entry.videoUrl = [entry.videoUrl stringByReplacingOccurrencesOfString:@"watch?v=" withString:@"embed/"];
//         if(playlistEntry != nil)
//         {
//             NSArray *playlistIDparts = [playlistEntry.identifier componentsSeparatedByString:@":"];
//             NSString *playlistID = playlistIDparts[[playlistIDparts count] - 1];
//             entry.videoUrl = [[entry.videoUrl stringByAppendingString:@"?list="] stringByAppendingString:playlistID];
//         }
//         NSLog(entry.videoUrl);
//         self.title = entry.song;
//         
//         NSString* videoHTML = [NSString stringWithFormat:@"\
//                                <html>\
//                                <head>\
//                                <style type=\"text/css\">\
//                                body {background-color:#000; margin:0;}\
//                                </style>\
//                                </head>\
//                                <body>\
//                                <iframe width=\"100%%\" height=\"180px\" src=\"%@\" frameborder=\"0\" allowfullscreen></iframe>\
//                                </body>\
//                                </html>", entry.videoUrl];
//         [videoWebView loadHTMLString:videoHTML baseURL:nil];
//         
//         [self correctLayout];
//         
//         if(entry.youtubeVideoID != @"")
//         {
//             [super fetchComments];
//         }
//         else
//         {
//             [commentLabelView setHidden:true];
//             [commentTable setHidden:true];
//             [commentTextField setHidden:true];
//             likeButton.enabled = false;
//             dislikeButton.enabled = false;
//         }
//     }];
}

- (void) loadPlaylistData:(ASIHTTPRequest *)request
{
    NSLog(@"Loading playlist data");
    NSError *error;
    NSData* responseData = [request responseData];
    GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:responseData
                                                           options:0
                                                             error:&error];
    NSLog(@"%@", error.description);
    if (doc == nil)
    {
        NSLog(@"failed to parse");
    }
    else
    {
        NSArray *videos = [doc.rootElement elementsForName:@"entry"];
        entry = [OTAYouTube parseVideo:videos[0]];
        NSLog(entry.song);
        [self fetchVideoMetaData];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
