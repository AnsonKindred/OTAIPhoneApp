//
//  OTAPlaylistTableViewController.m
//  Off The Ave
//
//  Created by Kyle Parker on 2/9/13.
//  Copyright (c) 2013 North Avenue Studios. All rights reserved.
//

#import "OTAPlaylistListTableViewController.h"
#import "GTMNSString+HTML.h"
#import "OTAYouTube.h"
#import "OTAGlobals.h"
#import "OTAComment.h"
#import "OTAPlaylistViewController.h"
#import "OTAPlaylistListTableCell.h"

@implementation OTAPlaylistListTableViewController
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

- (void)refresh
{
    GDataServiceGoogleYouTube* service = OTAYouTube.youTubeServiceGData;
    service.authorizer = nil;
    
    NSURL* url = [NSURL URLWithString:@"https://gdata.youtube.com/feeds/api/users/offtheavenue/playlists"];
    [service fetchFeedWithURL:url completionHandler:^(GDataServiceTicket *ticket, GDataFeedBase *list, NSError *error)
    {
        GDataFeedYouTubePlaylist* playlistList = (GDataFeedYouTubePlaylist*)list;
        for(GDataEntryYouTubePlaylist* playlist in playlistList)
        {
            [self.entries addObject:playlist];
        }
        
        [self.entries sortUsingFunction:compareLetters context:nil];
        [self.tableView reloadData];
    }];
}

NSComparisonResult compareLetters(GDataFeedYouTubePlaylist* t1, GDataFeedYouTubePlaylist* t2, void* context)
{
    return [t1.title.contentStringValue compare:t2.title.contentStringValue];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    GDataEntryYouTubePlaylist *entry;
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        entry = [self.filteredEntries objectAtIndex:indexPath.row];
    }
    else
    {
        entry = [entries objectAtIndex:indexPath.row];
    }
    OTAPlaylistViewController* playlistViewController = [[OTAPlaylistViewController alloc] initWithNibName:@"OTAPlaylistViewController" bundle:[NSBundle mainBundle]];
	playlistViewController.entry = entry;
	[[parent navigationController] pushViewController:playlistViewController animated:YES];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSError *error = [request error];
    NSLog(@"Error: %@", error);
}

#pragma mark - Table view data source

// Customize the number of sections in the table view.
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

// Customize the appearance of table view cells.
- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    OTAPlaylistListTableCell* cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (cell == nil) {
        cell = [[OTAPlaylistListTableCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
    }
	
    /*
     If the requesting table view is the search display controller's table view, configure the cell using the filtered content, otherwise use the main list.
     */
    GDataEntryYouTubePlaylist* entry = nil;
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        entry = [filteredEntries objectAtIndex:indexPath.row];
    }
    else
    {
        entry = [entries objectAtIndex:indexPath.row];
    }
	
    cell.entry = entry;
    cell.navigationController = [parent navigationController];
    cell.textLabel.text = [entry.title.contentStringValue componentsSeparatedByString:@"|"][0];
	
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
    for (GDataEntryYouTubePlaylist *entry in entries)
    {
        NSRange range1 = [entry.title.contentStringValue rangeOfString:searchText options:NSCaseInsensitiveSearch];
        
        if(range1.location != NSNotFound)
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
