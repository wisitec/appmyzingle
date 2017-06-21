//
//  DateSauceViewController.m
//  DateSauce
//
//  Created by veena on 5/30/17.
//  Copyright © 2017 appoets. All rights reserved.
//

#import "DateSauceViewController.h"
#import "RootViewController.h"
#import "PulsingHalo.h"
#import "ChatView.h"
#import <PulsingHalo/PulsingHaloLayer.h>
#import "UIView+InnerShadow.h"
#import "Utilities.h"
#import "CommenMethods.h"
#import "AppDelegate.h"
#import "AFNHelper.h"
#import "Constants.h"
#import "CSS_Class.h"
#import "ProfileViewController.h"
@interface DateSauceViewController (){
    
    
    AppDelegate *appDelegate;
    NSInteger matchedUserId;
    NSTimer *timerMatchCheck;
    BOOL launched;
}
@property (assign, nonatomic) NSInteger count,startIndex,slideCount;
@property (retain, nonatomic) UIImageView *profileImgView;
@property (retain, nonatomic) PulsingHaloLayer *halo;
@end

@implementation DateSauceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    appDelegate =(AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    [CSS_Class APP_Orangebutton:_sendMsgBtn];
    [CSS_Class APP_Orangebutton:_swipingBtn];
    [CSS_Class APP_Orangebutton:_sendMsgBtnSecond];
    [CSS_Class APP_Orangebutton:_swipingBtnSecond];
    
    [_buttonView setHidden:YES];
    
    _startIndex = 0;
    _slideCount = 0;
    
    ZLSwipeableView *swipeableView = [[ZLSwipeableView alloc] initWithFrame:CGRectMake(10, 0, self.view.frame.size.width - 20, self.view.frame.size.height - 150)];
    self.swipeableView.frame = swipeableView.frame;
    self.swipeableView = swipeableView;
    [self.view addSubview:self.swipeableView];
    
    // Required Data Source
    self.swipeableView.dataSource = self;
    
    // Optional Delegate
    self.swipeableView.delegate = self;
    
    _userImageView.layer.cornerRadius = _userImageView.frame.size.height/2;
    _userImageView.clipsToBounds = YES;
    _userImageView.layer.borderWidth = 3.0;
    _userImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    
    _userImageViewSecond.layer.cornerRadius = _userImageView.frame.size.height/2;
    _userImageViewSecond.clipsToBounds = YES;
    _userImageViewSecond.layer.borderWidth = 3.0;
    _userImageViewSecond.layer.borderColor = [UIColor whiteColor].CGColor;

    _matchedUserImageView.layer.cornerRadius = _matchedUserImageView.frame.size.height/2;
    _matchedUserImageView.clipsToBounds = YES;
    _matchedUserImageView.layer.borderWidth = 3.0;
    _matchedUserImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    
    _matchedUserImageViewSecond.layer.cornerRadius = _matchedUserImageView.frame.size.height/2;
    _matchedUserImageViewSecond.clipsToBounds = YES;
    _matchedUserImageViewSecond.layer.borderWidth = 3.0;
    _matchedUserImageViewSecond.layer.borderColor = [UIColor whiteColor].CGColor;

}

