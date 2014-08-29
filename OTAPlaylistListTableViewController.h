//
//  OTAPlaylistTableViewController.h
//  Off The Ave
//
//  Created by Kyle Parker on 2/9/13.
//  Copyright (c) 2013 North Avenue Studios. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OTARSSTableViewController.h"

@interface OTAPlaylistListTableViewController : UITableViewController <UISearchDisplayDelegate, UISearchBarDelegate, UIScrollViewDelegate>
{
    NSMutableArray* entries;
    NSOperationQueue* queue;
    
    // Ideally this would not be necessary but there is something I'm not understanding
@public
    id parent;
}

- (void)refresh;

@property (nonatomic, retain) NSMutableArray* entries;
@property (nonatomic, retain) NSMutableArray* filteredEntries;

@property (nonatomic, copy) NSString* savedSearchTerm;
@property (nonatomic) NSInteger savedScopeButtonIndex;
@property (nonatomic) BOOL searchWasActive;

@end
