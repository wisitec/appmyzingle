//
//  UserDetailsViewController.h
//  DateSauce
//
//  Created by veena on 5/31/17.
//  Copyright © 2017 appoets. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PayPalMobile.h"

@interface UserDetailsViewController : UIViewController<PayPalPaymentDelegate>

@property (nonatomic, strong, readwrite) PayPalConfiguration *payPalConfiguration;

@property (weak, nonatomic) IBOutlet UIButton *profileBtn;
- (IBAction)profileBtnAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *editProfileBtn;
- (IBAction)editProfileBtnAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *getTinderPlusBtn;
- (IBAction)getTinderPlusBtnAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *settingsBtn;
- (IBAction)settingsBtnAction:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *userNameLbl;
@property (weak, nonatomic) IBOutlet UILabel *workLbl;
@property (weak, nonatomic) IBOutlet UILabel *schoolLbl;

@end
