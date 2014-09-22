//
//  VideoEntryViewController.m
//  OffTheApp
//
//  Created by Zeb Long on 11/11/12.
//  Copyright (c) 2012 North Avenue Studios. All rights reserved.
//

#import "VideoEntryViewController.h"
#import "YouTube.h"
#import "Comment.h"
#import "Globals.h"

@implementation VideoEntryViewController
@synthesize videosListByArtistViewController=videosListByArtistViewController;
@synthesize entry;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    queue = [[NSOperationQueue alloc] init];
    
    videosListByArtistViewController->parent = self;
    
    [self.navigationController setNavigationBarHidden:false animated:true];
    self.title = entry.song;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(youtubeVideoExit:)
                                                 name:@"UIMoviePlayerControllerDidExitFullscreenNotification"
                                               object:nil];
    
    infoLabelView.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"labelBackground.png"]];
    commentLabelView.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"labelBackground.png"]];
    videosLabelView.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"labelBackground.png"]];
    
    Globals* global = [Globals getInstance];
    NSString* feed_url = [global.wordpressDomain stringByAppendingFormat:@"getSongInfo.php?id=%i", entry.ID];
    
    NSURL *url = [NSURL URLWithString:feed_url];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    
    [request setDelegate:self];
    [request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
    
    [queue addOperation:request];
    [videosListByArtistViewController refreshWithUrl:[global.wordpressDomain stringByAppendingFormat:@"getSongs.php?artistID=%i&excludeSongID=%i", entry.artistID, entry.ID ]];
    
    videoID = entry.videoID;
    NSLog(@"VIDEO ID: %@", videoID);
    
    [self updateVideoView];
    
    if(YouTube.canAuthorize && ![videoID  isEqual: @""])
    {
        [YouTube authenticateThen:@selector(checkIfVideoLiked:auth:error:) delegate:self viewController:self];
    }
    
    if(![videoID isEqual:@""])
    {
        [self fetchComments];
    }
    else
    {
        [commentLabelView setHidden:true];
        [commentTable setHidden:true];
        [commentTextField setHidden:true];
        likeButton.enabled = false;
        dislikeButton.enabled = false;
    }

}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if (navigationType == UIWebViewNavigationTypeLinkClicked)
    {
        [[UIApplication sharedApplication] openURL:[request URL]];
        
        return NO;
    }
    else if ( [[[request URL] scheme] isEqualToString:@"callback"] )
    {
        NSLog(@"get callback");
        
        return NO;
    }
    
    return YES;
}

// Called when description html is loaded
- (void)webViewDidFinishLoad:(UIWebView *)aWebView
{
    if(aWebView == descriptionWebView)
    {
        aWebView.scrollView.scrollEnabled = NO;    // Property available in iOS 5.0 and later
        CGRect frame = aWebView.frame;
        
        frame.size.width = self.view.frame.size.width;       // Your desired width here.
        frame.size.height = 1;        // Set the height to a small one.
        
        aWebView.frame = frame;       // Set webView's Frame, forcing the Layout of its embedded scrollView with current Frame's constraints (Width set above).
        
        frame.size.height = aWebView.scrollView.contentSize.height;  // Get the corresponding height from the webView's embedded scrollView.
        
        aWebView.frame = frame;       // Set the scrollView contentHeight back to the frame itself.
        
        NSLog(@"description loaded");
        [self correctLayout];
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
        NSLog(@"%@", error.description);
    }
    
    if ([object isKindOfClass:[NSDictionary class]])
    {
        NSDictionary *result = object;
        
        
        NSString* descriptionHTML = [NSString stringWithFormat:@"<html> \n"
                                       "<head> \n"
                                       "<style type=\"text/css\"> \n"
                                       "body {font-family: \"%@\"; font-size: %@;}\n"
                                       "</style> \n"
                                       "</head> \n"
                                       "<body>%@</body> \n"
                                       "</html>", [UIFont fontWithName:@"Helvetica" size:12].familyName, [NSNumber numberWithInt:12], [result valueForKey:@"description"]];
        [descriptionWebView loadHTMLString:descriptionHTML baseURL:nil];
        
    }
    else
    {
        /* there's no guarantee that the outermost object in a JSON packet will be a dictionary; */
        NSLog(@"ERROR ERROR");
    }
}

