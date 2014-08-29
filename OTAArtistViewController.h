//
//  DetailViewController.h
//
//  Created by Zeb Long on 11/8/12.
//  Copyright (c) 2012 North Avenue Studios. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "OTARSSEntry.h"
#import "OTAVideosListByArtistViewController.h"
#import <Foundation/NSXMLParser.h>

@interface OTAArtistViewController : UIViewController {
    IBOutlet UILabel *descriptionLabel;
	IBOutlet UIImageView *thumbnail;
    IBOutlet UIScrollView *scrollView;
	OTARSSEntry *entry;
    IBOutlet OTAVideosListByArtistViewController *videosListByArtistViewController;    
    NSOperationQueue *_videoQueue;
    
    NSMutableString* resultString;
}
@property (retain, nonatomic) IBOutlet OTAVideosListByArtistViewController *videosListByArtistViewController;
@property (nonatomic, retain) OTARSSEntry *entry;
@property (retain) NSOperationQueue *videoQueue;

@end