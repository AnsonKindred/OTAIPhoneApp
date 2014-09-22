//
//  OTAAppDelegate.m
//  Off The Avenue
//
//  Created by Zeb Long on 11/12/12.
//  Copyright (c) 2012 North Avenue Studios. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate
@synthesize rootViewController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    if (launchOptions != nil)
	{
        
        NSLog(@"Launched with options: %@", launchOptions);
		NSDictionary *dictionary = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
		if (dictionary != nil)
		{
            NSDictionary* data = [dictionary valueForKey:@"data"];
            entry = [[EntrySession alloc] init:data];
			[self handleNotification];
		}
	}
    
    return YES;
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    NSLog(@"Got a notification");
    NSDictionary* data = [userInfo valueForKey:@"data"];
    entry = [[EntrySession alloc] init:data];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"New Release!"
                                                    message:[[data valueForKey:@"song"] stringByAppendingFormat:@" by %@",[data valueForKey:@"artist"]]
                                                   delegate:self
                                          cancelButtonTitle:@"No thanks"
                                          otherButtonTitles:@"Check it out",nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        [self handleNotification];
    }
}

- (void)handleNotification
{
    VideoEntryViewController *controller = [[VideoEntryViewController alloc] initWithNibName:@"VideoEntryViewController" bundle:[NSBundle mainBundle]];
	controller.entry = entry;
	[rootViewController pushViewController:controller animated:YES];
}

- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
    NSString *tokenStr = [deviceToken description];
    NSString *urlStr = @"http://ota.zebadiah.me/registerOffTheAveDevice.php";
    NSURL *url = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url];
    
    [req setHTTPMethod:@"POST"];
    [req setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-type"];
    NSMutableData *postBody = [NSMutableData data];
    [postBody appendData:[[NSString stringWithFormat:@"&token=%@", tokenStr] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [req setHTTPBody:postBody];
    [[NSURLConnection alloc] initWithRequest:req delegate:nil];
    
	NSLog(@"My token is: %@", deviceToken);
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
	NSLog(@"Failed to get token, error: %@", error);
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    rootViewController = [[NavigationController alloc] init];
    [self.window setRootViewController:rootViewController];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
