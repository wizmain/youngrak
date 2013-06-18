//
//  MapInfo2ViewController.m
//  광주도시공사
//
//  Created by 김규완 on 13. 6. 13..
//  Copyright (c) 2013년 coelsoft. All rights reserved.
//

#import "MapInfo2ViewController.h"
#import "Utils.h"

@interface MapInfo2ViewController ()

@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property (nonatomic, retain) IBOutlet UIImageView *map;
@property (nonatomic, retain) IBOutlet UIButton *button1;
@property (nonatomic, retain) IBOutlet UIButton *button2;
@property (nonatomic, retain) IBOutlet UIButton *button3;
@property (nonatomic, retain) IBOutlet UIButton *button4;
@property (nonatomic, retain) IBOutlet UIButton *button5;
@property (nonatomic, retain) IBOutlet UIButton *button6;
@property (nonatomic, retain) IBOutlet UIButton *button7;
@property (nonatomic, retain) IBOutlet UIButton *button8;
@property (nonatomic, retain) IBOutlet UIButton *button9;
@property (nonatomic, retain) IBOutlet UIButton *button10;
@property (nonatomic, retain) IBOutlet UIView *view1;
@property (nonatomic, retain) IBOutlet UIView *view2;
@property (nonatomic, retain) IBOutlet UIView *view3;
@property (nonatomic, retain) IBOutlet UIView *view4;
@property (nonatomic, retain) IBOutlet UIView *view5;
@property (nonatomic, retain) IBOutlet UIView *view6;
@property (nonatomic, retain) IBOutlet UIView *view7;
@property (nonatomic, retain) IBOutlet UIView *view8;
@property (nonatomic, retain) IBOutlet UIView *view9;
@property (nonatomic, retain) IBOutlet UIView *view10;
@property (nonatomic, retain) NSMutableArray *buttonList;
@property (nonatomic, retain) NSMutableArray *viewList;

- (IBAction)buttonPressed:(id)sender;

@end

@implementation MapInfo2ViewController

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
    
    self.buttonList = [NSMutableArray arrayWithObjects:self.button1, self.button2, self.button3, self.button4, self.button5, self.button6, self.button7, self.button8, self.button9, self.button10, nil];
    
    self.viewList = [NSMutableArray arrayWithObjects:self.view1,self.view2,self.view3,self.view4,self.view5,self.view6,self.view7,self.view8,self.view9, self.view10, nil];
    
    if ([Utils isNullString:self.mapUrl]) {
        
    } else {
        
        NSLog(@"mapUrl exist %@", self.mapUrl);
        
        if ([self.mapUrl isEqualToString:@"http://www.cyberyoungrak.or.kr/map1"]) {//철쭉
            [self.scrollView setContentOffset:CGPointMake(180, 180) animated:YES];
            [self thumbView:0];
        } else if ([self.mapUrl isEqualToString:@"http://www.cyberyoungrak.or.kr/map2"]) {//관리사무소
            [self.scrollView setContentOffset:CGPointMake(300, 0) animated:YES];
            [self thumbView:1];
        } else if ([self.mapUrl isEqualToString:@"http://www.cyberyoungrak.or.kr/map3"]) {//6위용가족묘
            [self.scrollView setContentOffset:CGPointMake(380, 200) animated:YES];
            [self thumbView:2];
        } else if ([self.mapUrl isEqualToString:@"http://www.cyberyoungrak.or.kr/map4"]) {//12위용가족묘
            [self.scrollView setContentOffset:CGPointMake(600, 20) animated:YES];
            [self thumbView:3];
        } else if ([self.mapUrl isEqualToString:@"http://www.cyberyoungrak.or.kr/map5"]) {//평장
            [self.scrollView setContentOffset:CGPointMake(840, 500) animated:YES];
            [self thumbView:4];
        } else if ([self.mapUrl isEqualToString:@"http://www.cyberyoungrak.or.kr/map6"]) {//개나리
            [self.scrollView setContentOffset:CGPointMake(1000, 600) animated:YES];
            [self thumbView:5];
        } else if ([self.mapUrl isEqualToString:@"http://www.cyberyoungrak.or.kr/map7"]) {//자연장 청마루
            [self.scrollView setContentOffset:CGPointMake(400, 290) animated:YES];
            [self thumbView:6];
        } else if ([self.mapUrl isEqualToString:@"http://www.cyberyoungrak.or.kr/map8"]) {//승화원
            [self.scrollView setContentOffset:CGPointMake(180, 0) animated:YES];
            [self thumbView:7];
        } else if ([self.mapUrl isEqualToString:@"http://www.cyberyoungrak.or.kr/map9"]) {//제1추모관
            [self.scrollView setContentOffset:CGPointMake(360, 0) animated:YES];
            [self thumbView:8];
        } else if ([self.mapUrl isEqualToString:@"http://www.cyberyoungrak.or.kr/map10"]) {//제2추모관
            [self.scrollView setContentOffset:CGPointMake(600, 200) animated:YES];
            [self thumbView:9];
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
    self.scrollView = nil;
    self.map = nil;
    self.button1 = nil;
    self.button2 = nil;
    self.button3 = nil;
    self.button4 = nil;
    self.button5 = nil;
    self.button6 = nil;
    self.button7 = nil;
    self.button8 = nil;
    self.button9 = nil;
    self.button10 = nil;
    self.view1 = nil;
    self.view2 = nil;
    self.view3 = nil;
    self.view4 = nil;
    self.view5 = nil;
    self.view6 = nil;
    self.view7 = nil;
    self.view8 = nil;
    self.view9 = nil;
    self.view10 = nil;
    self.buttonList = nil;
    self.viewList = nil;
}

- (void)dealloc {
    [_buttonList release];
    [_viewList release];
    [super dealloc];
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

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    //UITouch *touch = [[event allTouches] anyObject];
    for (int i=0; i<self.buttonList.count; i++) {
        UIView *b = (UIView*)[self.viewList objectAtIndex:i];
        b.hidden = YES;
    }
    
    [super touchesBegan:touches withEvent:event];
}

- (IBAction)buttonPressed:(id)sender {
    
    UIButton *button = (UIButton*)sender;
    
    NSLog(@"buttonPressed tag=%d", button.tag);
    
    
    [self thumbView:button.tag];
    
}

- (void)thumbView:(int)tag {
    for (int i=0; i<self.buttonList.count; i++) {
        UIView *b = (UIView*)[self.viewList objectAtIndex:i];
        b.hidden = YES;
    }
    
    UIView *view = (UIView*)[self.viewList objectAtIndex:tag];
    view.hidden = NO;
}

@end
