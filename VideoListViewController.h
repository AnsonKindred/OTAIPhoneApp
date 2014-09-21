//
//  OTAVideoListViewController_new.h
//  Off The Ave
//
//  Created by Kyle Parker on 11/16/12.
//  Copyright (c) 2012 North Avenue Studios. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VideoListTableViewController.h"
#import "VideoEntryViewController.h"


@interface VideoListViewController : UIViewController {
    IBOutlet VideoListTableViewController* tableViewController;
    
@public
    int filterByGenre;
}

@property (atomic, strong) IBOutlet VideoListTableViewController* tableViewController;

@end
