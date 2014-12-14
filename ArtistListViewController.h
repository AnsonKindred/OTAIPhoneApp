//
//  RootViewController.h
//  OffTheApp
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>
#import "VideoEntryViewController.h"
#import "JSONTableViewController.h"
#import "ArtistListTableViewController.h"

@interface ArtistListViewController : UIViewController {
    IBOutlet ArtistListTableViewController *tableViewController;
    int lastEntryCount, page;
    IBOutlet UITableView* tableView;
    IBOutlet ADBannerView* bannerView;
    IBOutlet NSLayoutConstraint* tableHeightConstraint;
}
@property (atomic, strong) IBOutlet ArtistListTableViewController* tableViewController;
@end
