//
//  HomeViewController.m
//  youngrak
//
//  Created by 김규완 on 13. 6. 5..
//  Copyright (c) 2013년 coelsoft. All rights reserved.
//

#import "HomeViewController.h"
#import "HttpManager.h"
#import "TouchXML.h"
#import "MenuViewController.h"
#import "UserSearchViewController.h"
#import "AppDelegate.h"
#import "LoginViewController.h"

@interface HomeViewController ()

@property (nonatomic, retain) IBOutlet UIButton *button1;
@property (nonatomic, retain) IBOutlet UIButton *button2;
@property (nonatomic, retain) IBOutlet UIButton *button3;
@property (nonatomic, retain) IBOutlet UIButton *button4;
@property (nonatomic, retain) IBOutlet UIButton *button5;
@property (nonatomic, retain) IBOutlet UIButton *button6;
@property (nonatomic, retain) IBOutlet UITableView *table;
@property (nonatomic, retain) HttpManager *httpManager;
@property (nonatomic, retain) NSMutableArray *letterList;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (nonatomic, retain) IBOutlet UIButton *loginButton;
@property (nonatomic, retain) IBOutlet UIImageView *mainBg;
@property (nonatomic, retain) IBOutlet UIImageView *letterBox;

- (IBAction)buttonClick:(id)sender;
- (void)requestLetterList;
- (IBAction)loginButtonClick:(id)sender;

@end

@implementation HomeViewController {
    dispatch_queue_t letterQueue;
}

@synthesize button1, button2, button3, button4, button5, button6, table, letterList;

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
    
    //UIColor *backImg = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"main_bg"]];
    //self.view.backgroundColor = backImg;
    //[backImg release];
    
    if (IS_iPhone_5) {
        CGRect boxFrame = self.letterBox.frame;
        boxFrame.size.height = 214;
        self.letterBox.frame = boxFrame;
    }
    
    self.httpManager = [HttpManager sharedManager];
    self.httpManager.delegate = self;
    
    letterQueue = dispatch_queue_create("com.coelsoft.youngrak.letterQueue", NULL);
    
    dispatch_async(letterQueue, ^{
        [_activityIndicator startAnimating];
        [self requestLetterList];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.table reloadData];
            [_activityIndicator stopAnimating];
        });
    });
    
    //dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
    //    [self requestLetterList];
    //});
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ([[AppDelegate sharedAppDelegate] isAuthenticated]) {
        UIImage *logoutImage = [UIImage imageNamed:@"logout_button"];
        [self.loginButton setImage:logoutImage forState:UIControlStateNormal];
        [logoutImage release];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.button1 = nil;
    self.button2 = nil;
    self.button3 = nil;
    self.button4 = nil;
    self.button5 = nil;
    self.button6 = nil;
    self.table = nil;
    self.httpManager = nil;
    self.letterList = nil;
    _activityIndicator = nil;
}

- (void)dealloc
{
    [self.letterList release];
    [super dealloc];
}

#pragma mark -
#pragma mark Custom Method

- (IBAction)loginButtonClick:(id)sender {
    //[[AppDelegate sharedAppDelegate] switchLoginView];
    if ([[AppDelegate sharedAppDelegate] isAuthenticated]) {
        [self logout];
    } else {
    
        LoginViewController *login = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
        
        if(IS_iOS_6) {
            [self presentViewController:login animated:YES completion:nil];
        } else {
            [self presentModalViewController:login animated:YES];
        }
    }
}

