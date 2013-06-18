//
//  TributeSearchViewController.m
//  youngrak
//
//  Created by 김규완 on 13. 6. 9..
//  Copyright (c) 2013년 coelsoft. All rights reserved.
//

#import "TributeSearchViewController.h"
#import "HttpManager.h"
#import "AppDelegate.h"
#import "ImageCache.h"
#import "Utils.h"
#import "TributeRoomViewController.h"
#import "AlertUtils.h"

@interface TributeSearchViewController () <HttpManagerDelegate>

@property (nonatomic, retain) IBOutlet UISearchBar *searchBar;
@property (nonatomic, retain) IBOutlet UITableView *table;
@property (nonatomic, retain) NSMutableArray *userList;
@property (nonatomic, assign) BOOL searching;
@property (nonatomic, assign) BOOL isSelectRow;
@property (nonatomic, retain) IBOutlet UISegmentedControl *segment;
@property (nonatomic, retain) HttpManager *httpManager;
@property NSMutableDictionary *imageCache;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *activityIndicator;

- (IBAction)segmentSelected:(id)sender;

@end

@implementation TributeSearchViewController {
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
    UIColor *backImg = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"main_bg"]];
    self.view.backgroundColor = backImg;
    [backImg release];
    
    self.navigationItem.title = @"사이버추모관검색";
    
    //홈버튼 설정
    UIButton *hButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [hButton setBackgroundImage:[UIImage imageNamed:@"top_home_button"] forState:UIControlStateNormal];
    [hButton addTarget:self action:@selector(goHome) forControlEvents:UIControlEventTouchUpInside];
    hButton.frame = CGRectMake(0, 0, 44, 30);
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:hButton] autorelease];
    
    self.httpManager = [HttpManager sharedManager];
    self.httpManager.delegate = self;
    
    imageQueue = dispatch_queue_create("com.coelsoft.youngrak.imageQueue", NULL);
    _imageCache = [[NSMutableDictionary alloc] init];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.searchBar = nil;
    self.userList = nil;
    self.table = nil;
    self.httpManager = nil;
}

- (void)dealloc {
	[_searchBar release];
	[_userList release];
    [_table release];
    [_imageCache release];
    [super dealloc];
}

#pragma mark -
#pragma mark Custom Method {

- (void)searchTribute {
    
    [self.activityIndicator startAnimating];
    NSString *areaType = @"2";
    if(self.segment.selectedSegmentIndex == 1){
        areaType = @"1";
    }
    
    [self.httpManager searchTribute:_searchBar.text areaType:areaType];
}

- (IBAction)segmentSelected:(id)sender {
    
}

- (void)searchTributeResult:(NSMutableArray *)result {
    
    NSLog(@"searchTributeResult = %@", result);
    
    self.userList = result;
    
    [self.table reloadData];
    
    [self.activityIndicator stopAnimating];
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
	NSLog(@"numberOfRowsInSection = %d", [self.userList count]);
	return [self.userList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	// TODO: Double-check for performance drain later
	
    static NSString *normalCellIdentifier = @"회원정보";
    //static NSString *switchCellIdentifier = @"SwitchCell";
    //static NSString *activityCellIdentifier = @"ActivityCell";
	//static NSString *textCellIdentifier = @"TextCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:normalCellIdentifier];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:normalCellIdentifier] autorelease];
	}
	
	NSUInteger row = [indexPath row];
	
	if (self.userList != nil) {
		
		if(self.userList.count > 0){
			
            NSDictionary *userInfo = [self.userList objectAtIndex:row];
            
            cell.textLabel.text = [userInfo objectForKey:@"dead_name"];
            cell.detailTextLabel.text = [NSString stringWithFormat:@"사망년월일:%@ 생성자:%@", [userInfo objectForKey:@"dead_date"], [userInfo objectForKey:@"maker_name"]];
            cell.imageView.image = [UIImage imageNamed:@"photo_blank"];
            NSString *imagePath = [userInfo objectForKey:@"image"];
            
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
                        NSString *imageUrlString = [NSString stringWithFormat:@"http://www.cyberyoungrak.or.kr%@", [userInfo objectForKey:@"image"]];
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
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
    if ([[AppDelegate sharedAppDelegate] isAuthenticated]) {
        int row = [indexPath row];
        NSDictionary *userInfo = [self.userList objectAtIndex:row];
        TributeRoomViewController *tribute = [[TributeRoomViewController alloc] initWithNibName:@"TributeRoomViewController" bundle:nil];
        tribute.userInfo = userInfo;
        
        [self.navigationController pushViewController:tribute animated:YES];
    } else {
        AlertWithMessage(@"로그인 후에 이용해 주세요");
    }
	
}

#pragma mark -
#pragma mark SearchBar Delegate
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
	_searching = YES;
	_isSelectRow = NO;
	self.table.scrollEnabled = NO;
}

- (void)searchBar:(UISearchBar *)theSearchBar textDidChange:(NSString *)searchText {

	if ([searchText length] > 0) {
		_searching = YES;
		_isSelectRow = YES;
		self.table.scrollEnabled = YES;
		//[self searchTribute];
	} else {
		_searching = NO;
		_isSelectRow = NO;
		self.table.scrollEnabled = NO;
	}
	
	//[self.table reloadData];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
	
	NSLog(@"searchBarSearchButtonClicked");
    [self.view endEditing:YES];
	[self searchTribute];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
	//searchDisplayController.searchBar.hidden = YES;
	[self.searchDisplayController setActive:NO animated:YES];
}

#pragma mark -
#pragma mark SearchDisplayDelegate
//검색창이 닫아지는 때에 호출
- (void) searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller{
	[self searchBarCancelButtonClicked:controller.searchBar];
}
//검색창에 키워드 등록시 호출
- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString{
	return YES;
}

@end
