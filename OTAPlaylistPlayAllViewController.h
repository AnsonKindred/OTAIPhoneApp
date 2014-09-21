//
//  OTAPlaylistPlayAllViewController.h
//  Off The Ave
//
//  Created by Kyle Parker on 2/16/13.
//  Copyright (c) 2013 North Avenue Studios. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "EntrySession.h"

@interface OTAPlaylistPlayAllViewController : UIViewController <UIWebViewDelegate>
{
    IBOutlet UIWebView* webView;
    NSOperationQueue* queue;
    
    NSMutableArray* playlist;
    NSString* playlistCSV;
    NSString* firstVideo;
    
    int currentPlayerState, playlistIndex;
}

@property (strong, nonatomic) IBOutlet UIWebView *webView;
@property (retain) NSMutableArray* playlist;
@property (retain) NSString* playlistCSV;
@property (retain) NSString* firstVideo;

@end