-(void)viewWillAppear:(BOOL)animated{
  
    if([[CommenMethods getUserDefaultsKey:@"unmatched"] isEqualToString: @"1"]){
        
        [CommenMethods setUserDefaultsObject:@"0" key:@"unmatched"];
        [self stopAnimating];
    }

    if(!launched){
        launched = YES;
        
    [self startAnimating];
        
    timerMatchCheck= [NSTimer scheduledTimerWithTimeInterval:5.0
                                                      target:self
                                                    selector:@selector(getUsers)
                                                    userInfo:nil
                                                     repeats:YES];
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    
    [timerMatchCheck invalidate];
    timerMatchCheck = nil;

    if(self.count == 0){
        launched = NO;

    }
    else {
        launched = YES;

    }
}

- (void)viewDidLayoutSubviews {
    [self.swipeableView loadViewsIfNeeded];
}

#pragma mark - ZLSwipeableViewDelegate

- (void)swipeableView:(ZLSwipeableView *)swipeableView
         didSwipeView:(UIView *)view
          inDirection:(ZLSwipeableViewDirection)direction {
    NSLog(@"did swipe in direction: %zd", direction);
    
    UIButton *btnNope=(UIButton *)[self.view viewWithTag:3000+_slideCount];
    UIButton *btnLike=(UIButton *)[self.view viewWithTag:1000+_slideCount];
    UIButton *btnSupeLike=(UIButton *)[self.view viewWithTag:2000+_slideCount];
    // UIButton *btnNope=(UIButton *)[self.view viewWithTag:3000+nSlideCount];
    
    NSDictionary *userDict = [usersFound objectAtIndex:_slideCount];
    NSString *user_id = [userDict valueForKey:@"user_id"];
    
    NSString *strDir=[NSString stringWithFormat:@"%zd",direction];
    
    NSString *strLikeStatus;
    
    
    if ([strDir isEqualToString:@"1"])
    {
        strLikeStatus=@"2";
    }
    else if ([strDir isEqualToString:@"2"])
    {
        strLikeStatus=@"1";
    }
    else if ([strDir isEqualToString:@"4"])
    {
        strLikeStatus=@"3";
    }
    
  if([appDelegate internetConnected])
    {
        NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
        NSString *identi=[user valueForKey:@"id"];
        NSString *token=[user valueForKey:@"token"];
        
        NSDictionary * params=@{@"id":identi,@"token":token,@"suggestion_id":user_id,@"status":strLikeStatus};
        
//        [btnNope setHidden:YES];
//        [btnLike setHidden:YES];
//        [btnSupeLike setHidden:YES];
        
        AFNHelper *afn=[[AFNHelper alloc]initWithRequestMethod:POST_METHOD];
        [afn getDataFromPath:MD_LIKE withParamData:params withBlock:^(id response, NSDictionary *Error,NSString *strCode) {
            
            if([[response valueForKey:@"success"]boolValue] == 1)
            {
                [btnNope setHidden:YES];
                [btnLike setHidden:YES];
                [btnSupeLike setHidden:YES];
                _slideCount++;
                
                if(_slideCount == _count){
                    
                    [self.swipeableView removeFromSuperview];
                    
                    [self.view setBackgroundColor:[UIColor whiteColor]];
                    
                    [_buttonView setHidden:YES];
                    
                    [self startAnimating];
                    
                    timerMatchCheck= [NSTimer scheduledTimerWithTimeInterval:5.0
                                                                      target:self
                                                                    selector:@selector(getUsers)
                                                                    userInfo:nil
                                                                     repeats:YES];
                    
                    UIImage *imgCL=[UIImage imageNamed:@"CloseDisa.png"];
                    [_unlikeBtn setBackgroundImage:imgCL forState:UIControlStateNormal];
                    
                    UIImage *imgLV=[UIImage imageNamed:@"HeartDisa.png"];
                    [_likeBtn setBackgroundImage:imgLV forState:UIControlStateNormal];
                    
                    UIImage *imgST=[UIImage imageNamed:@"StarDisa.png"];
                    [_superLikeBtn setBackgroundImage:imgST forState:UIControlStateNormal];
                    
                    UIImage *imgRE=[UIImage imageNamed:@"RefreshDisa.png"];
                    [_rewindBtn setBackgroundImage:imgRE forState:UIControlStateNormal];
                    
                }

                if([[[response objectForKey:@"like"]valueForKey:@"match"]boolValue] == 1){
                 
                    NSLog(@"Matched");
                    
                    
                    NSString *ImageURL = [userDict valueForKey:@"picture"];
                    
                    [CommenMethods setUserDefaultsObject:[Utilities removeNullFromString:[userDict valueForKey:@"name"]] key:@"matchedUserName"];
                    [CommenMethods setUserDefaultsObject:ImageURL key:@"matchedUserImageUrl"];
                    [CommenMethods setUserDefaultsObject:[userDict valueForKey:@"user_id"] key:@"matched_id"];
                    
                    _matchedNameLabel.text = [NSString stringWithFormat:@"%@ and %@ have liked each other",[CommenMethods getUserDefaultsKey:@"name"],[CommenMethods getUserDefaultsKey:@"matchedUserName"]];
                    
                     _matchedNameLabelSecond.text = [NSString stringWithFormat:@"%@ and %@ have liked each other",[CommenMethods getUserDefaultsKey:@"name"],[CommenMethods getUserDefaultsKey:@"matchedUserName"]];
                    
                    [UIView animateWithDuration:0.45 animations:^{
                        
                        if(IS_IPHONE_5){
                            [self.view addSubview:_matched_shortscreenView];
                            _matched_shortscreenView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
                        }else {
                            [self.view addSubview:_matchedView];
                            _matchedView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
                        }
                    }];
                    
                    NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
                    NSString *profilePic= [Utilities removeNullFromString:[user valueForKey:@"picture"]];
                    if([profilePic  isEqualToString: @""]){
                        NSString *profilePic= [Utilities removeNullFromString:[user valueForKey:@"image"]];
                        if([profilePic  isEqualToString: @""]){
                            _userImageView.image = [UIImage imageNamed:@"PersonMsg"];
                            _userImageViewSecond.image = [UIImage imageNamed:@"PersonMsg"];
                        }
                        else {
                            NSURL *picURL = [NSURL URLWithString:profilePic];
                            NSData *data = [NSData dataWithContentsOfURL:picURL];
                            UIImage *image = [UIImage imageWithData:data];
                            [_userImageView setImage:image];
                            [_userImageViewSecond setImage:image];
                        }
                    }
                    else {
                        NSURL *picURL = [NSURL URLWithString:profilePic];
                        NSData *data = [NSData dataWithContentsOfURL:picURL];
                        UIImage *image = [UIImage imageWithData:data];
                        [_userImageView setImage:image];
                        [_userImageViewSecond setImage:image];
                    }
                    
                    NSString *matchedprofilePic= [Utilities removeNullFromString:[user valueForKey:@"matchedUserImageUrl"]];
                    if([matchedprofilePic  isEqualToString: @""]){
                        _matchedUserImageView.image = [UIImage imageNamed:@"PersonMsg"];
                        _matchedUserImageViewSecond.image = [UIImage imageNamed:@"PersonMsg"];
                    }
                    else {
                        NSURL *picURL = [NSURL URLWithString:matchedprofilePic];
                        NSData *data = [NSData dataWithContentsOfURL:picURL];
                        UIImage *image = [UIImage imageWithData:data];
                        [_matchedUserImageView setImage:image];
                        [_matchedUserImageViewSecond setImage:image];
                    }
                    

                }
                
            }
            else
            {
                NSString *strErrCode=[NSString stringWithFormat:@"%@",[response valueForKey:@"error_code"]];
                
                if ([strErrCode isEqualToString:@"104"])
                {
                    NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
                    [user removeObjectForKey:@"isLoggedin"];

                    RootViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"RootViewController"];
                    [self.navigationController pushViewController:controller animated:YES];
                    
                }
                
                if ([strCode intValue]==1)
                {
                    [btnNope setHidden:YES];
                    [btnLike setHidden:YES];
                    [btnSupeLike setHidden:YES];
                    [CommenMethods alertviewController_title:@"" MessageAlert:NSLocalizedString(@"ERRORMSG", nil) viewController:self okPop:NO];
                }
                else
                {
                    if ([Error objectForKey:@"email"]) {
                        [btnNope setHidden:YES];
                        [btnLike setHidden:YES];
                        [btnSupeLike setHidden:YES];
                        [CommenMethods alertviewController_title:@"" MessageAlert:[[Error objectForKey:@"email"] objectAtIndex:0]  viewController:self okPop:NO];
                    }
                    else if ([Error objectForKey:@"password"]) {
                        [btnNope setHidden:YES];
                        [btnLike setHidden:YES];
                        [btnSupeLike setHidden:YES];
                        [CommenMethods alertviewController_title:@"" MessageAlert:[[Error objectForKey:@"password"] objectAtIndex:0]  viewController:self okPop:NO];
                    }
                }
                
            }
        }];
    }
    else
    {
        [btnNope setHidden:YES];
        [btnLike setHidden:YES];
        [btnSupeLike setHidden:YES];
        [CommenMethods alertviewController_title:@"" MessageAlert:NSLocalizedString(@"Please Check Your Internet Connection", nil) viewController:self okPop:NO];
    }
    
}

