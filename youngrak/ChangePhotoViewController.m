//
//  ChangePhotoViewController.m
//  youngrak
//
//  Created by 김규완 on 13. 6. 11..
//  Copyright (c) 2013년 coelsoft. All rights reserved.
//

#import "ChangePhotoViewController.h"
#import "AFHTTPClient.h"
#import "AFHTTPRequestOperation.h"
#import "Constant.h"
#import <Foundation/Foundation.h>
#import "AlertUtils.h"

@interface ChangePhotoViewController ()

@property (nonatomic, retain) IBOutlet UIImageView *photo;
@property (nonatomic, retain) UIProgressView *progressView;
@property (nonatomic, retain) UIAlertView *progressAlert;
@property (nonatomic, retain) NSDictionary *selectedPhoto;
@property (nonatomic, retain) AFHTTPRequestOperation *httpOperation;
@property (nonatomic, retain) AFHTTPClient *httpClient;
@property (nonatomic, retain) IBOutlet UISegmentedControl *segment;

- (IBAction)photoUpload:(id)sender;
- (IBAction)photoSelect:(id)sender;

@end

@implementation ChangePhotoViewController

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
    if (self.isAlbumUpload) {
        self.navigationItem.title = @"앨범등록";
        self.segment.hidden = YES;
    } else {
        self.navigationItem.title = @"고인사진변경";
    }
    
    if(self.isAlbumUpload) {
        
    } else {
        if(self.tribute){
            NSString *imageUrlString = [NSString stringWithFormat:@"http://www.cyberyoungrak.or.kr%@", [self.tribute objectForKey:@"image"]];
            NSLog(@"imageUrl = %@", imageUrlString);
            NSURL * imageURL = [NSURL URLWithString:imageUrlString];
            NSData * imageData = [NSData dataWithContentsOfURL:imageURL];
            UIImage * image = [UIImage imageWithData:imageData];
            
            self.photo.image = image;
        }
    }
    
    //홈버튼 설정
    UIButton *hButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [hButton setBackgroundImage:[UIImage imageNamed:@"top_home_button"] forState:UIControlStateNormal];
    [hButton addTarget:self action:@selector(goHome) forControlEvents:UIControlEventTouchUpInside];
    hButton.frame = CGRectMake(0, 0, 44, 30);
    
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:hButton] autorelease];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    self.photo = nil;
    self.progressAlert = nil;
    self.progressView = nil;
    self.httpClient = nil;
    self.httpOperation = nil;
}

- (void)dealloc {
    [_httpClient release];
    [_httpOperation release];
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

- (IBAction)photoUpload:(id)sender {
    
    [self createProgressionAlertWithMessage:@"파일 업로드"];
    
    
    //NSURL *imageUrl = [self.selectedPhoto objectForKey:UIImagePickerControllerMediaURL];//UIImagePickerControllerReferenceURL
    NSURL *imageUrl = [self.selectedPhoto objectForKey:UIImagePickerControllerReferenceURL];
    NSString *imageName = [imageUrl lastPathComponent];
    NSString *imageSelect = @"1";
    
    if(self.segment.selectedSegmentIndex == 1){
        imageSelect = @"2";
    }
    
    NSData *uploadFile = UIImageJPEGRepresentation(self.photo.image, 1.0);
    
    [_progressAlert setMessage:@"파일 업로드 준비중.."];
    NSString *urlString = [NSString stringWithFormat:@"%@%@", kServerUrl, kCherishImageUploadUrl];
    NSURL *url = [NSURL URLWithString:kServerUrl];
    
    _httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    NSDictionary *param = nil;
    NSString *fileParamName = @"file";
    if (self.isAlbumUpload) {
        param = [[NSDictionary alloc] initWithObjectsAndKeys:[self.tribute objectForKey:@"cm1_id"], @"cm1_id", nil];
        fileParamName = @"album_name";
        urlString = [NSString stringWithFormat:@"%@%@", kServerUrl, kTributeAlbumUploadUrl];
    } else {
        param = [[NSDictionary alloc] initWithObjectsAndKeys:[self.tribute objectForKey:@"cm1_id"], @"cm1_id", imageSelect, @"img_select", nil];
    }
    NSLog(@"urlString=%@ param=%@", urlString, param);
    NSMutableURLRequest *request = [_httpClient multipartFormRequestWithMethod:@"POST" path:urlString parameters:param constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:uploadFile name:fileParamName fileName:imageName mimeType:@"image/jpeg"];
    }];
    
    _httpOperation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [_httpOperation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        NSLog(@"Sent %lld of %lld bytes", totalBytesWritten, totalBytesExpectedToWrite);
        [_progressAlert setMessage:[NSString stringWithFormat:@"파일업로드 %lld/%lld", totalBytesWritten, totalBytesExpectedToWrite]];
        float progress = totalBytesWritten/totalBytesExpectedToWrite;
        
        [self.progressView setProgress:progress animated:YES];
        if (totalBytesWritten >= totalBytesExpectedToWrite) {
            
            //[_progressAlert setMessage:@"저장완료.."];
            [_progressAlert dismissWithClickedButtonIndex:1 animated:YES];
            AlertWithMessage(@"전송이 완료 되었습니다");
            
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    }];
    
    [_httpOperation start];
}

- (void)createProgressionAlertWithMessage:(NSString *)message
{
    _progressAlert = [[UIAlertView alloc] initWithTitle:message message:@"\"파일정보 등록중..\"\n\n" delegate:self cancelButtonTitle:@"취소" otherButtonTitles:nil];
    
    //progressAlert = [[UIAlertView alloc] initWithFrame:CGRectMake(30, 200, 240, 200)];
    // Create the progress bar and add it to the alert
    _progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(30.0f, 80.0f, 225.0f, 90.0f)];
    [_progressAlert addSubview:_progressView];
    [_progressView setProgressViewStyle:UIProgressViewStyleBar];
    
    /*
     UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(90.0f, 90.0f, 225.0f, 40.0f)];
     label.backgroundColor = [UIColor clearColor];
     label.textColor = [UIColor whiteColor];
     label.font = [UIFont systemFontOfSize:12.0f];
     label.text = @"\"0%\"";
     label.tag = 1;
     
     [progressAlert addSubview:label];
     */
    
    [_progressAlert show];
    [_progressAlert release];
    
    
}

- (IBAction)photoSelect:(id)sender {
    
    UIImagePickerController *picker;
    picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.title = @"사진선택";
    [self presentModalViewController:picker animated:YES];
    [picker release];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController*)picker
{
    [picker dismissModalViewControllerAnimated:YES];
	//[[picker parentViewController] dismissModalViewControllerAnimated:YES];
    
}

- (void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary*)info
{
    NSLog(@"info=%@", info);
    
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    if ([mediaType isEqualToString:@"public.image"]){
        self.selectedPhoto = info;
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        NSURL *imageUrl = [self.selectedPhoto objectForKey:UIImagePickerControllerReferenceURL];
        NSLog(@"imageUrl = %@", imageUrl);
        self.photo.image = image;
    } else {
        AlertWithMessage(@"사진 파일만 선택해 주세요");
    }

	[picker dismissModalViewControllerAnimated:YES];
    
}

@end
