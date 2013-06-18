//
//  QRViewController.m
//  광주도시공사
//
//  Created by 김규완 on 13. 6. 13..
//  Copyright (c) 2013년 coelsoft. All rights reserved.
//

#import "QRViewController.h"
#import "ZXingWidgetController.h"
#import "QRCodeReader.h"
#import "MapInfo2ViewController.h"

@interface QRViewController () <ZXingDelegate>
@end

@implementation QRViewController

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
    self.navigationItem.title = @"QR코드 스캔";
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // QR코드 스캔 뷰 컨트롤러 선언
    ZXingWidgetController *controller = [[ZXingWidgetController alloc] initWithDelegate:self
                                                                             showCancel:YES
                                                                               OneDMode:NO];
    
    QRCodeReader *reader = [[QRCodeReader alloc] init];
    NSSet *readers= [[NSSet alloc] initWithObjects:reader, nil];
    [reader release];
    
    controller.readers = readers;
    [readers release];
    
    // 모달 뷰로 표시한다.
    [self presentModalViewController:controller animated:YES];
    [controller release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - XZingDelegate

// QR코드 스캔 결과를 표시
- (void)zxingController:(ZXingWidgetController *)controller didScanResult:(NSString *)result
{
    NSLog(@"result : %@", result);
    [self dismissModalViewControllerAnimated:NO];
    
    MapInfo2ViewController *mapInfo = [[MapInfo2ViewController alloc] initWithNibName:@"MapInfo2ViewController" bundle:nil];
    mapInfo.mapUrl = result;
    
    [self.navigationController pushViewController:mapInfo animated:YES];
}

// 스캔 취소
- (void)zxingControllerDidCancel:(ZXingWidgetController *)controller
{
    [self dismissModalViewControllerAnimated:YES];
}

@end
