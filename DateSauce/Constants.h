//
//  Constants.h
//  Truck
//
//  Created by veena on 1/12/17.
//  Copyright © 2017 appoets. All rights reserved.
//

#import <UIKit/UIKit.h>

#pragma mark - Service URL

#define USER_DEFAULTS [NSUserDefaults standardUserDefaults]
#define APP_NAME @"DateSauce"

#define SERVICE_URL @"https://datesauce.com/"
#define WEB_SOCKET @"http://datesauce.com:8890"

#define Address_URL @"https://maps.googleapis.com/maps/api/geocode/json?"
#define AutoComplete_URL @"https://maps.googleapis.com/maps/api/place/autocomplete/json?"

#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_RETINA ([[UIScreen mainScreen] scale] >= 2.0)

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))
#define IS_ZOOMED (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)

#define IS_IPHONE_4_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
#define IS_IPHONE_5 (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
#define IS_IPHONE_6 (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
#define IS_IPHONE_6P (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)

#define GOOGLE_API_KEY @"AIzaSyAb-4OFZafc4PPf3gG_V9JILphPQdnBIAA"
#define GMSMAP_KEY  @"AIzaSyAb-4OFZafc4PPf3gG_V9JILphPQdnBIAA"
#define GMSPLACES_KEY  @"AIzaSyAb-4OFZafc4PPf3gG_V9JILphPQdnBIAA"
#define Google_Client_ID @"710279630663-4lgj6e2c98imgiv4t2d6207l3296987e.apps.googleusercontent.com"

#define Stripe_KEY @"pk_test_0G4SKYMm8dK6kgayCPwKWTXy"

#define ClientID @"2"
#define Client_SECRET @"qCj8BU1jIy3D0UOe1lIMThLEZQyPjxFmLdUSOs6c"


//convert latlng to address;
//https://maps.googleapis.com/maps/api/geocode/json?latlng=18.345345,80.4235234&key=AIzaSyD14IIsfUksGaKdKCMfQERAYIkPE8VLOAM

#pragma mark - userdefaults
#pragma mark -

extern NSString *const UD_TOKEN_TYPE;
extern NSString *const UD_ACCESS_TOKEN;
extern NSString *const UD_REFERSH_TOKEN;
extern NSString *const UD_PROFILE_IMG;
extern NSString *const UD_PROFILE_NAME;
extern NSString *const UD_REQUESTID;


#pragma mark - Parameters
#pragma mark - --
extern NSString *const PICTURE;






#pragma mark - Parameters
#pragma mark - --   Seque

extern NSString *const LOGIN;
extern NSString *const REGISTER;



#pragma mark - methods
#pragma mark - 

extern NSString *const MD_LOGIN;
extern NSString *const MD_REGISTER;
extern NSString *const MD_GETPROFILE;
extern NSString *const MD_UPDATEPROFILE;
extern NSString *const MD_UPDATELOCATION;
extern NSString *const MD_CHANGEPASSWORD;
extern NSString *const MD_GET_SERVICE;
extern NSString *const MD_PROFILEIMAGE;
extern NSString *const MD_GETPREFERENCES;
extern NSString *const MD_PREFERENCE_SAVE;
extern NSString *const MD_ADDLOCATION;
extern NSString *const MD_DELETEACCOUNT;
extern NSString *const MD_DELETEUSERLOCATION;
extern NSString *const MD_SEARCH;
extern NSString *const MD_LIKE;
extern NSString *const MD_GET_MESSAGES;
extern NSString *const MD_GET_USER_MESSAGE;
extern NSString *const MD_USER_UNMATCH;
extern NSString *const MD_USER_AMOUNT;


