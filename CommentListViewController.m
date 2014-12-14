//
//  OTACommentListViewController.m
//  Off The Ave
//
//  Created by Kyle Parker on 2/5/13.
//  Copyright (c) 2013 North Avenue Studios. All rights reserved.
//

#import "CommentListViewController.h"
#import "Comment.h"

@implementation CommentListViewController
@synthesize comments;
@synthesize totalRowHeight;

- (void)viewDidLoad
{
    [super viewDidLoad];
    comments = [NSMutableArray array];
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
    Comment* comment = [comments objectAtIndex:indexPath.row];
    UITableViewCell* cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    
    CGSize maximumLabelSize = CGSizeMake(cell.frame.size.width-20, MAXFLOAT);
    
    NSStringDrawingOptions options = NSStringDrawingTruncatesLastVisibleLine |
    NSStringDrawingUsesLineFragmentOrigin;
    
    NSDictionary *attr = @{NSFontAttributeName: [UIFont systemFontOfSize:13]};
    CGRect size = [comment.text boundingRectWithSize:maximumLabelSize
                                              options:options
                                           attributes:attr
                                              context:nil];
    //CGSize size = [comment.text sizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:CGSizeMake(cell.frame.size.width - 20, 500)];
    
    return ceilf(size.size.height) + 35;
}

// Customize the appearance of table view cells.
- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    Comment* comment = [comments objectAtIndex:indexPath.row];
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
