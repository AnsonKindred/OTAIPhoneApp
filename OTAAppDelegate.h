//
//  OTAAppDelegate.h
//  Off The Avenue
//
//  Created by Zeb Long on 11/12/12.
//  Copyright (c) 2012 North Avenue Studios. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OTANavigationController.h"

@interface OTAAppDelegate : UIResponder <UIApplicationDelegate> {
    OTANavigationController* rootViewController;
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, atomic) OTANavigationController* rootViewController;

@end