- (void)swipeableView:(ZLSwipeableView *)swipeableView didCancelSwipe:(UIView *)view {
    NSLog(@"did cancel swipe");
    
    UIButton *btnLike=(UIButton *)[self.view viewWithTag:1000+_slideCount];
    UIButton *btnSupeLike=(UIButton *)[self.view viewWithTag:2000+_slideCount];
    UIButton *btnNope=(UIButton *)[self.view viewWithTag:3000+_slideCount];
    
    [btnNope setHidden:YES];
    [btnLike setHidden:YES];
    [btnSupeLike setHidden:YES];
}

- (void)swipeableView:(ZLSwipeableView *)swipeableView
  didStartSwipingView:(UIView *)view
           atLocation:(CGPoint)location {
    NSLog(@"did start swiping at location: x %f, y %f", location.x, location.y);
}

- (void)swipeableView:(ZLSwipeableView *)swipeableView
          swipingView:(UIView *)view
           atLocation:(CGPoint)location
          translation:(CGPoint)translation {
    
    UIButton *btnLike=(UIButton *)[self.view viewWithTag:1000+_slideCount];
    UIButton *btnSupeLike=(UIButton *)[self.view viewWithTag:2000+_slideCount];
    UIButton *btnNope=(UIButton *)[self.view viewWithTag:3000+_slideCount];
    
    //  strUserId=[btnNope titleForState:UIControlStateNormal];
    
    [btnNope setHidden:YES];
    [btnLike setHidden:YES];
    [btnSupeLike setHidden:YES];
    
    
    int nXTrans=translation.x;
    int nYTrans=translation.y;
    
    if (nXTrans<0)
    {
        nXTrans=-(nXTrans);
    }
    if (nYTrans<0)
    {
        nYTrans=-(nYTrans);
    }
    
    // NSLog(@"Trans Y: %d",nYTrans);
    
    
    
    if (nXTrans > nYTrans)
    {
        
        if (translation.x < 0)
        {
            
            
            NSLog(@"Swipe Left");
            
            [btnNope setHidden:NO];
            [btnLike setHidden:YES];
            [btnSupeLike setHidden:YES];
            
            
        }
        else if (translation.x > 0)
        {
            NSLog(@"Swipe Right");
            [btnNope setHidden:YES];
            [btnLike setHidden:NO];
            [btnSupeLike setHidden:YES];
            
        }
    }
    else
    {
        if (translation.y < 0)
        {
            NSLog(@"Swipe Top");
            [btnNope setHidden:YES];
            [btnLike setHidden:YES];
            [btnSupeLike setHidden:NO];
        }
    }

}

