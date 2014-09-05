//
//  OTARSSTableViewController.h
//  Off The Ave
//
//  Created by Zeb Long on 11/15/12.
//  Copyright (c) 2012 North Avenue Studios. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OTARSSEntry.h"
#import "OTAGlobals.h"
#import "ASIHTTPRequest.h"
#import "ASIDownloadCache.h"
#import "GDataFramework.h"
#import "GDataXMLElement-Extras.h"
#import "NSDate+InternetDateTime.h"
#import "NSArray+Extras.h"

@interface OTARSSTableViewController : UITableViewController <UISearchDisplayDelegate, UISearchBarDelegate, UIScrollViewDelegate> {
    NSMutableArray* entries;
    NSOperationQueue* queue;
    NSString* feed_url;
    
    int lastEntryCount, page, totalRows, currentRows;
    bool isRequestDone;
    
    // Ideally this would not be necessary but there is something I'm not understanding
    @public
    id parent;
    bool isPaginated;
}

- (void)refresh;
- (void)refreshWithUrl:(NSString*) url;

@property (nonatomic, retain) NSMutableArray* entries;
@property (nonatomic, retain) NSMutableArray* filteredEntries;
@property (nonatomic, retain) NSString* feed_url;

@property (nonatomic, copy) NSString* savedSearchTerm;
@property (nonatomic) NSInteger savedScopeButtonIndex;
@property (nonatomic) BOOL searchWasActive;

@end
