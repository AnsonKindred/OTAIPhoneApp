//
//  OTAHomeViewController.m
//  Off The Ave
//
//  Created by Zeb Long on 11/12/12.
//  Copyright (c) 2012 North Avenue Studios. All rights reserved.
//

#import "HomeViewController.h"
#import "Globals.h"

@implementation HomeViewController
@synthesize homeCollectionViewController;


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    NSDictionary *testNotification = [NSJSONSerialization
                                      JSONObjectWithData:[@"{'aps':{'alert':'Test alert','sound':'default'}}" dataUsingEncoding:NSUTF8StringEncoding]
                                      options:0
                                      error:nil];
    
    [[[UIApplication sharedApplication] delegate]
     application:[UIApplication sharedApplication]
     didReceiveRemoteNotification:testNotification];
    
    homeCollectionViewController->parent = self;
    self.navigationController.navigationBarHidden = true;
    
    queue = [[NSOperationQueue alloc] init];
    
    Globals* global = [Globals getInstance];
    NSString* feed_url = [global.wordpressDomain stringByAppendingString:@"getFeaturedVideo.php"];
    
    NSURL *url = [NSURL URLWithString:feed_url];
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    
    [request setDelegate:self];
    [request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
    
    [queue addOperation:request];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(youTubeVideoExit:)
                                                 name:@"UIMoviePlayerControllerDidExitFullscreenNotification"
                                               object:nil];}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSData* returnedData = [request responseData];
    NSString* videoID = [[NSString alloc] initWithData:returnedData encoding:NSUTF8StringEncoding];
    NSLog(@"%@", videoID);
    NSString* videoHTML = [NSString stringWithFormat:@"\
            <html>\
                <head>\
                    <style type=\"text/css\">\
                        body {background-color:#000; margin:0;}\
                    </style>\
                </head>\
                <body>\
                    <iframe width=\"100%%\"\
                            height=\"180px\"\
                            src=\"http://www.youtube.com/embed/%@/?modestbranding=1&controls=2&rel=0&iv_load_policy=3&showinfo=0&autoplay=1&playerapiid=ytplayer&version=3\"\
                            frameborder=\"0\"\
                            allowfullscreen>\
                   </iframe>\
                </body>\
            </html>",
            videoID
        ];
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