//
//  MessageTableViewCell.m
//  DateSauce
//
//  Created by veena on 6/15/17.
//  Copyright © 2017 appoets. All rights reserved.
//

#import "MessageTableViewCell.h"

@implementation MessageTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.recipientImage.layer.cornerRadius = self.recipientImage.frame.size.height/2;
    self.recipientImage.clipsToBounds = YES;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
