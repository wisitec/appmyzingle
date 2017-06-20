//
//  CSS_Class.m
//  TruckLogics
//
//  Created by STS-Manoj on 8/18/15.
//  Copyright (c) 2015 SPAN Technology Services. All rights reserved.
//

#import "CSS_Class.h"
#import "config.h"
#import "BackgroundLayer.h"
#import "Colors.h"

@implementation CSS_Class
{
    
}

#pragma mark - Labels - methods

+ (void)App_Header:(UILabel *)label
{
    label.backgroundColor = [UIColor clearColor];
    label.textColor = RGB(255, 255, 255);
    [label setFont:[UIFont fontWithName:@"ClanPro-NarrNews" size:30]];
}
+ (void)App_subHeader:(UILabel *)label
{
    label.backgroundColor = [UIColor clearColor];
    label.textColor = TEXTCOLOR;
    [label setFont:[UIFont fontWithName:@"ClanPro-Book" size:22]];
}
+ (void)APP_labelName:(UILabel *)label
{
    label.backgroundColor = [UIColor clearColor];
    label.textColor = TEXTCOLOR;
    [label setFont:[UIFont fontWithName:@"ClanPro-Book" size:16]];
}

+ (void)APP_SocialLabelName:(UILabel *)label
{
    label.backgroundColor = [UIColor clearColor];
    label.textColor = BLUECOLOR_TEXT;
    [label setFont:[UIFont fontWithName:@"ClanPro-Book" size:16]];
}

+ (void)APP_labelName_Small:(UILabel *)label
{
    label.backgroundColor = [UIColor clearColor];
    label.textColor = TEXTCOLOR;
    [label setFont:[UIFont fontWithName:@"ClanPro-Book" size:12]];
}

+ (void)APP_fieldValue:(UILabel *)label
{
    label.backgroundColor = [UIColor clearColor];
    label.textColor = TEXTCOLOR;
    [label setFont:[UIFont fontWithName:@"ClanPro-Book" size:16]];
}
+ (void)APP_fieldValue_Small:(UILabel *)label
{
    label.backgroundColor = [UIColor clearColor];
    label.textColor = TEXTCOLOR;
    [label setFont:[UIFont fontWithName:@"ClanPro-Book" size:12]];
}

+ (void)APP_SmallText:(UILabel *)label
{
    label.backgroundColor = [UIColor clearColor];
    label.textColor = TEXTCOLOR_LIGHT;
    [label setFont:[UIFont fontWithName:@"ClanPro-Book" size:10]];
}

#pragma mark - Buttons - methods

+ (void)APP_Blackbutton:(UIButton *)button
{
    button.titleLabel.font = [UIFont fontWithName:@"GothamRounded-Medium" size:16];
    button.frame = CGRectMake(button.frame.origin.x, button.frame.origin.y, button.frame.size.width, 40);
    button.layer.cornerRadius = 5.0f;
    
    [button setTitleColor:RGB(255,255,255) forState:UIControlStateNormal];
    [button setTitleColor:RGB(255,255,255) forState:UIControlStateSelected];
    [button.titleLabel.text uppercaseString];
    button.clipsToBounds = NO;
    button.backgroundColor = BLACKCOLOR;
}

+ (void)APP_Orangebutton:(UIButton *)button
{
    button.titleLabel.font = [UIFont fontWithName:@"GothamRounded-Medium" size:16];
    button.frame = CGRectMake(button.frame.origin.x, button.frame.origin.y, button.frame.size.width, 40);
    button.layer.cornerRadius = button.frame.size.height/2;
    
    [button setTitleColor:RGB(255,255,255) forState:UIControlStateNormal];
    [button setTitleColor:RGB(255,255,255) forState:UIControlStateSelected];
    [button.titleLabel.text uppercaseString];
    button.clipsToBounds = NO;
    button.backgroundColor = ORANGECOLOR;
    
    [button.layer setShadowColor:[UIColor blackColor].CGColor];
    [button.layer setShadowOpacity:0.3];
    [button.layer setShadowRadius:2.0];
    [button.layer setShadowOffset:CGSizeMake(2.0, 2.0)];
}



