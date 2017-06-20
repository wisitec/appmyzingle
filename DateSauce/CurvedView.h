//
//  CurvedView.h
//  DateSauce
//
//  Created by veena on 5/31/17.
//  Copyright © 2017 appoets. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE
@interface CurvedView : UIView
@property (nonatomic, strong) IBInspectable UIColor *fillColor;
@property (nonatomic, weak) CAShapeLayer *curvedLayer;
@end