- (void) updateVideoView
{
    NSString* videoHTML = [NSString stringWithFormat:@"\
           <html>\
               <head>\
                   <style type=\"text/css\">\
                       body {background-color:#000; margin:0;}\
                   </style>\
               </head>\
               <body>\
                   <iframe width=\"100%%\"\
                           height=\"180px\"\
                           src=\"http://www.youtube.com/embed/%@/?modestbranding=1&controls=2&rel=0&iv_load_policy=3&showinfo=0&autoplay=1&playerapiid=ytplayer&version=3\"\
                           frameborder=\"0\"\
                           allowfullscreen>\
                   </iframe>\
               </body>\
           </html>",
            videoID
       ];
    
    [videoWebView loadHTMLString:videoHTML baseURL:nil];
}

- (void)fetchComments
{
    NSLog(@"Fetching comments");
    NSString* urlString = [[@"https://gdata.youtube.com/feeds/api/videos/" stringByAppendingString:videoID] stringByAppendingString:@"/comments?v=2"];
    NSURL *url = [NSURL URLWithString:urlString];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    
    [request setDelegate:self];
    [request setDidFinishSelector:@selector(displayComments:)];
    [request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
    
    [queue addOperation:request];
}

- (void)displayComments:(ASIHTTPRequest *)request
{
    [queue addOperationWithBlock:^{
		
        NSError *error;
        NSData* responseData = [request responseData];
        GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:responseData
                                                               options:0
                                                                 error:&error];
        if (doc == nil)
        {
            [descriptionWebView loadHTMLString:@"failed to parse" baseURL:nil];
        }
        else
        {
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                NSArray *comments = [doc.rootElement elementsForName:@"entry"];
                int i = 0;
                for (GDataXMLElement *comment in comments)
                {
                    NSString* commentText   = [comment valueForChild:@"content"];
                    NSString* commentAuthor = [[comment elementForChild:@"author"] valueForChild:@"name"];
                    [self addComment:commentText withAuthor:commentAuthor atIndex:i];
                    
                    i++;
                }
                NSLog(@"comments loaded");
                [self correctLayout];
            }];
        }
    }];
	
}

- (void)addComment:(NSString*)commentText
        withAuthor:(NSString*)author
           atIndex:(int)index
{
    [commentTableController.comments insertObject:[[Comment alloc] init:commentText author:author] atIndex:index];
    
    NSIndexPath* indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    NSArray* indexPathArray = [NSArray arrayWithObject:[NSIndexPath indexPathForRow:index inSection:0]];
    [commentTable insertRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationNone];
    
    UITableViewCell* cell = [commentTableController tableView:commentTable cellForRowAtIndexPath:indexPath];
    CGSize size = [commentText sizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:CGSizeMake(cell.frame.size.width - 20, 500)];
    commentTableController.totalRowHeight += size.height+35;
}

