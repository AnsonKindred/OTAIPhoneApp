//
//  OTAHomeViewController.m
//  Off The Ave
//
//  Created by Zeb Long on 11/12/12.
//  Copyright (c) 2012 North Avenue Studios. All rights reserved.
//

#import "OTAHomeViewController.h"

@implementation OTAHomeViewController
@synthesize homeCollectionViewController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    homeCollectionViewController->parent = self;
    self.navigationController.navigationBarHidden = true;
    NSString* videoUrl = @"http://www.youtube.com/embed/_QCbDX2FnsM?list=PLBF8681780CA9F5DD";
    NSString* videoHTML = [NSString stringWithFormat:@"\
                           <html>\
                           <head>\
                           <style type=\"text/css\">\
                           body {background-color:#000; margin:0;}\
                           </style>\
                           </head>\
                           <body>\
                           <iframe width=\"100%%\" height=\"180px\" src=\"%@\" frameborder=\"0\" allowfullscreen></iframe>\
                           </body>\
                           </html>", videoUrl];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(youTubeVideoExit:)
                                                 name:@"UIMoviePlayerControllerDidExitFullscreenNotification"
                                               object:nil];
    [videoWebView loadHTMLString:videoHTML baseURL:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:true animated:true];
    self.navigationController.navigationBarHidden = true;
    [super viewWillAppear:animated];
}

- (void)youTubeVideoExit:(id)sender {
    [[UIApplication sharedApplication] setStatusBarOrientation:UIDeviceOrientationPortrait animated:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
