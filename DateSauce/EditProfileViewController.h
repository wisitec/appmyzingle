//
//  EditProfileViewController.h
//  DateSauce
//
//  Created by veena on 6/5/17.
//  Copyright © 2017 appoets. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditProfileViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *firstImageView;
@property (weak, nonatomic) IBOutlet UIImageView *secondImageView;
@property (weak, nonatomic) IBOutlet UIImageView *thirdImageView;
@property (weak, nonatomic) IBOutlet UIImageView *fourthImageView;
@property (weak, nonatomic) IBOutlet UIImageView *fifthImageView;
@property (weak, nonatomic) IBOutlet UIImageView *sixthImageView;
@property (nonatomic) UIImagePickerController *imagePickerController;
- (IBAction)addImageBtnAction:(UIButton*)sender;
@property (weak, nonatomic) IBOutlet UIButton *firstImgBtn;
@property (weak, nonatomic) IBOutlet UIButton *secondImgBtn;
@property (weak, nonatomic) IBOutlet UIButton *thirdImgBtn;
@property (weak, nonatomic) IBOutlet UIButton *fourthImgBtn;
@property (weak, nonatomic) IBOutlet UIButton *fifthImgBtn;
@property (weak, nonatomic) IBOutlet UIButton *sixthImgBtn;

@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIScrollView *editProfieScrollView;
@property (strong, nonatomic) IBOutlet UIView *topMostView;
- (IBAction)maleBtnAction:(id)sender;
- (IBAction)femaleBtnAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *maleImageView;
@property (weak, nonatomic) IBOutlet UIImageView *femaleImageView;
@property (weak, nonatomic) IBOutlet UITextView *aboutYouTextView;
@property (weak, nonatomic) IBOutlet UITextField *workTxtField;
@property (weak, nonatomic) IBOutlet UITextField *schoolTxtField;
@property (weak, nonatomic) IBOutlet UITextField *userNameTxtFld;

@property NSString *isFrom;

- (IBAction)backButtonAction:(id)sender;

- (IBAction)doneBtnAction:(id)sender;

@end
