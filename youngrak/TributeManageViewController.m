//
//  TributeManageViewController.m
//  youngrak
//
//  Created by 김규완 on 13. 6. 11..
//  Copyright (c) 2013년 coelsoft. All rights reserved.
//

#import "TributeManageViewController.h"
#import "HttpManager.h"
#import "AlertUtils.h"
#import "ChangeMovieViewController.h"
#import "ChangePhotoViewController.h"


@interface TributeManageViewController () <HttpManagerDelegate>

@property (nonatomic, retain) IBOutlet UITableView *table;
@property (nonatomic, retain) IBOutlet UIButton *deleteButton;
@property (nonatomic, retain) HttpManager *httpManager;


- (IBAction)tributeDelete:(id)sender;

@end

@implementation TributeManageViewController

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
    self.httpManager = [HttpManager sharedManager];
    
    self.navigationItem.title = @"추모방관리";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    self.table = nil;
}

- (void)tributeDelete:(id)sender {
    self.httpManager.delegate = self;
    [self.httpManager deleteTributeRoom:[self.userInfo objectForKey:@"cm1_id"]];
}

- (void)deleteTributeRoomResult:(NSString*)result message:(NSString*)message {
    NSLog(@"result=%@ %@", result, message);
    
    if ([result isEqualToString:@"success"]) {
        AlertWithMessage(@"삭제되었습니다");
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        AlertWithMessage(message);
    }
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
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
	
	if (row == 0) {
        cell.textLabel.text = @"고인사진변경";
    } else if (row == 1) {
        cell.textLabel.text = @"동영상파일";
    } else if (row == 2) {
        cell.textLabel.text = @"추모앨범등록";
    }
	
	return cell;
}


#pragma mark -
#pragma mark Table view delegate


- (void)tableView:(UITableView *)tv didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	NSUInteger row = [indexPath row];
    
    if (row == 0) {
        ChangePhotoViewController *changePhoto = [[ChangePhotoViewController alloc] initWithNibName:@"ChangePhotoViewController" bundle:nil];
        changePhoto.tribute = self.userInfo;
        [self.navigationController pushViewController:changePhoto animated:YES];
    } else if (row == 1){
        ChangeMovieViewController *changeMovie = [[ChangeMovieViewController alloc] initWithNibName:@"ChangeMovieViewController" bundle:nil];
        [self.navigationController pushViewController:changeMovie animated:YES];
    } else if (row == 2){
        ChangePhotoViewController *changePhoto = [[ChangePhotoViewController alloc] initWithNibName:@"ChangePhotoViewController" bundle:nil];
        changePhoto.tribute = self.userInfo;
        changePhoto.isAlbumUpload = YES;
        [self.navigationController pushViewController:changePhoto animated:YES];
    }
}

@end