- (void)correctLayout
{
    NSLog(@"correcting layout");
    
    [descriptionWebView setFrame:CGRectMake(descriptionWebView.frame.origin.x, descriptionWebView.frame.origin.y, commentTextField.frame.size.width, descriptionWebView.frame.size.height)];
    // Fit description label to text size
    [descriptionWebView sizeToFit];
    
    
    if (videosListByArtistViewController.entries.count > 0)
    {
        [videosTable setHidden:FALSE];
        [videosLabelView setHidden:FALSE];
        [videosLabelView setFrame:CGRectMake(0.0, descriptionWebView.frame.origin.y+descriptionWebView.frame.size.height, videosLabelView.frame.size.width, videosLabelView.frame.size.height)];
        // Make sure the "Videos" table sits just beneath the description text
        [videosTable setFrame:CGRectMake(0.0, videosLabelView.frame.origin.y+videosLabelView.frame.size.height, videosTable.frame.size.width, videosTable.frame.size.height)];
        // Make sure the "Comments" title sits just beneath the videos table
        [commentLabelView setFrame:CGRectMake(0.0, videosTable.frame.origin.y+videosTable.frame.size.height, commentLabelView.frame.size.width, commentLabelView.frame.size.height)];
    }
    else
    {
        [videosLabelView setHidden:TRUE];
        [videosTable setHidden:TRUE];
        // Make sure the "Comments" title sits just beneath the description
        [commentLabelView setFrame:CGRectMake(0.0, descriptionWebView.frame.origin.y+descriptionWebView.frame.size.height, commentLabelView.frame.size.width, commentLabelView.frame.size.height)];
    }
    
    // Make sure the comment text field sits just beneath the "Comments" title
    [commentTextField setFrame:CGRectMake(commentTextField.frame.origin.x, commentLabelView.frame.origin.y + commentLabelView.frame.size.height+10, commentTextField.frame.size.width, commentTextField.frame.size.height)];
    
    // Make sure the comment list sits just below the comment text field and is just tall enough to fit the content
    CGRect tempFrame = commentTable.frame;
    float rowHeight = commentTableController.totalRowHeight;
    tempFrame.origin.y = commentTextField.frame.origin.y + commentTextField.frame.size.height;
    tempFrame.size.height = rowHeight;
    [commentTable setFrame:tempFrame];
    
    // Set the scroll view's content height to just past the last element (in this case the table view)
    [scrollView setContentSize:CGSizeMake(scrollView.frame.size.width, tempFrame.origin.y + tempFrame.size.height + 10)];
}


