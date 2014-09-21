//
//  OTAVideoListViewController_new.m
//  Off The Ave
//
//  Created by Kyle Parker on 11/16/12.
//  Copyright (c) 2012 North Avenue Studios. All rights reserved.
//

#import "VideoListViewController.h"

@implementation VideoListViewController
@synthesize tableViewController;

- (void)viewDidLoad
{
    [self.navigationController setNavigationBarHidden:false animated:true];
    
    self.title = @"Videos";
    tableViewController->parent = self;
    tableViewController->isPaginated = true;
    
    if (filterByGenre != 0)
    {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPlay target:tableViewController action:@selector(playAll)];
        [tableViewController refreshWithUrl:[self.tableViewController->feed_url stringByAppendingFormat:@"&genreID=%i", filterByGenre]];
    }
    else
    {
        [tableViewController refresh];
    }
    
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:false animated:true];
}

@end
