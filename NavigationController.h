//
//  OTANavigationController.h
//  Off The Ave
//
//  Created by Zeb Long on 11/14/12.
//  Copyright (c) 2012 North Avenue Studios. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeViewController.h"

@interface NavigationController : UINavigationController {
    
    IBOutlet HomeViewController *homeViewController;
}
@property (strong, atomic) IBOutlet HomeViewController* homeViewController;
@end
