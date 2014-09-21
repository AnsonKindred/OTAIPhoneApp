//
//  OTAArtistListTableViewController.m
//  Off The Ave
//
//  Created by Kyle Parker on 2/8/13.
//  Copyright (c) 2013 North Avenue Studios. All rights reserved.
//

#import "ArtistListTableViewController.h"
#import "VideoEntryViewController.h"

@implementation ArtistListTableViewController

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    EntrySession *entry;
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        entry = [self.filteredEntries objectAtIndex:indexPath.row];
    }
    else
    {
        entry = [entries objectAtIndex:indexPath.row];
    }
	VideoEntryViewController *controller = [[VideoEntryViewController alloc] initWithNibName:@"VideoEntryViewController" bundle:[NSBundle mainBundle]];
	controller.entry = entry;
	[[parent navigationController] pushViewController:controller animated:YES];
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    UITableViewCell* cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    EntrySession *entry;
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        entry = [self.filteredEntries objectAtIndex:indexPath.row];
    }
    else
    {
        entry = [entries objectAtIndex:indexPath.row];
    }
    cell.textLabel.text = entry.artist;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%i", entry.count];
    cell.detailTextLabel.text = [cell.detailTextLabel.text stringByAppendingString:@" videos"];
    return cell;
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
        NSRange range2 = [entry.artist rangeOfString:searchText options:NSCaseInsensitiveSearch];
        
        if(range2.location != NSNotFound)
        {
            [self.filteredEntries addObject:entry];
        }
    }
}

@end
