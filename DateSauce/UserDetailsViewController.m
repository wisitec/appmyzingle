//
//  UserDetailsViewController.m
//  DateSauce
//
//  Created by veena on 5/31/17.
//  Copyright © 2017 appoets. All rights reserved.
//

#import "UserDetailsViewController.h"
#import "SettingsViewController.h"
#import "EditProfileViewController.h"
#import "ProfileViewController.h"
#import "RootViewController.h"
#import "AppDelegate.h"
#import "AFNHelper.h"
#import <AFNetworking/AFNetworking.h>
#import "CSS_Class.h"
#import "Colors.h"
#import "config.h"
#import "Constants.h"
#import "CommenMethods.h"

@interface UserDetailsViewController ()
{
    AppDelegate *appDelegate;
}

@end

@implementation UserDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    appDelegate =(AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    [self setUpDesign];
    
    [self getProfile];
}

- (void)setUpDesign {
    
    if(IS_IPHONE_5){
        
        [_profileBtn setFrame:CGRectMake(_profileBtn.frame.origin.x, _profileBtn.frame.origin.y, 100, 100)];
        _profileBtn.center = CGPointMake(self.view.center.x, self.profileBtn.center.y);
        [_getTinderPlusBtn.titleLabel setFont:[UIFont fontWithName:@"GothamRounded-Medium" size:13]];
    }
    
    _profileBtn.layer.cornerRadius = _profileBtn.frame.size.height/2;
    _profileBtn.clipsToBounds = YES;
    _getTinderPlusBtn.layer.cornerRadius = _getTinderPlusBtn.frame.size.height/2;
}

-(void)viewWillAppear:(BOOL)animated{
    
}

-(void)commonMethod{
    
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

- (IBAction)profileBtnAction:(id)sender {
    
    ProfileViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"ProfileViewController"];
    [self.navigationController pushViewController:controller animated:YES];

}
- (IBAction)editProfileBtnAction:(id)sender {
    
    EditProfileViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"EditProfileViewController"];
    controller.isFrom = @"userdetails";
    [self.navigationController pushViewController:controller animated:YES];
}
- (IBAction)getTinderPlusBtnAction:(id)sender {
}
- (IBAction)settingsBtnAction:(id)sender {
    
    SettingsViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"SettingsViewController"];
    [self.navigationController pushViewController:controller animated:YES];
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
//                NSLog(@"user profile...%@",response);
                _userNameLbl.text = [NSString stringWithFormat:@"%@, %@",[[response objectForKey:@"user"]valueForKey:@"username"],[[response objectForKey:@"user"]valueForKey:@"age"]];
                _workLbl.text = [NSString stringWithFormat:@"%@",[[response objectForKey:@"user"]valueForKey:@"work"]];
                _schoolLbl.text = [NSString stringWithFormat:@"%@",[[response objectForKey:@"user"]valueForKey:@"school"]];
                
                NSString *ImageURL = [[response objectForKey:@"user"]valueForKey:@"picture"];
                
                if([ImageURL  isEqual: @""]){
                    
                    NSArray *otherImages = [[response objectForKey:@"user"]objectForKey:@"images"];
                    
                    NSURL *picURL = [NSURL URLWithString:[otherImages objectAtIndex:0]];
                    NSData *data = [NSData dataWithContentsOfURL:picURL];
                    UIImage *image = [UIImage imageWithData:data];
                    
                    [_profileBtn setImage:image forState:UIControlStateNormal];
                }
                else {
                    
                    NSURL *picURL = [NSURL URLWithString:ImageURL];
                    NSData *data = [NSData dataWithContentsOfURL:picURL];
                    UIImage *image = [UIImage imageWithData:data];
                    [_profileBtn setImage:image forState:UIControlStateNormal];
                    
                     _profileBtn.layer.cornerRadius = _profileBtn.frame.size.height/2;
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
