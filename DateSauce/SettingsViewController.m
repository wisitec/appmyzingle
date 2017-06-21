//
//  SettingsViewController.m
//  DateSauce
//
//  Created by veena on 5/31/17.
//  Copyright © 2017 appoets. All rights reserved.
//

#import "SettingsViewController.h"
#import "SettingsTableViewCell.h"
#import "WebViewViewController.h"
#import "ViewController.h"
#import "RootViewController.h"
#import "AppDelegate.h"
#import "AFNHelper.h"
#import "CommenMethods.h"
#import "Constants.h"
#import <GooglePlaces/GooglePlaces.h>

@interface SettingsViewController ()<GMSAutocompleteViewControllerDelegate,UITableViewDelegate,UITableViewDataSource>
{
    NSString *men,*women,*showMe;
    NSMutableArray *locationsArray, *locationDetailsArray;
    BOOL locationSelected;
    NSInteger selectedIndex;
    AppDelegate *appDelegate;

}
@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    userApi/getPreferences?id=97&token=2y10USfXOAspRgaZl6mdV5YLfuTFL9jZexxZWMUB4M92TnnjWjwuS9YG
    
    appDelegate =(AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    [self onLocationUpdateStart];
    
    [self getPreferences];
    
    [_topView.layer setShadowColor:[UIColor blackColor].CGColor];
    [_topView.layer setShadowOpacity:0.3];
    [_topView.layer setShadowRadius:5.0];
    [_topView.layer setShadowOffset:CGSizeMake(2.0, 2.0)];
    
    [self setShadowToView:_swipingInView];
    [self setShadowToView:_logoutView];
    [self setShadowToView:_showAgesView];
    [self setShadowToView:_searchDistView];
    [self setShadowToView:_showMeView];
    [self setShadowToView:_showMeOnDateSauceView];
    [self setShadowToView:_changePasswordView];
    [self setShadowToView:_privacyTermsView];
    [self setShadowToView:_helpSupportView];
    [self setShadowToView:_deleteAccountView];
    
    self.swipingInTableView.delegate = self;
    self.swipingInTableView.dataSource = self;
    
   // [_topMostView setFrame:CGRectMake(self.view.frame.origin.x, 0, self.topMostView.frame.size.width, self.topMostView.frame.size.height)];
    [_topMostView setFrame:CGRectMake(self.view.frame.origin.x, 0, self.view.frame.size.width, self.topMostView.frame.size.height)];
    [_settingsScrollView addSubview:self.topMostView];
    
    [_settingsScrollView setContentSize:CGSizeMake(_topMostView.frame.size.width, _topMostView.frame.size.height)];
    
    [_distanceSlider addTarget:self action:@selector(sliderChanged:) forControlEvents:UIControlEventValueChanged];
    [_agesSlider addTarget:self action:@selector(agesliderChanged:) forControlEvents:UIControlEventValueChanged];
    [_menSwitch addTarget:self action:@selector(menSwitchToggled:) forControlEvents:UIControlEventValueChanged];
    [_womenSwitch addTarget:self action:@selector(womenSwitchToggled:) forControlEvents:UIControlEventValueChanged];
    [_showMeSwitch addTarget:self action:@selector(showMeSwitchToggled:) forControlEvents:UIControlEventValueChanged];
    
    locationSelected = YES;
    
//    locationsArray = [[NSMutableArray alloc]initWithObjects:@"Current Location", nil];
}


