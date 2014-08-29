//
//  OTAVideoListViewController_new.m
//  Off The Ave
//
//  Created by Kyle Parker on 11/16/12.
//  Copyright (c) 2012 North Avenue Studios. All rights reserved.
//

#import "OTAVideoListViewController.h"

@implementation OTAVideoListViewController
@synthesize tableViewController;

static NSString *const FEED_TYPE = @"json";
static const int POSTS_PER_PAGE = 20;

- (void)viewDidLoad
{
    [self.navigationController setNavigationBarHidden:false animated:true];
    
    self.title = @"Videos";
    self.tableViewController->parent = self;
    lastEntryCount = 0;
    page = 1;
    global = [OTAGlobals getInstance];
    
    [self loadData];
    
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:false animated:true];
}

- (void)requestFinished
{
    if([tableViewController.entries count] > lastEntryCount)
    {
        page++;
        lastEntryCount = (int)[tableViewController.entries count];
        
        [self loadData];
    }
}

- (void)loadData
{
    NSString* query = [NSString stringWithFormat:@"%@/?feed=%@&posts_per_page=%i&paged=%i", global.wordpressDomain, FEED_TYPE, POSTS_PER_PAGE, page];
    
    [tableViewController refreshWithUrl:query];
}
@end
