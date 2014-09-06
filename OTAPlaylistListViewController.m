//
//  OTAPlaylistViewController.m
//  Off The Ave
//
//  Created by Kyle Parker on 2/9/13.
//  Copyright (c) 2013 North Avenue Studios. All rights reserved.
//

#import "OTAPlaylistListViewController.h"

@implementation OTAPlaylistListViewController
@synthesize tableViewController;

- (void)viewDidLoad
{
    [self.navigationController setNavigationBarHidden:false animated:true];
    [super viewDidLoad];
	
    self.title = @"Playlists";
    self.tableViewController->parent = self;
    self.tableViewController->isPaginated = true;
    OTAGlobals* global = [OTAGlobals getInstance];
    [tableViewController refreshWithUrl:[global.wordpressDomain stringByAppendingFormat:@"getGenres.php?posts_per_page=%i", 20]];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:false animated:true];
}

@end
