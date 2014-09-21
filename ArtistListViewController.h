//
//  RootViewController.h
//  OffTheApp
//

#import <UIKit/UIKit.h>
#import "VideoEntryViewController.h"
#import "JSONTableViewController.h"
#import "ArtistListTableViewController.h"

@interface ArtistListViewController : UIViewController {
    IBOutlet ArtistListTableViewController *tableViewController;
    int lastEntryCount, page;
}
@property (atomic, strong) IBOutlet ArtistListTableViewController* tableViewController;
@end