- (void)swipeableView:(ZLSwipeableView *)swipeableView
    didEndSwipingView:(UIView *)view
           atLocation:(CGPoint)location {
    NSLog(@"did end swiping at location: x %f, y %f", location.x, location.y);
}

#pragma mark - ZLSwipeableViewDataSource

//- (UIView *)previousViewForSwipeableView:(ZLSwipeableView *)swipeableView {
//    UIView *view = [self nextViewForSwipeableView:swipeableView];
//    [self applyRandomTransform:view];
//    return view;
//}
//
//- (void)applyRandomTransform:(UIView *)view {
//    CGFloat width = self.swipeableView.bounds.size.width;
//    CGFloat height = self.swipeableView.bounds.size.height;
//    CGFloat distance = MAX(width, height);
//    
//    CGAffineTransform transform = CGAffineTransformMakeRotation([self randomRadian]);
//    transform = CGAffineTransformTranslate(transform, distance, 0);
//    transform = CGAffineTransformRotate(transform, [self randomRadian]);
//    view.transform = transform;
//}
//
//- (CGFloat)randomRadian {
//    return (random() % 360) * (M_PI / 180.0);
//}

- (UIView *)nextViewForSwipeableView:(ZLSwipeableView *)swipeableView {
    
    if(_startIndex<_count){
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(10, 0, self.view.frame.size.width - 20, self.view.frame.size.height -150)];
        
        // Shadow
        view.layer.shadowColor = [UIColor blackColor].CGColor;
        view.layer.shadowOpacity = 0.33;
        view.layer.shadowOffset = CGSizeMake(0, 1.5);
        view.layer.shadowRadius = 4.0;
        view.layer.shouldRasterize = YES;
        view.layer.rasterizationScale = [UIScreen mainScreen].scale;
        
        // Corner Radius
        view.layer.cornerRadius = 10.0;
        view.clipsToBounds = YES;
        
        [view setBackgroundColor:[UIColor whiteColor]];
        
        view.tag = 5000+_startIndex;
        
        UIImageView *profileImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, view.frame.size.width, view.frame.size.height)];
        
        [profileImg addInnerShadowWithRadius:150.0f
                              andColor:[UIColor colorWithWhite:0 alpha:0.75f]
                           inDirection:NLInnerShadowDirectionBottom];

        
        NSDictionary *userDict = [usersFound objectAtIndex:_startIndex];
        NSString *ImageURL = [userDict valueForKey:@"picture"];
        NSString *name = [NSString stringWithFormat:@"%@,%@",[userDict valueForKey:@"name"],[userDict valueForKey:@"age"]];
        NSString *company = [Utilities removeNullFromString:[userDict valueForKey:@"work"]];
        NSString *distance = [Utilities removeNullFromString:[NSString stringWithFormat:@"%@km away",[userDict valueForKey:@"distance"]]];
        
        if([ImageURL  isEqual: @""]){
            
            profileImg.image = [UIImage imageNamed:@"PersonMsg"];
        }
        else {
        NSURL *picURL = [NSURL URLWithString:ImageURL];
        NSData *data = [NSData dataWithContentsOfURL:picURL];
        UIImage *image = [UIImage imageWithData:data];
        profileImg.image =  image;
        }
        
        UILabel *nameAgeLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, view.frame.size.height - 100,200,30)];
        nameAgeLabel.textColor = [UIColor whiteColor];
        nameAgeLabel.font = [UIFont fontWithName:@"GothamRounded-Medium" size:18];
        nameAgeLabel.tag = 200+_startIndex;
        nameAgeLabel.backgroundColor = [UIColor clearColor];
        nameAgeLabel.text = name;
        
        UILabel *companyLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, view.frame.size.height - 70,200,20)];
        companyLabel.textColor = [UIColor whiteColor];
        companyLabel.font = [UIFont fontWithName:@"GothamRounded-Medium" size:13];
        companyLabel.backgroundColor = [UIColor clearColor];
        companyLabel.text = company;
        
        UILabel *distanceLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, view.frame.size.height - 50,200,20)];
        distanceLabel.textColor = [UIColor whiteColor];
        distanceLabel.font = [UIFont fontWithName:@"GothamRounded-Medium" size:13];
        distanceLabel.backgroundColor = [UIColor clearColor];
        distanceLabel.text = distance;
        
        UIButton *btnLIKE=[UIButton buttonWithType:UIButtonTypeCustom];
        btnLIKE.frame=CGRectMake(10, 20, 200, 100);
        UIImage *imgCL=[UIImage imageNamed:@"Like.png"];
        [btnLIKE setImage:imgCL forState:UIControlStateNormal];
        btnLIKE.userInteractionEnabled=NO;
        btnLIKE.hidden=YES;
        btnLIKE.tag=1000+_startIndex;
        
        UIButton *btnSUPLIKE=[UIButton buttonWithType:UIButtonTypeCustom];
        btnSUPLIKE.frame=CGRectMake((view.frame.size.width/2)-100, view.frame.size.height-230, 280, 140);
        UIImage *imgLV=[UIImage imageNamed:@"SuperLike.png"];
        [btnSUPLIKE setImage:imgLV forState:UIControlStateNormal];
        btnSUPLIKE.userInteractionEnabled=NO;
        btnSUPLIKE.hidden=YES;
        btnSUPLIKE.tag=2000+_startIndex;
        
        UIButton *btnNOPE=[UIButton buttonWithType:UIButtonTypeCustom];
        btnNOPE.frame=CGRectMake(view.frame.size.width-210, 20, 200, 100);
        UIImage *imgST=[UIImage imageNamed:@"Nope.png"];
        [btnNOPE setImage:imgST forState:UIControlStateNormal];
        btnNOPE.userInteractionEnabled=NO;
        btnNOPE.hidden=YES;
        btnNOPE.tag=3000+_startIndex;
        [btnNOPE setTitle:[NSString stringWithFormat:@"%@",[userDict valueForKey:@"user_id"]]  forState:UIControlStateNormal];
        [btnNOPE setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
                
        [view addSubview:profileImg];
        [view addSubview:nameAgeLabel];
        [view addSubview:companyLabel];
        [view addSubview:distanceLabel];
        [view addSubview:btnLIKE];
        [view addSubview:btnSUPLIKE];
        [view addSubview:btnNOPE];
        
        _startIndex++;
        
    
    return view;
    }
    else {
        return nil;
    }
}

