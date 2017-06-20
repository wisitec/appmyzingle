//
//  SettingsViewController.h
//  DateSauce
//
//  Created by veena on 5/31/17.
//  Copyright © 2017 appoets. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface SettingsViewController : UIViewController<CLLocationManagerDelegate>{
      CLLocation *myLocation;
}

@property(nonatomic,retain) CLLocationManager *locationManager;

@property (weak, nonatomic) IBOutlet UITableView *swipingInTableView;
@property (weak, nonatomic) IBOutlet UIScrollView *settingsScrollView;
@property (strong, nonatomic) IBOutlet UIView *topMostView;
@property (weak, nonatomic) IBOutlet UIView *topView;
- (IBAction)backBtnAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *swipingInView;
@property (weak, nonatomic) IBOutlet UIView *showMeView;
@property (weak, nonatomic) IBOutlet UIView *searchDistView;
@property (weak, nonatomic) IBOutlet UIView *showAgesView;
@property (weak, nonatomic) IBOutlet UIView *showMeOnDateSauceView;
@property (weak, nonatomic) IBOutlet UIView *changePasswordView;
@property (weak, nonatomic) IBOutlet UIView *helpSupportView;
@property (weak, nonatomic) IBOutlet UIView *logoutView;
@property (weak, nonatomic) IBOutlet UIView *privacyTermsView;
@property (weak, nonatomic) IBOutlet UIView *deleteAccountView;
- (IBAction)addLocationBtnAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *addLocationBtn;
@property (weak, nonatomic) IBOutlet UISwitch *menSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *womenSwitch;
@property (weak, nonatomic) IBOutlet UISlider *distanceSlider;
@property (weak, nonatomic) IBOutlet UISlider *agesSlider;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *agesLabel;
@property (weak, nonatomic) IBOutlet UISwitch *showMeSwitch;
- (IBAction)changePasswordBtnAction:(id)sender;
- (IBAction)helpSupportBtnAction:(id)sender;
- (IBAction)logoutBtnAction:(id)sender;
- (IBAction)privacyPolicyBtnAction:(id)sender;
- (IBAction)termsOfServiceBtnAction:(id)sender;
- (IBAction)deletAccountButtonAction:(id)sender;
- (IBAction)doneBtnAction:(id)sender;

@end
