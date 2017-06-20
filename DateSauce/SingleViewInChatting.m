//
//  SingleViewInChatting.m
//  Binder
//
//  Created by Wepop on 27/06/16.
//  Copyright © 2016 WePop Info Solutions Pvt. Ltd. All rights reserved.
//

#import "SingleViewInChatting.h"
#import "MBProgressHUD.h"
//#import "LogIn.h"
#import "AsyncImageView.h"
#import "RootViewController.h"

@interface SingleViewInChatting ()
{
    NSString *strid ,*strToken , *strSattus ;
    AppDelegate *appDelegate;
    NSDictionary *dictSnglFrnd;
    UIView *viewSingle;
    UIScrollView *scrollView, *imgScrlView;
    UIPageControl *pageControl;
    int nCount;
    UIFont *fontname13,*fontname15,*fontname16, *fontname18, *fontname15_16;
    
}
@end

@implementation SingleViewInChatting
@synthesize strRecvId, strReciverName;

#pragma mark -
#pragma mark - Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    fontname13 = [UIFont fontWithName:@"Exo2-Regular" size:13];
    fontname15 = [UIFont fontWithName:@"Exo2-Regular" size:15];
    fontname15_16 = [UIFont fontWithName:@"Exo2-Regular" size:16];
    fontname16 = [UIFont fontWithName:@"Exo2-Regular" size:16];
    fontname18 = [UIFont fontWithName:@"Exo2-Medium" size:18];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    strid=[defaults valueForKey:@"id"];
    strToken=[defaults valueForKey:@"token"];
    strSattus=[defaults valueForKey:@"status"];
    
    UIBarButtonItem *barBtn = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"BackButtonArrow.png"] style:UIBarButtonItemStylePlain target:self action:@selector(onBack)];
    barBtn.tintColor=[UIColor blackColor];
    [self.navigationItem setLeftBarButtonItem:barBtn ];
    
    
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
    // self.navigationController.navigationBar.barTintColor=[UIColor blackColor];
    [self.navigationController.navigationBar
     setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    // self.navigationController.navigationBar.tintColor=[UIColor blackColor];
    //self.navigationItem.title=@"Log In With Email";
    
    UILabel *lblNav=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 30)];
    lblNav.text=strReciverName;
    lblNav.textColor=[UIColor blackColor];
    lblNav.backgroundColor=[UIColor clearColor];
    [lblNav setFont:fontname18];
    
    self.navigationItem.titleView=lblNav;
    self.navigationController.navigationBar.translucent = YES;
}
-(void)viewWillAppear:(BOOL)animated
{
    
    if([appDelegate.is_from_push isEqualToString:@"yes"])
    {
        strRecvId=[appDelegate.dictNotiDetails valueForKey:@"Req_Sender_id"];
    }
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    webservice *service=[[webservice alloc]init];
    service.tag=1;
    service.delegate=self;
    
    NSString *strValues=[NSString stringWithFormat:@"{\"id\":\"%@\",\"token\":\"%@\",\"suggestion_id\":\"%@\"}",strid,strToken,strRecvId];
    
    [service executeWebserviceWithMethod:METHOD_SINGLE_FRIEND withValues:strValues];
}
-(void)onBack
{
    
    if([appDelegate.is_from_push isEqualToString:@"yes"])
    {
        
        [self performSegueWithIdentifier:@"singleViw_BinderHome" sender:self];
    }
    else
    {
//        [self.navigationController popViewControllerAnimated:YES];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
}

-(void)DispSingle
{
    viewSingle=[[UIView alloc]initWithFrame:self.view.frame];
    viewSingle.backgroundColor=[UIColor whiteColor];
    //[self.view addSubview:viewSingle];
    
    viewSingle.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.001, 0.001);
    
    [self.view addSubview:viewSingle];
    
    [UIView animateWithDuration:0.40 animations:^{
        viewSingle.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1, 1);
        //   }
        //    completion:^(BOOL finished) {
        //        [UIView animateWithDuration:0.30 animations:^{
        //            viewSingle.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.9, 0.9);
        //        } completion:^(BOOL finished) {
        //            [UIView animateWithDuration:0.30 animations:^{
        //                viewSingle.transform = CGAffineTransformIdentity;
        //            }];
        //       }];
    }];
    
    [scrollView removeFromSuperview];
    scrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    scrollView.backgroundColor=[UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1.0];
    scrollView.showsVerticalScrollIndicator=NO;
    [viewSingle addSubview:scrollView];
    
    
    NSDictionary *dictUsrData=[dictSnglFrnd valueForKey:@"user_data"];
    NSArray *arrSlidData=[dictSnglFrnd valueForKey:@"slider_data"];
    NSArray *arrDropData=[dictSnglFrnd valueForKey:@"drop_data"];
    
    
    
    int y=0;
    
    NSArray *arrImage=[dictUsrData valueForKey:@"images"];
    NSInteger pageCount=arrImage.count;
    
    
    imgScrlView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, y, self.view.frame.size.width, (self.view.frame.size.height/2)+50)];
    imgScrlView.backgroundColor=[UIColor clearColor];
    imgScrlView.pagingEnabled=YES;
    imgScrlView.delegate=self;
    imgScrlView.contentSize=CGSizeMake(pageCount * imgScrlView.bounds.size.width , imgScrlView.bounds.size.height);
    [imgScrlView setShowsHorizontalScrollIndicator:NO];
    [imgScrlView setShowsVerticalScrollIndicator:NO];
    
    imgScrlView.userInteractionEnabled = YES;
    //    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onSingleRemove:)];
    //    [imgScrlView addGestureRecognizer:singleTap];
    
    CGRect viewSize;//=imgScrlView.bounds;
    
    for (int nCountImg=0; nCountImg<arrImage.count; nCountImg++)
    {
        NSString *strImageURL=[arrImage objectAtIndex:nCountImg];
        
        if (nCountImg==0)
            viewSize=imgScrlView.bounds;
        else
            viewSize=CGRectOffset(viewSize, imgScrlView.bounds.size.width, 0);
        
        UIImageView *imgView=[[UIImageView alloc] initWithFrame:viewSize];
        
        if ([strImageURL isEqualToString:@"http://api.datesauce.com/flamerui/img/user.png"])
        {
            imgView.image=[UIImage imageNamed:@"user.png"];
        }
        else
        {
            AsyncImageView *async = [[AsyncImageView alloc]initWithFrame:CGRectMake(0, 0, imgView.frame.size.width, imgView.frame.size.height)];
            [async loadImageFromURL:[NSURL URLWithString:strImageURL]];
            [imgView addSubview:async];
        }
        imgView.contentMode = UIViewContentModeScaleAspectFit;
        [imgScrlView addSubview:imgView];
    }
    [scrollView addSubview:imgScrlView];
    
    
    pageControl = [[UIPageControl alloc] init];
    pageControl.frame = CGRectMake((self.view.frame.size.width/2)-55,(self.view.frame.size.height/2)+30,110,20);
    pageControl.numberOfPages = pageCount;
    pageControl.currentPage = 0;
    pageControl.contentHorizontalAlignment=UIControlContentHorizontalAlignmentCenter;
    pageControl.currentPageIndicatorTintColor=[UIColor colorWithRed:252/255.0 green:89/255.0 blue:77/255.0 alpha:1.0];
    pageControl.pageIndicatorTintColor=[UIColor whiteColor];
    [pageControl addTarget:self action:@selector(pageChanged) forControlEvents:UIControlEventValueChanged];
    [scrollView addSubview:pageControl];
    
    
    y+=(self.view.frame.size.height/2)+70;
    
    NSString *strName=[dictUsrData valueForKey:@"name"];
    NSString *strAge=[dictUsrData valueForKey:@"age"];
    
    // yPos+=210;
    
    UILabel *lblNameAge=[[UILabel alloc]initWithFrame:CGRectMake(10, y, self.view.frame.size.width-20, 25 )];
    lblNameAge.text=[NSString stringWithFormat:@"%@ , %@",strName,strAge];
    [lblNameAge setFont:fontname18];
    lblNameAge.textColor=[UIColor blackColor];
    [scrollView addSubview:lblNameAge];
    
    y+=30;
    
    if (![[dictUsrData valueForKey:@"company"] isEqualToString:@""])
    {
        
        UILabel *lblCompany=[[UILabel alloc]initWithFrame:CGRectMake(10, y, self.view.frame.size.width-20, 25 )];
        lblCompany.text=[dictUsrData valueForKey:@"company"];
        [lblCompany setFont:fontname15];
        lblCompany.textColor=[UIColor blackColor];
        [scrollView addSubview:lblCompany];
        
        y+=30;
    }
    
    if (![[dictUsrData valueForKey:@"work"] isEqualToString:@""])
    {
        
        UILabel *lblWork=[[UILabel alloc]initWithFrame:CGRectMake(10, y, self.view.frame.size.width-20, 25 )];
        lblWork.text=[dictUsrData valueForKey:@"work"];
        [lblWork setFont:fontname16];
        lblWork.textColor=[UIColor blackColor];
        [scrollView addSubview:lblWork];
        
        y+=30;
    }
    
    if (![[dictUsrData valueForKey:@"description"] isEqualToString:@""])
    {
        
        //            UILabel *lblDesc=[[UILabel alloc]initWithFrame:CGRectMake(10, y, self.view.frame.size.width-20, 25 )];
        //            lblDesc.text=[dictUsrData valueForKey:@"description"];
        //            [lblDesc setFont:fontname16];
        //            lblDesc.textColor=[UIColor blackColor];
        //            lblDesc.numberOfLines=2;
        //            lblDesc.lineBreakMode=NSLineBreakByWordWrapping;
        //            [scrollView addSubview:lblDesc];
        //            y+=30;
        
        UILabel *lblDescription=[[UILabel alloc]initWithFrame:CGRectMake(10, y, self.view.frame.size.width-20, 25 )];
        lblDescription.text=[dictUsrData valueForKey:@"description"];
        [lblDescription setFont:fontname16];
        lblDescription.textColor=[UIColor blackColor];
        lblDescription.textAlignment=NSTextAlignmentLeft;
        lblDescription.numberOfLines=10;
        lblDescription.lineBreakMode=NSLineBreakByWordWrapping;
        [scrollView addSubview:lblDescription];
        
        [lblDescription sizeToFit];
        int h=lblDescription.frame.size.height;
        y+=h+10;
        
        
    }
    //        if (![[dictSing valueForKey:@"distance"] isEqualToString:@""])
    //        {
    
    UILabel *lblDesc=[[UILabel alloc]initWithFrame:CGRectMake(10, y, self.view.frame.size.width-20, 25 )];
    lblDesc.text=[NSString stringWithFormat:@"%@ km away",[dictUsrData valueForKey:@"distance"]];
    [lblDesc setFont:fontname16];
    lblDesc.textColor=[UIColor grayColor];
    [scrollView addSubview:lblDesc];
    y+=35;
    // }
    
    int btnHeight=0;
    
    if (arrDropData.count!=0)
    {
        
        
        UILabel *lblUserDetails=[[UILabel alloc]initWithFrame:CGRectMake(15, y, self.view.frame.size.width, 25)];
        lblUserDetails.text=@"User Details";
        [lblUserDetails setFont:fontname15_16];
        lblUserDetails.textColor=[UIColor blackColor];
        [scrollView addSubview:lblUserDetails];
        
        
        
        y+=35;
        
        
        
        {
            
            
            
            int indexOfLeftmostButtonOnCurrentLine = 0;
            
            NSMutableArray *buttons = [[NSMutableArray alloc] init];
            
            float runningWidth = 0.0f;
            
            float maxWidth =self.view.frame.size.width-30;
            
            float horizontalSpaceBetweenButtons = 15.0f;
            
            float verticalSpaceBetweenButtons = y;
            
            
            
            for (int i=0; i<arrDropData.count; i++) {
                
                NSDictionary *dictDrop=[arrDropData objectAtIndex:i];
                
                UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                
                NSString *strQues=[dictDrop valueForKey:@"question"];
                NSString *strAns=[dictDrop valueForKey:@"option"];
                
                NSString *strQuesAns=[NSString stringWithFormat:@"   %@ : %@   ",strQues,strAns];
                
                [button setTitle:strQuesAns forState:UIControlStateNormal];
                
                [button setTitleColor:[UIColor colorWithRed:252/255.0 green:89/255.0 blue:77/255.0 alpha:1.0] forState:UIControlStateNormal];
                
                
                // button.tag=[[dictLoc valueForKey:@"id"] intValue];
                
                //[button addTarget:self action:@selector(onOffer:) forControlEvents:UIControlEventTouchDownRepeat];
                
                //        [button setBackgroundImage:[UIImage imageNamed:@"b1.png"] forState:UIControlStateNormal];
                
                //        [button setBackgroundImage:[UIImage imageNamed:@"b2.png"] forState:UIControlStateSelected];
                
                //        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentFill;
                
                //        button.contentVerticalAlignment = UIControlContentVerticalAlignmentFill;
                
                
                
                [button.layer setBorderWidth:1.0];
                
                button.layer.borderColor=[UIColor colorWithRed:252/255.0 green:89/255.0 blue:77/255.0 alpha:1.0].CGColor;
                
                //[button.layer setBorderColor:(__bridge CGColorRef _Nullable)([UIColor whiteColor])];
                
                button.layer.cornerRadius = 3.0f;
                
                button.clipsToBounds = YES;
                
                [button.titleLabel setFont:fontname13];
                
                
                
                
                
                
                
                //        [layer setBorderWidth:1.0];
                
                //        [layer setBorderColor:[[UIColor grayColor] CGColor]];
                
                
                
                
                
                
                
                button.translatesAutoresizingMaskIntoConstraints = NO;
                
                [button sizeToFit];
                
                [scrollView addSubview:button];
                
                
                
                // check if first button or button would exceed maxWidth
                
                if ((i == 0) || (runningWidth + button.frame.size.width > maxWidth)) {
                    
                    // wrap around into next line
                    
                    runningWidth = button.frame.size.width;
                    
                    
                    
                    if (i== 0) {
                        
                        // first button (top left)
                        
                        // horizontal position: same as previous leftmost button (on line above)
                        
                        NSLayoutConstraint *horizontalConstraint = [NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:scrollView attribute:NSLayoutAttributeLeft multiplier:1.0f constant:horizontalSpaceBetweenButtons];
                        
                        [scrollView addConstraint:horizontalConstraint];
                        
                        
                        
                        // vertical position:
                        
                        NSLayoutConstraint *verticalConstraint = [NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:scrollView attribute:NSLayoutAttributeTop              multiplier:1.0f constant:verticalSpaceBetweenButtons];
                        
                        [scrollView addConstraint:verticalConstraint];
                        
                        
                        btnHeight=btnHeight+button.frame.size.height;
                        
                        
                    }
                    
                    else
                    {
                        
                        // put it in new line
                        
                        UIButton *previousLeftmostButton = [buttons objectAtIndex:indexOfLeftmostButtonOnCurrentLine];
                        
                        
                        
                        // horizontal position: same as previous leftmost button (on line above)
                        
                        NSLayoutConstraint *horizontalConstraint = [NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:previousLeftmostButton attribute:NSLayoutAttributeLeft multiplier:1.0f constant:0.0f];
                        
                        [scrollView addConstraint:horizontalConstraint];
                        
                        
                        
                        // vertical position:
                        
                        NSLayoutConstraint *verticalConstraint = [NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:previousLeftmostButton attribute:NSLayoutAttributeBottom multiplier:1.0f constant:verticalSpaceBetweenButtons];
                        
                        [scrollView addConstraint:verticalConstraint];
                        
                        
                        
                        indexOfLeftmostButtonOnCurrentLine = i;
                        
                        btnHeight=btnHeight+button.frame.size.height;
                        
                    }
                    
                } else {
                    
                    // put it right from previous buttom
                    
                    runningWidth += button.frame.size.width + horizontalSpaceBetweenButtons;
                    
                    
                    
                    UIButton *previousButton = [buttons objectAtIndex:(i-1)];
                    
                    
                    
                    // horizontal position: right from previous button
                    
                    NSLayoutConstraint *horizontalConstraint = [NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:previousButton attribute:NSLayoutAttributeRight multiplier:1.0f constant:horizontalSpaceBetweenButtons];
                    
                    [scrollView addConstraint:horizontalConstraint];
                    
                    
                    
                    // vertical position same as previous button
                    
                    NSLayoutConstraint *verticalConstraint = [NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:previousButton attribute:NSLayoutAttributeTop multiplier:1.0f constant:0.0f];
                    
                    [scrollView addConstraint:verticalConstraint];
                    
                }
                
                
                
                [buttons addObject:button];
                
                verticalSpaceBetweenButtons = 10.0f;
                horizontalSpaceBetweenButtons = 10.0f;
                
            }
            
        }
        
        y+=btnHeight+35;
    }
    
    if (arrSlidData.count!=0)
    {
        
        UILabel *lblInterests=[[UILabel alloc]initWithFrame:CGRectMake(15, y, self.view.frame.size.width, 25)];
        lblInterests.text=@"Interests";
        [lblInterests setFont:fontname15_16];
        lblInterests.textColor=[UIColor blackColor];
        [scrollView addSubview:lblInterests];
        
        y+=35;
        
        btnHeight=0;
        
        {
            
            int indexOfLeftmostButtonOnCurrentLine = 0;
            
            NSMutableArray *buttons = [[NSMutableArray alloc] init];
            
            float runningWidth = 0.0f;
            
            float maxWidth =self.view.frame.size.width-30;
            
            float horizontalSpaceBetweenButtons = 15.0f;
            
            float verticalSpaceBetweenButtons = y;
            
            
            
            for (int i=0; i<arrSlidData.count; i++) {
                
                NSDictionary *dictSlider=[arrSlidData objectAtIndex:i];
                
                UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                
                NSString *strQues=[dictSlider valueForKey:@"question"];
                NSString *strAns=[dictSlider valueForKey:@"slider_value"];
                
                NSString *strQuesAns=[NSString stringWithFormat:@"   %@ : %@   ",strQues,strAns];
                
                [button setTitle:strQuesAns forState:UIControlStateNormal];
                
                [button setTitleColor:[UIColor colorWithRed:252/255.0 green:89/255.0 blue:77/255.0 alpha:1.0] forState:UIControlStateNormal];
                
                
                // button.tag=[[dictLoc valueForKey:@"id"] intValue];
                
                //[button addTarget:self action:@selector(onOffer:) forControlEvents:UIControlEventTouchDownRepeat];
                
                //        [button setBackgroundImage:[UIImage imageNamed:@"b1.png"] forState:UIControlStateNormal];
                
                //        [button setBackgroundImage:[UIImage imageNamed:@"b2.png"] forState:UIControlStateSelected];
                
                //        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentFill;
                
                //        button.contentVerticalAlignment = UIControlContentVerticalAlignmentFill;
                
                
                
                [button.layer setBorderWidth:1.0];
                
                button.layer.borderColor=[UIColor colorWithRed:252/255.0 green:89/255.0 blue:77/255.0 alpha:1.0].CGColor;
                
                //[button.layer setBorderColor:(__bridge CGColorRef _Nullable)([UIColor whiteColor])];
                
                button.layer.cornerRadius = 3.0f;
                
                button.clipsToBounds = YES;
                
                [button.titleLabel setFont:fontname13];
                
                
                
                
                
                
                
                //        [layer setBorderWidth:1.0];
                
                //        [layer setBorderColor:[[UIColor grayColor] CGColor]];
                
                
                
                
                
                
                
                button.translatesAutoresizingMaskIntoConstraints = NO;
                
                [button sizeToFit];
                
                [scrollView addSubview:button];
                
                
                
                // check if first button or button would exceed maxWidth
                
                if ((i == 0) || (runningWidth + button.frame.size.width > maxWidth)) {
                    
                    // wrap around into next line
                    
                    runningWidth = button.frame.size.width;
                    
                    
                    
                    if (i== 0) {
                        
                        // first button (top left)
                        
                        // horizontal position: same as previous leftmost button (on line above)
                        
                        NSLayoutConstraint *horizontalConstraint = [NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:scrollView attribute:NSLayoutAttributeLeft multiplier:1.0f constant:horizontalSpaceBetweenButtons];
                        
                        [scrollView addConstraint:horizontalConstraint];
                        
                        
                        
                        // vertical position:
                        
                        NSLayoutConstraint *verticalConstraint = [NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:scrollView attribute:NSLayoutAttributeTop              multiplier:1.0f constant:verticalSpaceBetweenButtons];
                        
                        [scrollView addConstraint:verticalConstraint];
                        
                        btnHeight=btnHeight+button.frame.size.height;
                        
                        
                        
                    } else {
                        
                        // put it in new line
                        
                        UIButton *previousLeftmostButton = [buttons objectAtIndex:indexOfLeftmostButtonOnCurrentLine];
                        
                        
                        
                        // horizontal position: same as previous leftmost button (on line above)
                        
                        NSLayoutConstraint *horizontalConstraint = [NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:previousLeftmostButton attribute:NSLayoutAttributeLeft multiplier:1.0f constant:0.0f];
                        
                        [scrollView addConstraint:horizontalConstraint];
                        
                        
                        
                        // vertical position:
                        
                        NSLayoutConstraint *verticalConstraint = [NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:previousLeftmostButton attribute:NSLayoutAttributeBottom multiplier:1.0f constant:verticalSpaceBetweenButtons];
                        
                        [scrollView addConstraint:verticalConstraint];
                        
                        
                        
                        indexOfLeftmostButtonOnCurrentLine = i;
                        
                        btnHeight=btnHeight+button.frame.size.height;
                        
                    }
                    
                } else {
                    
                    // put it right from previous buttom
                    
                    runningWidth += button.frame.size.width + horizontalSpaceBetweenButtons;
                    
                    
                    
                    UIButton *previousButton = [buttons objectAtIndex:(i-1)];
                    
                    
                    
                    // horizontal position: right from previous button
                    
                    NSLayoutConstraint *horizontalConstraint = [NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:previousButton attribute:NSLayoutAttributeRight multiplier:1.0f constant:horizontalSpaceBetweenButtons];
                    
                    [scrollView addConstraint:horizontalConstraint];
                    
                    
                    
                    // vertical position same as previous button
                    
                    NSLayoutConstraint *verticalConstraint = [NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:previousButton attribute:NSLayoutAttributeTop multiplier:1.0f constant:0.0f];
                    
                    [scrollView addConstraint:verticalConstraint];
                    
                }
                
                
                
                [buttons addObject:button];
                
                verticalSpaceBetweenButtons = 10.0f;
                horizontalSpaceBetweenButtons = 10.0f;
                
            }
            
        }
        y+=btnHeight+25;
    }
    
    if([appDelegate.is_from_push isEqualToString:@"yes"])
    {
        
        UIButton *btnClose=[UIButton buttonWithType:UIButtonTypeCustom];
        btnClose.frame=CGRectMake(0, self.view.frame.size.height-75, 60, 60);
        UIImage *imgCL=[UIImage imageNamed:@"white-dislike-icon.png"];
        [btnClose setBackgroundImage:imgCL forState:UIControlStateNormal];
        [btnClose addTarget:self action:@selector(onRespNotif:) forControlEvents:UIControlEventTouchDown];
        //        [[btnClose layer]setBorderWidth:2.5];
        //        [[btnClose layer]setBorderColor:[UIColor grayColor].CGColor];
        btnClose.layer.cornerRadius=25;
        btnClose.clipsToBounds=YES;
        btnClose.tag=BTN_NOPE;
        btnClose.backgroundColor=[UIColor clearColor];
        [viewSingle addSubview:btnClose];
        
        [UIView animateWithDuration:0.85 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            btnClose.frame = CGRectMake((self.view.frame.size.width/2)-105,self.view.frame.size.height-75, 60, 60);
        } completion:^(BOOL finished) {
            // your animation finished
        }];
        
        
        UIButton *btnLove=[UIButton buttonWithType:UIButtonTypeCustom];
        btnLove.frame=CGRectMake((self.view.frame.size.width/2)-25, self.view.frame.size.height-75, 60, 60);
        UIImage *imgLV=[UIImage imageNamed:@"white-like-icon.png"];
        [btnLove setBackgroundImage:imgLV forState:UIControlStateNormal];
        [btnLove addTarget:self action:@selector(onRespNotif:) forControlEvents:UIControlEventTouchDown];
        //        [[btnLove layer]setBorderWidth:2.5];
        //        [[btnLove layer]setBorderColor:[UIColor grayColor].CGColor];
        btnLove.layer.cornerRadius=25;
        btnLove.clipsToBounds=YES;
        btnLove.tag=BTN_LIKE;
        btnLove.backgroundColor=[UIColor clearColor];
        [viewSingle addSubview:btnLove];
        
        
        UIButton *btnStar=[UIButton buttonWithType:UIButtonTypeCustom];
        btnStar.frame=CGRectMake(self.view.frame.size.width, self.view.frame.size.height-75, 60, 60);
        UIImage *imgST=[UIImage imageNamed:@"white-super-like-icon.png"];
        [btnStar setBackgroundImage:imgST forState:UIControlStateNormal];
        [btnStar addTarget:self action:@selector(onRespNotif:) forControlEvents:UIControlEventTouchDown];
        //        [[btnStar layer]setBorderWidth:2.5];
        //        [[btnStar layer]setBorderColor:[UIColor grayColor].CGColor];
        btnStar.layer.cornerRadius=25;
        btnStar.clipsToBounds=YES;
        btnStar.tag=BTN_SUPER_LIKE;
        btnStar.backgroundColor=[UIColor clearColor];
        [viewSingle addSubview:btnStar];
        
        [UIView animateWithDuration:0.85 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            btnStar.frame = CGRectMake((self.view.frame.size.width/2)+55,self.view.frame.size.height-75, 60, 60);
        } completion:^(BOOL finished) {
            // your animation finished
        }];
        
        
        //        UIButton *btnSinRemove=[[UIButton alloc]initWithFrame:imgScrlView.frame];
        //        btnSinRemove.backgroundColor=[UIColor clearColor];
        //        [btnSinRemove addTarget:self action:@selector(onSingleRemove:) forControlEvents:UIControlEventTouchUpInside];
        //        [scrollView addSubview:btnSinRemove];
        
        
    }
    
    else
    {
        UIButton *btnUnMatch=[UIButton buttonWithType:UIButtonTypeCustom];
        btnUnMatch.frame=CGRectMake(0, self.view.frame.size.height-40, self.view.frame.size.width, 40);
        [btnUnMatch setTitle:@"UnMatch" forState:UIControlStateNormal];
        [btnUnMatch setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btnUnMatch.titleLabel.font=fontname18;
        [btnUnMatch addTarget:self action:@selector(onUnMatchConfirm:) forControlEvents:UIControlEventTouchDown];
        [btnUnMatch setBackgroundColor:[UIColor colorWithRed:252/255.0 green:89/255.0 blue:77/255.0 alpha:1.0]];
        [viewSingle addSubview:btnUnMatch];
        
        //        UIButton *btnSinRemove=[[UIButton alloc]initWithFrame:imgScrlView.frame];
        //        btnSinRemove.backgroundColor=[UIColor clearColor];
        //        [btnSinRemove addTarget:self action:@selector(onSingleRemove:) forControlEvents:UIControlEventTouchUpInside];
        //        [scrollView addSubview:btnSinRemove];
    }
    
    scrollView.contentSize=CGSizeMake(self.view.frame.size.width, y+100);
    
}

