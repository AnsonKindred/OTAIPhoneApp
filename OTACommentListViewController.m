//
//  OTACommentListViewController.m
//  Off The Ave
//
//  Created by Kyle Parker on 2/5/13.
//  Copyright (c) 2013 North Avenue Studios. All rights reserved.
//

#import "OTACommentListViewController.h"
#import "OTAComment.h"

@implementation OTACommentListViewController
@synthesize comments;
@synthesize totalRowHeight;

- (void)viewDidLoad
{
    [super viewDidLoad];
    comments = [[NSMutableArray array] retain];
    totalRowHeight = 0;
}

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [comments count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OTAComment* comment = [comments objectAtIndex:indexPath.row];
    UITableViewCell* cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
  
    CGSize size = [comment.text sizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:CGSizeMake(cell.frame.size.width - 20, 500)];
    
    return size.height + 35;
}

// Customize the appearance of table view cells.
- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    OTAComment* comment = [comments objectAtIndex:indexPath.row];
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
    }
	
    cell.textLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:13];
    cell.textLabel.text = comment.author;
    cell.detailTextLabel.font = [UIFont fontWithName:@"Helvetica" size:13];
    cell.detailTextLabel.text = comment.text;
    cell.detailTextLabel.numberOfLines = 0;
    [cell.detailTextLabel sizeToFit];
	
    return cell;
}

@end
