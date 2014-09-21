//
//  OTARSSTableViewController.m
//  Off The Ave
//
//  Created by Zeb Long on 11/15/12.
//  Copyright (c) 2012 North Avenue Studios. All rights reserved.
//

#import "JSONTableViewController.h"
#import "GTMNSString+HTML.h"

@implementation JSONTableViewController
@synthesize entries;
@synthesize filteredEntries, savedSearchTerm, savedScopeButtonIndex, searchWasActive;
@synthesize feed_url;

static const int POSTS_PER_PAGE = 20;

- (void)viewDidLoad
{
    [super viewDidLoad];
 
    // register observer for contentSize change
    [self.tableView addObserver:self forKeyPath:@"contentSize" options:(NSKeyValueObservingOptionNew |
                                                                        NSKeyValueObservingOptionOld) context:NULL];
    
    entries = [[NSMutableArray array] retain];
    queue = [[NSOperationQueue alloc] init];
    
    page = 1;
    lastEntryCount = 0;
    
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
    
    Globals* global = [Globals getInstance];
    feed_url = [global.wordpressDomain stringByAppendingFormat:@"getSongs.php?posts_per_page=%i", POSTS_PER_PAGE];
    [feed_url retain];
    
    //[ASIHTTPRequest setDefaultCache:[ASIDownloadCache sharedCache]];
    //[[ASIDownloadCache sharedCache] setShouldRespectCacheControlHeaders:NO];
}

// called when content size changes
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    int oldHeight = [[change objectForKey:NSKeyValueChangeOldKey] CGSizeValue].height;
    int newHeight = [[change objectForKey:NSKeyValueChangeNewKey] CGSizeValue].height;

    if(newHeight - oldHeight > 0 && [parent respondsToSelector:@selector(correctLayout)])
    {
        CGRect frame = self.tableView.frame;
        frame.size = self.tableView.contentSize;
        self.tableView.frame = frame;
        NSLog(@"adjusting table view to fit contents");
        [parent correctLayout];
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

- (void)refreshWithUrl:(NSString*)url
{
    feed_url = url;
    [feed_url retain];
    [self refresh];
}

- (void)refresh
{
    //NSLog(@"%i", page);
    NSURL *url = [NSURL URLWithString:[feed_url stringByAppendingFormat:@"&paged=%i", page]];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    
    [request setDelegate:self];
    
    [request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
    [queue addOperation:request];
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSData* returnedData = [request responseData];
    //NSLog(@"%@", [[NSString alloc] initWithData:returnedData encoding:NSUTF8StringEncoding]);
    NSError *error = nil;
    id object = [NSJSONSerialization
                 JSONObjectWithData:returnedData
                 options:0
                 error:&error];
    
    if (error)
    {
        /* JSON was malformed, act appropriately here */
        NSLog(error.description);
    }
    
    if ([object isKindOfClass:[NSArray class]])
    {
        NSArray *results = object;
        [self parseFeedJSON:results];
        
        if(isPaginated && entries.count > lastEntryCount)
        {
            page++;
            lastEntryCount = entries.count;
            
            [self refresh];
        }
        else
        {
            isRequestDone = true;
            //NSLog(@"request finished");
            //if([parent respondsToSelector:@selector(correctLayout)]) [parent correctLayout];
        }
    }
    else
    {
        /* there's no guarantee that the outermost object in a JSON packet will be a dictionary; */
        NSLog(@"ERROR ERROR");
    }
}

- (void)parseFeedJSON:(NSArray *)items
{
    totalRows = [items count];
    for (NSDictionary *item in items)
    {
        EntrySession *entry = [[EntrySession alloc] init:item];
        
        [entries addObject:entry];
        
        [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:[entries count]-1 inSection:0]]
                              withRowAnimation:UITableViewRowAnimationTop];
    }
}

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
    EntrySession* entry = nil;
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
    for (EntrySession *entry in entries)
    {
        NSRange range1 = [entry.song rangeOfString:searchText options:NSCaseInsensitiveSearch];
        NSRange range2 = [entry.artist rangeOfString:searchText options:NSCaseInsensitiveSearch];
        
        if(range1.location != NSNotFound || range2.location != NSNotFound)
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