-(void)onUnMatch:(id)sender
{
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    
    webservice *service=[[webservice alloc]init];
    service.tag=2;
    service.delegate=self;
    
    
    NSString *strValues=[NSString stringWithFormat:@"{\"id\":\"%@\",\"token\":\"%@\",\"unmatch_user_id\":\"%@\"}",strid,strToken,strRecvId];
    
    [service executeWebserviceWithMethod:METHOD_UNMATCH withValues:strValues];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -
#pragma mark - Action
-(IBAction)onRespNotif:(id)sender
{
    UIButton *btn=(UIButton *)sender;
    NSString *strLikeStatus=[NSString stringWithFormat:@"%ld",(long)btn.tag];
    
    webservice *service=[[webservice alloc]init];
    service.tag=3;
    service.delegate=self;
    
    NSString *strValues=[NSString stringWithFormat:@"{\"id\":\"%@\",\"token\":\"%@\",\"suggestion_id\":\"%@\",\"status\":\"%@\"}",strid,strToken,strRecvId,strLikeStatus];
    
    [service executeWebserviceWithMethod:METHOD_LIKE withValues:strValues];
    
    
    
}


-(IBAction)onUnMatchConfirm:(id)sender
{
    NSString *strmesg=[NSString stringWithFormat:@"Are you sure want to  un match %@ ?",strReciverName];
    
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:@"Binder"
                                  message:strmesg
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction
                         actionWithTitle:@"Un Match"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
                             //[alert dismissViewControllerAnimated:YES completion:nil];
                             [self onUnMatch:nil];
                             
                         }];
    UIAlertAction* cancel = [UIAlertAction
                             actionWithTitle:@"Cancel"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 [alert dismissViewControllerAnimated:YES completion:nil];
                                 
                             }];
    
    [alert addAction:ok];
    [alert addAction:cancel];
    
    [self presentViewController:alert animated:YES completion:nil];
    
    
}


