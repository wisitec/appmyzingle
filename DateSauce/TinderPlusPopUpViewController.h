//
//  TinderPlusPopUpViewController.h
//  DateSauce
//
//  Created by umama on 9/7/17.
//  Copyright © 2017 appoets. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PayPalMobile.h"

@interface TinderPlusPopUpViewController : UIViewController<PayPalPaymentDelegate>

@property (nonatomic, strong, readwrite) PayPalConfiguration *payPalConfiguration;

@property (weak, nonatomic) IBOutlet UIView *popUpView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet UILabel *amountLbl;
@property (weak, nonatomic) IBOutlet UIButton *continueBtn;
- (IBAction)continueBtnAction:(id)sender;

@end
