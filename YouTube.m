//
//  OTAYouTube.m
//  Off The Ave
//
//  Created by Kyle Parker on 2/4/13.
//  Copyright (c) 2013 North Avenue Studios. All rights reserved.
//

#import "YouTube.h"
#import "Globals.h"

@implementation YouTube

SEL authenticateThenAction;
id authenticateThenDelegate;

NSString* kKeychainItemName = @"OTA: OAuth2 Youtube";
NSString* kMyClientID = @"173918856707.apps.googleusercontent.com";
NSString* kMyClientSecret = @"TeK7s5plYxU_sjaSaLNViYxy";
NSString* scope = @"https://www.googleapis.com/auth/youtube";
NSString* developerKey = @"AI39si4lqh87sRiuNbPH3kisvTBlKQUrLx5qEFRXB8lTXkKfjh1aVH-LyUuIMZn9GeL-fSkmP7_vNASrQ_8umyCvPBi0wi2Oqw";

+ (void)authenticateThen:(SEL)fn
                delegate:(id)delegate
          viewController:(UIViewController*)viewController
{
    authenticateThenAction = fn;
    authenticateThenDelegate = delegate;
    NSLog(@"Authenticate then");
    if(!YouTube.canAuthorize)
    {
        GTMOAuth2ViewControllerTouch *loginViewController;
        loginViewController = [[GTMOAuth2ViewControllerTouch alloc] initWithScope:scope
                                                                    clientID:kMyClientID
                                                                clientSecret:kMyClientSecret
                                                            keychainItemName:kKeychainItemName
                                                                    delegate:self
                                                                 finishedSelector:@selector(doneAuthenticating:auth:error:)];
        [[viewController navigationController] pushViewController:loginViewController animated:YES];
    }
    else
    {
        [self doneAuthenticating:nil auth:YouTube.youTubeService.authorizer error:nil];
    }
}

+ (void) doneAuthenticating:(UIViewController*)viewController
                       auth:(GTMOAuth2Authentication*)auth
                      error:(NSError*)error
{
    NSLog(@"Done authenticating");
    // Check if we have the user's info, if not grab it
    Globals* globals = [Globals getInstance];
    NSLog(@"%@", globals.username);
    NSLog(@"%@", globals.likePlaylistID);
    if(globals.username == nil || [globals.username  isEqual: @""])
    {
        NSLog(@"Fetching user info");
        [YouTube.youTubeServiceGData fetchEntryWithURL:[NSURL URLWithString:@"https://gdata.youtube.com/feeds/api/users/default"]
                                        completionHandler:^(GDataServiceTicket *ticket, GDataEntryBase *userProfileEntry, NSError *error)
        {
            GDataEntryYouTubeUserProfile* userProfile = (GDataEntryYouTubeUserProfile*)userProfileEntry;
            globals.username = userProfile.username;
            NSLog(@"%@", globals.username);
            GTLQueryYouTube *query = [GTLQueryYouTube queryForChannelsListWithPart:@"contentDetails"];
            query.mine = YES;
            query.maxResults = 1;
            [YouTube.youTubeService executeQuery:query
                                  completionHandler:^(GTLServiceTicket *ticket, GTLYouTubeChannelListResponse *channelList, NSError *error)
            {
                if(error != nil)
                {
                    NSLog(@"%@", error.description);
                }
                else if ([[channelList items] count] > 0)
                {
                     GTLYouTubeChannel *channel = channelList[0];
                     
                     globals.likePlaylistID = channel.contentDetails.relatedPlaylists.likes;
                     NSLog(@"%@", globals.likePlaylistID);
                     [self donePostAuthenticating:viewController auth:auth error:error];
                 }
            }];
        }];
    }
    else
    {
        [self donePostAuthenticating:viewController auth:auth error:error];
    }
    
}

+ (void) donePostAuthenticating:(UIViewController*)viewController
                           auth:(GTMOAuth2Authentication*)auth
                          error:(NSError*)error
{
    NSLog(@"Done post-authenticating");
    // Call post-authentication method from original 'authenticateThen' call
    NSMethodSignature *sig = [authenticateThenDelegate methodSignatureForSelector:authenticateThenAction];
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:sig];
    [invocation setSelector:authenticateThenAction];
    [invocation setTarget:authenticateThenDelegate];
    if(viewController != nil)
    {
        [invocation setArgument:viewController atIndex:2];
    }
    [invocation setArgument:YouTube.youTubeService.authorizer atIndex:3];
    if(error != nil)
    {
        [invocation setArgument:error atIndex:4];
    }
    [invocation invoke];
}

