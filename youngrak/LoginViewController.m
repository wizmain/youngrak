//
//  LoginViewController.m
//  youngrak
//
//  Created by 김규완 on 13. 6. 5..
//  Copyright (c) 2013년 coelsoft. All rights reserved.
//

#import "LoginViewController.h"
#import "ProgressIndicator.h"
#import "HttpManager.h"
#import "Utils.h"
#import "AlertUtils.h"

@interface LoginViewController () <HttpManagerDelegate>

@property (nonatomic, retain) IBOutlet UITextField *useridField;
@property (nonatomic, retain) IBOutlet UITextField *passwdField;
@property (nonatomic, retain) ProgressIndicator *spinner;
@property (nonatomic, retain) IBOutlet UIButton *loginButton;

- (IBAction)login:(id)sender;

@end

@implementation LoginViewController

@synthesize useridField, passwdField, spinner, loginButton;

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
    
    UIColor *backImg = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"login_bg"]];
    self.view.backgroundColor = backImg;
    [backImg release];
    
    useridField.frame =  CGRectMake(useridField.frame.origin.x, useridField.frame.origin.y, useridField.frame.size.width, 40);
    passwdField.frame =  CGRectMake(passwdField.frame.origin.x, passwdField.frame.origin.y, passwdField.frame.size.width, 40);
    [useridField setDelegate:self];
    [passwdField setDelegate:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark Custom Method
- (IBAction)login:(id)sender {
    
    spinner = [[ProgressIndicator alloc] initWithLabel:@"로그인중..."];
	[spinner show];
    
    [useridField resignFirstResponder];
    [passwdField resignFirstResponder];
	
    if ([Utils isNullString:useridField.text]) {
        [spinner dismissWithClickedButtonIndex:0 animated:YES];
        AlertWithMessage(@"아이디를 입력해 주세요");
        return;
    }
    
    if ([Utils isNullString:passwdField.text]) {
        [spinner dismissWithClickedButtonIndex:0 animated:YES];
        AlertWithMessage(@"비밀번호를 입력해 주세요");
        return;
    }
    
    HttpManager *manager = [HttpManager sharedManager];
    manager.delegate = self;
    [manager login:useridField.text password:passwdField.text];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [[event allTouches] anyObject];
    if ([useridField isFirstResponder] && [touch view] != useridField) {
        [useridField resignFirstResponder];
    }
    
    if ([passwdField isFirstResponder] && [touch view] != passwdField) {
        [passwdField resignFirstResponder];
    }
    [super touchesBegan:touches withEvent:event];
}

#pragma mark -
#pragma HttpManager Delegate
- (void)loginResult:(id)JSON {
    NSLog(@"loginResult %@", [JSON valueForKeyPath:@"result"]);
    [spinner dismissWithClickedButtonIndex:0 animated:YES];
    
    NSString *result = [JSON valueForKeyPath:@"result"];
    if ([result isEqualToString:@"success"]) {
        
        [[AppDelegate sharedAppDelegate] setIsAuthenticated:YES];
        [[AppDelegate sharedAppDelegate] setAuthUserID:useridField.text];
        
        //[[AppDelegate sharedAppDelegate] switchMainView];
        [self dismissModalViewControllerAnimated:YES];
        
    } else {
        AlertWithMessage([JSON valueForKeyPath:@"message"]);
    }
}

#pragma mark -
#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	if ([textField isEqual:useridField]) {
		[passwdField becomeFirstResponder];
	} else {
		[textField resignFirstResponder];
		[self login:nil];
	}
	return YES;
}


-(void)keyboardWillShow {
    // Animate the current view out of the way
    if (self.view.frame.origin.y >= 0)
    {
        [self setViewMovedUp:YES];
    }
    else if (self.view.frame.origin.y < 0)
    {
        [self setViewMovedUp:NO];
    }
}

-(void)keyboardWillHide {
    if (self.view.frame.origin.y >= 0)
    {
        [self setViewMovedUp:YES];
    }
    else if (self.view.frame.origin.y < 0)
    {
        [self setViewMovedUp:NO];
    }
}

#define kOFFSET_FOR_KEYBOARD 120.0
-(void)setViewMovedUp:(BOOL)movedUp
{
    //float offset = 80.0;
    float offset = kOFFSET_FOR_KEYBOARD;
    
    if (IS_iPhone_5) {
        offset = 40.0;
    }
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3]; // if you want to slide up the view
    
    CGRect rect = self.view.frame;
    if (movedUp)
    {
        // 1. move the view's origin up so that the text field that will be hidden come above the keyboard
        // 2. increase the size of the view so that the area behind the keyboard is covered up.
        rect.origin.y -= offset;
        rect.size.height += offset;
    }
    else
    {
        // revert back to the normal state.
        rect.origin.y += offset;
        rect.size.height -= offset;
    }
    self.view.frame = rect;
    
    [UIView commitAnimations];
}


- (void)viewWillAppear:(BOOL)animated
{
    // register for keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    // unregister for keyboard notifications while not visible.
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}

@end
