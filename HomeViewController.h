//
//  OTAHomeViewController.h
//  Off The Ave
//
//  Created by Zeb Long on 11/12/12.
//  Copyright (c) 2012 North Avenue Studios. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeCollectionViewController.h"
#import "VideoListViewController.h"
#import "PlaylistListViewController.h"

@interface HomeViewController : UIViewController <VideoListViewControllerDelegate, ArtistListViewControllerDelegate, PlaylistListViewControllerDelegate, ADBannerViewDelegate>
{
    IBOutlet UIImageView* logoImageView;
    UIImage* logoImage;
    IBOutlet UIWebView *videoWebView;
    IBOutlet HomeCollectionViewController *homeCollectionViewController;
    NSOperationQueue* queue;
    
    @public
    ADBannerView* sharedAdView;
}
@property (atomic, strong) IBOutlet HomeCollectionViewController* homeCollectionViewController;
@end
