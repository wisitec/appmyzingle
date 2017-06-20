//
//  MessageView.h
//  Binder
//
//  Created by Wepop on 22/06/16.
//  Copyright © 2016 WePop Info Solutions Pvt. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "webservice.h"

@interface MessageView : UIViewController<WebServiceDelegate,UITableViewDelegate,UITableViewDataSource>

@property NSString *isFrom;

@end
