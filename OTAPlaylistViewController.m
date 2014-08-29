//
//  OTAPlaylistViewController.m
//  Off The Ave
//
//  Created by Kyle Parker on 2/10/13.
//  Copyright (c) 2013 North Avenue Studios. All rights reserved.
//

#import "OTAPlaylistViewController.h"

@implementation OTAPlaylistViewController
@synthesize entry;

- (void)viewDidLoad
{
    [self.navigationController setNavigationBarHidden:false animated:true];
    [super viewDidLoad];
    self.title = @"Videos";
    tableViewController->parent = self;
    NSArray *playlistIDparts = [entry.identifier componentsSeparatedByString:@":"];
    NSString *playlistID = playlistIDparts[[playlistIDparts count] - 1];
    tableViewController->playlistUrl = [@"https://gdata.youtube.com/feeds/api/playlists/" stringByAppendingString:playlistID];
    [tableViewController refresh];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:false animated:true];
}
@end