- (IBAction)buttonClick:(id)sender {
    UIButton *button = (UIButton*)sender;
    if(button.tag == 0){//추모관안내
        MenuViewController *view = [[MenuViewController alloc] initWithNibName:@"MenuViewController" bundle:nil];
        NSDictionary *menu1 = [[NSDictionary alloc] initWithObjectsAndKeys:@"사이버추모관안내", @"title", @"1_1", @"menu", nil];
        NSDictionary *menu2 = [[NSDictionary alloc] initWithObjectsAndKeys:@"이용안내 및 신청", @"title", @"1_2", @"menu", nil];
        NSDictionary *menu3 = [[NSDictionary alloc] initWithObjectsAndKeys:@"사이버 추모관 검색", @"title", @"1_3", @"menu", nil];
        NSDictionary *menu4 = [[NSDictionary alloc] initWithObjectsAndKeys:@"하늘나라 우체국 편지", @"title", @"1_4", @"menu", nil];
        NSMutableArray *menuList = [NSMutableArray arrayWithObjects:menu1, menu2, menu3, menu4, nil];
        view.navigationItem.title = @"사이버추모관안내";
        view.menuList = menuList;
        [menu1 release];
        [menu2 release];
        [menu3 release];
        [menu4 release];
        
        UIImage *naviBg = [UIImage imageNamed:@"titlebar_bg"];
        UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:view];
        
        if([navi.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)]) {
            [navi.navigationBar setBackgroundImage:naviBg forBarMetrics:UIBarMetricsDefault];
        }
        if(IS_iOS_6) {
            [self presentViewController:navi animated:YES completion:nil];
        } else {
            [self presentModalViewController:navi animated:YES];
        }
        
        [naviBg release];
        [view release];
        [navi release];
        
    } else if(button.tag == 1) {//고인찾기
        UserSearchViewController *search = [[UserSearchViewController alloc] initWithNibName:@"UserSearchViewController" bundle:nil];
        search.navigationItem.title = @"고인찾기";
        UIImage *naviBg = [UIImage imageNamed:@"titlebar_bg"];
        UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:search];
        
        if([navi.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)]) {
            [navi.navigationBar setBackgroundImage:naviBg forBarMetrics:UIBarMetricsDefault];
        }
        if(IS_iOS_6) {
            [self presentViewController:navi animated:YES completion:nil];
        } else {
            [self presentModalViewController:navi animated:YES];
        }
        
        
        [naviBg release];
        [search release];
        [navi release];
        
    } else if(button.tag == 2) {//사이버추모
        MenuViewController *view = [[MenuViewController alloc] initWithNibName:@"MenuViewController" bundle:nil];
        NSDictionary *menu1 = [[NSDictionary alloc] initWithObjectsAndKeys:@"사이버추모관이용안내", @"title", @"3_1", @"menu", nil];
        NSDictionary *menu2 = [[NSDictionary alloc] initWithObjectsAndKeys:@"추모방검색", @"title", @"3_2", @"menu", nil];
        NSDictionary *menu3 = [[NSDictionary alloc] initWithObjectsAndKeys:@"내가개설한사이버추모관", @"title", @"3_3", @"menu", nil];
        NSMutableArray *menuList = [NSMutableArray arrayWithObjects:menu1, menu2, menu3, nil];
        view.navigationItem.title = @"사이버추모관이용안내";
        view.menuList = menuList;
        [menu1 release];
        [menu2 release];
        [menu3 release];
        
        UIImage *naviBg = [UIImage imageNamed:@"titlebar_bg"];
        UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:view];
        
        if([navi.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)]) {
            [navi.navigationBar setBackgroundImage:naviBg forBarMetrics:UIBarMetricsDefault];
        }
        if(IS_iOS_6) {
            [self presentViewController:navi animated:YES completion:nil];
        } else {
            [self presentModalViewController:navi animated:YES];
        }
        
        
        [naviBg release];
        [view release];
        [navi release];
    } else if(button.tag == 3) {//둘러보기
        MenuViewController *view = [[MenuViewController alloc] initWithNibName:@"MenuViewController" bundle:nil];
        NSDictionary *menu1 = [[NSDictionary alloc] initWithObjectsAndKeys:@"QR코드 위치찾기", @"title", @"4_1", @"menu", nil];
        NSDictionary *menu2 = [[NSDictionary alloc] initWithObjectsAndKeys:@"영락공원 MAP", @"title", @"4_2", @"menu", nil];
        NSMutableArray *menuList = [NSMutableArray arrayWithObjects:menu1, menu2, nil];
        view.navigationItem.title = @"둘러보기";
        view.menuList = menuList;
        [menu1 release];
        [menu2 release];
        
        UIImage *naviBg = [UIImage imageNamed:@"titlebar_bg"];
        UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:view];
        
        if([navi.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)]) {
            [navi.navigationBar setBackgroundImage:naviBg forBarMetrics:UIBarMetricsDefault];
        }
        if(IS_iOS_6) {
            [self presentViewController:navi animated:YES completion:nil];
        } else {
            [self presentModalViewController:navi animated:YES];
        }
        
        
        [naviBg release];
        [view release];
        [navi release];
    } else if(button.tag == 4) {//장례정보
        MenuViewController *view = [[MenuViewController alloc] initWithNibName:@"MenuViewController" bundle:nil];
        NSDictionary *menu1 = [[NSDictionary alloc] initWithObjectsAndKeys:@"문상예절", @"title", @"5_1", @"menu", nil];
        NSDictionary *menu2 = [[NSDictionary alloc] initWithObjectsAndKeys:@"장례절차", @"title", @"5_2", @"menu", nil];
        NSMutableArray *menuList = [NSMutableArray arrayWithObjects:menu1, menu2, nil];
        view.navigationItem.title = @"장례정보";
        view.menuList = menuList;
        [menu1 release];
        [menu2 release];
        
        UIImage *naviBg = [UIImage imageNamed:@"titlebar_bg"];
        UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:view];
        
        if([navi.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)]) {
            [navi.navigationBar setBackgroundImage:naviBg forBarMetrics:UIBarMetricsDefault];
        }
        if(IS_iOS_6) {
            [self presentViewController:navi animated:YES completion:nil];
        } else {
            [self presentModalViewController:navi animated:YES];
        }
        
        
        [naviBg release];
        [view release];
        [navi release];
    } else if(button.tag == 5) {//영락공원소개
        MenuViewController *view = [[MenuViewController alloc] initWithNibName:@"MenuViewController" bundle:nil];
        NSDictionary *menu1 = [[NSDictionary alloc] initWithObjectsAndKeys:@"영락공원소개", @"title", @"6_1", @"menu", nil];
        NSDictionary *menu2 = [[NSDictionary alloc] initWithObjectsAndKeys:@"공지사항", @"title", @"6_2", @"menu", nil];
        NSDictionary *menu3 = [[NSDictionary alloc] initWithObjectsAndKeys:@"오시는길", @"title", @"6_3", @"menu", nil];
        NSDictionary *menu4 = [[NSDictionary alloc] initWithObjectsAndKeys:@"장사시설안내", @"title", @"6_4", @"menu", nil];
        NSMutableArray *menuList = [NSMutableArray arrayWithObjects:menu1, menu2, menu3, menu4, nil];
        view.navigationItem.title = @"영락공원소개";
        view.menuList = menuList;
        [menu1 release];
        [menu2 release];
        [menu3 release];
        [menu4 release];
        
        UIImage *naviBg = [UIImage imageNamed:@"titlebar_bg"];
        UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:view];
        
        if([navi.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)]) {
            [navi.navigationBar setBackgroundImage:naviBg forBarMetrics:UIBarMetricsDefault];
        }
        if(IS_iOS_6) {
            [self presentViewController:navi animated:YES completion:nil];
        } else {
            [self presentModalViewController:navi animated:YES];
        }
        
        
        [naviBg release];
        [view release];
        [navi release];
    }
}

