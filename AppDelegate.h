//
//  OTAAppDelegate.h
//  Off The Avenue
//
//  Created by Zeb Long on 11/12/12.
//  Copyright (c) 2012 North Avenue Studios. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavigationController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate> {
    NavigationController* rootViewController;
    
    EntrySession* entry;
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, atomic) NavigationController* rootViewController;

@end
