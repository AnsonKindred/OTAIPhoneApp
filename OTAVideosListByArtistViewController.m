//
//  VideosListByArtistViewController.m
//  OffTheApp
//
//  Created by Zeb Long on 11/9/12.
//  Copyright (c) 2012 North Avenue Studios. All rights reserved.
//

#import "OTAVideosListByArtistViewController.h"
#import "OTARSSEntry.h"
#import "ASIHTTPRequest/ASIHTTPRequest.h"
#import "GDataXMLNode.h"
#import "GDataXML/GDataXMLElement-Extras.h"
#import "NSArray+Extras.h"
#import "NSDate+InternetDateTime.h"
#import "OTAVideoEntryViewController.h"

@implementation OTAVideosListByArtistViewController

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"Videos";
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    OTARSSEntry *selectedEntry = [entries objectAtIndex:indexPath.row];
	OTAVideoEntryViewController *controller = [[OTAVideoEntryViewController alloc] initWithNibName:@"OTAVideoEntryViewController" bundle:[NSBundle mainBundle]];
	controller.entry = selectedEntry;
	[[parent navigationController] pushViewController:controller animated:YES];
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath {
    UITableViewCell* cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    OTARSSEntry *entry = [entries objectAtIndex:indexPath.row];
    
    cell.textLabel.text = entry.song;
    cell.detailTextLabel.text = @"";
    
    return cell;
}

@end
