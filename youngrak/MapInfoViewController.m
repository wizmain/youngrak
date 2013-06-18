//
//  MapInfoViewController.m
//  youngrak
//
//  Created by 김규완 on 13. 6. 10..
//  Copyright (c) 2013년 coelsoft. All rights reserved.
//

#import "MapInfoViewController.h"

@interface MapInfoViewController ()

@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property (nonatomic, retain) IBOutlet UIImageView *map;

@end

@implementation MapInfoViewController

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
    self.navigationItem.title = @"영락공원 지도";
    
    //홈버튼 설정
    UIButton *hButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [hButton setBackgroundImage:[UIImage imageNamed:@"top_home_button"] forState:UIControlStateNormal];
    [hButton addTarget:self action:@selector(goHome) forControlEvents:UIControlEventTouchUpInside];
    hButton.frame = CGRectMake(0, 0, 44, 30);
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:hButton] autorelease];
    
    
    CGSize imageSize = CGSizeMake(self.map.image.size.width, self.map.image.size.height);
	[self.scrollView setContentSize:imageSize];
	[self.scrollView setContentOffset:CGPointMake(imageSize.width/4, imageSize.height/4)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    self.scrollView = nil;
    self.map = nil;
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
	return self.map;
}


- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(float)scale {
	CGSize imageSize = CGSizeMake(self.map.image.size.width *scale, self.map.image.size.height * scale);
	[self.scrollView setContentSize:imageSize];
}

- (void)goHome {
    if(IS_iOS_6){
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self dismissModalViewControllerAnimated:YES];
    }
    
    
}
@end
