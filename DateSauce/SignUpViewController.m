//
//  SignUpViewController.m
//  DateSauce
//
//  Created by veena on 5/30/17.
//  Copyright © 2017 appoets. All rights reserved.
//

#import "SignUpViewController.h"
#import "RootViewController.h"
#import "CSS_Class.h"
#import "config.h"
#import "UIScrollView+EKKeyboardAvoiding.h"
#import "AppDelegate.h"
#import "AFNHelper.h"
#import "Constants.h"
#import "AFNetworking.h"
#import "CommenMethods.h"
#import "ViewController.h"

@interface SignUpViewController ()<UIGestureRecognizerDelegate,UITextFieldDelegate,UIImagePickerControllerDelegate>
{
    AppDelegate *appDelegate;
    NSString *strLoginType, *gender, *emailString;
}
@end

@implementation SignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    appDelegate =(AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    gender = @"female";
    
    strLoginType=@"manual";
    
    _emailAddressTxtFld.text=appDelegate.strEmail;
    
    [self onLocationUpdateStart];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapReceived:)];
    [tapGestureRecognizer setDelegate:self];
    [self.view addGestureRecognizer:tapGestureRecognizer];
    
    [_detailsScrollView setContentSize:[_detailsScrollView frame].size];
    [_detailsScrollView setKeyboardAvoidingEnabled:YES];

    _emailAddressTxtFld.delegate = self;
    _passwordTxtFld.delegate = self;
    _fullNameTxtFld.delegate = self;
    _dateOfBirthTxtFld.delegate = self;

    _profileImageView.layer.cornerRadius = _profileImageView.frame.size.height/2;
    _profileImageView.clipsToBounds = YES;
    
    _profileBtn.layer.cornerRadius = _profileBtn.frame.size.height/2;
    _profileBtn.clipsToBounds = YES;
    
    [self setUpDesign];
}

-(void)tapReceived:(UITapGestureRecognizer *)tapGestureRecognizer
{
    [self.view endEditing:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(textField==_fullNameTxtFld)
    {
        [_emailAddressTxtFld becomeFirstResponder];
    }
    else if(textField==_emailAddressTxtFld)
    {
        [_passwordTxtFld becomeFirstResponder];
    }
    else if(textField==_passwordTxtFld)
    {
        [_dateOfBirthTxtFld becomeFirstResponder];
    }
    else if(textField==_dateOfBirthTxtFld)
    {
        [_dateOfBirthTxtFld resignFirstResponder];
    }
    else
    {
        [textField resignFirstResponder];
    }
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    if((textField == _emailAddressTxtFld) || (textField == _fullNameTxtFld))
    {
        NSUInteger oldLength = [textField.text length];
        NSUInteger replacementLength = [string length];
        NSUInteger rangeLength = range.length;
        
        NSUInteger newLength = oldLength - rangeLength + replacementLength;
        
        BOOL returnKey = [string rangeOfString: @"\n"].location != NSNotFound;
        
        return newLength <= INPUTLENGTH || returnKey;
    }
       else
    {
        return YES;
    }
    return NO;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    //[CSS_Class APP_textfield_Infocus:textField];
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    //[CSS_Class APP_textfield_Outfocus:textField];
    return YES;
}



- (void)setUpDesign {
    
    datePicker =[[UIDatePicker alloc]init];
    datePicker.datePickerMode=UIDatePickerModeDate;
    datePicker.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    datePicker.frame = CGRectMake(0.0, self.view.frame.size.height-200, self.view.frame.size.width, 200);
    datePicker.backgroundColor = [UIColor lightGrayColor];
    datePicker.date=[NSDate date];
    datePicker.maximumDate = [NSDate date];
    
    [datePicker addTarget:self action:@selector(LabelTitle:) forControlEvents:UIControlEventValueChanged];
    
    datePickerToolbar= [[UIToolbar alloc] initWithFrame:CGRectMake(0,0,self.view.frame.size.width,44)];
    datePickerToolbar.barStyle = UIBarStyleDefault;
    datePickerToolbar.tintColor = RGB(249, 178, 48);
    UIBarButtonItem *flexibleSpaceLeft = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem* doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(save:)];
    [datePickerToolbar setItems:[NSArray arrayWithObjects:flexibleSpaceLeft, doneButton, nil]];
    
    _dateOfBirthTxtFld.inputView = datePicker;
    _dateOfBirthTxtFld.inputAccessoryView = datePickerToolbar;
    
    [CSS_Class APP_Yellowbutton:_registerBtn];
    [CSS_Class APP_textfield_Infocus:_fullNameTxtFld PaddingIcon:@"user"];
    [CSS_Class APP_textfield_Infocus:_dateOfBirthTxtFld PaddingIcon:@"calendar"];
    [CSS_Class APP_textfield_Infocus:_emailAddressTxtFld PaddingIcon:@"mail-1"];
    [CSS_Class APP_textfield_Infocus:_passwordTxtFld PaddingIcon:@"lock"];
}

