//
//  OTAYouTube.h
//  Off The Ave
//
//  Created by Kyle Parker on 2/4/13.
//  Copyright (c) 2013 North Avenue Studios. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GTMOAuth2ViewControllerTouch.h"
#import "GTMOAuth2WindowController.h"
#import "GTLYouTube.h"
#import "GDataYouTube.h"
#import "EntrySession.h"
#import "GDataXMLElement-Extras.h"

@interface OTAYouTube : NSObject
{
    const NSString *kKeychainItemName, *kMyClientID, *kMyClientSecret, *scope, *developerKey;
    
}
+ (void) authenticateThen:(SEL)fn
                 delegate:(id)delegate
           viewController:(UIViewController*)viewController;
+ (void) doneAuthenticating:(UIViewController*)viewController
                       auth:(GTMOAuth2Authentication*)auth
                      error:(NSError*)error;
+ (void) donePostAuthenticating:(UIViewController*)viewController
                           auth:(GTMOAuth2Authentication*)auth
                          error:(NSError*)error;
+ (GTLServiceYouTube *) youTubeService;
+ (GDataServiceGoogleYouTube *) youTubeServiceGData;

+ (Boolean) canAuthorize;

+ (EntrySession*) parseVideo:(GDataXMLElement*)video;
@end
