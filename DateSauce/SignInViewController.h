//
//  SignInViewController.h
//  DateSauce
//
//  Created by veena on 5/30/17.
//  Copyright © 2017 appoets. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignInViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *fbLoginBtn;
- (IBAction)facebookLoginBtnAction:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *emailAddressTxtFld;
@property (weak, nonatomic) IBOutlet UITextField *passwordTxtFld;
@property (weak, nonatomic) IBOutlet UIButton *signInBtn;
- (IBAction)signInBtnAction:(id)sender;
- (IBAction)backBtnAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIScrollView *loginScrollView;

@end