-(void)LabelTitle:(id)sender
{
    NSDateFormatter *dateFormat=[[NSDateFormatter alloc]init];
    dateFormat.dateStyle=NSDateFormatterMediumStyle;
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    NSString *str=[NSString stringWithFormat:@"%@",[dateFormat  stringFromDate:datePicker.date]];
    _dateOfBirthTxtFld.text = str;
    
}

-(void)save:(id)sender
{
    [_dateOfBirthTxtFld resignFirstResponder];
    
}

#pragma mark - Get Current Location

-(void)onLocationUpdateStart
{
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.distanceFilter = kCLDistanceFilterNone;
    _locationManager.delegate=self;
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [_locationManager requestWhenInUseAuthorization];
    [_locationManager requestAlwaysAuthorization];
    [_locationManager startMonitoringSignificantLocationChanges];
    [_locationManager startUpdatingLocation];
    
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    //    btnCurrentLocation.hidden=YES;
    [_locationManager stopUpdatingLocation];
    
    myLocation = newLocation; //(CLLocation *)[locations lastObject];
    NSLog(@"Location: %@", [NSString stringWithFormat:@"%.8f", myLocation.coordinate.latitude]);
    NSLog(@"Location: %@", [NSString stringWithFormat:@"%.8f", myLocation.coordinate.longitude]);
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)maleSelectedAction:(id)sender {
    
    gender = @"male";
    [_maleImageView setImage:[UIImage imageNamed:@"radioOn"]];
    [_femaleImageView setImage:[UIImage imageNamed:@"radioOff"]];
}

