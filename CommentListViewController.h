//
//  OTACommentListViewController.h
//  Off The Ave
//
//  Created by Kyle Parker on 2/5/13.
//  Copyright (c) 2013 North Avenue Studios. All rights reserved.
//

@interface CommentListViewController : UITableViewController <UIScrollViewDelegate>
{
    NSMutableArray* comments;
    int totalRowHeight;
}
@property (retain) NSMutableArray* comments;
@property int totalRowHeight;

@end