-(void)startAnimating {
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    
    _halo = [PulsingHaloLayer layer];
    //_halo.position = self.view.center;
    _halo.position = CGPointMake(screenWidth/2, screenHeight/2);
    _halo.haloLayerNumber = 4;
    if(IS_IPHONE_5){
    _halo.radius = 150.0;
    }
    else {
    _halo.radius = 200.0;
    }
    _halo.backgroundColor = [UIColor redColor].CGColor;
    
    [self.view.layer addSublayer:_halo];
    [_halo start];
    
    _profileImgView = [[UIImageView alloc]initWithFrame:CGRectMake((screenWidth-100)/2, (screenHeight-100)/2, 100, 100)];
    
    NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
    NSString *profilePic= [Utilities removeNullFromString:[user valueForKey:@"picture"]];
    if([profilePic  isEqualToString: @""]){
        NSString *profilePic= [Utilities removeNullFromString:[user valueForKey:@"image"]];
        if([profilePic  isEqualToString: @""]){
        _profileImgView.image = [UIImage imageNamed:@"PersonMsg"];
        }
        else {
            NSURL *picURL = [NSURL URLWithString:profilePic];
            NSData *data = [NSData dataWithContentsOfURL:picURL];
            UIImage *image = [UIImage imageWithData:data];
            [_profileImgView setImage:image];
        }
    }
    else {
        NSURL *picURL = [NSURL URLWithString:profilePic];
        NSData *data = [NSData dataWithContentsOfURL:picURL];
        UIImage *image = [UIImage imageWithData:data];
        [_profileImgView setImage:image];
    }
    //_profileImgView.center = self.view.center;
    _profileImgView.center = CGPointMake(screenWidth/2, screenHeight/2);
    _profileImgView.layer.cornerRadius = _profileImgView.frame.size.height/2;
    _profileImgView.clipsToBounds = YES;
    _profileImgView.layer.borderWidth = 4.0;
    _profileImgView.layer.borderColor = [UIColor whiteColor].CGColor;
   // _profileImgView.layer.borderColor = [UIColor colorWithRed:235/255.0 green:68/255.0 blue:97/255.0 alpha:1.0].CGColor;
    
    [self.view addSubview:_profileImgView];
    
    NSLog(@"My view frame: %@",NSStringFromCGRect(self.view.frame));
    
}

