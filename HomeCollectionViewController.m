//
//  OTAHomeCollectionViewController.m
//  Off The Ave
//
//  Created by Zeb Long on 11/13/12.
//  Copyright (c) 2012 North Avenue Studios. All rights reserved.
//

#import "HomeCollectionViewController.h"
#import "HomeViewController.h"

@implementation HomeCollectionViewController
@synthesize collectionView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.collectionView registerNib:[UINib nibWithNibName:@"HomeCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"Anything"];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    HomeCollectionViewCell* cell = [cv dequeueReusableCellWithReuseIdentifier:@"Anything" forIndexPath:indexPath];
    
    // cell.icon = Resources.homeButtons[indexPath.row];
    NSString* plistPath = [[NSBundle mainBundle] pathForResource:@"home-buttons" ofType:@"plist"];
    NSArray* plistData = [NSArray arrayWithContentsOfFile:plistPath];
    NSDictionary* iconData = [plistData objectAtIndex:indexPath.row];
    [cell.iconImage setImage:[UIImage imageNamed:[iconData objectForKey:@"image"]]];
    [cell.iconLabel setText:[iconData objectForKey:@"label"]];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView*) cv layout:(UICollectionViewLayout*) layout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize size = CGSizeMake(self.view.frame.size.width/2-1, self.view.frame.size.height/2);
    if(indexPath.row%2 == 1)
    {
        size.width += 1;
    }
    return size;
}

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section
{
    return 4;
}

- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView
{
    return 1;
}

- (void)collectionView:(UICollectionView *)cv didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    switch(indexPath.row)
    {
        case 0:
            if(artistListViewController == nil)
            {
                artistListViewController = [[ArtistListViewController alloc] init];
            }
            artistListViewController->bannerView = parent->sharedAdView;
            artistListViewController->bannerView.delegate = artistListViewController;
            parent->sharedAdView = nil;
            artistListViewController.delegate = parent;
            [((UIViewController*)parent).navigationController pushViewController:artistListViewController animated:true];
            break;
        case 1:
            if(videoListViewController == nil)
            {
                videoListViewController = [[VideoListViewController alloc] init];
            }
            videoListViewController->bannerView = parent->sharedAdView;
            videoListViewController->bannerView.delegate = videoListViewController;
            parent->sharedAdView = nil;
            videoListViewController.delegate = parent;
            [((UIViewController*)parent).navigationController pushViewController:videoListViewController animated:true];
            break;
        case 2:
            if(playlistViewController == nil)
            {
                playlistViewController = [[PlaylistListViewController alloc] init];
            }
            playlistViewController->bannerView = parent->sharedAdView;
            playlistViewController->bannerView.delegate = playlistViewController;
            parent->sharedAdView = nil;
            playlistViewController.delegate = parent;
            [((UIViewController*)parent).navigationController pushViewController:playlistViewController animated:true];
            break;
        case 3:
            if(playAllViewController == nil)
            {
                playAllViewController = [[PlaylistPlayAllViewController alloc] init];
            }
            playAllViewController.playlist = NULL;
            playAllViewController.goingBack = false;
            [((UIViewController*)parent).navigationController pushViewController:playAllViewController animated:true];
    }
}

- (void)collectionView:(UICollectionView *)cv didHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell* cell = [cv cellForItemAtIndexPath:indexPath];
    [cell.contentView setBackgroundColor:[UIColor colorWithRed:54/255.0 green:189/255.0 blue:175/255.0 alpha:.5]];
}

- (void)collectionView:(UICollectionView *)cv didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell* cell = [cv cellForItemAtIndexPath:indexPath];
    cell.contentView.backgroundColor = nil;
}

@end
