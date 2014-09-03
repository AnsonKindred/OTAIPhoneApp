//
//  OTAPlaylistTableViewController.m
//  Off The Ave
//
//  Created by Kyle Parker on 2/10/13.
//  Copyright (c) 2013 North Avenue Studios. All rights reserved.
//

#import "OTAPlaylistTableViewController.h"
#import "OTAYouTube.h"
#import "GDataXMLElement-Extras.h"
#import "OTARSSEntry.h"
#import "OTAPlaylistVideoViewController.h"

@implementation OTAPlaylistTableViewController
@synthesize entries;
@synthesize filteredEntries, savedSearchTerm, savedScopeButtonIndex, searchWasActive;

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"INIT");
    queue = [[NSOperationQueue alloc] init];
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
}

- (void)viewDidUnload
{
    self.filteredEntries = nil;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
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

- (void)refresh
{
    NSString* urlString = [playlistUrl stringByAppendingString:@"?v=2&orderby=title"];
    
    NSURL *url = [NSURL URLWithString:urlString];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    
    [request setDelegate:self];
    [request setDidFinishSelector:@selector(loadData:)];
    
    [queue addOperation:request];
}

- (void) loadData:(ASIHTTPRequest *)request
{
    NSError *error;
    NSData* responseData = [request responseData];
    GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:responseData
                                                           options:0
                                                             error:&error];
    NSLog(@"%@", error.description);
    if (doc == nil)
    {
        NSLog(@"failed to parse");
    }
    else
    {
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            NSArray *videos = [doc.rootElement elementsForName:@"entry"];
            int i = 0;
            for (GDataXMLElement *video in videos)
            {
                [entries addObject:[OTAYouTube parseVideo:video]];

                i++;
            }
            NSLog(@"reload");
            [self.tableView reloadData];
        }];
    }
}

// Customize the appearance of table view cells.
- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
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
	
    cell.textLabel.text = entry.title;
    cell.detailTextLabel.text = entry.subTitle;
	
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
        NSRange range1 = [entry.title rangeOfString:searchText options:NSCaseInsensitiveSearch];
        NSRange range2 = [entry.subTitle rangeOfString:searchText options:NSCaseInsensitiveSearch];
        
        if(range1.location != NSNotFound || range2.location != NSNotFound)
        {
            [self.filteredEntries addObject:entry];
        }
    }
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    OTARSSEntry *entry;
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        entry = [self.filteredEntries objectAtIndex:indexPath.row];
    }
    else
    {
        entry = [entries objectAtIndex:indexPath.row];
    }
    OTAPlaylistVideoViewController* playlistViewController = [[OTAPlaylistVideoViewController alloc] initWithNibName:@"OTAPlaylistVideoViewController" bundle:[NSBundle mainBundle]];
	playlistViewController.entry = entry;
	[[parent navigationController] pushViewController:playlistViewController animated:YES];
}

@end
