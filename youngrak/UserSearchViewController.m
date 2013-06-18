//
//  UserSearchViewController.m
//  youngrak
//
//  Created by 김규완 on 13. 6. 10..
//  Copyright (c) 2013년 coelsoft. All rights reserved.
//

#import "UserSearchViewController.h"
#import "HttpManager.h"
#import "UserInfoViewController.h"

@interface UserSearchViewController () <HttpManagerDelegate>

@property (nonatomic, retain) IBOutlet UISearchBar *searchBar;
@property (nonatomic, retain) IBOutlet UITableView *table;
@property (nonatomic, retain) NSMutableArray *userList;
@property (nonatomic, assign) BOOL searching;
@property (nonatomic, assign) BOOL isSelectRow;
@property (nonatomic, retain) IBOutlet UISegmentedControl *segment;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (nonatomic, retain) HttpManager *httpManager;

- (IBAction)segmentSelected:(id)sender;

@end

@implementation UserSearchViewController


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
    
    self.httpManager = [HttpManager sharedManager];
    [self.httpManager setDelegate:self];
    
    //홈버튼 설정
    UIButton *hButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [hButton setBackgroundImage:[UIImage imageNamed:@"top_home_button"] forState:UIControlStateNormal];
    [hButton addTarget:self action:@selector(goHome) forControlEvents:UIControlEventTouchUpInside];
    hButton.frame = CGRectMake(0, 0, 44, 30);
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:hButton] autorelease];
    
    [self.segment setSelectedSegmentIndex:0];
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
}

- (void)dealloc {
	[_searchBar release];
	[_userList release];
    [_table release];
    [super dealloc];
}

#pragma mark -
#pragma mark Custom Method
- (void)searchUser {
    
    [self.activityIndicator startAnimating];
    
    NSString *areaType = @"2";
    if(self.segment.selectedSegmentIndex == 1){
        areaType = @"1";
    }
    [self.httpManager searchUser:_searchBar.text areaType:areaType];
}

- (void)searchUserResult:(NSMutableArray *)result {
    
    [self.activityIndicator stopAnimating];
    NSLog(@"searchUserResult result count=%d", result.count);
    self.userList = result;
    
    [self.table reloadData];
}

- (void)goHome {
    if(IS_iOS_6){
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self dismissModalViewControllerAnimated:YES];
    }
    
    
}

- (IBAction)segmentSelected:(id)sender {
    
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
            //NSString *label = [[userInfo objectForKey:@"userKName"] stringByAppendingFormat:@" (%@)",[userInfo objectForKey:@"userID"]];
            
            cell.textLabel.text = [NSString stringWithFormat:@"%@ 사망일자:%@", [userInfo objectForKey:@"dead_name"], [userInfo objectForKey:@"dead_date"]];
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@|%@|%@",[userInfo objectForKey:@"dead_sex"], [userInfo objectForKey:@"area_type"], [userInfo objectForKey:@"bury_no"]];
			
			
		}
	}
	
	return cell;
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	

    NSDictionary *user = [self.userList objectAtIndex:[indexPath row]];
    
    UserInfoViewController *userInfo = [[UserInfoViewController alloc] initWithNibName:@"UserInfoViewController" bundle:nil];
    userInfo.userInfo = user;
    [self.navigationController pushViewController:userInfo animated:YES];
			
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
		//[self searchUser];
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
	[self searchUser];
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
