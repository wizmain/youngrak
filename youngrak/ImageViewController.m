//
//  ImageViewController.m
//  youngrak
//
//  Created by 김규완 on 13. 6. 12..
//  Copyright (c) 2013년 coelsoft. All rights reserved.
//

#import "ImageViewController.h"
#import "Utils.h"
#import "ImageCache.h"
#import "Constant.h"

@interface ImageViewController ()

@property (nonatomic, retain) IBOutlet UIImageView *imageView;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *activityIndicator;
@property NSMutableDictionary *imageCache;

@end

@implementation ImageViewController {
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
    
    self.navigationItem.title = @"앨범보기";
    
    imageQueue = dispatch_queue_create("com.coelsoft.youngrak.imageQueue", NULL);
    _imageCache = [[NSMutableDictionary alloc] init];
    
    if ([Utils isNullString:self.imageUrl]) {
        NSLog(@"imagePath null");
        
    } else {
        
        //썸네일 이미지 미리 저장된 이미지로
        //NSString *thumbPath = [NSString stringWithFormat:@"%@/%@.png", documentsDirectory, interview.filename];
        //NSLog(@"thumbPath=%@", thumbPath);
        //UIImage *thumbImg = [UIImage imageWithContentsOfFile:thumbPath];
        //[movieListCell.thumbnailImageView setImage:thumbImg];
        //NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:thumbPath]];
        
        //if ([[ImageCache sharedImageCache] isExist:interview.filename]) {
        
        
        if ([self.imageCache objectForKey:self.imageUrl] != nil) {
            //UIImage *thumbImg = [[ImageCache sharedImageCache] getImage:interview.filename];
            UIImage *thumbImg = [self.imageCache objectForKey:self.imageUrl];
            self.imageView.image = thumbImg;
            NSLog(@"use cache");
        } else {
            NSLog(@"use image load");
            dispatch_async(imageQueue, ^{
                
                [self.activityIndicator startAnimating];
                
                NSString *imageUrlString = [NSString stringWithFormat:@"%@%@", kServerUrl, self.imageUrl];
                NSLog(@"imageUrl = %@", imageUrlString);
                NSURL * imageURL = [NSURL URLWithString:imageUrlString];
                NSData * imageData = [NSData dataWithContentsOfURL:imageURL];
                UIImage * image = [UIImage imageWithData:imageData];
                //[[ImageCache sharedImageCache] addImage:interview.filename image:thumbImg];
                [self.imageCache setValue:image forKey:self.imageUrl];
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    self.imageView.image = image;
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
    
    self.imageView = nil;
    self.imageCache = nil;
    imageQueue = nil;
}


- (void)dealloc {
    [_imageCache release];
    [super dealloc];
}


@end
