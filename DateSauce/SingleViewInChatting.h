//
//  SingleViewInChatting.h
//  Binder
//
//  Created by Wepop on 27/06/16.
//  Copyright © 2016 WePop Info Solutions Pvt. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "webservice.h"
#import "AppDelegate.h"

#define BTN_NOPE 2
#define BTN_LIKE 1
#define BTN_SUPER_LIKE 3

@interface SingleViewInChatting : UIViewController <WebServiceDelegate, UIScrollViewDelegate>
{
    
}
@property(strong, nonatomic)NSString *strRecvId;
@property(strong,nonatomic)NSString *strReciverName;
@end
