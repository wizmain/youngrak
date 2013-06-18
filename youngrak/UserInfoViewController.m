//
//  UserInfoViewController.m
//  youngrak
//
//  Created by 김규완 on 13. 6. 10..
//  Copyright (c) 2013년 coelsoft. All rights reserved.
//

#import "UserInfoViewController.h"
#import "MapInfoViewController.h"
#import "HttpManager.h"
#import "AppDelegate.h"
#import "AlertUtils.h"

@interface UserInfoViewController () <HttpManagerDelegate>

@property (nonatomic, retain) IBOutlet UILabel *label1;
@property (nonatomic, retain) IBOutlet UILabel *label2;
@property (nonatomic, retain) IBOutlet UILabel *label3;
@property (nonatomic, retain) IBOutlet UILabel *label4;
@property (nonatomic, retain) IBOutlet UILabel *label5;
@property (nonatomic, retain) IBOutlet UILabel *label6;
@property (nonatomic, retain) IBOutlet UILabel *titleLabel;
@property (nonatomic, retain) IBOutlet UIButton *locationButton;
@property (nonatomic, retain) IBOutlet UIButton *tributeButton;
@property (nonatomic, retain) HttpManager *httpManager;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *activityIndicator;

- (IBAction)goLocation:(id)sender;
- (IBAction)requestTribute:(id)sender;

@end

@implementation UserInfoViewController

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
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"고인찾기";
    
    //홈버튼 설정
    UIButton *hButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [hButton setBackgroundImage:[UIImage imageNamed:@"top_home_button"] forState:UIControlStateNormal];
    [hButton addTarget:self action:@selector(goHome) forControlEvents:UIControlEventTouchUpInside];
    hButton.frame = CGRectMake(0, 0, 44, 30);
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:hButton] autorelease];
    
    
    if (self.userInfo) {
        self.titleLabel.text = [self.userInfo objectForKey:@"dead_name"];
        self.label1.text = [self.userInfo objectForKey:@"dead_sex"];
        self.label2.text = [self.userInfo objectForKey:@"bury_date"];
        self.label3.text = [self.userInfo objectForKey:@"area_type"];
        self.label4.text = [self.userInfo objectForKey:@"dead_id"];
        self.label5.text = [self.userInfo objectForKey:@"dead_date"];
        self.label6.text = [self.userInfo objectForKey:@"pay_name"];
    }
    
    self.httpManager = [HttpManager sharedManager];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    
    self.label1 = nil;
    self.label2 = nil;
    self.label3 = nil;
    self.label4 = nil;
    self.label5 = nil;
    self.label6 = nil;
    self.titleLabel = nil;
    self.locationButton = nil;
    self.tributeButton = nil;
}


#pragma mark -
#pragma mark Custom Method
- (void)goHome {
    if(IS_iOS_6){
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self dismissModalViewControllerAnimated:YES];
    }
    
    
}

- (IBAction)goLocation:(id)sender {
    MapInfoViewController *mapInfo = [[MapInfoViewController alloc] initWithNibName:@"MapInfoViewController" bundle:nil];
    
    /*
    UIImage *naviBg = [UIImage imageNamed:@"titlebar_bg"];
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:mapInfo];
    
    if([navi.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)]) {
        [navi.navigationBar setBackgroundImage:naviBg forBarMetrics:UIBarMetricsDefault];
    }
    if(IS_iOS_6) {
        [self presentViewController:navi animated:YES completion:nil];
    } else {
        [self presentModalViewController:navi animated:YES];
    }
    
    [naviBg release];
    [mapInfo release];
    [navi release];
    */
    
    [self.navigationController pushViewController:mapInfo animated:YES];
}

- (IBAction)requestTribute:(id)sender {
    
    NSLog(@"requestTribute Click");
    
    
    
    [self.activityIndicator startAnimating];
    if([[AppDelegate sharedAppDelegate] isAuthenticated]){
        NSString *userID = [[AppDelegate sharedAppDelegate] authUserID];
        self.httpManager.delegate = self;
        [self.httpManager requestTribute:[self.userInfo objectForKey:@"dead_id"] checkType:[self.userInfo objectForKey:@"check_type"] areaType:[self.userInfo objectForKey:@"area_type"] memID:userID];
        
    } else {
        AlertWithMessage(@"로그인 후에 이용해 주세요");
    }
}
- (void)requestTributeResult:(NSString*)result message:(NSString*)message {
    NSLog(@"result=%@", result);
    [self.activityIndicator stopAnimating];
    
    if([result isEqualToString:@"success"]) {
        AlertWithMessage(@"생성되었습니다");
    } else {
        AlertWithMessage(message);
    }
}

@end