- (void)requestLetterList {
    
    NSLog(@"requestLetterList");
    
    
    
    letterList = [[NSMutableArray alloc] init];
    
    NSURL *url = [NSURL URLWithString:@"http://www.cyberyoungrak.or.kr/cms/bbs/rss.php?dk_table=cyber_04_4"];
    
    NSError *error = nil;
    
    CXMLDocument *theXMLDocument = [[[CXMLDocument alloc] initWithContentsOfURL:url options:0 error:&error] autorelease];
    NSArray *resultNodes = nil;
    
    if(error){
        NSLog(@"fail with = %@", error);
    }
    
    resultNodes = [theXMLDocument nodesForXPath:@"//item" error:nil];
    
    for(CXMLElement *item in resultNodes) {
        NSMutableDictionary *letter = [[NSMutableDictionary alloc] init];
        int i=0;
        for(i=0;i<[item childCount];i++){
            [letter setObject:[[item childAtIndex:i] stringValue] forKey:[[item childAtIndex:i] name]];
        }
        [letterList addObject:[letter copy]];
    }

}

- (void)logout {
    [self.httpManager logout];
    
    UIImage *loginImage = [UIImage imageNamed:@"login_button"];
    [self.loginButton setImage:loginImage forState:UIControlStateNormal];
    [loginImage release];
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.letterList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	// TODO: Double-check for performance drain later
	
    static NSString *normalCellIdentifier = @"LetterListCell";
    //static NSString *switchCellIdentifier = @"SwitchCell";
    //static NSString *activityCellIdentifier = @"ActivityCell";
	//static NSString *textCellIdentifier = @"TextCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:normalCellIdentifier];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:normalCellIdentifier] autorelease];
		cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSeparatorStyleNone;
	}
	
	NSUInteger row = [indexPath row];
	
	if (self.letterList != nil) {
        if(self.letterList.count > 0){
			NSDictionary *a = [self.letterList objectAtIndex:row];
            NSLog(@"a=%@", a);
            if(a){
                if([a objectForKey:@"title"] != (id)[NSNull null]){
                    cell.textLabel.text = [a objectForKey:@"title"];
                }
                
                NSString *dateString = [a objectForKey:@"dc:date"];
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                [formatter setDateFormat:@"EEE, dd MMM yyyy HH:mm:ss Z"];
                NSDate *date = [formatter dateFromString:dateString];
                [formatter setDateFormat:@"yyyy.MM.dd"];
                NSString *dateStringResult = [formatter stringFromDate:date];
                if([a objectForKey:@"dc:date"] != (id)[NSNull null]){
                    cell.detailTextLabel.text = dateStringResult;
                }
                
                [cell.textLabel setTextColor:[UIColor grayColor]];
                [cell.textLabel setFont:[cell.textLabel.font fontWithSize:14]];
                [cell.detailTextLabel setTextColor:[UIColor grayColor]];
                [cell.detailTextLabel setFont:[cell.detailTextLabel.font fontWithSize:12]];
                
                /*
                if([a objectForKey:@"s_date"] != (id)[NSNull null] && [a objectForKey:@"e_date"] != (id)[NSNull null]){
                    NSDateFormatter *format = [[NSDateFormatter alloc] init];
                    [format setDateFormat:@"yyyyMMddHHmmss"];
                    NSDate *sDate = [format dateFromString:[a objectForKey:@"s_date"]];
                    NSDate *eDate = [format dateFromString:[a objectForKey:@"e_date"]];
                    [format setDateFormat:@"yyyy-MM-dd"];
                    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ ~ %@",[format stringFromDate:sDate], [format stringFromDate:eDate]];
                    
                }
                */
            }
        }
    }
	
	return cell;
}


#pragma mark -
#pragma mark Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 30;
}

- (void)tableView:(UITableView *)tv didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	//NSUInteger row = [indexPath row];
    /*
	NSDictionary *a = [self.surveyList objectAtIndex:row];
    
    SurveyApplyViewController *apply = [[SurveyApplyViewController alloc] initWithNibName:@"SurveyApplyViewController" bundle:nil];
    apply.surveyInfo = a;
    UIImage *naviBg = [UIImage imageNamed:@"title_bg"];
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:apply];
    if([navi.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)]) {
        [navi.navigationBar setBackgroundImage:naviBg forBarMetrics:UIBarMetricsDefault];
    }
    [self presentModalViewController:navi animated:YES];
    [naviBg release];
    [apply release];
    [navi release];
    */
}


@end
