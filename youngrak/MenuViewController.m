//
//  MenuViewController.m
//  youngrak
//
//  Created by 김규완 on 13. 6. 7..
//  Copyright (c) 2013년 coelsoft. All rights reserved.
//

#import "MenuViewController.h"
#import "WebViewController.h"
#import "ApplyViewController.h"
#import "TributeSearchViewController.h"
#import "MapInfoViewController.h"
#import "MyTributeListViewController.h"
#import "AppDelegate.h"
#import "AlertUtils.h"
#import "QRViewController.h"
#import "MapInfo2ViewController.h"

@interface MenuViewController ()

@property (nonatomic, retain) IBOutlet UITableView *table;


@end

@implementation MenuViewController

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
    
    //홈버튼 설정
    UIButton *homeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [homeButton setBackgroundImage:[UIImage imageNamed:@"top_home_button"] forState:UIControlStateNormal];
    [homeButton addTarget:self action:@selector(goHome) forControlEvents:UIControlEventTouchUpInside];
    homeButton.frame = CGRectMake(0, 0, 44, 30);
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:homeButton] autorelease];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    _table = nil;
    _menuList = nil;
    [super viewDidUnload];
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


#pragma mark -
#pragma mark Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.menuList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	// TODO: Double-check for performance drain later
	
    static NSString *normalCellIdentifier = @"MenuListCell";
    //static NSString *switchCellIdentifier = @"SwitchCell";
    //static NSString *activityCellIdentifier = @"ActivityCell";
	//static NSString *textCellIdentifier = @"TextCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:normalCellIdentifier];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:normalCellIdentifier] autorelease];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	}
	
	NSUInteger row = [indexPath row];
	
	if (self.menuList != nil) {
        if(self.menuList.count > 0){
			NSDictionary *a = [self.menuList objectAtIndex:row];
            NSLog(@"a=%@", a);
            if(a){
                if([a objectForKey:@"title"] != (id)[NSNull null]){
                    cell.textLabel.text = [a objectForKey:@"title"];
                }
                
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


- (void)tableView:(UITableView *)tv didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	NSUInteger row = [indexPath row];
    
    NSDictionary *a = [self.menuList objectAtIndex:row];
    NSString *menu = (NSString *)[a objectForKey:@"menu"];
    if ([menu isEqualToString:@"1_1"]) {//사이버 추모관 안내
        WebViewController *web = [[WebViewController alloc] initWithNibName:@"WebViewController" bundle:nil];
        web.urlString = @"/m/1_1.php";
        web.title = [a objectForKey:@"title"];
        
        [self.navigationController pushViewController:web animated:YES];
    } else if ([menu isEqualToString:@"1_2"]) {//이용안내 및 신청
        ApplyViewController *apply = [[ApplyViewController alloc] initWithNibName:@"ApplyViewController" bundle:nil];
        [self.navigationController pushViewController:apply animated:YES];
        
    } else if ([menu isEqualToString:@"1_3"]) {//사이버추모관검색
        TributeSearchViewController *search = [[TributeSearchViewController alloc] initWithNibName:@"TributeSearchViewController" bundle:nil];
        [self.navigationController pushViewController:search animated:YES];
    } else if ([menu isEqualToString:@"1_4"]) {//하늘나라 우체국
        WebViewController *web = [[WebViewController alloc] initWithNibName:@"WebViewController" bundle:nil];
        web.urlString = @"/cms/bbs/board_mobile.php?dk_table=cyber_04_4";
        web.title = [a objectForKey:@"title"];
        [self.navigationController pushViewController:web animated:YES];
    } else if ([menu isEqualToString:@"2_1"]) {//고인검색
        
    } else if ([menu isEqualToString:@"3_1"]) {//사이버추모관이용안내
        WebViewController *web = [[WebViewController alloc] initWithNibName:@"WebViewController" bundle:nil];
        web.urlString = @"/m/3_1.php";
        web.title = [a objectForKey:@"title"];
        
        [self.navigationController pushViewController:web animated:YES];
    } else if ([menu isEqualToString:@"3_2"]) {//추모방검색
        TributeSearchViewController *tribute = [[TributeSearchViewController alloc] initWithNibName:@"TributeSearchViewController" bundle:nil];
        [self.navigationController pushViewController:tribute animated:YES];
    } else if ([menu isEqualToString:@"3_3"]) {//내가개설한사이버추모관
        if ([[AppDelegate sharedAppDelegate] isAuthenticated]) {
            MyTributeListViewController *myTribute = [[MyTributeListViewController alloc] initWithNibName:@"MyTributeListViewController" bundle:nil];
            [self.navigationController pushViewController:myTribute animated:YES];
        } else {
            AlertWithMessage(@"로그인 후에 이용해 주세요");
        }
    } else if ([menu isEqualToString:@"4_1"]) {//QR코드 위치찾기
        QRViewController *qr = [[QRViewController alloc] initWithNibName:@"QRViewController" bundle:nil];
        [self.navigationController pushViewController:qr animated:YES];
    } else if ([menu isEqualToString:@"4_2"]) {//영락공원MAP
        MapInfo2ViewController *mapInfo = [[MapInfo2ViewController alloc] initWithNibName:@"MapInfo2ViewController" bundle:nil];
        [self.navigationController pushViewController:mapInfo animated:YES];
    } else if ([menu isEqualToString:@"5_1"]) {//문상예절
        MenuViewController *view = [[MenuViewController alloc] initWithNibName:@"MenuViewController" bundle:nil];
        NSDictionary *menu1 = [[NSDictionary alloc] initWithObjectsAndKeys:@"문상절차", @"title", @"5_1_1", @"menu", nil];
        NSDictionary *menu2 = [[NSDictionary alloc] initWithObjectsAndKeys:@"문상객의 옷차림", @"title", @"5_1_2", @"menu", nil];
        NSDictionary *menu3 = [[NSDictionary alloc] initWithObjectsAndKeys:@"절하는법", @"title", @"5_1_3", @"menu", nil];
        NSDictionary *menu4 = [[NSDictionary alloc] initWithObjectsAndKeys:@"문상할 때의 인사말", @"title", @"5_1_4", @"menu", nil];
        NSDictionary *menu5 = [[NSDictionary alloc] initWithObjectsAndKeys:@"문상시 삼가야 할 일", @"title", @"5_1_5", @"menu", nil];
        NSMutableArray *menuList = [NSMutableArray arrayWithObjects:menu1, menu2, menu3, menu4, menu5, nil];
        view.navigationItem.title = @"절하는법";
        view.menuList = menuList;
        [menu1 release];
        [menu2 release];
        [menu3 release];
        [menu4 release];
        [menu5 release];
        [self.navigationController pushViewController:view animated:YES];
    } else if ([menu isEqualToString:@"5_1_1"]) {//문상절차
        WebViewController *web = [[WebViewController alloc] initWithNibName:@"WebViewController" bundle:nil];
        web.urlString = @"/m/5_1_1.php";
        web.title = [a objectForKey:@"title"];
        
        [self.navigationController pushViewController:web animated:YES];
    } else if ([menu isEqualToString:@"5_1_2"]) {//문상객의옷차림
        WebViewController *web = [[WebViewController alloc] initWithNibName:@"WebViewController" bundle:nil];
        web.urlString = @"/m/5_1_2.php";
        web.title = [a objectForKey:@"title"];
        
        [self.navigationController pushViewController:web animated:YES];
    } else if ([menu isEqualToString:@"5_1_3"]) {//절하는법
        MenuViewController *view = [[MenuViewController alloc] initWithNibName:@"MenuViewController" bundle:nil];
        NSDictionary *menu1 = [[NSDictionary alloc] initWithObjectsAndKeys:@"절의의미", @"title", @"5_1_3_1", @"menu", nil];
        NSDictionary *menu2 = [[NSDictionary alloc] initWithObjectsAndKeys:@"절하기전바른자세", @"title", @"5_1_3_2", @"menu", nil];
        NSDictionary *menu3 = [[NSDictionary alloc] initWithObjectsAndKeys:@"남자의절", @"title", @"5_1_3_3", @"menu", nil];
        NSDictionary *menu4 = [[NSDictionary alloc] initWithObjectsAndKeys:@"여자의절", @"title", @"5_1_3_4", @"menu", nil];
        NSMutableArray *menuList = [NSMutableArray arrayWithObjects:menu1, menu2, menu3, menu4, nil];
        view.navigationItem.title = @"절하는법";
        view.menuList = menuList;
        [menu1 release];
        [menu2 release];
        [menu3 release];
        [menu4 release];
        [self.navigationController pushViewController:view animated:YES];
    } else if ([menu isEqualToString:@"5_1_3_1"]) {//절의의미
        WebViewController *web = [[WebViewController alloc] initWithNibName:@"WebViewController" bundle:nil];
        web.urlString = @"/m/5_1_3_1.php";
        web.title = [a objectForKey:@"title"];
        
        [self.navigationController pushViewController:web animated:YES];
    } else if ([menu isEqualToString:@"5_1_3_2"]) {//절하기전 바른자세
        WebViewController *web = [[WebViewController alloc] initWithNibName:@"WebViewController" bundle:nil];
        web.urlString = @"/m/5_1_3_2.php";
        web.title = [a objectForKey:@"title"];
        
        [self.navigationController pushViewController:web animated:YES];
    } else if ([menu isEqualToString:@"5_1_3_3"]) {//남자의 절
        WebViewController *web = [[WebViewController alloc] initWithNibName:@"WebViewController" bundle:nil];
        web.urlString = @"/m/5_1_3_3.php";
        web.title = [a objectForKey:@"title"];
        
        [self.navigationController pushViewController:web animated:YES];
    } else if ([menu isEqualToString:@"5_1_3_4"]) {//여자의절
        WebViewController *web = [[WebViewController alloc] initWithNibName:@"WebViewController" bundle:nil];
        web.urlString = @"/m/5_1_3_4.php";
        web.title = [a objectForKey:@"title"];
        
        [self.navigationController pushViewController:web animated:YES];
    } else if ([menu isEqualToString:@"5_1_4"]) {//문상할 때의 인사말
        WebViewController *web = [[WebViewController alloc] initWithNibName:@"WebViewController" bundle:nil];
        web.urlString = @"/m/5_1_4.php";
        web.title = [a objectForKey:@"title"];
        
        [self.navigationController pushViewController:web animated:YES];
    } else if ([menu isEqualToString:@"5_1_5"]) {//문상시 삼가야 할 일
        WebViewController *web = [[WebViewController alloc] initWithNibName:@"WebViewController" bundle:nil];
        web.urlString = @"/m/5_1_5.php";
        web.title = [a objectForKey:@"title"];
        
        [self.navigationController pushViewController:web animated:YES];
    } else if ([menu isEqualToString:@"5_2"]) {//장례절차
        WebViewController *web = [[WebViewController alloc] initWithNibName:@"WebViewController" bundle:nil];
        web.urlString = @"/m/5_1_6.php";
        web.title = [a objectForKey:@"title"];
        
        [self.navigationController pushViewController:web animated:YES];
    } else if ([menu isEqualToString:@"6_1"]) {//영락공원소개
        WebViewController *web = [[WebViewController alloc] initWithNibName:@"WebViewController" bundle:nil];
        web.urlString = @"/m/5_1.php";
        web.title = [a objectForKey:@"title"];
        
        [self.navigationController pushViewController:web animated:YES];
    } else if ([menu isEqualToString:@"6_2"]) {//공지사항
        WebViewController *web = [[WebViewController alloc] initWithNibName:@"WebViewController" bundle:nil];
        web.urlString = @"/cms/bbs/board_mobile.php?dk_table=cyber_06_1";
        web.title = [a objectForKey:@"title"];
        
        [self.navigationController pushViewController:web animated:YES];
    } else if ([menu isEqualToString:@"6_3"]) {//오시는길
        WebViewController *web = [[WebViewController alloc] initWithNibName:@"WebViewController" bundle:nil];
        web.urlString = @"/m/5_5.php";
        web.title = [a objectForKey:@"title"];
        
        [self.navigationController pushViewController:web animated:YES];
    } else if ([menu isEqualToString:@"6_4"]) {//장사시설안내
        MenuViewController *view = [[MenuViewController alloc] initWithNibName:@"MenuViewController" bundle:nil];
        NSDictionary *menu1 = [[NSDictionary alloc] initWithObjectsAndKeys:@"화장시설", @"title", @"6_4_1", @"menu", nil];
        NSDictionary *menu2 = [[NSDictionary alloc] initWithObjectsAndKeys:@"일반매장", @"title", @"6_4_2", @"menu", nil];
        NSDictionary *menu3 = [[NSDictionary alloc] initWithObjectsAndKeys:@"추모관(봉안당)", @"title", @"6_4_3", @"menu", nil];
        NSDictionary *menu4 = [[NSDictionary alloc] initWithObjectsAndKeys:@"자연장", @"title", @"6_4_4", @"menu", nil];
        NSDictionary *menu5 = [[NSDictionary alloc] initWithObjectsAndKeys:@"가족봉안묘", @"title", @"6_4_5", @"menu", nil];
        NSDictionary *menu6 = [[NSDictionary alloc] initWithObjectsAndKeys:@"2기평장분묘", @"title", @"6_4_6", @"menu", nil];
        NSMutableArray *menuList = [NSMutableArray arrayWithObjects:menu1, menu2, menu3, menu4, menu5, menu6, nil];
        view.navigationItem.title = @"장사시설안내";
        view.menuList = menuList;
        [menu1 release];
        [menu2 release];
        [menu3 release];
        [menu4 release];
        [self.navigationController pushViewController:view animated:YES];

    } else if ([menu isEqualToString:@"6_4_1"]) {//화장시설
        WebViewController *web = [[WebViewController alloc] initWithNibName:@"WebViewController" bundle:nil];
        web.urlString = @"/m/6_4_1.php";
        web.title = [a objectForKey:@"title"];
        
        [self.navigationController pushViewController:web animated:YES];
    } else if ([menu isEqualToString:@"6_4_2"]) {//일반매장
        WebViewController *web = [[WebViewController alloc] initWithNibName:@"WebViewController" bundle:nil];
        web.urlString = @"/m/6_4_2.php";
        web.title = [a objectForKey:@"title"];
        
        [self.navigationController pushViewController:web animated:YES];
    } else if ([menu isEqualToString:@"6_4_3"]) {//추모관(봉안당)
        WebViewController *web = [[WebViewController alloc] initWithNibName:@"WebViewController" bundle:nil];
        web.urlString = @"/m/6_4_3.php";
        web.title = [a objectForKey:@"title"];
        
        [self.navigationController pushViewController:web animated:YES];
    } else if ([menu isEqualToString:@"6_4_4"]) {//자연장
        WebViewController *web = [[WebViewController alloc] initWithNibName:@"WebViewController" bundle:nil];
        web.urlString = @"/m/6_4_4.php";
        web.title = [a objectForKey:@"title"];
        
        [self.navigationController pushViewController:web animated:YES];
    } else if ([menu isEqualToString:@"6_4_5"]) {//가족봉안묘
        WebViewController *web = [[WebViewController alloc] initWithNibName:@"WebViewController" bundle:nil];
        web.urlString = @"/m/6_4_5.php";
        web.title = [a objectForKey:@"title"];
        
        [self.navigationController pushViewController:web animated:YES];
    } else if ([menu isEqualToString:@"6_4_6"]) {//2기평장분묘
        WebViewController *web = [[WebViewController alloc] initWithNibName:@"WebViewController" bundle:nil];
        web.urlString = @"/m/6_4_6.php";
        web.title = [a objectForKey:@"title"];
        
        [self.navigationController pushViewController:web animated:YES];
    }
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
