//
//  ChangePhotoViewController.h
//  youngrak
//
//  Created by 김규완 on 13. 6. 11..
//  Copyright (c) 2013년 coelsoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChangePhotoViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, retain) NSDictionary *tribute;
@property (nonatomic, assign) BOOL isAlbumUpload;

@end
