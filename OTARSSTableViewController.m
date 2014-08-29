//
//  OTARSSTableViewController.m
//  Off The Ave
//
//  Created by Zeb Long on 11/15/12.
//  Copyright (c) 2012 North Avenue Studios. All rights reserved.
//

#import "OTARSSTableViewController.h"
#import "GTMNSString+HTML.h"

@implementation OTARSSTableViewController
@synthesize entries;
@synthesize filteredEntries, savedSearchTerm, savedScopeButtonIndex, searchWasActive;

- (void)viewDidLoad
{
    [super viewDidLoad];
    entries = [[NSMutableArray array] retain];
    queue = [[NSOperationQueue alloc] init];
    
    // create a filtered list that will contain products for the search results table.
    self.filteredEntries = [NSMutableArray arrayWithCapacity:[self.entries count]];
    
    // restore search settings if they were saved in didReceiveMemoryWarning.
    if (self.savedSearchTerm)
    {
        [self.searchDisplayController setActive:self.searchWasActive];
        [self.searchDisplayController.searchBar setSelectedScopeButtonIndex:self.savedScopeButtonIndex];
        [self.searchDisplayController.searchBar setText:savedSearchTerm];
        
        self.savedSearchTerm = nil;
    }
    
    //[ASIHTTPRequest setDefaultCache:[ASIDownloadCache sharedCache]];
    //[[ASIDownloadCache sharedCache] setShouldRespectCacheControlHeaders:NO];
}

- (void)viewDidUnload
{
    self.filteredEntries = nil;
}

- (void)viewDidDisappear:(BOOL)animated
{
    // save the state of the search UI so that it can be restored if the view is re-created
    self.searchWasActive = [self.searchDisplayController isActive];
    self.savedSearchTerm = [self.searchDisplayController.searchBar text];
    self.savedScopeButtonIndex = [self.searchDisplayController.searchBar selectedScopeButtonIndex];
}

- (void)refreshWithUrl:(NSString*)url {
    feed_url = url;
    [self refresh];
}

- (void)refresh {
    NSURL *url = [NSURL URLWithString:feed_url];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    
    [request setDelegate:self];
    
    [request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
    [queue addOperation:request];
}

- (void)requestFinished:(ASIHTTPRequest *)request {
    NSData* returnedData = [request responseData];
    
    NSError *error = nil;
    id object = [NSJSONSerialization
                 JSONObjectWithData:returnedData
                 options:0
                 error:&error];
    
    if (error)
    {
        /* JSON was malformed, act appropriately here */
        NSLog(@"ERROR ERROR");
    }
    
    if ([object isKindOfClass:[NSArray class]])
    {
        NSArray *results = object;
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [self parseFeedJSON:results];
            if(parent != nil) [parent requestFinished];
        }];
    }
    else
    {
        /* there's no guarantee that the outermost object in a JSON packet will be a dictionary; */
        NSLog(@"ERROR ERROR");
    }
    
    /*[queue addOperationWithBlock:^{
		
        NSError *error;
        NSData* responseData = [request responseData];
        GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:responseData
                                                               options:0
                                                                 error:&error];
        if (doc == nil)
        {
            NSLog(@"Failed to parse %@", request.url);
        }
        else
        {
			
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                [self parseFeed:doc.rootElement];
                if(parent != nil)
                {
                    [parent requestFinished];
                }
            }];
			
        }
    }];*/
	
}

- (void)parseFeedJSON:(NSArray *)items
{
    for (NSDictionary *item in items)
    {
        OTARSSEntry *entry = [[OTARSSEntry alloc] init:item];
        
        [entries addObject:entry];
        
        [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:[entries count]-1 inSection:0]]
                              withRowAnimation:UITableViewRowAnimationTop];
    }
}

