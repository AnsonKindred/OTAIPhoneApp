//
//  OTAPlaylistViewController.m
//  Off The Ave
//
//  Created by Kyle Parker on 2/9/13.
//  Copyright (c) 2013 North Avenue Studios. All rights reserved.
//

#import "OTAPlaylistListViewController.h"

@implementation OTAPlaylistListViewController

- (void)viewDidLoad
{
    [self.navigationController setNavigationBarHidden:false animated:true];
    [super viewDidLoad];
    self.title = @"Playlists";
    tableViewController->parent = self;
    [tableViewController refresh];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:false animated:true];
}

@end