- (void)youtubeVideoExit:(id)sender
{
    [[UIApplication sharedApplication] setStatusBarOrientation:UIDeviceOrientationPortrait animated:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)checkIfVideoLiked:(GTMOAuth2ViewControllerTouch *)viewController
                    auth:(GTMOAuth2Authentication *)auth
                   error:(NSError *)error
{
    NSLog(@"Check if video liked");
    Globals* globals = [Globals getInstance];
    GTLServiceYouTube *service = YouTube.youTubeService;
    service.shouldFetchNextPages = FALSE;
    GTLQueryYouTube *query2 = [GTLQueryYouTube queryForPlaylistItemsListWithPart:@"contentDetails"];
    query2.playlistId = globals.likePlaylistID;
    query2.videoId = videoID;
    query2.maxResults = 1;
    
    [service executeQuery:query2 completionHandler:^(GTLServiceTicket *ticket2, GTLYouTubePlaylistItemListResponse *videoList, NSError *error2)
    {
        NSLog(@"done checking video liked");
        if([[videoList items] count] > 0)
        {
            NSLog(@"%@", [[[videoList items] objectAtIndex:0] identifier]);
            likeButton.enabled = false;
        }
        else
        {
            likeButton.enabled = true;
        }
    }];
}

-(IBAction)likeVideo:(id)sender
{
    NSLog(@"like video");
    [YouTube authenticateThen: @selector(likeVideoAuthenticated:auth:error:) delegate:self viewController:self];
}

- (IBAction)dislikeVideo:(id)sender
{
    [YouTube authenticateThen: @selector(dislikeVideoAuthenticated:auth:error:) delegate:self viewController:self];
}

-(IBAction)addComment:(id)sender
{
    [YouTube authenticateThen: @selector(addCommentAuthenticated:auth:error:) delegate:self viewController:self];
}

- (IBAction)startEditingComment:(id)sender
{
    [scrollView setContentOffset:CGPointMake(0, commentLabelView.frame.origin.y) animated:YES];
}

-(void)addCommentAuthenticated:(GTMOAuth2ViewControllerTouch *)viewController
                         auth:(GTMOAuth2Authentication *)auth
                        error:(NSError *)error
{
    Globals* globals = [Globals getInstance];
    GDataServiceGoogleYouTube* service = YouTube.youTubeServiceGData;
    
    NSString* videoURL = [@"https://gdata.youtube.com/feeds/api/videos/" stringByAppendingString:videoID];
    [service fetchEntryWithURL:[NSURL URLWithString:videoURL] completionHandler:^(GDataServiceTicket *ticket, GDataEntryBase *video, NSError *error)
    {
        GDataEntryYouTubeVideo* videoEntry = (GDataEntryYouTubeVideo*)video;
        NSLog(@"%@", videoEntry.comment.feedLink.URL);
        GDataEntryYouTubeComment *newCommentEntry = [GDataEntryYouTubeComment commentEntry];
        [newCommentEntry setContentWithString:commentTextField.text];
        [service fetchEntryByInsertingEntry:newCommentEntry forFeedURL:videoEntry.comment.feedLink.URL completionHandler:^(GDataServiceTicket *ticket, GDataEntryBase *entry, NSError *error)
        {
            if (error == nil)
            {
                [self addComment:commentTextField.text withAuthor:globals.username atIndex:0];
                commentTextField.text = @"";
                [self correctLayout];
            }
            else
            {
                NSLog(@"%@", error.description);
            }
        }];
    }];
}

-(void)dislikeVideoAuthenticated:(GTMOAuth2ViewControllerTouch *)viewController
                            auth:(GTMOAuth2Authentication *)auth
                           error:(NSError *)error
{
    NSLog(@"Dislike video authenticated");
    GDataServiceGoogleYouTube* service = YouTube.youTubeServiceGData;
    
    NSString* videoURL = [@"https://gdata.youtube.com/feeds/api/videos/" stringByAppendingString:videoID];
    [service fetchEntryWithURL:[NSURL URLWithString:videoURL] completionHandler:^(GDataServiceTicket *ticket, GDataEntryBase *video, NSError *error)
    {
         GDataEntryYouTubeVideo* videoEntry = (GDataEntryYouTubeVideo*)video;
         NSLog(@"%@", videoEntry.ratingsLink);
         GDataEntryYouTubeRating *newRating = [GDataEntryYouTubeRating ratingEntryWithValue:@"dislike"];
         [service fetchEntryByInsertingEntry:newRating forFeedURL:videoEntry.ratingsLink.URL completionHandler:^(GDataServiceTicket *ticket, GDataEntryBase *entry, NSError *error)
         {
              if (error == nil)
              {
                  likeButton.enabled = true;
                  dislikeButton.enabled = false;
              }
              else
              {
                  NSLog(@"%@", error.description);
              }
         }];
    }];
}

-(void)likeVideoAuthenticated:(GTMOAuth2ViewControllerTouch *)viewController
                         auth:(GTMOAuth2Authentication *)auth
                        error:(NSError *)error
{
    NSLog(@"Like video authenticated");
    Globals* globals = [Globals getInstance];
    GTLYouTubePlaylistItem *playlistItem = [[GTLYouTubePlaylistItem alloc] init];
    playlistItem.snippet = [[GTLYouTubePlaylistItemSnippet alloc] init];
    playlistItem.snippet.playlistId = globals.likePlaylistID;
    playlistItem.snippet.resourceId = [[GTLYouTubeResourceId alloc] init];
    playlistItem.snippet.resourceId.kind = @"youtube#video";
    playlistItem.snippet.resourceId.videoId = videoID;
    
    GTLQueryYouTube *query = [GTLQueryYouTube queryForPlaylistItemsInsertWithObject:playlistItem part:@"snippet"];
    query.mine = YES;
    query.maxResults = 1;
    
    [YouTube.youTubeService executeQuery:query completionHandler:^(GTLServiceTicket *ticket, GTLYouTubeChannelListResponse *channelList, NSError *error) {}];
    likeButton.enabled = false;
    dislikeButton.enabled = true;
}


@end
