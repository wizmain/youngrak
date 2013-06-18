//
//  ApplyViewController.m
//  youngrak
//
//  Created by 김규완 on 13. 6. 9..
//  Copyright (c) 2013년 coelsoft. All rights reserved.
//

#import "ApplyViewController.h"
#import "UserSearchViewController.h"

@interface ApplyViewController ()

@property (nonatomic, retain) IBOutlet UIWebView *webview;
@property (nonatomic, retain) IBOutlet UIButton *requestButton;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *loadingIndicator;

- (IBAction)requestTribute:(id)sender;

@end

@implementation ApplyViewController

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
    
    if (IS_iPhone_5) {
        
    } else {
        CGRect frame = _loadingIndicator.frame;
        frame.origin.y = 198;
        self.loadingIndicator.frame = frame;
        
        //CGRect buttonFrame = self.requestButton.frame;
        //buttonFrame.origin.y =
    }
    
    self.navigationItem.title = @"이용안내 및 신청";
    
    //홈버튼 설정
    UIButton *homeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [homeButton setBackgroundImage:[UIImage imageNamed:@"top_home_button"] forState:UIControlStateNormal];
    [homeButton addTarget:self action:@selector(goHome) forControlEvents:UIControlEventTouchUpInside];
    homeButton.frame = CGRectMake(0, 0, 44, 30);
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:homeButton] autorelease];
    
    NSURL *url = [NSURL URLWithString:@"http://www.cyberyoungrak.or.kr/m/1_2.php"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webview loadRequest:request];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    _webview = nil;
    _requestButton = nil;
}

- (IBAction)requestTribute:(id)sender {
    UserSearchViewController *userSearch = [[UserSearchViewController alloc] initWithNibName:@"UserSearchViewController" bundle:nil];
    [self.navigationController pushViewController:userSearch animated:YES];
}


- (void)goHome {
    if(IS_iOS_6){
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self dismissModalViewControllerAnimated:YES];
    }
    
    
}
@end