+ (void)APP_Yellowbutton:(UIButton *)button
{
    button.titleLabel.font = [UIFont fontWithName:@"GothamRounded-Medium" size:16];
    button.frame = CGRectMake(button.frame.origin.x, button.frame.origin.y, button.frame.size.width, 40);
    button.layer.cornerRadius = button.frame.size.height/2;
    
    [button setTitleColor:RGB(255,255,255) forState:UIControlStateNormal];
    [button setTitleColor:RGB(255,255,255) forState:UIControlStateSelected];
    [button.titleLabel.text uppercaseString];
    button.clipsToBounds = NO;
    button.backgroundColor = YELLOWCOLOR;
    
    [button.layer setShadowColor:[UIColor blackColor].CGColor];
    [button.layer setShadowOpacity:0.3];
    [button.layer setShadowRadius:2.0];
    [button.layer setShadowOffset:CGSizeMake(2.0, 2.0)];
}

+ (void)APP_Clearbutton:(UIButton *)button
{
    //button.titleLabel.font = [UIFont fontWithName:@"ClanPro-NarrMedium" size:12];
    
    [button setTitleColor:ORANGECOLOR forState:UIControlStateNormal];
    [button setTitleColor:ORANGECOLOR forState:UIControlStateSelected];
    [button.titleLabel.text uppercaseString];
    
    button.backgroundColor = [UIColor clearColor];
    
}


#pragma mark - TextField - methods


+ (void)APP_textfield_Infocus:(UITextField *)textField PaddingIcon:(NSString*)icon
{
    textField.frame = CGRectMake(textField.frame.origin.x, textField.frame.origin.y, textField.frame.size.width, 40);
    
    textField.leftViewMode = UITextFieldViewModeAlways;
    
    textField.layer.cornerRadius = textField.frame.size.height/2;
    
    textField.layer.borderColor = [[UIColor darkGrayColor]CGColor];
    textField.layer.borderWidth = 1.0;
    
    CGRect textRect = textField.rightView.bounds;
    textRect.origin.x -= 10;
    [textField.rightView setBounds:textRect];
    
    UIView *vwContainer = [[UIView alloc] init];
    [vwContainer setFrame:CGRectMake(10.0f, 0.0f, 60.0f, 45.0f)];
    [vwContainer setBackgroundColor:[UIColor clearColor]];
    
    UIImageView *iconImage = [[UIImageView alloc] init];
    [iconImage setImage:[UIImage imageNamed:icon]];
    [iconImage setFrame:CGRectMake(10.f, 0.0f, 45.0f, 45.0f)];
    [iconImage setBackgroundColor:[UIColor clearColor]];
    
    [vwContainer addSubview:iconImage];
    
    [textField setLeftView:vwContainer];
    //textField.leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:icon]];
    
    textField.font=[UIFont fontWithName:@"GothamRounded-Book" size:16];
    
    textField.textColor = TEXTCOLOR_LIGHT;
    textField.backgroundColor = [UIColor clearColor];
    
//    CALayer *bottomBorder = [CALayer layer];
//    bottomBorder.frame = CGRectMake(0.0f, textField.frame.size.height - 1, textField.frame.size.width, 1.0f);
//    bottomBorder.backgroundColor = BLACKCOLOR.CGColor;
//    [textField.layer addSublayer:bottomBorder];
}


+ (void)APP_textfield_Outfocus:(UITextField *)textField
{
    textField.leftViewMode = UITextFieldViewModeAlways;
    
    textField.font=[UIFont fontWithName:@"GothamRounded-Book" size:16];
    
    textField.textColor = TEXTCOLOR_LIGHT;
    textField.backgroundColor = [UIColor clearColor];
    
    CALayer *bottomBorder = [CALayer layer];
    bottomBorder.frame = CGRectMake(0.0f, textField.frame.size.height - 1, textField.frame.size.width, 1.0f);
    bottomBorder.backgroundColor = RGB(200, 200, 200).CGColor;
    [textField.layer addSublayer:bottomBorder];
}


+ (void)APP_textView_Outfocus:(UITextView *)textView
{
    textView.textColor = TEXTCOLOR_LIGHT;
    textView.font=[UIFont fontWithName:@"GothamRounded-Book" size:16];
    textView.backgroundColor = [UIColor whiteColor];
    textView.layer.cornerRadius = 2.5;
    
    textView.layer.borderWidth = 1.0f;
    textView.layer.borderColor = BLACKCOLOR.CGColor;
}


+ (void)APP_textView_Infocus:(UITextView *)textView
{
    textView.textColor = TEXTCOLOR_LIGHT;
    
    textView.font=[UIFont fontWithName:@"GothamRounded-Book" size:16];
    
    textView.backgroundColor = [UIColor whiteColor];
    textView.layer.cornerRadius = 2.5;
    
    textView.layer.borderWidth = 1.0f;
    textView.layer.borderColor = TEXTCOLOR_LIGHT.CGColor;
}


@end
