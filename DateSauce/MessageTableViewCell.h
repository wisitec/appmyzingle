//
//  MessageTableViewCell.h
//  DateSauce
//
//  Created by veena on 6/15/17.
//  Copyright © 2017 appoets. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *innerView;
@property (weak, nonatomic) IBOutlet UIImageView *recipientImage;
@property (weak, nonatomic) IBOutlet UILabel *recipientNameLbl;

@end
