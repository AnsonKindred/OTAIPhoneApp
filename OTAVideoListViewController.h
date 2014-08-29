//
//  OTAVideoListViewController_new.h
//  Off The Ave
//
//  Created by Kyle Parker on 11/16/12.
//  Copyright (c) 2012 North Avenue Studios. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OTAVideoListTableViewController.h"
#import "OTAVideoEntryViewController.h"
#import "OTAGlobals.h"


@interface OTAVideoListViewController : UIViewController {
    IBOutlet OTAVideoListTableViewController* tableViewController;
    
    int lastEntryCount, page;
    OTAGlobals* global;
}

@property (atomic, strong) IBOutlet OTAVideoListTableViewController* tableViewController;
- (void)loadData;

@end
