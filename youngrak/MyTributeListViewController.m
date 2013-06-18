//
//  MyTributeListViewController.m
//  youngrak
//
//  Created by 김규완 on 13. 6. 10..
//  Copyright (c) 2013년 coelsoft. All rights reserved.
//

#import "MyTributeListViewController.h"
#import "HttpManager.h"
#import "AppDelegate.h"
#import "Utils.h"
#import "ImageCache.h"
#import "TributeRoomViewController.h"

@interface MyTributeListViewController () <HttpManagerDelegate>

@property (nonatomic, retain) NSMutableArray *tributeRoomList;
@property (nonatomic, retain) IBOutlet UITableView *table;
@property (nonatomic, retain) HttpManager *httpManager;
@property NSMutableDictionary *imageCache;

@end

@implementation MyTributeListViewController {
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
    
    self.navigationItem.title = @"나의사이버추모방";
    imageQueue = dispatch_queue_create("com.coelsoft.youngrak.imageQueue", NULL);
    _imageCache = [[NSMutableDictionary alloc] init];
    
    //홈버튼 설정
    UIButton *hButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [hButton setBackgroundImage:[UIImage imageNamed:@"top_home_button"] forState:UIControlStateNormal];
    [hButton addTarget:self action:@selector(goHome) forControlEvents:UIControlEventTouchUpInside];
    hButton.frame = CGRectMake(0, 0, 44, 30);
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:hButton] autorelease];
    
    self.httpManager = [HttpManager sharedManager];
    

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    self.table = nil;
    self.tributeRoomList = nil;
    self.httpManager = nil;
}

- (void)dealloc {
    [_imageCache release];
    [super dealloc];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.httpManager.delegate = self;
    [self.httpManager requestMyTributeRoom];
}

#pragma mark -
#pragma mark Custom Method 
- (void)requestMyTributeRoomResult:(NSMutableArray *)result {
    
    NSLog(@"requestMyTributeRoomtList count = %d", result.count);
    
    self.tributeRoomList = result;
    
    [self.table reloadData];
}

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
	return self.tributeRoomList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	// TODO: Double-check for performance drain later
	
    static NSString *normalCellIdentifier = @"TributeListCell";
    //static NSString *switchCellIdentifier = @"SwitchCell";
    //static NSString *activityCellIdentifier = @"ActivityCell";
	//static NSString *textCellIdentifier = @"TextCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:normalCellIdentifier];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:normalCellIdentifier] autorelease];
		cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
	}
	
	NSUInteger row = [indexPath row];
	
	if (self.tributeRoomList != nil) {
        if(self.tributeRoomList.count > 0){
			NSDictionary *a = [self.tributeRoomList objectAtIndex:row];
                        
            cell.textLabel.text = [a objectForKey:@"dead_name"];
            cell.detailTextLabel.text = [NSString stringWithFormat:@"사망년월일:%@", [a objectForKey:@"dead_date"]];
            cell.imageView.image = [UIImage imageNamed:@"photo_blank"];
            NSString *imagePath = [a objectForKey:@"image"];
            
            if ([Utils isNullString:imagePath]) {
                NSLog(@"imagePath null");
                
            } else {
                
                //썸네일 이미지 미리 저장된 이미지로
                //NSString *thumbPath = [NSString stringWithFormat:@"%@/%@.png", documentsDirectory, interview.filename];
                //NSLog(@"thumbPath=%@", thumbPath);
                //UIImage *thumbImg = [UIImage imageWithContentsOfFile:thumbPath];
                //[movieListCell.thumbnailImageView setImage:thumbImg];
                //NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:thumbPath]];
                
                //if ([[ImageCache sharedImageCache] isExist:interview.filename]) {
                if ([self.imageCache objectForKey:imagePath] != nil) {
                    //UIImage *thumbImg = [[ImageCache sharedImageCache] getImage:interview.filename];
                    UIImage *thumbImg = [self.imageCache objectForKey:imagePath];
                    cell.imageView.image = thumbImg;
                    NSLog(@"use cache");
                } else {
                    NSLog(@"use image load");
                    dispatch_async(imageQueue, ^{
                        NSString *imageUrlString = [NSString stringWithFormat:@"http://www.cyberyoungrak.or.kr%@", [a objectForKey:@"image"]];
                        NSLog(@"imageUrl = %@", imageUrlString);
                        NSURL * imageURL = [NSURL URLWithString:imageUrlString];
                        NSData * imageData = [NSData dataWithContentsOfURL:imageURL];
                        UIImage * image = [UIImage imageWithData:imageData];
                        //[[ImageCache sharedImageCache] addImage:interview.filename image:thumbImg];
                        [self.imageCache setValue:image forKey:imagePath];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            cell.imageView.image = image;
                            //[self.table reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
                        });
                    });
                }
            }
            
            
        }
    }
	
	return cell;
}


#pragma mark -
#pragma mark Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (void)tableView:(UITableView *)tv didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	NSUInteger row = [indexPath row];
    
    NSDictionary *a = [self.tributeRoomList objectAtIndex:row];
    
    TributeRoomViewController *tribute = [[TributeRoomViewController alloc] initWithNibName:@"TributeRoomViewController" bundle:nil];
    tribute.userInfo = a;
    
    [self.navigationController pushViewController:tribute animated:YES];
    
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