#pragma mark -
#pragma mark - PageControl Delegate

-(void)viewanimation
{
    if (nCount<3)
    {
        nCount++;
        int pageNumber = nCount;
        
        CGRect frame = imgScrlView.frame;
        frame.origin.x = frame.size.width*pageNumber;
        frame.origin.y=0;
        
        [imgScrlView scrollRectToVisible:frame animated:YES];
    }
    else
    {
        nCount=0;
        int pageNumber = nCount;
        
        CGRect frame = imgScrlView.frame;
        frame.origin.x = frame.size.width*pageNumber;
        frame.origin.y=0;
        
        [imgScrlView scrollRectToVisible:frame animated:YES];
    }
}


- (void)scrollViewDidScroll:(UIScrollView *)sclView{
    
    CGFloat viewWidth = sclView.frame.size.width;
    // content offset - tells by how much the scroll view has scrolled.
    
    int pageNumber = floor((sclView.contentOffset.x - viewWidth/50) / viewWidth) +1;
    
    pageControl.currentPage=pageNumber;
    nCount=pageNumber;
    
}

- (void)pageChanged {
    
    int pageNumber = (int)pageControl.currentPage;
    
    CGRect frame = imgScrlView.frame;
    frame.origin.x = frame.size.width*pageNumber;
    frame.origin.y=0;
    
    [imgScrlView scrollRectToVisible:frame animated:YES];
}


