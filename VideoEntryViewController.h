//
//  VideoEntryViewController.h
//  OffTheApp
//
//  Created by Zeb Long on 11/11/12.
//  Copyright (c) 2012 North Avenue Studios. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EntrySession.h"
#import "GTMOAuth2ViewControllerTouch.h"
#import "GTMOAuth2WindowController.h"
#import "GDataXMLNode.h"
#import "GDataXMLElement-Extras.h"
#import "ASIHTTPRequest.h"
#import "CommentListViewController.h"
#import "VideosListByArtistViewController.h"

@interface VideoEntryViewController : UIViewController {
    EntrySession* entry;

    IBOutlet UIWebView *videoWebView;
    IBOutlet UIWebView *descriptionWebView;
    IBOutlet UIView *infoLabelView;
    IBOutlet UIBarButtonItem *likeButton;
    IBOutlet UIBarButtonItem *dislikeButton;
    IBOutlet UIScrollView *scrollView;
    IBOutlet UITableView *videosTable;
    IBOutlet UITableView *commentTable;
    IBOutlet CommentListViewController *commentTableController;
    IBOutlet VideosListByArtistViewController *videosListByArtistViewController;
    
    IBOutlet UITextField *commentTextField;
    IBOutlet UILabel *commentLabel;
    IBOutlet UIView *commentLabelView;
    IBOutlet UIView *videosLabelView;
    NSOperationQueue* queue;
    
    NSString* videoID;
    NSString* description;
}

@property (retain) EntrySession* entry;
@property (retain, nonatomic) IBOutlet VideosListByArtistViewController *videosListByArtistViewController;

- (void)correctLayout;
- (void) updateVideoView;
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
