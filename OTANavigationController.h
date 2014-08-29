//
//  OTANavigationController.h
//  Off The Ave
//
//  Created by Zeb Long on 11/14/12.
//  Copyright (c) 2012 North Avenue Studios. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OTAHomeViewController.h"

@interface OTANavigationController : UINavigationController {
    
    IBOutlet OTAHomeViewController *homeViewController;
}
@property (strong, atomic) IBOutlet OTAHomeViewController* homeViewController;
@end
