//
//  OTAPlaylistPlayAllViewController.h
//  Off The Ave
//
//  Created by Kyle Parker on 2/16/13.
//  Copyright (c) 2013 North Avenue Studios. All rights reserved.
//
#import <UIKit/UIKit.h>

@interface OTAPlaylistPlayAllViewController : UIViewController
{
    IBOutlet UIWebView* webView;
    
    NSString* playlistURL;
}

@property (strong, nonatomic) IBOutlet UIWebView *webView;
@property (strong) NSString* playlistURL;

@end
