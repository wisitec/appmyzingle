//
//  SignInViewController.m
//  DateSauce
//
//  Created by veena on 5/30/17.
//  Copyright © 2017 appoets. All rights reserved.
//

#import "SignInViewController.h"
#import "RootViewController.h"
#import "ViewController.h"
#import "AppDelegate.h"
#import "UIScrollView+EKKeyboardAvoiding.h"
#import "AFNHelper.h"
#import "AFNetworking.h"
#import "CSS_Class.h"
#import "Constants.h"
#import "CommenMethods.h"

@interface SignInViewController ()<UIGestureRecognizerDelegate,UITextFieldDelegate>
{
    AppDelegate *appDelegate;
    NSString *strLoginType, *emailString;
}
@end

@implementation SignInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setUpDesign];
    
    appDelegate =(AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    strLoginType=@"manual";
    
    _emailAddressTxtFld.text=appDelegate.strEmail;
    
    _emailAddressTxtFld.delegate = self;
    _passwordTxtFld.delegate = self;
    
    [_loginScrollView setContentSize:[_loginScrollView frame].size];
    [_loginScrollView setKeyboardAvoidingEnabled:YES];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapReceived:)];
    [tapGestureRecognizer setDelegate:self];
    [self.view addGestureRecognizer:tapGestureRecognizer];
}

- (void)setUpDesign {
    
    [CSS_Class APP_Orangebutton:_signInBtn];
    [CSS_Class APP_textfield_Infocus:_emailAddressTxtFld PaddingIcon:@"mail-1"];
    [CSS_Class APP_textfield_Infocus:_passwordTxtFld PaddingIcon:@"user"];
}


-(void)tapReceived:(UITapGestureRecognizer *)tapGestureRecognizer
{
    [self.view endEditing:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(textField==_emailAddressTxtFld)
    {
        [_passwordTxtFld becomeFirstResponder];
    }
    else if(textField==_passwordTxtFld)
    {
        [_passwordTxtFld resignFirstResponder];
    }
    else
    {
        [textField resignFirstResponder];
    }
    return YES;
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

- (IBAction)facebookLoginBtnAction:(id)sender {
}
- (IBAction)signInBtnAction:(id)sender {
    
    emailString = @"true";
    
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
        
        [CommenMethods alertviewController_title:@"" MessageAlert:NSLocalizedString(@"Password is required", nil) viewController:self okPop:NO];
        
    }
    
    if ([emailString isEqualToString:@"true"])
    {
        
    [self onLogin];
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
            else if([[response valueForKey:@"success"]boolValue] == 0)
            {
                if ([[response valueForKey:@"error_code"]integerValue] == 403) {
                    
                    [CommenMethods alertviewController_title:@"" MessageAlert:[response valueForKey:@"error"] viewController:self okPop:NO];
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


@end
