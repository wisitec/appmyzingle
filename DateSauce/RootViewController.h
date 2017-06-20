//
//  RootViewController.h
//  DateSauce
//
//  Created by veena on 5/30/17.
//  Copyright © 2017 appoets. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RootViewController : UIViewController{
    int pageIndex;
    NSMutableArray *images;
}
@property (weak, nonatomic) IBOutlet UIButton *signInBtn;
- (IBAction)signInBtnAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *signUpBtn;
- (IBAction)signUpBtnAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *termsOfServiceBtn;
- (IBAction)termsOfServiceBtnAction:(id)sender;

@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property (nonatomic, retain) IBOutlet UIPageControl *pageControl;
@property (nonatomic, readwrite) BOOL pageControlUsed;
//@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (nonatomic, retain) UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *bysigningInLbl;

- (IBAction)changePage:(id)sender;

@end
