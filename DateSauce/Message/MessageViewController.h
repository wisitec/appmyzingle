//
//  MessageViewController.h
//  DateSauce
//
//  Created by veena on 6/15/17.
//  Copyright © 2017 appoets. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageViewController : UIViewController{
    NSArray *arrNewMatches, *arrMessages;
    NSString *strReciverID,*strReciverName,*strRecivePic, *strMsgCnt;
    UIView *viewNoMsgsMatches;
}
@property (weak, nonatomic) IBOutlet UITableView *messageListTableView;

@end
