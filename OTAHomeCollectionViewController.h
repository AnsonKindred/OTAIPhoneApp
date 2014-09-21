//
//  OTAHomeCollectionViewController.h
//  Off The Ave
//
//  Created by Zeb Long on 11/13/12.
//  Copyright (c) 2012 North Avenue Studios. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OTAHomeCollectionViewCell.h"
#import "OTAArtistListViewController.h"
#import "OTAVideoListViewController.h"
#import "OTAPlaylistListViewController.h"
#import "OTAPlaylistPlayAllViewController.h"

@interface OTAHomeCollectionViewController : UICollectionViewController <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout> {
    IBOutlet UICollectionView *collectionView;
    OTAArtistListViewController* artistListViewController;
    OTAVideoListViewController* videoListViewController;
    OTAPlaylistListViewController* playlistViewController;
    OTAPlaylistPlayAllViewController* playAllViewController;
    
    @public
    UIViewController* parent;
}
@property(nonatomic, strong) IBOutlet UICollectionView *collectionView;
@end