-(void)stopAnimating {
    
    [_halo removeFromSuperlayer];
    [_profileImgView removeFromSuperview];
}

-(void)getUsers {
    
    if([appDelegate internetConnected])
    {
        NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
        NSString *identi=[user valueForKey:@"id"];
        NSString *token=[user valueForKey:@"token"];
        
        NSString* latitude;
        NSString* longitude;
        
        latitude = [Utilities removeNullFromString:[NSString stringWithFormat:@"%@",[user valueForKey:@"selectedLat"]]];
        
        if([latitude  isEqual: @""]){
            latitude = [NSString stringWithFormat:@"%f",myLocation.coordinate.latitude];
            longitude = [NSString stringWithFormat:@"%f",myLocation.coordinate.longitude];
        }
        else{
            latitude = [NSString stringWithFormat:@"%@",[user valueForKey:@"selectedLat"]];
            longitude = [NSString stringWithFormat:@"%@",[user valueForKey:@"selectedLong"]];
        }

        
        NSDictionary * params=@{@"id":identi,@"token":token,@"latitude":latitude,@"longitude":longitude};
        
        AFNHelper *afn=[[AFNHelper alloc]initWithRequestMethod:POST_METHOD];
        [afn getDataFromPath:MD_SEARCH withParamData:params withBlock:^(id response, NSDictionary *Error,NSString *strCode) {
            
            if([[response valueForKey:@"success"]boolValue] == 1)
            {
                self.count = [[response objectForKey:@"user_count"]integerValue];
                if(self.count == 0)
                {
                    //[self startAnimating];
                    [_buttonView setHidden:YES];
                    
                    UIImage *imgCL=[UIImage imageNamed:@"CloseDisa.png"];
                    [_unlikeBtn setBackgroundImage:imgCL forState:UIControlStateNormal];
                    
                    UIImage *imgLV=[UIImage imageNamed:@"HeartDisa.png"];
                    [_likeBtn setBackgroundImage:imgLV forState:UIControlStateNormal];
                    
                    UIImage *imgST=[UIImage imageNamed:@"StarDisa.png"];
                    [_superLikeBtn setBackgroundImage:imgST forState:UIControlStateNormal];
                    
                    UIImage *imgRE=[UIImage imageNamed:@"RefreshDisa.png"];
                    [_rewindBtn setBackgroundImage:imgRE forState:UIControlStateNormal];
                }
                else {
                    
                    [timerMatchCheck invalidate];
                    timerMatchCheck = nil;
                    
                    [self stopAnimating];
                    
                    [self.view setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
                    
                    usersFound = [response objectForKey:@"user_data"];
                    
                    [_buttonView setHidden:NO];
                    
                    UIImage *imgCL=[UIImage imageNamed:@"Close.png"];
                    [_unlikeBtn setBackgroundImage:imgCL forState:UIControlStateNormal];
                    
                    UIImage *imgLV=[UIImage imageNamed:@"Heart.png"];
                    [_likeBtn setBackgroundImage:imgLV forState:UIControlStateNormal];
                    
                    UIImage *imgST=[UIImage imageNamed:@"Star.png"];
                    [_superLikeBtn setBackgroundImage:imgST forState:UIControlStateNormal];
                    
                    UIImage *imgRE=[UIImage imageNamed:@"Refresh.png"];
                    [_rewindBtn setBackgroundImage:imgRE forState:UIControlStateNormal];

                }
                
            }
            else
            {
                NSString *strErrCode=[NSString stringWithFormat:@"%@",[response valueForKey:@"error_code"]];
                
                if ([strErrCode isEqualToString:@"104"])
                {
                    
                    NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
                    [user removeObjectForKey:@"isLoggedin"];
                    
                    RootViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"RootViewController"];
                    [self.navigationController pushViewController:controller animated:YES];
                    
                }

                
                if ([strCode intValue]==1)
                {
                    [CommenMethods alertviewController_title:@"" MessageAlert:NSLocalizedString(@"ERRORMSG", nil) viewController:self okPop:NO];
                }
                else
                {
                    if ([Error objectForKey:@"email"]) {
                        [CommenMethods alertviewController_title:@"" MessageAlert:[[Error objectForKey:@"email"] objectAtIndex:0]  viewController:self okPop:NO];
                    }
                    else if ([Error objectForKey:@"password"]) {
                        [CommenMethods alertviewController_title:@"" MessageAlert:[[Error objectForKey:@"password"] objectAtIndex:0]  viewController:self okPop:NO];
                    }
                }
                
            }
        }];
    }
    else
    {
        [CommenMethods alertviewController_title:@"" MessageAlert:NSLocalizedString(@"Please Check Your Internet Connection", nil) viewController:self okPop:NO];
    }
}

