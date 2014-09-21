//
//  OTAVideoListViewController.m
//  Off The Ave
//
//  Created by Kyle Parker on 11/15/12.
//  Copyright (c) 2012 North Avenue Studios. All rights reserved.
//

#import "VideoListTableViewController.h"

@implementation VideoListTableViewController

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

    VideoEntryViewController *controller = [[VideoEntryViewController alloc] initWithNibName:@"VideoEntryViewController" bundle:[NSBundle mainBundle]];
	controller.entry = entry;
	[[parent navigationController] pushViewController:controller animated:YES];
}

- (void)playAll
{
    PlaylistPlayAllViewController *controller = [[PlaylistPlayAllViewController alloc] initWithNibName:@"PlaylistPlayAllViewController" bundle:[NSBundle mainBundle]];
    controller.playlist = entries;
    controller.goingBack = false;
	[[parent navigationController] pushViewController:controller animated:YES];
}

@end