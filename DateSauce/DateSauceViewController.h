//
//  DateSauceViewController.h
//  DateSauce
//
//  Created by veena on 5/30/17.
//  Copyright © 2017 appoets. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "ZLSwipeableView.h"

@interface DateSauceViewController : UIViewController<ZLSwipeableViewDataSource, ZLSwipeableViewDelegate,CLLocationManagerDelegate>{
    CLLocation *myLocation;
    NSMutableArray *usersFound;
    NSString *animationStr;
}
@property (nonatomic, strong) ZLSwipeableView *swipeableView;

- (UIView *)nextViewForSwipeableView:(ZLSwipeableView *)swipeableView;
@property (weak, nonatomic) IBOutlet UIView *buttonView;

@property(nonatomic,retain) CLLocationManager *locationManager;
@property (weak, nonatomic) IBOutlet UILabel *nameAgeLabel;
@property (weak, nonatomic) IBOutlet UILabel *workLabel;
@property (weak, nonatomic) IBOutlet UILabel *schoolLabel;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;

@property (strong, nonatomic) IBOutlet UIButton *rewindBtn;
@property (weak, nonatomic) IBOutlet UIButton *unlikeBtn;
@property (weak, nonatomic) IBOutlet UIButton *likeBtn;
@property (weak, nonatomic) IBOutlet UIButton *superLikeBtn;
@property (strong, nonatomic) IBOutlet UIView *matchedView;
@property (weak, nonatomic) IBOutlet UIButton *sendMsgBtn;
@property (weak, nonatomic) IBOutlet UIButton *swipingBtn;
@property (weak, nonatomic) IBOutlet UILabel *matchedNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@property (weak, nonatomic) IBOutlet UIImageView *matchedUserImageView;
@property (strong, nonatomic) IBOutlet UIView *matched_shortscreenView;
@property (weak, nonatomic) IBOutlet UIImageView *userImageViewSecond;
@property (weak, nonatomic) IBOutlet UIImageView *matchedUserImageViewSecond;
@property (weak, nonatomic) IBOutlet UIButton *sendMsgBtnSecond;
@property (weak, nonatomic) IBOutlet UIButton *swipingBtnSecond;
@property (weak, nonatomic) IBOutlet UILabel *matchedNameLabelSecond;

@property NSString *isFrom;
- (IBAction)unlikeBtnAction:(id)sender;
- (IBAction)rewindBtnAction:(id)sender;
- (IBAction)likeBtnAction:(id)sender;
- (IBAction)superLikeBtnAction:(id)sender;
- (IBAction)sendMsgBtnAction:(id)sender;
- (IBAction)keepSwipingBtnAction:(id)sender;

@end
