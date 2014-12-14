//
//  RootViewController.h
//  OffTheApp
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>
#import "VideoEntryViewController.h"
#import "JSONTableViewController.h"
#import "ArtistListTableViewController.h"

@class ArtistListViewController;

@protocol ArtistListViewControllerDelegate <NSObject>
- (void)setSharedAdView:(ADBannerView *)adView;
@end

@interface ArtistListViewController : UIViewController <ADBannerViewDelegate> {
    IBOutlet ArtistListTableViewController *tableViewController;
    int lastEntryCount, page;
    IBOutlet UITableView* tableView;
    IBOutlet UIView* bannerContainer;
    IBOutlet NSLayoutConstraint* bannerConstraint;

@public
    ADBannerView* bannerView;
}
@property (atomic, strong) IBOutlet ArtistListTableViewController* tableViewController;
@property (nonatomic, strong) id <ArtistListViewControllerDelegate> delegate;
@end
