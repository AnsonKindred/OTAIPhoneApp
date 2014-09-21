//
//  OTANavigationController.m
//  Off The Ave
//
//  Created by Zeb Long on 11/14/12.
//  Copyright (c) 2012 North Avenue Studios. All rights reserved.
//

#import "NavigationController.h"

@implementation NavigationController
@synthesize homeViewController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    homeViewController = [[HomeViewController alloc] init];
    [self pushViewController:homeViewController animated:NO];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)shouldAutorotate
{
    return true;
}

- (NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait|UIInterfaceOrientationMaskPortraitUpsideDown;
}

@end
