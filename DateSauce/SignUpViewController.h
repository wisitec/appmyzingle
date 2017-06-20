//
//  SignUpViewController.h
//  DateSauce
//
//  Created by veena on 5/30/17.
//  Copyright © 2017 appoets. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface SignUpViewController : UIViewController<CLLocationManagerDelegate>
{
    UIDatePicker *datePicker;
    UIToolbar *datePickerToolbar;
    CLLocation *myLocation;
}
@property(nonatomic,retain) CLLocationManager *locationManager;
@property (weak, nonatomic) IBOutlet UIImageView *maleImageView;
@property (weak, nonatomic) IBOutlet UIImageView *femaleImageView;
- (IBAction)maleSelectedAction:(id)sender;
- (IBAction)femaleSelectedAction:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *fullNameTxtFld;
@property (weak, nonatomic) IBOutlet UITextField *emailAddressTxtFld;
@property (weak, nonatomic) IBOutlet UITextField *passwordTxtFld;
@property (weak, nonatomic) IBOutlet UITextField *dateOfBirthTxtFld;
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;
- (IBAction)registerBtnAction:(id)sender;
- (IBAction)backBtnAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIScrollView *detailsScrollView;
- (IBAction)imageBtnAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UIButton *profileBtn;

@end