#pragma mark -
#pragma mark - WebService Delegate

-(void)receivedErrorWithMessage:(NSString *)message
{
    [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
    
    
    UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"Binder" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* ok = [UIAlertAction
                         actionWithTitle:@"OK"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
                             [alert dismissViewControllerAnimated:YES completion:nil];
                             
                         }];
    [alert addAction:ok];
    
    [self presentViewController:alert animated:YES completion:nil];
    
    
}
-(void)receivedResponse:(NSDictionary *)dictResponse fromWebservice:(webservice *)webservice
{
    [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
    
    if (webservice.tag==1)
    {
        if ([[dictResponse valueForKey:@"success"] boolValue]==true)
        {
            dictSnglFrnd=dictResponse;
            [self DispSingle];
        }
        else
        {
            NSString *strErrCode=[NSString stringWithFormat:@"%@",[dictResponse valueForKey:@"error_code"]];
            
            if ([strErrCode isEqualToString:@"104"])
            {
                NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
                [user removeObjectForKey:@"isLoggedin"];
                
                RootViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"RootViewController"];
                [self.navigationController pushViewController:controller animated:YES];
            }
            
            
            UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"Binder" message:[dictResponse valueForKey:@"error"] preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* ok = [UIAlertAction
                                 actionWithTitle:@"OK"
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action)
                                 {
                                     [alert dismissViewControllerAnimated:YES completion:nil];
                                     
                                 }];
            [alert addAction:ok];
            
            [self presentViewController:alert animated:YES completion:nil];
            
        }
    }
    else if (webservice.tag==2)
    {
        if ([[dictResponse valueForKey:@"success"] boolValue]==true)
        {
            appDelegate.strIsFrmChat=@"yes";
            
            
            UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"Binder" message:[dictResponse valueForKey:@"message"] preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* ok = [UIAlertAction
                                 actionWithTitle:@"OK"
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action)
                                 {
                                     [alert dismissViewControllerAnimated:YES completion:nil];
                                     [self.navigationController popToRootViewControllerAnimated:YES];
                                     
                                 }];
            [alert addAction:ok];
            
            [self presentViewController:alert animated:YES completion:nil];
            
            
        }
        else
        {
            NSString *strErrCode=[NSString stringWithFormat:@"%@",[dictResponse valueForKey:@"error_code"]];
            
            if ([strErrCode isEqualToString:@"104"])
            {
                NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
                [user removeObjectForKey:@"isLoggedin"];
                
                RootViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"RootViewController"];
                [self.navigationController pushViewController:controller animated:YES];
                
            }
            
            
            UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"Binder" message:[dictResponse valueForKey:@"error"] preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* ok = [UIAlertAction
                                 actionWithTitle:@"OK"
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action)
                                 {
                                     [alert dismissViewControllerAnimated:YES completion:nil];
                                     
                                 }];
            [alert addAction:ok];
            
            [self presentViewController:alert animated:YES completion:nil];
            
        }
    }
    
    else if (webservice.tag==3)
    {
        if ([[dictResponse valueForKey:@"success"] boolValue]==true)
        {
            
            NSDictionary  *dictLike=[dictResponse valueForKey:@"like"];
            
            if ([[dictLike valueForKey:@"match"] boolValue]==true)
            {
                // for Notification back
                appDelegate.strIsFrmChat=@"yes";
                [self performSegueWithIdentifier:@"singleViw_BinderHome" sender:self];
            }
        }
        else
        {
            
            
            NSString *strErrCode=[NSString stringWithFormat:@"%@",[dictResponse valueForKey:@"error_code"]];
            
            if ([strErrCode isEqualToString:@"104"])
            {
                NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
                [user removeObjectForKey:@"isLoggedin"];
                
                RootViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"RootViewController"];
                [self.navigationController pushViewController:controller animated:YES];
            }
            
            
            UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"Binder" message:[dictResponse valueForKey:@"error"] preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* ok = [UIAlertAction
                                 actionWithTitle:@"OK"
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action)
                                 {
                                     [alert dismissViewControllerAnimated:YES completion:nil];
                                     
                                 }];
            [alert addAction:ok];
            
            [self presentViewController:alert animated:YES completion:nil];
            
        }
        
        
        
    }
    
    
    
    
    
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
