//
//  OTAPlaylistTableViewController.m
//  Off The Ave
//
//  Created by Kyle Parker on 2/9/13.
//  Copyright (c) 2013 North Avenue Studios. All rights reserved.
//

#import "PlaylistListTableViewController.h"
#import "GTMNSString+HTML.h"
#import "YouTube.h"
#import "Globals.h"
#import "Comment.h"
#import "VideoListViewController.h"
#import "EntryGenre.h"
#import "PlaylistListViewController.h"

@implementation PlaylistListTableViewController

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    EntryGenre *entry;
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        entry = [self.filteredEntries objectAtIndex:indexPath.row];
    }
    else
    {
        entry = [entries objectAtIndex:indexPath.row];
    }
    VideoListViewController* videoListViewController = [[VideoListViewController alloc] initWithNibName:@"VideoListViewController" bundle:[NSBundle mainBundle]];
	videoListViewController->filterByGenre = entry.ID;
    videoListViewController->bannerView = ((PlaylistListViewController*)parent)->bannerView;
    videoListViewController->bannerView.delegate = ((PlaylistListViewController*)parent);
    videoListViewController.delegate = ((PlaylistListViewController*)parent);
	[[parent navigationController] pushViewController:videoListViewController animated:YES];
}

- (void)parseFeedJSON:(NSArray *)items
{
    totalRows = [items count];
    for (NSDictionary *item in items)
    {
        EntryGenre *entry = [[EntryGenre alloc] init:item];
        
        [entries addObject:entry];
        
        [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:[entries count]-1 inSection:0]]
                              withRowAnimation:UITableViewRowAnimationTop];
    }
}

#pragma mark - Table view data source

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
    EntryGenre* entry;
    //GDataEntryYouTubePlaylist* entry = nil;
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        entry = [self.filteredEntries objectAtIndex:indexPath.row];
    }
    else
    {
        entry = [entries objectAtIndex:indexPath.row];
    }
	
    //cell.entry = entry;
    //cell.navigationController = [parent navigationController];
    cell.textLabel.text = entry.title;
	
    return cell;
}

@end