#pragma mark - Get Current Location

-(void)onLocationUpdateStart
{
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.distanceFilter = kCLDistanceFilterNone;
    _locationManager.delegate=self;
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    //[_locationManager requestWhenInUseAuthorization];
    //[_locationManager requestAlwaysAuthorization];
    [_locationManager startMonitoringSignificantLocationChanges];
    [_locationManager startUpdatingLocation];
    
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    //    btnCurrentLocation.hidden=YES;
    [_locationManager stopUpdatingLocation];
    
    myLocation = newLocation; //(CLLocation *)[locations lastObject];
    NSLog(@"Location: %@", [NSString stringWithFormat:@"%.8f", myLocation.coordinate.latitude]);
    NSLog(@"Location: %@", [NSString stringWithFormat:@"%.8f", myLocation.coordinate.longitude]);
    
}


- (IBAction)unlikeBtnAction:(id)sender {
    
    UIButton *btnLike=(UIButton *)[self.view viewWithTag:1000+_slideCount];
    UIButton *btnSupeLike=(UIButton *)[self.view viewWithTag:2000+_slideCount];
    UIButton *btnNope=(UIButton *)[self.view viewWithTag:3000+_slideCount];
    
    [btnNope setHidden:NO];
    [btnLike setHidden:YES];
    [btnSupeLike setHidden:YES];
    
    [self.swipeableView swipeTopViewToLeft];
    
}

