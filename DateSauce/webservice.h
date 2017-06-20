//
//  webservice.h
//  Fullfill
//
//  Created by Ramesh on 07/10/15.
//  Copyright (c) 2015 WePOP AR Research Lab. All rights reserved.
//

#import <Foundation/Foundation.h>

//#define SERVICE_URL @"http://api.datesauce.com/"


#define METHOD_SIGNUP @"userApi/signup"
#define METHOD_LOGIN @"userApi/login"
#define METHOD_UPDATE_PROFILE @"userApi/updateProfile"
#define METHOD_UPDATE_PROFILE_IMAGE @"userApi/profileImage"
#define METHOD_GET_QUESTIONS @"userApi/getQuestions"
#define METHOD_POST_ANSWERS @"userApi/answer"
#define METHOD_GET_PROFILE @"userApi/profile"
#define METHOD_GET_PREFERENCE @"userApi/getPreferences"
#define METHOD_SAVE_PREFERENCE @"userApi/preferenceSave"
#define METHOD_CHANGE_PASSWORD @"userApi/changePassword"
#define METHOD_DELETE_ACCOUNT @"userApi/deleteAccount"
#define METHOD_SEARCH_FRIENDS @"search?longitude"
#define METHOD_SINGLE_FRIEND @"single"
#define METHOD_LIKE @"userApi/like"
#define METHOD_ADD_USER_LOCATION @"userApi/add_user_location"
#define METHOD_GET_ALL_LOCATIONS @"userApi/get_all_locations"
#define METHOD_DELETE_LOCATION @"userApi/delete_user_location"
#define METHOD_GET_PRO_AMOUNT @"userApi/get_pro_amount"
#define METHOD_PAYPAL_PAYMENT_SUCCESS @"userApi/pay_by_paypal"
#define METHOD_MESSAGES @"userApi/messages"
#define METHOD_GET_USER_MESSAGES @"userApi/getUserMessage"
#define METHOD_GET_PROVIDER_MESSAGES @"userApi/getUserMessage"
#define METHOD_ABOUT @"userApi/about"
#define METHOD_PRIVACY @"userApi/privacy"
#define METHOD_TERMS @"userApi/terms"
#define METHOD_FORGOT_PASSWORD @"userApi/forgotpassword"
#define METHOD_UNMATCH @"userApi/unmatch"



@class webservice;

@protocol WebServiceDelegate <NSObject>

-(void) receivedResponse:(NSDictionary *)dictResponse fromWebservice:(webservice *)webservice;
-(void) receivedErrorWithMessage:(NSString *)message;

@end

@interface webservice : NSObject
{
    NSMutableData *receivedData;
}

@property(nonatomic,retain) id<WebServiceDelegate> delegate;
@property int tag;

- (void) executeWebserviceWithMethod:(NSString *) method withValues:(NSString *) values;
- (void) executeWebserviceWithMethod1:(NSString *) method withValues:(NSString *) values;
- (void) executeWebserviceWithMethod2:(NSString *)method;
-(void) executeWebserviceWithMethodinImage:(NSString *)method withValues:(NSURLRequest *)values;

@end
