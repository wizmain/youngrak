//
//  MenuViewController.h
//  youngrak
//
//  Created by 김규완 on 13. 6. 7..
//  Copyright (c) 2013년 coelsoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MenuViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, retain) NSMutableArray *menuList;

@end
