//
//  VideosListByArtistViewController.m
//  OffTheApp
//
//  Created by Zeb Long on 11/9/12.
//  Copyright (c) 2012 North Avenue Studios. All rights reserved.
//

#import "VideosListByArtistViewController.h"
#import "EntrySession.h"
#import "ASIHTTPRequest/ASIHTTPRequest.h"
#import "GDataXMLNode.h"
#import "GDataXML/GDataXMLElement-Extras.h"
#import "NSArray+Extras.h"
#import "NSDate+InternetDateTime.h"
#import "VideoEntryViewController.h"

@implementation VideosListByArtistViewController

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
//    return @"  Other videos";
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"TEST");
    EntrySession *selectedEntry = [entries objectAtIndex:indexPath.row];
	VideoEntryViewController *controller = [[VideoEntryViewController alloc] initWithNibName:@"VideoEntryViewController" bundle:[NSBundle mainBundle]];
	controller.entry = selectedEntry;
    UINavigationController* navigationController = [parent navigationController];
	[navigationController popViewControllerAnimated:NO];
    [navigationController pushViewController:controller animated:YES];
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath {
    UITableViewCell* cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    EntrySession *entry = [entries objectAtIndex:indexPath.row];
    
    cell.textLabel.text = entry.song;
    cell.detailTextLabel.text = @"";
    
    return cell;
}

@end
