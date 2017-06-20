//
//  AppDelegate.h
//  DateSauce
//
//  Created by veena on 5/30/17.
//  Copyright © 2017 appoets. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reachability.h"
#import <UserNotifications/UserNotifications.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate,UNUserNotificationCenterDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UINavigationController *navigationController;
@property (strong, nonatomic) UIStoryboard *storyboard;
@property(strong,nonatomic) NSString *strDeviceToken,*strEmail;
@property(strong,nonatomic)NSString *strUserCount;

@property(strong,nonatomic)NSString  *strLatitude, *strLongitude, *strAppState, *strIsLoggedOut, *strLoginStatus, *strSattus, *strProUser, *strSwipeLat, *strSwipeLong, *strCityName, *strGender, *strIsFrmChat;

@property(strong,nonatomic)NSString *strID, *strName, *strPicture, *strToken, *strEidtBtnClicked, *strWchAppSetting, *strAddNewLocClicked, *strisFrmBindPlus, *strCityDeleted, *StrSocialType;

@property(weak, nonatomic)NSString        *is_from_push;
@property(strong, nonatomic)NSDictionary *dictNotiDetails;
@property(strong, nonatomic)NSString *strNotiType, *isFrmMessage;

-(BOOL)internetConnected;
-(void)onStartLoader;
-(void)onEndLoader;

@end