- (IBAction)rewindBtnAction:(id)sender {
    [self.swipeableView rewind];
    
    if(_slideCount<=0){
        
    }
    else {
        
        if([appDelegate internetConnected])
        {
            
            NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
            NSString *identi=[user valueForKey:@"id"];
            NSString *token=[user valueForKey:@"token"];
            
            NSString* latitude;
            NSString* longitude;
            
            
            NSDictionary *userDict = [usersFound objectAtIndex:_slideCount-1];
            NSString *user_id = [userDict valueForKey:@"user_id"];
            
            latitude = [Utilities removeNullFromString:[NSString stringWithFormat:@"%@",[user valueForKey:@"selectedLat"]]];
            
            if([latitude  isEqual: @""]){
                latitude = [NSString stringWithFormat:@"%f",myLocation.coordinate.latitude];
                longitude = [NSString stringWithFormat:@"%f",myLocation.coordinate.longitude];
            }
            else{
                latitude = [NSString stringWithFormat:@"%@",[user valueForKey:@"selectedLat"]];
                longitude = [NSString stringWithFormat:@"%@",[user valueForKey:@"selectedLong"]];
            }
            
            
            NSDictionary * params=@{@"id":identi,@"token":token,@"latitude":latitude,@"longitude":longitude,@"status":@"reload",@"last_id":user_id};
            
            AFNHelper *afn=[[AFNHelper alloc]initWithRequestMethod:POST_METHOD];
            [afn getDataFromPath:MD_SEARCH withParamData:params withBlock:^(id response, NSDictionary *Error,NSString *strCode) {
                
                [self stopAnimating];
                if([[response valueForKey:@"success"]boolValue] == 1)
                {
                    _slideCount--;
                    
                }
                else
                {
                    NSString *strErrCode=[NSString stringWithFormat:@"%@",[response valueForKey:@"error_code"]];
                    
                    if ([strErrCode isEqualToString:@"104"])
                    {
                        
                        NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
                        [user removeObjectForKey:@"isLoggedin"];
                        
                        RootViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"RootViewController"];
                        [self.navigationController pushViewController:controller animated:YES];
                        
                    }

                    if ([strCode intValue]==1)
                    {
                        [CommenMethods alertviewController_title:@"" MessageAlert:NSLocalizedString(@"ERRORMSG", nil) viewController:self okPop:NO];
                    }
                    else
                    {
                        if ([Error objectForKey:@"email"]) {
                            [CommenMethods alertviewController_title:@"" MessageAlert:[[Error objectForKey:@"email"] objectAtIndex:0]  viewController:self okPop:NO];
                        }
                        else if ([Error objectForKey:@"password"]) {
                            [CommenMethods alertviewController_title:@"" MessageAlert:[[Error objectForKey:@"password"] objectAtIndex:0]  viewController:self okPop:NO];
                        }
                    }
                    
                }
            }];
        }
        else
        {
            [CommenMethods alertviewController_title:@"" MessageAlert:NSLocalizedString(@"Please Check Your Internet Connection", nil) viewController:self okPop:NO];
        }
    }
}

- (IBAction)likeBtnAction:(id)sender {
    
    UIButton *btnLike=(UIButton *)[self.view viewWithTag:1000+_slideCount];
    UIButton *btnSupeLike=(UIButton *)[self.view viewWithTag:2000+_slideCount];
    UIButton *btnNope=(UIButton *)[self.view viewWithTag:3000+_slideCount];
    
    [btnNope setHidden:YES];
    [btnLike setHidden:NO];
    [btnSupeLike setHidden:YES];

    [self.swipeableView swipeTopViewToRight];
   
}
- (IBAction)superLikeBtnAction:(id)sender {
    
    UIButton *btnLike=(UIButton *)[self.view viewWithTag:1000+_slideCount];
    UIButton *btnSupeLike=(UIButton *)[self.view viewWithTag:2000+_slideCount];
    UIButton *btnNope=(UIButton *)[self.view viewWithTag:3000+_slideCount];
    
    [btnNope setHidden:YES];
    [btnLike setHidden:YES];
    [btnSupeLike setHidden:NO];
    
    [self.swipeableView swipeTopViewToUp];
    
}

- (IBAction)sendMsgBtnAction:(id)sender {
    
    [UIView animateWithDuration:0.45 animations:^{
        
        _matchedView.frame = CGRectMake(self.view.frame.size.width+100, self.view.frame.size.height+100, self.view.frame.size.width, self.view.frame.size.height);
        
        _matched_shortscreenView.frame = CGRectMake(self.view.frame.size.width+100, self.view.frame.size.height+100, self.view.frame.size.width, self.view.frame.size.height);
    }];
    
    NSString *strReciverID=[CommenMethods getUserDefaultsKey:@"matched_id"];
    NSString *strReciverName=[CommenMethods getUserDefaultsKey:@"matchedUserName"];
    NSString *strRecivePic=[CommenMethods getUserDefaultsKey:@"matchedUserImageUrl"];
    NSString *strMsgCnt=@"0";
    
    ChatView *chat = [self.storyboard instantiateViewControllerWithIdentifier:@"ChatView"];
    chat.strReciverID=strReciverID;
    chat.strReciverName=strReciverName;
    chat.strReciverPic=strRecivePic;
    chat.strTotalMsg=strMsgCnt;
    [self.navigationController pushViewController:chat animated:YES];
}

- (IBAction)keepSwipingBtnAction:(id)sender {
    
    [UIView animateWithDuration:0.45 animations:^{
        
        _matched_shortscreenView.frame = CGRectMake(self.view.frame.size.width+100, self.view.frame.size.height+100, self.view.frame.size.width, self.view.frame.size.height);
        
        _matchedView.frame = CGRectMake(self.view.frame.size.width+100, self.view.frame.size.height+100, self.view.frame.size.width, self.view.frame.size.height);
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