//- (void)parseFeed:(GDataXMLElement *)rootElement {
//	
//    NSArray *channels = [rootElement elementsForName:@"channel"];
//    for (GDataXMLElement *channel in channels) {
//		
//        NSArray *items = [channel elementsForName:@"item"];
//        for (GDataXMLElement *item in items) {
//			
//            NSString *title = [item valueForChild:@"title"];
//            NSString *artist = [[[item valueForChild:@"artist"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding] stringByReplacingOccurrencesOfString:@"+" withString:@" "];
//            NSString *song = [[[item valueForChild:@"song"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding] stringByReplacingOccurrencesOfString:@"+" withString:@" "];
//            NSString *url = [item valueForChild:@"link"];
//			NSString *description = [item valueForChild:@"description"];
//			NSString *thumbnail = [item valueForChild:@"thumbnail"];
//            NSString *videoUrl = [item valueForChild:@"videoUrl"];
//            NSString *blipVideoUrl = [item valueForChild:@"blipVideoUrl"];
//            
//            NSString *youtubeVideoID = @"";
//            
//            if(description.length > 0 && [description characterAtIndex:0] == '\n')
//            {
//                description = [description substringWithRange:NSMakeRange(1, [description length]-1)];
//            }
//            
//            description = [[description gtm_stringByUnescapingFromHTML] stringByReplacingOccurrencesOfString:@"Share on Facebook" withString:@""];
//            
//            if(blipVideoUrl.length > 0)
//            {
//                videoUrl = [blipVideoUrl stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//            }
//            else
//            {
//                videoUrl = [videoUrl stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//            
//                NSError *error = NULL;
//                NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"\\watch\\?v=([a-zA-Z0-9\\-_]+)(&|$)\\b"
//                                                                                       options:NSRegularExpressionCaseInsensitive
//                                                                                         error:&error];
//                NSTextCheckingResult *match = [regex firstMatchInString:videoUrl
//                                                                options:0
//                                                                  range:NSMakeRange(0, [videoUrl length])];
//            
//            
//                if (!NSEqualRanges([match rangeAtIndex:1], NSMakeRange(NSNotFound, 0)) && [match rangeAtIndex:1].location != 0)
//                {
//                    youtubeVideoID = [videoUrl substringWithRange:[match rangeAtIndex:1]];
//                }
//                else
//                {
//                    // Not a youtube video, check for vimeo
//                    regex = [NSRegularExpression regularExpressionWithPattern:@"\\vimeo.com/([0-9]+)(\\?|$)\\b"
//                                                                      options:NSRegularExpressionCaseInsensitive
//                                                                        error:&error];
//                    match = [regex firstMatchInString:videoUrl
//                                              options:0
//                                                range:NSMakeRange(0, [videoUrl length])];
//                    if (!NSEqualRanges([match rangeAtIndex:1], NSMakeRange(NSNotFound, 0)) && [match rangeAtIndex:1].location != 0)
//                    {
//                        NSString* vimeoID = [videoUrl substringWithRange:[match rangeAtIndex:1]];
//                        videoUrl = [@"http://player.vimeo.com/video/" stringByAppendingString:vimeoID];
//                    }
//                }
//            }
//            
//            thumbnail = [thumbnail stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//            NSString *artistTag = [item valueForChild:@"artistTag"];
//            NSString *date = [item valueForChild:@"date"];
//            NSInteger numPosts = [[item valueForChild:@"numPosts"] integerValue];
//            
//			
//            OTARSSEntry *entry = [[OTARSSEntry alloc] init:title
//                                                       url:url
//                                                      date:date
//                                               description:description
//                                                 thumbnail:thumbnail
//                                                 artistTag:artistTag
//                                                  videoUrl:videoUrl
//                                            youtubeVideoID:youtubeVideoID
//                                                  numPosts:numPosts
//                                                    artist:artist
//                                                      song:song];
//            [entries addObject:entry];
//            [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:[entries count]-1 inSection:0]]
//                                  withRowAnimation:UITableViewRowAnimationTop];
//        }
//    }
//	
//}

- (void)requestFailed:(ASIHTTPRequest *)request {
    NSError *error = [request error];
    NSLog(@"Error: %@", error);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    /*
     If the requesting table view is the search display controller's table view, return the count of
     the filtered list, otherwise return the count of the main list.
     */
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        return [self.filteredEntries count];
    }
    else if (self.entries != nil)
    {
        return [self.entries count];
    }
    else
    {
        return 0;
    }
}

// Customize the appearance of table view cells.
- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath {
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
    }
	
    /*
     If the requesting table view is the search display controller's table view, configure the cell using the filtered content, otherwise use the main list.
     */
    OTARSSEntry* entry = nil;
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        entry = [filteredEntries objectAtIndex:indexPath.row];
    }
    else
    {
        entry = [entries objectAtIndex:indexPath.row];
    }
	
    cell.textLabel.text = entry.song;
    cell.detailTextLabel.text = entry.artist;
	
    return cell;
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString scope:
     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}


- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption
{
    [self filterContentForSearchText:[self.searchDisplayController.searchBar text] scope:
     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:searchOption]];
    
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    /*
     Update the filtered array based on the search text and scope.
     */
    
    [self.filteredEntries removeAllObjects]; // First clear the filtered array.
    
    /*
     Search the main list for products whose type matches the scope (if selected) and whose name matches searchText; add items that match to the filtered array.
     */
    for (OTARSSEntry *entry in entries)
    {
        NSRange range1 = [entry.song rangeOfString:searchText options:NSCaseInsensitiveSearch];
        NSRange range2 = [entry.artist rangeOfString:searchText options:NSCaseInsensitiveSearch];
        NSRange range3 = [entry.title rangeOfString:searchText options:NSCaseInsensitiveSearch];
        
        if(range1.location != NSNotFound || range2.location != NSNotFound || range3.location != NSNotFound)
        {
            [self.filteredEntries addObject:entry];
        }
    }
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
    self.searchDisplayController.searchBar.showsScopeBar = YES;
    [self.searchDisplayController.searchBar sizeToFit];
    return YES;
}

@end
