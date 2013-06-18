//
//  AppDelegate.h
//  youngrak
//
//  Created by 김규완 on 13. 6. 5..
//  Copyright (c) 2013년 coelsoft. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HomeViewController;
@class LoginViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, retain) HomeViewController *homeViewController;
@property (nonatomic, retain) LoginViewController *loginViewController;
@property (nonatomic, assign) BOOL isAuthenticated;
@property (nonatomic, retain) NSString *authUserID;
@property (nonatomic, getter = isAlertRunning) BOOL alertRunning;

+ (AppDelegate *)sharedAppDelegate;
- (void)switchHomeView;
- (void)switchLoginView;


@end
