//
//  EditProfileViewController.m
//  DateSauce
//
//  Created by veena on 6/5/17.
//  Copyright © 2017 appoets. All rights reserved.
//

#import "EditProfileViewController.h"
#import "ProfileViewController.h"
#import "UserDetailsViewController.h"
#import "RootViewController.h"
#import "ViewController.h"
#import "CSS_Class.h"
#import "config.h"
#import "UIScrollView+EKKeyboardAvoiding.h"
#import "AppDelegate.h"
#import "AFNHelper.h"
#import "Constants.h"
#import "AFNetworking.h"
#import "CommenMethods.h"

@interface EditProfileViewController ()<UIImagePickerControllerDelegate,UIGestureRecognizerDelegate,UITextViewDelegate>
{
    NSInteger selectedImgBtn;
    NSString *gender;
    AppDelegate *appDelegate;
    NSMutableArray *imagesArray, *positionArray;
}

@end

@implementation EditProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    appDelegate =(AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    [self setUpDesign];
    
    imagesArray = [[NSMutableArray alloc]init];
    positionArray = [[NSMutableArray alloc]init];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapReceived:)];
    [tapGestureRecognizer setDelegate:self];
    [self.view addGestureRecognizer:tapGestureRecognizer];
    
}

-(void)setUpDesign{
    
    gender = @"female";
    
    _firstImgBtn.tag = 301;
    _secondImgBtn.tag = 302;
    _thirdImgBtn.tag = 303;
    _fourthImgBtn.tag = 304;
    _fifthImgBtn.tag = 305;
    _sixthImgBtn.tag = 306;
    
    [_topView.layer setShadowColor:[UIColor blackColor].CGColor];
    [_topView.layer setShadowOpacity:0.3];
    [_topView.layer setShadowRadius:5.0];
    [_topView.layer setShadowOffset:CGSizeMake(2.0, 2.0)];
    
    [_topMostView setFrame:CGRectMake(self.view.frame.origin.x, 0, self.view.frame.size.width, self.topMostView.frame.size.height)];
    [_editProfieScrollView addSubview:self.topMostView];
    
    [_editProfieScrollView setContentSize:CGSizeMake(_topMostView.frame.size.width, _topMostView.frame.size.height)];
    [_editProfieScrollView setKeyboardAvoidingEnabled:YES];
    
    _firstImageView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _secondImageView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _thirdImageView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _fourthImageView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _fifthImageView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _sixthImageView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    _firstImageView.layer.borderWidth = 2.0;
    _secondImageView.layer.borderWidth = 2.0;
    _thirdImageView.layer.borderWidth = 2.0;
    _fourthImageView.layer.borderWidth = 2.0;
    _fifthImageView.layer.borderWidth = 2.0;
    _sixthImageView.layer.borderWidth = 2.0;

    
    _firstImageView.layer.cornerRadius = 5.0;
    _secondImageView.layer.cornerRadius = 5.0;
    _thirdImageView.layer.cornerRadius = 5.0;
    _fourthImageView.layer.cornerRadius = 5.0;
    _fifthImageView.layer.cornerRadius = 5.0;
    _sixthImageView.layer.cornerRadius = 5.0;
    
    _firstImageView.clipsToBounds = YES;
    _secondImageView.clipsToBounds = YES;
    _thirdImageView.clipsToBounds = YES;
    _fourthImageView.clipsToBounds = YES;
    _fifthImageView.clipsToBounds = YES;
    _sixthImageView.clipsToBounds = YES;

    _aboutYouTextView.text = @"Tell about you...";
    _aboutYouTextView.delegate = self;
    
    [self getProfile];
    
}

-(void)tapReceived:(UITapGestureRecognizer *)tapGestureRecognizer
{
    [self.view endEditing:YES];
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@"Tell about you..."]) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor]; //optional
    }
    [textView becomeFirstResponder];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@""]) {
        textView.text = @"Tell about you...";
        textView.textColor = [UIColor lightGrayColor]; //optional
    }
    [textView resignFirstResponder];
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

