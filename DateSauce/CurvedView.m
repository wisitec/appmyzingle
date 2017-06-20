//
//  CurvedView.m
//  DateSauce
//
//  Created by veena on 5/31/17.
//  Copyright © 2017 appoets. All rights reserved.
//

#import "CurvedView.h"

@implementation CurvedView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self configureView];
    }
    return self;
}

- (instancetype _Nullable)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self configureView];
    }
    return self;
}

- (void)configureView {
    self.fillColor = [UIColor whiteColor];
    
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.fillColor = self.fillColor.CGColor;
    layer.strokeColor = [UIColor clearColor].CGColor;
    layer.lineWidth = 0;
    [self.layer addSublayer:layer];
    self.curvedLayer = layer;
}

- (void)setFillColor:(UIColor *)fillColor {
    _fillColor = fillColor;
    
    self.curvedLayer.fillColor = fillColor.CGColor;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.curvedLayer.path = [self pathOfArcWithinSize:self.bounds.size].CGPath;
}

- (UIBezierPath * _Nullable)pathOfArcWithinSize:(CGSize)size {
    if (size.width == 0 || size.height <= 0) return nil;
    
    CGFloat theta = M_PI - atan2(size.width / 2.0, size.height) * 2.0;
    CGFloat radius = self.bounds.size.height / (1.0 - cos(theta));
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0, 0)];
    [path addArcWithCenter:CGPointMake(size.width / 2.0, -radius + size.height) radius:radius startAngle:M_PI_2 + theta endAngle:M_PI_2 - theta clockwise:false];
    [path closePath];
    
    return path;
}


@end
