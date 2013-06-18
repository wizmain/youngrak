//
//  TributeRoomViewController.m
//  youngrak
//
//  Created by 김규완 on 13. 6. 11..
//  Copyright (c) 2013년 coelsoft. All rights reserved.
//

#import "TributeRoomViewController.h"
#import "HttpManager.h"
#import "TributeManageViewController.h"
#import "TributeAlbumViewController.h"
#import "AlertUtils.h"
#import "ImageCache.h"
#import "Utils.h"
#import "WebViewController.h"
#import "Constant.h"

@interface TributeRoomViewController () <HttpManagerDelegate>

@property (nonatomic, retain) IBOutlet UITableView *table;
@property (nonatomic, retain) IBOutlet UIButton *manageButton;
@property (nonatomic, retain) IBOutlet UIButton *photoButton;
@property (nonatomic, retain) IBOutlet UIButton *movieButton;
@property (nonatomic, retain) IBOutlet UIImageView *tributeImage;
@property (nonatomic, retain) NSMutableArray *letterList;
@property (nonatomic, retain) NSString *cm1ID;
@property (nonatomic, retain) HttpManager *httpManager;
@property (nonatomic, retain) IBOutlet UIButton *memoryButton;

@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *activityIndicator;
@property NSMutableDictionary *imageCache;

- (IBAction)manageButtonClick:(id)sender;
- (IBAction)photoButtonClick:(id)sender;
- (IBAction)movieButtonClick:(id)sender;
- (IBAction)memoryButtonClick:(id)sender;

@end

@implementation TributeRoomViewController {
    dispatch_queue_t imageQueue;
}

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
    
    //self.navigationItem.title = @"사이버추모방";
    
    imageQueue = dispatch_queue_create("com.coelsoft.youngrak.imageQueue", NULL);
    _imageCache = [[NSMutableDictionary alloc] init];
    
    //홈버튼 설정
    UIButton *hButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [hButton setBackgroundImage:[UIImage imageNamed:@"top_home_button"] forState:UIControlStateNormal];
    [hButton addTarget:self action:@selector(goHome) forControlEvents:UIControlEventTouchUpInside];
    hButton.frame = CGRectMake(0, 0, 44, 30);
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:hButton] autorelease];
    
    self.cm1ID = [self.userInfo objectForKey:@"cm1_id"];
    self.navigationItem.title = [self.userInfo objectForKey:@"dead_name"];
    self.httpManager = [HttpManager sharedManager];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.httpManager.delegate = self;
    [self.httpManager requestMemoryList:[self.userInfo objectForKey:@"cm1_id"]];
    
    NSString *imageUrl = [self.userInfo objectForKey:@"image"];
    
    if([Utils isNullString:imageUrl]){
        imageUrl = [self.userInfo objectForKey:@"cm1_image"];
    }
    
    if ([Utils isNullString:imageUrl]) {
        
    } else {
        if ([self.imageCache objectForKey:imageUrl] != nil) {
            //UIImage *thumbImg = [[ImageCache sharedImageCache] getImage:interview.filename];
            UIImage *thumbImg = [self.imageCache objectForKey:imageUrl];
            self.tributeImage.image = thumbImg;
            NSLog(@"use cache");
        } else {
            NSLog(@"use image load");
            dispatch_async(imageQueue, ^{
                
                [self.activityIndicator startAnimating];
                
                NSString *imageUrlString = [NSString stringWithFormat:@"http://www.cyberyoungrak.or.kr%@", imageUrl];
                NSLog(@"imageUrl = %@", imageUrlString);
                NSURL * imageURL = [NSURL URLWithString:imageUrlString];
                NSData * imageData = [NSData dataWithContentsOfURL:imageURL];
                UIImage * image = [UIImage imageWithData:imageData];
                //[[ImageCache sharedImageCache] addImage:interview.filename image:thumbImg];
                [self.imageCache setValue:image forKey:imageUrl];
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    self.tributeImage.image = image;
                    [self.activityIndicator stopAnimating];
                    //[self.table reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
                });
            });
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    self.table = nil;
    self.manageButton = nil;
    self.photoButton = nil;
    self.movieButton = nil;
    self.tributeImage = nil;
    self.letterList = nil;
    self.imageCache = nil;
}

- (void)dealloc {
    [_imageCache release];
    [super dealloc];
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

- (void)requestMemoryListResult:(NSMutableArray *)result {
    self.letterList = result;
    NSLog(@"result count=%d", result.count);
    [self.table reloadData];
}

- (IBAction)manageButtonClick:(id)sender {
    TributeManageViewController *manage = [[TributeManageViewController alloc] initWithNibName:@"TributeManageViewController" bundle:nil];
    manage.userInfo = self.userInfo;
    [self.navigationController pushViewController:manage animated:YES];
}

- (IBAction)photoButtonClick:(id)sender {
    TributeAlbumViewController *album = [[TributeAlbumViewController alloc] initWithNibName:@"TributeAlbumViewController" bundle:nil];
    album.tribute = self.userInfo;
    [self.navigationController pushViewController:album animated:YES];
}

- (IBAction)movieButtonClick:(id)sender {
    AlertWithMessage(@"동영상이 없습니다");
}

- (IBAction)memoryButtonClick:(id)sender {
    WebViewController *webview = [[WebViewController alloc] initWithNibName:@"WebViewController" bundle:nil];
    webview.title = @"추모의글";
    webview.urlString = [NSString stringWithFormat:@"/cms/cyber/cyber_memory2_list_mobile2.php?cm1_id2=%@", [self.userInfo objectForKey:@"cm1_id"]];
    [self.navigationController pushViewController:webview animated:YES];
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
	}
	
	NSUInteger row = [indexPath row];
	
	if (self.letterList != nil) {
        if(self.letterList.count > 0){
			NSDictionary *a = [self.letterList objectAtIndex:row];
            NSLog(@"a=%@", a);
            if(a){
                if([a objectForKey:@"cm2_title"] != (id)[NSNull null]){
                    cell.textLabel.text = [a objectForKey:@"cm2_title"];
                }
                if([a objectForKey:@"mb_name"] != (id)[NSNull null]){
                    cell.detailTextLabel.text = [a objectForKey:@"mb_name"];
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
	
    [self memoryButtonClick:nil];
    
    //WebViewController *webview = [[WebViewController alloc] initWithNibName:@"WebViewController" bundle:nil];
    //webview.title = @"추모의글";
    //webview.urlString = [NSString stringWithFormat:@"/cms/cyber/cyber_memory2_list_mobile2.php?cm1_id2=%@", [self.userInfo objectForKey:@"cm1_id"]];
    //[self.navigationController pushViewController:webview animated:YES];
    
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