- (IBAction)addImageBtnAction:(UIButton*)sender {
    
    selectedImgBtn = sender.tag;
    
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
    
    switch (selectedImgBtn) {
        case 301:{
            _firstImageView.image = chosenImage;
            [_firstImgBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
            [imagesArray addObject:chosenImage];
        }
            break;
        case 302:{
            _secondImageView.image = chosenImage;
            [_secondImgBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
            [imagesArray addObject:chosenImage];
    }
            break;
        case 303:{
            _thirdImageView.image = chosenImage;
            [_thirdImgBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
            [imagesArray addObject:chosenImage];
    }
            break;
        case 304:{
            _fourthImageView.image = chosenImage;
            [_fourthImgBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
            [imagesArray addObject:chosenImage];
    }
            break;
        case 305:{
            _fifthImageView.image = chosenImage;
            [_fifthImgBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
            [imagesArray addObject:chosenImage];
    }
            break;
        case 306:{
            _sixthImageView.image = chosenImage;
            [_sixthImgBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
            [imagesArray addObject:chosenImage];
    }
            break;
            
        default:
            break;
    }
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
    [self updateImagesWithPosition:[NSString stringWithFormat:@"%ld",selectedImgBtn-300] andImage:chosenImage];
    
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

- (IBAction)maleBtnAction:(id)sender {
    
    gender = @"male";
    [_maleImageView setImage:[UIImage imageNamed:@"radioOn"]];
    [_femaleImageView setImage:[UIImage imageNamed:@"radioOff"]];
}

- (IBAction)femaleBtnAction:(id)sender {
    
    gender = @"female";
    [_maleImageView setImage:[UIImage imageNamed:@"radioOff"]];
    [_femaleImageView setImage:[UIImage imageNamed:@"radioOn"]];

}
- (IBAction)backButtonAction:(id)sender {
    
    if([_isFrom  isEqualToString:@"profile"]){
        
        ProfileViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"ProfileViewController"];
        [self.navigationController pushViewController:controller animated:YES];
    }
    else if ([_isFrom isEqualToString:@"userdetails"]){
        
        ViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"ViewController"];
        controller.IsFrom = @"editprofile";
        [self.navigationController pushViewController:controller animated:YES];
        
    }

}

-(void)getProfile {
    
    if([appDelegate internetConnected])
    {
        NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
        NSString *identi=[user valueForKey:@"id"];
        NSString *token=[user valueForKey:@"token"];
        
        NSDictionary * params=@{@"id":identi,@"token":token};
        
        [appDelegate onStartLoader];
        AFNHelper *afn=[[AFNHelper alloc]initWithRequestMethod:GET_METHOD];
        [afn getDataFromPath:MD_GETPROFILE withParamData:params withBlock:^(id response, NSDictionary *Error,NSString *strCode) {
            [appDelegate onEndLoader];
            if([[response valueForKey:@"success"]boolValue] == 1)
            {
                _userNameTxtFld.text = [NSString stringWithFormat:@"%@",[[response objectForKey:@"user"]valueForKey:@"name"]];
                _workTxtField.text = [NSString stringWithFormat:@"%@",[[response objectForKey:@"user"]valueForKey:@"work"]];
                _schoolTxtField.text = [NSString stringWithFormat:@"%@",[[response objectForKey:@"user"]valueForKey:@"school"]];
                _aboutYouTextView.text = [NSString stringWithFormat:@"%@",[[response objectForKey:@"user"]valueForKey:@"description"]];
                
                if([_aboutYouTextView.text  isEqual: @""]){
                    
                    _aboutYouTextView.text = @"Tell about you...";
                    _aboutYouTextView.textColor = [UIColor lightGrayColor];
                }
                else {
                    _aboutYouTextView.textColor = [UIColor blackColor];
                }
                gender = [NSString stringWithFormat:@"%@",[[response objectForKey:@"user"]valueForKey:@"gender"]];
                if([gender  isEqual: @"male"]){
                    [_maleImageView setImage:[UIImage imageNamed:@"radioOn"]];
                    [_femaleImageView setImage:[UIImage imageNamed:@"radioOff"]];
                }
                else if([gender  isEqual: @"female"]){
                    [_femaleImageView setImage:[UIImage imageNamed:@"radioOn"]];
                    [_maleImageView setImage:[UIImage imageNamed:@"radioOff"]];
                }
                
                NSString *ImageURL = [[response objectForKey:@"user"]valueForKey:@"picture"];
                
                if([ImageURL  isEqual: @""]){
                    
                    
                }
                else {
                    
//                    NSURL *picURL = [NSURL URLWithString:ImageURL];
//                    NSData *data = [NSData dataWithContentsOfURL:picURL];
//                    UIImage *image = [UIImage imageWithData:data];
//                    [imagesArray addObject:image];
                }
                
                NSArray *otherImages = [[response objectForKey:@"user"]objectForKey:@"images"];
                
                for(int i= 0; i<[otherImages count]; i++){
                    
                    if([[otherImages objectAtIndex:i]  isEqual: @"https://datesauce.com/flamerui/img/user.png"]){
                        
                    }
                    else{
                        NSURL *picURL = [NSURL URLWithString:[otherImages objectAtIndex:i]];
                        NSData *data = [NSData dataWithContentsOfURL:picURL];
                        UIImage *image = [UIImage imageWithData:data];
                        [imagesArray addObject:image];

                    }
                }
                
                if([imagesArray count]){
                    for (int i = 0; i<imagesArray.count; i++){
                        
                        if(i ==0){
                            
                            _firstImageView.image = [imagesArray objectAtIndex:i];
                            [_firstImgBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
                        }
                        else if(i ==1){
                            
                            _secondImageView.image = [imagesArray objectAtIndex:i];
                            [_secondImgBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
                        }
                        else if(i ==2){
                            
                            _thirdImageView.image = [imagesArray objectAtIndex:i];
                            [_thirdImgBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
                        }
                        else if(i ==3){
                            
                            _fourthImageView.image = [imagesArray objectAtIndex:i];
                            [_fourthImgBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
                        }
                        else if(i ==4){
                            
                            _fifthImageView.image = [imagesArray objectAtIndex:i];
                            [_fifthImgBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
                        }
                        else if(i ==5){
                            
                            _sixthImageView.image = [imagesArray objectAtIndex:i];
                            [_sixthImgBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
                        }
                    }
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

- (IBAction)doneBtnAction:(id)sender {
    
    [self updateProfile];
}

-(void)updateImagesWithPosition:(NSString *)position andImage:(UIImage *)image{
    
    if([appDelegate internetConnected])
    {
        NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
        NSString *identi=[user valueForKey:@"id"];
        NSString *token=[user valueForKey:@"token"];
        
        NSDictionary * params=@{@"id":identi,@"token":token,@"position":position};
        
        [appDelegate onStartLoader];
        AFNHelper *afn=[[AFNHelper alloc]initWithRequestMethod:POST_METHOD];
        [afn getDataFromPath:MD_PROFILEIMAGE withParamDataImage:params andImage:image withBlock:^(id response, NSDictionary *Error,NSString *strCode) {
            [appDelegate onEndLoader];
            if([[response valueForKey:@"success"]boolValue] == 1)
            {
               
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

-(void)updateProfile {
    
    if([appDelegate internetConnected])
    {
        NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
        NSString *identi=[user valueForKey:@"id"];
        NSString *token=[user valueForKey:@"token"];
        NSString *email=[user valueForKey:@"email"];
        NSString *device_token=[user valueForKey:@"device_token"];
        
        NSString *description = _aboutYouTextView.text;
        if([_aboutYouTextView.text  isEqualToString: @"Tell about you..."]){
            
            description = @"";
        }
        
        NSDictionary * params=@{@"id":identi,@"token":token,@"name":_userNameTxtFld.text,@"gender":gender,@"email":email,@"device_token":device_token,@"description":description,@"work":_workTxtField.text,@"school":_schoolTxtField.text};
        
        [appDelegate onStartLoader];
        AFNHelper *afn=[[AFNHelper alloc]initWithRequestMethod:POST_METHOD];
        [afn getDataFromPath:MD_UPDATEPROFILE withParamData:params withBlock:^(id response, NSDictionary *Error,NSString *strCode) {
            [appDelegate onEndLoader];
            if([[response valueForKey:@"success"]boolValue] == 1)
            {
                NSArray *otherImages = [[response objectForKey:@"user"]objectForKey:@"images"];
                
                NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
                [user setValue:[[response valueForKey:@"user"] valueForKey:@"name"] forKey:@"name"];
                [user setValue:[[response valueForKey:@"user"] valueForKey:@"gender"] forKey:@"gender"];
                [user setValue:[[response valueForKey:@"user"] valueForKey:@"email"] forKey:@"email"];
                [user setValue:[otherImages objectAtIndex:0] forKey:@"picture"];
                [user setValue:[otherImages objectAtIndex:0] forKey:@"image"];
                [user setValue:response[@"picture"] forKey:@"picture"];
                [user setValue:response[@"status"] forKey:@"status"];
                [user setValue:response[@"question_status"] forKey:@"question_status"];
                [user setValue:response[@"school"] forKey:@"school"];
                [user setValue:response[@"work"] forKey:@"work"];
                [user setValue:response[@"age"] forKey:@"age"];
                
                if([_isFrom  isEqualToString:@"profile"]){
                    
                    ProfileViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"ProfileViewController"];
                    [self.navigationController pushViewController:controller animated:YES];
                }
                else if ([_isFrom isEqualToString:@"userdetails"]){
                    
                    ViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"ViewController"];
                    controller.IsFrom = @"editprofile";
                    [self.navigationController pushViewController:controller animated:YES];
                    
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
                    [appDelegate onEndLoader];
                    [CommenMethods alertviewController_title:@"" MessageAlert:NSLocalizedString(@"ERRORMSG", nil) viewController:self okPop:NO];
                }
                else
                {
                    if ([Error objectForKey:@"email"]) {
                        [appDelegate onEndLoader];
                        [CommenMethods alertviewController_title:@"" MessageAlert:[[Error objectForKey:@"email"] objectAtIndex:0]  viewController:self okPop:NO];
                    }
                    else if ([Error objectForKey:@"password"]) {
                        [appDelegate onEndLoader];
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

@end
