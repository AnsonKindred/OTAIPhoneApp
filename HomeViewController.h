//
//  OTAHomeViewController.h
//  Off The Ave
//
//  Created by Zeb Long on 11/12/12.
//  Copyright (c) 2012 North Avenue Studios. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeCollectionViewController.h"

@interface HomeViewController : UIViewController{
    IBOutlet UIImageView* logoImageView;
    UIImage* logoImage;
    IBOutlet UIWebView *videoWebView;
    IBOutlet HomeCollectionViewController *homeCollectionViewController;
    NSOperationQueue* queue;
}
@property (atomic, strong) IBOutlet HomeCollectionViewController* homeCollectionViewController;
@end