#pragma mark -- Table View Delegates Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [locationsArray count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SettingsTableViewCell *cell = (SettingsTableViewCell*)[_swipingInTableView dequeueReusableCellWithIdentifier:@"SettingsTableViewCell"];
    cell.locationLabel.text = [locationsArray objectAtIndex:indexPath.row];
    
    if(indexPath.row == 0 && locationSelected){
        
        [cell.radioBtn setImage:[UIImage imageNamed:@"radioOn"] forState:UIControlStateNormal];
    }
    else if(indexPath.row == selectedIndex){
        
        [cell.radioBtn setImage:[UIImage imageNamed:@"radioOn"] forState:UIControlStateNormal];
    }
    else {
        
        [cell.radioBtn setImage:[UIImage imageNamed:@"radioOff"] forState:UIControlStateNormal];
    }
    
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SettingsTableViewCell *cell = (SettingsTableViewCell*)[_swipingInTableView cellForRowAtIndexPath:indexPath];
    locationSelected = NO;
    
    selectedIndex =indexPath.row;
    
    if(indexPath.row != 0){
    NSDictionary *locDict = [locationDetailsArray objectAtIndex:selectedIndex-1];
    [CommenMethods setUserDefaultsObject:[locDict valueForKey:@"latitude"] key:@"selectedLat"];
    [CommenMethods setUserDefaultsObject:[locDict valueForKey:@"longitude"] key:@"selectedLong"];
    [CommenMethods setUserDefaultsObject:[locationsArray objectAtIndex:indexPath.row] key:@"address"];
    }
    
    [cell.radioBtn setImage:[UIImage imageNamed:@"radioOn"] forState:UIControlStateNormal];
    [self.swipingInTableView reloadData];
}