- (IBAction)femaleSelectedAction:(id)sender {
    
    gender = @"female";
    [_maleImageView setImage:[UIImage imageNamed:@"radioOff"]];
    [_femaleImageView setImage:[UIImage imageNamed:@"radioOn"]];
}
- (IBAction)registerBtnAction:(id)sender {
    
    [self.view endEditing:YES];//|| (_passwordText.text.length==0) || (_lastNameText.text.length==0)
    
    emailString = @"true";
    
    NSData *data1 = UIImagePNGRepresentation(_profileImageView.image);
    NSData *data2 = UIImagePNGRepresentation([UIImage imageNamed:@"PersonMsg"]);
    
    if(_emailAddressTxtFld.text.length != 0)
    {
        NSString *email = _emailAddressTxtFld.text;
        NSString *emailRegEx =
        @"(?:[A-Za-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[a-z0-9!#$%\\&'*+/=?\\^_`{|}"
        @"~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\"
        @"x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-"
        @"z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5"
        @"]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-"
        @"9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21"
        @"-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])";
        
        NSPredicate *regExPredicate =
        [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegEx];
        BOOL myStringMatchesRegEx = [regExPredicate evaluateWithObject:email];
        
        if(myStringMatchesRegEx)
        {
            emailString = @"true";
        }
        else
        {
            emailString = @"false";
        }
    }
    
    if(_emailAddressTxtFld.text.length==0)
    {
        emailString = false;
        
        [CommenMethods alertviewController_title:@"" MessageAlert:NSLocalizedString(@"Email Address is required", nil) viewController:self okPop:NO];
        
    }
    else if ([emailString isEqualToString:@"false"])
    {
        emailString = false;
        
        [CommenMethods alertviewController_title:@"" MessageAlert:NSLocalizedString(@"Email Address is invalid", nil) viewController:self okPop:NO];
        
    }
    if (_passwordTxtFld.text.length==0)
    {
        emailString = false;
        
        [CommenMethods alertviewController_title:@"" MessageAlert:NSLocalizedString(@"Password field is required", nil) viewController:self okPop:NO];
       
    }
    if (_fullNameTxtFld.text.length==0)
    {
        emailString = false;
        
        [CommenMethods alertviewController_title:@"" MessageAlert:NSLocalizedString(@"Name field is required", nil) viewController:self okPop:NO];
        
    }

    if (_dateOfBirthTxtFld.text.length==0)
    {
        emailString = false;
        
        [CommenMethods alertviewController_title:@"" MessageAlert:NSLocalizedString(@"Date of birth is required", nil) viewController:self okPop:NO];
        
    }
    if ([data1 isEqual:data2])
    {
        emailString = false;
        
        [CommenMethods alertviewController_title:@"" MessageAlert:NSLocalizedString(@"Profile Image is required", nil) viewController:self okPop:NO];
        
    }
    
    if ([emailString isEqualToString:@"true"])
    {
        if([appDelegate internetConnected])
        {
            NSString* UDID_Identifier = [[[UIDevice currentDevice] identifierForVendor] UUIDString]; // IOS 6+
            NSLog(@"output is : %@", UDID_Identifier);
            
            NSString* latitude = [NSString stringWithFormat:@"%f",myLocation.coordinate.latitude];
            NSString* longitude = [NSString stringWithFormat:@"%f",myLocation.coordinate.longitude];
            
            NSDictionary*params;
            if([strLoginType isEqualToString:@"manual"])
            {
                params=@{@"email":_emailAddressTxtFld.text,@"password":_passwordTxtFld.text,@"name":_fullNameTxtFld.text,@"dob":_dateOfBirthTxtFld.text,@"gender":gender,@"device_token":appDelegate.strDeviceToken,@"login_by":strLoginType,@"device_type":@"ios",@"latitude":latitude,@"longitude":longitude};
            }
            
            UIImage *image = _profileImageView.image;
                       
            [appDelegate onStartLoader];
            AFNHelper *afn=[[AFNHelper alloc]initWithRequestMethod:POST_METHOD];
            [afn getDataFromPath:MD_REGISTER withParamDataImage:params andImage:image withBlock:^(id response, NSDictionary *Error,NSString *strCode) {
                [appDelegate onEndLoader];
                if([[response valueForKey:@"success"]boolValue] == 1)
                {
                    [self onLogin];
                }
                else if([[response valueForKey:@"success"]boolValue] == 0)
                {
                    if ([[response valueForKey:@"error_code"]integerValue] == 401) {
                        
                        [CommenMethods alertviewController_title:@"" MessageAlert:[[response valueForKey:@"error_messages"] objectAtIndex:0]  viewController:self okPop:NO];
                    }
                    else{
                        
                        [CommenMethods alertviewController_title:@"" MessageAlert:NSLocalizedString(@"Please try again later!!", nil) viewController:self okPop:NO];
                    }
                    
                }
                else
                {
                    NSString *strErrCode=[NSString stringWithFormat:@"%@",[response valueForKey:@"error_code"]];
                    
                    if ([strErrCode isEqualToString:@"104"])
                    {
                        
                        NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
                        [user removeObjectForKey:@"isLoggedin"];
                        
                        RootViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"RootViewController"];
                        [self.navigationController pushViewController:controller animated:YES];
                        
                    }

                    if ([strCode intValue]==1)
                    {
                        [CommenMethods alertviewController_title:@"" MessageAlert:NSLocalizedString(@"ERRORMSG", nil) viewController:self okPop:NO];
                    }
                    else
                    {
                        if ([Error objectForKey:@"email"]) {
                            [CommenMethods alertviewController_title:@"" MessageAlert:[[Error objectForKey:@"email"] objectAtIndex:0]  viewController:self okPop:NO];
                        }
                        else if ([Error objectForKey:@"full_name"]) {
                            [CommenMethods alertviewController_title:@"" MessageAlert:[[Error objectForKey:@"first_name"] objectAtIndex:0]  viewController:self okPop:NO];
                        }
                        else if ([Error objectForKey:@"dateofbirth"]) {
                            [CommenMethods alertviewController_title:@"" MessageAlert:[[Error objectForKey:@"dateofbirth"] objectAtIndex:0]  viewController:self okPop:NO];
                        }
                        else if ([Error objectForKey:@"password"]) {
                            [CommenMethods alertviewController_title:@"" MessageAlert:[[Error objectForKey:@"password"] objectAtIndex:0]  viewController:self okPop:NO];
                        }
                    }
                    
                }
            }];
        }
        else
        {
            
            [CommenMethods alertviewController_title:@"" MessageAlert:NSLocalizedString(@"Please Check Your Internet Connection", nil) viewController:self okPop:NO];
        }
    }
}

- (IBAction)backBtnAction:(id)sender {
    
     [self.navigationController popViewControllerAnimated:YES];
}

