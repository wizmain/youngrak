//
//  TributeAlbumViewController.m
//  youngrak
//
//  Created by 김규완 on 13. 6. 11..
//  Copyright (c) 2013년 coelsoft. All rights reserved.
//

#import "TributeAlbumViewController.h"
#import "HttpManager.h"
#import "Utils.h"
#import "ImageCache.h"
#import "ImageViewController.h"

@interface TributeAlbumViewController () <HttpManagerDelegate>

@property (nonatomic, retain) IBOutlet UITableView *table;
@property (nonatomic, retain) NSMutableArray *albumList;
@property NSMutableDictionary *imageCache;
@property (nonatomic, retain) HttpManager *httpManager;

@end

@implementation TributeAlbumViewController {
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
    
    self.navigationItem.title = @"추모앨범";
    
    
    // Do any additional setup after loading the view from its nib.
    self.httpManager = [HttpManager sharedManager];
    self.httpManager.delegate = self;
    imageQueue = dispatch_queue_create("com.coelsoft.youngrak.imageQueue", NULL);
    _imageCache = [[NSMutableDictionary alloc] init];
    NSLog(@"tribute=%@", self.tribute);
    [self.httpManager requestAlbum:[self.tribute objectForKey:@"cm1_id"]];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    self.table = nil;
    self.httpManager =  nil;
    self.albumList = nil;
    self.imageCache = nil;
}

- (void)dealloc {
    [_imageCache release];
    [super dealloc];
}

- (void)requestAlbumResult:(NSMutableArray *)result {
    NSLog(@"requestAlbumResult count=%d", result.count);
    self.albumList = result;
    [self.table reloadData];
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

	return [self.albumList count];
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
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
	}
	
	NSUInteger row = [indexPath row];
	
	if (self.albumList != nil) {
		
		if(self.albumList.count > 0){
			
            NSDictionary *album = [self.albumList objectAtIndex:row];
            /*
            cell.textLabel.text = [album objectForKey:@""];
            cell.detailTextLabel.text = [NSString stringWithFormat:@"사망년월일:%@ 생성자:%@", [userInfo objectForKey:@"dead_date"], [userInfo objectForKey:@"maker_name"]];
            */
            cell.imageView.contentMode = UIViewContentModeScaleAspectFill;
            cell.imageView.image = [UIImage imageNamed:@"photo_blank"];
            CGRect imageFrame = cell.imageView.frame;
            imageFrame.size.height = 300;
            cell.imageView.frame = imageFrame;
            
            NSString *imagePath = [album objectForKey:@"album_name"];
            
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
                        NSString *imageUrlString = [NSString stringWithFormat:@"http://www.cyberyoungrak.or.kr%@", [album objectForKey:@"album_name"]];
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
    return 200;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
    int row = [indexPath row];
    
    NSDictionary *a = [self.albumList objectAtIndex:row];
    
    ImageViewController *image = [[ImageViewController alloc] initWithNibName:@"ImageViewController" bundle:nil];
    image.imageUrl = [a objectForKey:@"album_name"];
    
    [self.navigationController pushViewController:image animated:YES];
    
}

@end
