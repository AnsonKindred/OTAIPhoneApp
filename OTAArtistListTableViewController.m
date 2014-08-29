//
//  OTAArtistListTableViewController.m
//  Off The Ave
//
//  Created by Kyle Parker on 2/8/13.
//  Copyright (c) 2013 North Avenue Studios. All rights reserved.
//

#import "OTAArtistListTableViewController.h"
#import "OTAArtistViewController.h"

@implementation OTAArtistListTableViewController

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
    OTAArtistViewController* artistViewController = [[OTAArtistViewController alloc] initWithNibName:@"OTAArtistViewController" bundle:[NSBundle mainBundle]];
	artistViewController.entry = entry;
	[[parent navigationController] pushViewController:artistViewController animated:YES];
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    UITableViewCell* cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    OTARSSEntry *entry;
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        entry = [self.filteredEntries objectAtIndex:indexPath.row];
    }
    else
    {
        entry = [entries objectAtIndex:indexPath.row];
    }
    cell.textLabel.text = entry.title;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%d", entry.numPosts];
    cell.detailTextLabel.text = [cell.detailTextLabel.text stringByAppendingString:@" videos"];
    return cell;
}

@end