+ (Boolean) canAuthorize
{
    return ((GTMOAuth2Authentication*)YouTube.youTubeService.authorizer).canAuthorize;
}

+ (GTLServiceYouTube *)youTubeService
{
    static GTLServiceYouTube *service;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        service = [[GTLServiceYouTube alloc] init];
        
        // Have the service object set tickets to fetch consecutive pages
        // of the feed so we do not need to manually fetch them.
        service.shouldFetchNextPages = YES;
        
        // Have the service object set tickets to retry temporary error conditions
        // automatically.
        service.retryEnabled = YES;
    });
    
    service.authorizer = [GTMOAuth2ViewControllerTouch authForGoogleFromKeychainForName:kKeychainItemName
                                                                               clientID:kMyClientID
                                                                           clientSecret:kMyClientSecret];
    
    return service;
}

+ (GDataServiceGoogleYouTube *)youTubeServiceGData
{
    static GDataServiceGoogleYouTube *service;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        service = [[GDataServiceGoogleYouTube alloc] init];
        service.youTubeDeveloperKey = developerKey;
    });
    
    service.authorizer = [GTMOAuth2ViewControllerTouch authForGoogleFromKeychainForName:kKeychainItemName
                                                                               clientID:kMyClientID
                                                                           clientSecret:kMyClientSecret];
    return service;
}

//+ (EntrySession*) parseVideo:(GDataXMLElement*)video
//{
//    NSString* dataString = [video valueForChild:@"title"];
//    NSArray* data = [dataString componentsSeparatedByString:@"|"];
//    if([data count] == 2)
//    {
//        dataString = data[0];
//    }
//    data = [dataString componentsSeparatedByString:@"\""];
//    NSString *artist;
//    NSString *song;
//    if([data count] >= 2)
//    {
//        artist = data[0];
//        song = data[1];
//    }
//    else
//    {
//        data = [dataString componentsSeparatedByString:@"-"];
//        if([data count] >= 2)
//        {
//            artist = data[0];
//            song = data[1];
//            if([song characterAtIndex:0] == ' ')
//            {
//                song = [song substringFromIndex:1];
//            }
//        }
//        else
//        {
//            artist = @"";
//            song = dataString;
//        }
//    }
//    
//    NSString* youtubeVideoID = @"";
//    NSString* videoUrl = @"";
//    NSError* error = nil;
//    NSArray* playerNode = [video nodesForXPath:@"./media:group/media:player" error:&error];
//    
//    if([playerNode count] > 0)
//    {
//        GDataXMLNode* attr = [playerNode[0] attributeForName:@"url"];
//        videoUrl = attr.stringValue;
//        
//        if(videoUrl != nil && ![videoUrl isEqualToString:@""])
//        {
//            NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"\\watch\\?v=([a-zA-Z0-9\\-_]+)(&.*)|$\\b"
//                                                                                   options:NSRegularExpressionCaseInsensitive
//                                                                                     error:&error];
//            NSTextCheckingResult *match = [regex firstMatchInString:videoUrl
//                                                            options:0
//                                                              range:NSMakeRange(0, [videoUrl length])];
//            
//            if (!NSEqualRanges([match rangeAtIndex:1], NSMakeRange(NSNotFound, 0)) && [match rangeAtIndex:1].location != 0)
//            {
//                youtubeVideoID = [videoUrl substringWithRange:[match rangeAtIndex:1]];
//                if (!NSEqualRanges([match rangeAtIndex:2], NSMakeRange(NSNotFound, 0)) && [match rangeAtIndex:2].location != 0)
//                {
//                    videoUrl = [videoUrl stringByReplacingOccurrencesOfString:[videoUrl substringWithRange:[match rangeAtIndex:2]] withString:@""];
//                }
//            }
//        }
//    } 
//    
//    return [[EntrySession alloc] init:artist
//                                song:song
//                            videoUrl:videoUrl
//                      youtubeVideoID:youtubeVideoID];
//}

@end
