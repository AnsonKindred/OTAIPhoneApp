//
//  RootViewController.h
//  OffTheApp
//

#import <UIKit/UIKit.h>
#import "OTAArtistViewController.h"
#import "OTAVideoEntryViewController.h"
#import "OTARSSTableViewController.h"
#import "OTAArtistListTableViewController.h"

@interface OTAArtistListViewController : UIViewController {
    IBOutlet OTAArtistListTableViewController *tableViewController;
    int lastEntryCount, page;
}
@property (atomic, strong) IBOutlet OTAArtistListTableViewController* tableViewController;
@end
