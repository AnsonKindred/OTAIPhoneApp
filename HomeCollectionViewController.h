//
//  OTAHomeCollectionViewController.h
//  Off The Ave
//
//  Created by Zeb Long on 11/13/12.
//  Copyright (c) 2012 North Avenue Studios. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeCollectionViewCell.h"
#import "ArtistListViewController.h"
#import "VideoListViewController.h"
#import "PlaylistListViewController.h"
#import "PlaylistPlayAllViewController.h"

@interface HomeCollectionViewController : UICollectionViewController <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout> {
    IBOutlet UICollectionView *collectionView;
    ArtistListViewController* artistListViewController;
    VideoListViewController* videoListViewController;
    PlaylistListViewController* playlistViewController;
    PlaylistPlayAllViewController* playAllViewController;
    
    @public
    UIViewController* parent;
}
@property(nonatomic, strong) IBOutlet UICollectionView *collectionView;
@end
