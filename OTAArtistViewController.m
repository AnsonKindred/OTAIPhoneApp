//
//  DetailViewController.m
//
//  Created by Zeb Long on 11/8/12.
//  Copyright (c) 2012 North Avenue Studios. All rights reserved.
//

#import "OTAArtistViewController.h"
#import "ASIHTTPRequest/ASIHTTPRequest.h"
#import "GDataXMLNode.h"
#import "GDataXML/GDataXMLElement-Extras.h"
#import "NSArray+Extras.h"
#import "NSDate+InternetDateTime.h"

@implementation OTAArtistViewController
@synthesize entry;
@synthesize videoQueue = _videoQueue;
@synthesize videosListByArtistViewController=videosListByArtistViewController;

- (void)viewDidLoad
{
	[super viewDidLoad];
	
    videosListByArtistViewController->parent = self;
    
    __unsafe_unretained OTAArtistViewController *me = self; // OK for iOS 4.x and up
    __unsafe_unretained UIImageView* thumbnail_volatile = thumbnail; // OK for iOS 4.x and up
    [thumbnail setImageWithURL:[NSURL URLWithString:entry.thumbnail]
                       success:^(UIImage *image, BOOL cached) {
                           float ratio = thumbnail_volatile.image.size.height/thumbnail.image.size.width;
                           CGRect tempFrame = thumbnail_volatile.frame;
                           tempFrame.size.height = tempFrame.size.width*ratio;
                           [thumbnail_volatile setFrame:tempFrame];
                           [me correctLayout];
                       }
                       failure:^(NSError *error) {}
                    ];
    
    descriptionLabel.text = entry.description;
    descriptionLabel.text = [descriptionLabel.text stringByReplacingOccurrencesOfString:@"Share on Facebook" withString:@""];
    [self correctLayout];
	//Set the title of the navigation bar
	self.navigationItem.title = entry.title;
    
    NSString* urlString = @"http://www.offtheavenue.tv/?feed=rss2&tag=";
    urlString = [urlString stringByAppendingString:entry.artistTag];
    [videosListByArtistViewController refreshWithUrl:urlString];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self correctLayout];
}

- (void)correctLayout
{
    // Fit description label to text size
    [descriptionLabel sizeToFit];
    [scrollView setFrame:self.view.frame];
    // Make sure the description sits just below the image
    CGRect tempFrame = descriptionLabel.frame;
    tempFrame.origin.y = thumbnail.frame.origin.y + thumbnail.frame.size.height + 8;
    [descriptionLabel setFrame:tempFrame];
    
    // Make sure the video list sits just below the description and is just tall enough to fit the content
    tempFrame = self.videosListByArtistViewController.tableView.frame;
    float rowHeight = self.videosListByArtistViewController.tableView.rowHeight;
    float titleHeight = self.videosListByArtistViewController.tableView.sectionHeaderHeight;
    tempFrame.origin.y = descriptionLabel.frame.origin.y + descriptionLabel.frame.size.height+8;
    tempFrame.size.height =  [self.videosListByArtistViewController.entries count]*rowHeight+titleHeight;
    [self.videosListByArtistViewController.tableView setFrame:tempFrame];
    
    // Set the scroll view's content height to just past the last element (in this case the table view)
    [scrollView setFrame:self.view.frame];
    [scrollView setContentSize:CGSizeMake(scrollView.frame.size.width, tempFrame.origin.y + tempFrame.size.height)];
}

- (void)requestFinished {
    [self correctLayout];
}

@end