-(void)onLogin
{
    if([appDelegate internetConnected])
    {
        NSDictionary * params=@{@"email":_emailAddressTxtFld.text,@"password":_passwordTxtFld.text,@"device_token":appDelegate.strDeviceToken,@"grant_type":@"password",@"device_type":@"ios",@"client_id":ClientID,@"client_secret":Client_SECRET,@"login_by":strLoginType};
        
        [appDelegate onStartLoader];
        AFNHelper *afn=[[AFNHelper alloc]initWithRequestMethod:POST_METHOD];
        [afn getDataFromPath:MD_LOGIN withParamData:params withBlock:^(id response, NSDictionary *Error,NSString *strCode) {
            [appDelegate onEndLoader];
            if([[response valueForKey:@"success"]boolValue] == 1)
            {
                NSArray *otherImages = [[response objectForKey:@"user"]objectForKey:@"images"];
                
                NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
                [user setValue:response[@"id"] forKey:@"id"];
                [user setValue:response[@"token"] forKey:@"token"];
                [user setValue:response[@"name"] forKey:@"name"];
                [user setValue:[otherImages objectAtIndex:0] forKey:@"image"];
                [user setValue:response[@"picture"] forKey:@"picture"];
                [user setValue:response[@"gender"] forKey:@"gender"];
                [user setValue:response[@"status"] forKey:@"status"];
                [user setValue:response[@"question_status"] forKey:@"question_status"];
                [user setValue:response[@"email"] forKey:@"email"];
                [user setValue:response[@"device_token"] forKey:@"device_token"];
                [user setValue:response[@"school"] forKey:@"school"];
                [user setValue:response[@"work"] forKey:@"work"];
                [user setValue:response[@"age"] forKey:@"age"];
                [user setBool:true forKey:@"isLoggedin"];
                [user synchronize];

                
                ViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"ViewController"];
                [self.navigationController pushViewController:controller animated:YES];
            }
            else
            {
                NSString *strErrCode=[NSString stringWithFormat:@"%@",[response valueForKey:@"error_code"]];
                
                if ([strErrCode isEqualToString:@"104"])
                {
                    
                    NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
                    [user removeObjectForKey:@"isLoggedin"];
                    
                    RootViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"RootViewController"];
                    [self.navigationController pushViewController:controller animated:YES];
                    
                }

                if ([strCode intValue]==1)
                {
                    [CommenMethods alertviewController_title:@"" MessageAlert:NSLocalizedString(@"ERRORMSG", nil) viewController:self okPop:NO];
                }
                else
                {
                    if ([Error objectForKey:@"email"]) {
                        [CommenMethods alertviewController_title:@"" MessageAlert:[[Error objectForKey:@"email"] objectAtIndex:0]  viewController:self okPop:NO];
                    }
                    else if ([Error objectForKey:@"password"]) {
                        [CommenMethods alertviewController_title:@"" MessageAlert:[[Error objectForKey:@"password"] objectAtIndex:0]  viewController:self okPop:NO];
                    }
                }
                
            }
        }];
    }
    else
    {
        [CommenMethods alertviewController_title:@"" MessageAlert:NSLocalizedString(@"Please Check Your Internet Connection", nil) viewController:self okPop:NO];
    }
}


- (IBAction)imageBtnAction:(id)sender {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil
                                                                   message:nil
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *openCamrea = [UIAlertAction actionWithTitle:@"Take Photo"
                                                         style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
                                 {
                                     if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                                         
                                         UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Error"message:@"Device has no camera"delegate:nil cancelButtonTitle:@"OK"otherButtonTitles: nil];
                                         
                                         [myAlertView show];
                                     }
                                     else
                                     {
                                         UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                                         picker.delegate = self;
                                         picker.allowsEditing = YES;
                                         picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                                         
                                         [self presentViewController:picker animated:YES completion:NULL];
                                     }
                                 }];
    UIAlertAction *openGallery = [UIAlertAction actionWithTitle:@"Choose Photo"
                                                          style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
                                  {
                                      UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                                      picker.delegate = self;
                                      picker.allowsEditing = YES;
                                      picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                                      
                                      [self presentViewController:picker animated:YES completion:NULL];
                                  }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel"
                                                     style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
                             {
                                 [self dismissViewControllerAnimated:YES completion:NULL];
                             }];
    
    [alert addAction:openCamrea];
    [alert addAction:openGallery];
    [alert addAction:cancel];
    
    [alert.view setTintColor:[UIColor colorWithRed:235/255.0 green:68/255.0 blue:97/255.0 alpha:1.0]];
    
    [self presentViewController:alert animated:YES completion:nil];

}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(nullable NSDictionary<NSString *,id> *)editingInfo NS_DEPRECATED_IOS(2_0, 3_0);
{
    
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    
    _profileImageView.image = chosenImage;
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}


@end
