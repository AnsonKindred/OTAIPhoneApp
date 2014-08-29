//
//  VideoEntryViewController.h
//  OffTheApp
//
//  Created by Zeb Long on 11/11/12.
//  Copyright (c) 2012 North Avenue Studios. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OTARSSEntry.h"
#import "GTMOAuth2ViewControllerTouch.h"
#import "GTMOAuth2WindowController.h"
#import "GDataXMLNode.h"
#import "GDataXMLElement-Extras.h"
#import "ASIHTTPRequest.h"
#import "OTACommentListViewController.h"

@interface OTAVideoEntryViewController : UIViewController {
    OTARSSEntry* entry;
    IBOutlet UIWebView *videoWebView;
    IBOutlet UILabel *descriptionLabel;
    IBOutlet UIView *infoLabelView;
    IBOutlet UIBarButtonItem *likeButton;
    IBOutlet UIBarButtonItem *dislikeButton;
    IBOutlet UIScrollView *scrollView;
    IBOutlet UITableView *commentTable;
    IBOutlet OTACommentListViewController *commentTableController;
    
    IBOutlet UITextField *commentTextField;
    IBOutlet UILabel *commentLabel;
    IBOutlet UIView *commentLabelView;
    NSOperationQueue* queue;
}

@property (retain) OTARSSEntry* entry;

- (void)correctLayout;

- (IBAction)likeVideo:(id)sender;
- (IBAction)dislikeVideo:(id)sender;
- (void)addComment:(NSString*)comment
        withAuthor:(NSString*)author
           atIndex:(int)index;
- (void)fetchComments;
- (IBAction)addComment:(id)sender;
- (IBAction)startEditingComment:(id)sender;
- (void)checkIfVideoLiked:(GTMOAuth2ViewControllerTouch *)viewController
                     auth:(GTMOAuth2Authentication *)auth
                    error:(NSError *)error;
- (void)likeVideoAuthenticated:(GTMOAuth2ViewControllerTouch *)viewController
                          auth:(GTMOAuth2Authentication *)auth
                         error:(NSError *)error;
- (void)dislikeVideoAuthenticated:(GTMOAuth2ViewControllerTouch *)viewController
                             auth:(GTMOAuth2Authentication *)auth
                            error:(NSError *)error;
- (void)addCommentAuthenticated:(GTMOAuth2ViewControllerTouch *)viewController
                           auth:(GTMOAuth2Authentication *)auth
                          error:(NSError *)error;
@end