-(BOOL)tableView:(UITableView* )tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0){
        return NO;
    }
    else {
    return YES;
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row!=0)
    {
        if (editingStyle == UITableViewCellEditingStyleDelete)
        {
            
            if([appDelegate internetConnected])
            {
                NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
                NSString *identi=[user valueForKey:@"id"];
                NSString *token=[user valueForKey:@"token"];
                
                NSDictionary *locDict = [locationDetailsArray objectAtIndex:indexPath.row-1];
                
                NSString *locId = [locDict valueForKey:@"id"];
                
                NSDictionary * params=@{@"id":identi,@"token":token,@"location_id":locId};
                
                [appDelegate onStartLoader];
                AFNHelper *afn=[[AFNHelper alloc]initWithRequestMethod:POST_METHOD];
                [afn getDataFromPath:MD_DELETEUSERLOCATION withParamData:params withBlock:^(id response, NSDictionary *Error,NSString *strCode) {
                    [appDelegate onEndLoader];
                    if([[response valueForKey:@"success"]boolValue] == 1)
                    {
                        [self getPreferences];
                    }
                    else
                    {
                        
                        if ([strCode intValue]==1)
                        {
                            [appDelegate onEndLoader];
                            [CommenMethods alertviewController_title:@"" MessageAlert:NSLocalizedString(@"ERRORMSG", nil) viewController:self okPop:NO];
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
    }
  
}

- (void)sliderChanged:(UISlider *)slider {
    int sliderValue;
    sliderValue = slider.value;
    self.distanceLabel.text = [NSString stringWithFormat:@"%d mi.", sliderValue ];
}

- (void)agesliderChanged:(UISlider *)slider {
    int sliderValue;
    sliderValue = slider.value;
    self.agesLabel.text = [NSString stringWithFormat:@"%d", sliderValue];
}

- (void)menSwitchToggled:(id)sender {
    UISwitch *mySwitch = (UISwitch *)sender;
    if ([mySwitch isOn]) {
        men = @"1";
    } else {
        men = @"0";
    }
}

- (void)womenSwitchToggled:(id)sender {
    UISwitch *mySwitch = (UISwitch *)sender;
    if ([mySwitch isOn]) {
        women = @"1";
    } else {
        women = @"0";
    }
}

- (void)showMeSwitchToggled:(id)sender {
    UISwitch *mySwitch = (UISwitch *)sender;
    if ([mySwitch isOn]) {
        showMe = @"1";
    } else {
        showMe = @"0";
    }
}

-(void)setShadowToView:(UIView*)view{
    
    [view.layer setShadowColor:[UIColor blackColor].CGColor];
    [view.layer setShadowOpacity:0.3];
    [view.layer setShadowRadius:2.0];
    [view.layer setShadowOffset:CGSizeMake(2.0, 2.0)];
}

- (IBAction)backBtnAction:(id)sender {
    
    ViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"ViewController"];
    controller.IsFrom = @"settings";
    [self.navigationController pushViewController:controller animated:YES];
}
- (IBAction)addLocationBtnAction:(id)sender {
    
    GMSAutocompleteViewController *acController = [[GMSAutocompleteViewController alloc] init];
    acController.delegate = self;
    [self presentViewController:acController animated:YES completion:nil];
}

- (void)viewController:(GMSAutocompleteViewController *)viewController
didAutocompleteWithPlace:(GMSPlace *)place {
    [self dismissViewControllerAnimated:YES completion:nil];
    // Do something with the selected place.
    NSLog(@"Place name %@", place.name);
    
    NSString*str=[NSString stringWithFormat:@"%f", place.coordinate.latitude];
    NSString*str1=[NSString stringWithFormat:@"%f", place.coordinate.longitude];
    [CommenMethods setUserDefaultsObject:str key:@"selectedLat"];
    [CommenMethods setUserDefaultsObject:str1 key:@"selectedLong"];
    [CommenMethods setUserDefaultsObject:place.name key:@"address"];
    
    [locationsArray addObject:place.name];
    locationSelected = NO;
    selectedIndex = locationsArray.count-1;
    [self.swipingInTableView reloadData];
    //[_searchBtn setTitle:place.formattedAddress forState:UIControlStateNormal];
    
    NSLog(@"Place address %@", place.formattedAddress);
    NSLog(@"Place attributions %@", place.attributions.string);
    
    [self addLocation];
}


- (void)viewController:(GMSAutocompleteViewController *)viewController
didFailAutocompleteWithError:(NSError *)error {
    [self dismissViewControllerAnimated:YES completion:nil];
    // TODO: handle the error.
    NSLog(@"Error: %@", [error description]);
}
// User canceled the operation.
- (void)wasCancelled:(GMSAutocompleteViewController *)viewController
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
// Turn the network activity indicator on and off again.
- (void)didRequestAutocompletePredictions:(GMSAutocompleteViewController *)viewController
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)didUpdateAutocompletePredictions:(GMSAutocompleteViewController *)viewController
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}
- (BOOL)viewController:(GMSAutocompleteViewController *)viewController
   didSelectPrediction:(GMSAutocompletePrediction *)prediction;
{
//    GMSCameraPosition *ccamera = [GMSCameraPosition cameraWithLatitude:[[CommenMethods getUserDefaultsKey:@"searchLat"]floatValue]
//                                  
//                                                             longitude:[[CommenMethods getUserDefaultsKey:@"searchLong"]floatValue]
//                                                                  zoom:15];
//    [_mkap setCamera:ccamera];
    [self.view reloadInputViews];
    return YES;
}


- (IBAction)changePasswordBtnAction:(id)sender {
}

- (IBAction)helpSupportBtnAction:(id)sender {
    
    WebViewViewController *signIn = [self.storyboard instantiateViewControllerWithIdentifier:@"WebViewViewController"];
    signIn.navTitle = @"Help and Support";
    signIn.urlToLoad = @"https://datesauce.com/help";
    [self.navigationController pushViewController:signIn animated:YES];

}

- (IBAction)logoutBtnAction:(id)sender {
    
    NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
    [user removeObjectForKey:UD_TOKEN_TYPE];
    [user removeObjectForKey:UD_ACCESS_TOKEN];
    [user removeObjectForKey:UD_REFERSH_TOKEN];
    [user removeObjectForKey:@"isLoggedin"];

    RootViewController *root = [self.storyboard instantiateViewControllerWithIdentifier:@"RootViewController"];
    [self.navigationController pushViewController:root animated:YES];
}
- (IBAction)privacyPolicyBtnAction:(id)sender {
    
    WebViewViewController *signIn = [self.storyboard instantiateViewControllerWithIdentifier:@"WebViewViewController"];
    signIn.navTitle = @"Privacy Policy";
    signIn.urlToLoad = @"https://datesauce.com/privacy";
    [self.navigationController pushViewController:signIn animated:YES];

}

- (IBAction)termsOfServiceBtnAction:(id)sender {
    
    WebViewViewController *signIn = [self.storyboard instantiateViewControllerWithIdentifier:@"WebViewViewController"];
    signIn.navTitle = @"Terms and Conditions";
    signIn.urlToLoad = @"https://datesauce.com/terms";
    [self.navigationController pushViewController:signIn animated:YES];

}

- (IBAction)deletAccountButtonAction:(id)sender {
    
    [self deleteAccount];
}

- (IBAction)doneBtnAction:(id)sender {
    
    [self savePreferences];
}

-(void)getPreferences {
    
    if([appDelegate internetConnected])
    {
        NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
        NSString *identi=[user valueForKey:@"id"];
        NSString *token=[user valueForKey:@"token"];
        
        NSDictionary * params=@{@"id":identi,@"token":token};
        
        [appDelegate onStartLoader];
        AFNHelper *afn=[[AFNHelper alloc]initWithRequestMethod:GET_METHOD];
        [afn getDataFromPath:MD_GETPREFERENCES withParamData:params withBlock:^(id response, NSDictionary *Error,NSString *strCode) {
            [appDelegate onEndLoader];
            if([[response valueForKey:@"success"]boolValue] == 1)
            {
                NSDictionary *preferences = [response objectForKey:@"preference"];
                _agesSlider.value = [[preferences objectForKey:@"age_limit"]floatValue];
                self.agesLabel.text = [NSString stringWithFormat:@"%d", [[preferences objectForKey:@"age_limit"]intValue] ];
                if([[preferences objectForKey:@"discovery"] isEqualToString: @"1"] )
                {
                    _showMeSwitch.on =YES;
                    showMe = @"1";
                }
                else if([[preferences objectForKey:@"discovery"] isEqualToString: @"0"] )
                {
                    _showMeSwitch.on =NO;
                     showMe = @"0";
                }
                _distanceSlider.value = [[preferences objectForKey:@"distance"]floatValue];
                self.distanceLabel.text = [NSString stringWithFormat:@"%d mi.", [[preferences objectForKey:@"distance"]intValue] ];
                
                if([[preferences objectForKey:@"gender"] isEqualToString: @"male"] )
                {
                    _menSwitch.on =YES;
                    _womenSwitch.on =NO;
                     men = @"1";
                }
                else if([[preferences objectForKey:@"gender"] isEqualToString: @"female"] )
                {
                    _menSwitch.on =NO;
                    _womenSwitch.on =YES;
                    women = @"1";
                }
                NSArray *locArray = [preferences objectForKey:@"locations"];
                locationDetailsArray = [[NSMutableArray alloc]init];
                locationsArray = [[NSMutableArray alloc]init];
                [locationsArray addObject:@"Current Location"];
                
                if([locArray count]){
                    
                    int i =1;
                    locationDetailsArray = [preferences valueForKey:@"locations"];
                    locationSelected = NO;
                
                for(NSDictionary *dict in locationDetailsArray){
                
                    
                    [locationsArray addObject:[dict valueForKey:@"address"]];
                    
                    NSString *preferencesLat = [NSString stringWithFormat:@"%@",[preferences valueForKey:@"latitude"]];
                    NSString *dictLat = [NSString stringWithFormat:@"%@",[dict valueForKey:@"latitude"]];
                    
                    NSString *preferencesLong = [NSString stringWithFormat:@"%@",[preferences valueForKey:@"longitude"]];
                    NSString *dictLong = [NSString stringWithFormat:@"%@",[dict valueForKey:@"longitude"]];

                    if(([preferencesLat isEqualToString:dictLat]) && ([preferencesLong isEqualToString:dictLong])){
                        
                        selectedIndex = i;
                    }
                    i++;
                }
                }
                [_swipingInTableView reloadData];

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

-(void)savePreferences {
    
    if([appDelegate internetConnected])
    {
        NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
        NSString *identi=[user valueForKey:@"id"];
        NSString *token=[user valueForKey:@"token"];
        
        NSString *gender;
        if([men  isEqual: @"1"]){
            
            gender = @"male";
        }
        else if([women  isEqual: @"1"]){
            
            gender = @"female";
        }
        
        int age = _agesSlider.value;
        int distance = _distanceSlider.value;
        
        NSString* latitude;
        NSString* longitude;
        if(selectedIndex == 0){
         latitude = [NSString stringWithFormat:@"%f",myLocation.coordinate.latitude];
         longitude = [NSString stringWithFormat:@"%f",myLocation.coordinate.longitude];
        }
        else{
         latitude = [NSString stringWithFormat:@"%@",[user valueForKey:@"selectedLat"]];
         longitude = [NSString stringWithFormat:@"%@",[user valueForKey:@"selectedLong"]];
        }
        
        NSDictionary * params=@{@"id":identi,@"token":token,@"age_limit":[NSString stringWithFormat:@"%d",age],@"gender":gender,@"distance":[NSString stringWithFormat:@"%d",distance],@"discovery":showMe,@"latitude":latitude,@"longitude":longitude};
        
        [appDelegate onStartLoader];
        AFNHelper *afn=[[AFNHelper alloc]initWithRequestMethod:POST_METHOD];
        [afn getDataFromPath:MD_PREFERENCE_SAVE withParamData:params withBlock:^(id response, NSDictionary *Error,NSString *strCode) {
            [appDelegate onEndLoader];
            if([[response valueForKey:@"success"]boolValue] == 1)
            {
                ViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"ViewController"];
                controller.IsFrom = @"settings";
                [self.navigationController pushViewController:controller animated:YES];
            }
            else
            {
                
                if ([strCode intValue]==1)
                {
                    [appDelegate onEndLoader];
                    [CommenMethods alertviewController_title:@"" MessageAlert:NSLocalizedString(@"ERRORMSG", nil) viewController:self okPop:NO];
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

-(void)addLocation {
    
    if([appDelegate internetConnected])
    {
        NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
        NSString *identi=[user valueForKey:@"id"];
        NSString *token=[user valueForKey:@"token"];
        
        NSString* latitude;
        NSString* longitude;
        
        NSString *address = [NSString stringWithFormat:@"%@",[user valueForKey:@"address"]];
        
        latitude = [NSString stringWithFormat:@"%@",[user valueForKey:@"selectedLat"]];
        longitude = [NSString stringWithFormat:@"%@",[user valueForKey:@"selectedLong"]];
        
        NSDictionary * params=@{@"id":identi,@"token":token,@"latitude":latitude,@"longitude":longitude,@"address":address};
        
        [appDelegate onStartLoader];
        AFNHelper *afn=[[AFNHelper alloc]initWithRequestMethod:POST_METHOD];
        [afn getDataFromPath:MD_ADDLOCATION withParamData:params withBlock:^(id response, NSDictionary *Error,NSString *strCode) {
            [appDelegate onEndLoader];
            if([[response valueForKey:@"success"]boolValue] == 1)
            {
                [self getPreferences];
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

-(void)deleteAccount {
    
    if([appDelegate internetConnected])
    {
        NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
        NSString *identi=[user valueForKey:@"id"];
        NSString *token=[user valueForKey:@"token"];
        
        NSDictionary * params=@{@"id":identi,@"token":token};
        
        [appDelegate onStartLoader];
        AFNHelper *afn=[[AFNHelper alloc]initWithRequestMethod:GET_METHOD];
        [afn getDataFromPath:MD_DELETEACCOUNT withParamData:params withBlock:^(id response, NSDictionary *Error,NSString *strCode) {
            [appDelegate onEndLoader];
            if([[response valueForKey:@"success"]boolValue] == 1)
            {
                [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"id"];
                [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"token"];
                
                RootViewController *signIn = [self.storyboard instantiateViewControllerWithIdentifier:@"RootViewController"];
                [self.navigationController pushViewController:signIn animated:YES];
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

#pragma mark - Get Current Location

-(void)onLocationUpdateStart
{
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.distanceFilter = kCLDistanceFilterNone;
    _locationManager.delegate=self;
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    //[_locationManager requestWhenInUseAuthorization];
    //[_locationManager requestAlwaysAuthorization];
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
@end
