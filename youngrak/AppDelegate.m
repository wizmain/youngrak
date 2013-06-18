//
//  AppDelegate.m
//  youngrak
//
//  Created by 김규완 on 13. 6. 5..
//  Copyright (c) 2013년 coelsoft. All rights reserved.
//

#import "AppDelegate.h"
#import "HomeViewController.h"
#import "LoginViewController.h"

@implementation AppDelegate

@synthesize homeViewController, loginViewController;
@synthesize authUserID, alertRunning;


+ (AppDelegate *)sharedAppDelegate {
	return (AppDelegate *)[UIApplication sharedApplication].delegate;
}

- (void)dealloc
{
    [_window release];
    
    [homeViewController release];
    [loginViewController release];
    [authUserID release];
    
    
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    
    
    if (self.homeViewController.view.superview == nil) {
		if (self.homeViewController == nil) {
			HomeViewController *homeView = [[HomeViewController alloc]
											initWithNibName:@"HomeViewController"
											bundle:nil];
			self.homeViewController = homeView;
			//CGRect newFrame = self.window.frame;
			//self.mainViewController.view.frame = CGRectMake(0, 20, 320, 460);
            CGRect rect = [[UIScreen mainScreen] bounds];
            self.homeViewController.view.frame = rect;
			[homeView release];
		}
	}
    
    if (self.loginViewController == nil) {
		LoginViewController *login = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
		self.loginViewController = login;
		[login release];
        
		//self.loginViewController.view.frame = CGRectMake(0, 20, 320, 460);
        //CGRect rect = [[UIScreen mainScreen] bounds];
        
        //self.loginViewController.view.frame = CGRectMake(rect.origin.x, rect.origin.y+20, rect.size.width, rect.size.height);
	}
    
    
    
	//[self.window addSubview:self.loginViewController.view];
    //[self.window addSubview:self.homeViewController.view];
    _window.rootViewController = homeViewController;
    
    [self.window makeKeyAndVisible];
    return YES;
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
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


- (void)switchHomeView {
    NSLog(@"switchMainView");
	if (self.homeViewController == nil) {
		HomeViewController *home = [[HomeViewController alloc] initWithNibName:@"HomeViewController" bundle:nil];
        
		self.homeViewController = home;
        CGRect rect = [[UIScreen mainScreen] bounds];
        self.homeViewController.view.frame = CGRectMake(rect.origin.x, rect.origin.y+20, rect.size.width, rect.size.height);
        
        
		[home release];
        
	}
    
    [self.window addSubview:self.homeViewController.view];
    //[self.window bringSubviewToFront:self.mainViewController.view];
	
}

- (void)switchLoginView {
    
	if (self.loginViewController == nil) {
		LoginViewController *login = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
		self.loginViewController = login;
		[login release];
        
		//self.loginViewController.view.frame = CGRectMake(0, 20, 320, 460);
        CGRect rect = [[UIScreen mainScreen] bounds];
        
        self.loginViewController.view.frame = CGRectMake(rect.origin.x, rect.origin.y+20, rect.size.width, rect.size.height);
	}
	[self.window addSubview:self.loginViewController.view];
}

@end
