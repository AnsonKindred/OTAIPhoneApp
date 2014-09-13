//
//  OTAVideoListViewController.m
//  Off The Ave
//
//  Created by Kyle Parker on 11/15/12.
//  Copyright (c) 2012 North Avenue Studios. All rights reserved.
//

#import "OTAVideoListTableViewController.h"

@implementation OTAVideoListTableViewController

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    EntrySession* entry;
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        entry = [self.filteredEntries objectAtIndex:indexPath.row];
    }
    else
    {
        entry = [entries objectAtIndex:indexPath.row];
    }
    
    [self loadSession:entry];
}

- (void)playAll
{
    EntrySession* entry = [entries objectAtIndex:0];
    
    [self loadSession:entry];
}

- (void)loadSession:(EntrySession*) entry
{
	OTAVideoEntryViewController *controller = [[OTAVideoEntryViewController alloc] initWithNibName:@"OTAVideoEntryViewController" bundle:[NSBundle mainBundle]];
	controller.entry = entry;
	[[parent navigationController] pushViewController:controller animated:YES];
}
@end