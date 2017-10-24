//
//  RootViewController.m
//  DateSauce
//
//  Created by veena on 5/30/17.
//  Copyright © 2017 appoets. All rights reserved.
//

#import "RootViewController.h"
#import "SignInViewController.h"
#import "SignUpViewController.h"
#import "WebViewViewController.h"
#import "CSS_Class.h"
#import "Constants.h"

@interface RootViewController ()<UIScrollViewDelegate>

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setUpDesign];
    
}

- (void)setUpDesign {
    
    ////////////////  dhyan ////////////////
    
    NSAttributedString *titleString = [[NSAttributedString alloc] initWithString:@"Terms of service" attributes:@{NSUnderlineStyleAttributeName : @(NSUnderlineStyleSingle | NSUnderlinePatternSolid)}];
    _termsOfServiceBtn.titleLabel.font = [UIFont fontWithName:@"GothamRounded-Book" size:11];
    [_termsOfServiceBtn setAttributedTitle:titleString forState:UIControlStateNormal];
    [_termsOfServiceBtn setTitleColor:[UIColor colorWithRed:235/255.0 green:68/255.0 blue:97/255.0 alpha:1.0/255.0] forState:UIControlStateNormal];
    
    if(IS_IPHONE_5){
        _bysigningInLbl.font=[UIFont fontWithName:@"GothamRounded-Book" size:9];
        _termsOfServiceBtn.titleLabel.font = [UIFont fontWithName:@"GothamRounded-Book" size:9];
    }
    
    pageIndex = 0;
    
    self.scrollView.pagingEnabled = NO;
    self.scrollView.clipsToBounds = YES;
    self.scrollView.delegate = self;
    self.scrollView.scrollEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.backgroundColor = [UIColor clearColor];
    
    images = [[NSMutableArray alloc]initWithObjects:[UIImage imageNamed:@"welcome_screen_one"],[UIImage imageNamed:@"welcome_screen_two"], nil];
    
    CGFloat xValue = 0;
    for (UIImage *image in images) {
        
        UIImageView *imageViewObject = [[UIImageView alloc] initWithFrame:CGRectMake(xValue, 0, _scrollView.frame.size.width, _scrollView.frame.size.height)];
        
        imageViewObject.image = image;
        [self.scrollView addSubview:imageViewObject];
        
        xValue += self.scrollView.frame.size.width;
        
    }
    
    [self.scrollView setContentSize:CGSizeMake(xValue, self.scrollView.frame.size.height)];
    
    // This statement connect and execute the changePage: method's code
    [self.pageControl addTarget:self action:@selector(changePage:) forControlEvents:UIControlEventValueChanged];
    self.pageControl.currentPage = 0;
    self.pageControl.numberOfPages = images.count;
    
    [self.view bringSubviewToFront:self.pageControl];
   
    //self.pageControl.transform = CGAffineTransformMakeScale(2, 2);
    
    [self.navigationController setNavigationBarHidden:YES];
    
    [CSS_Class APP_Orangebutton:_signInBtn];
    [CSS_Class APP_Yellowbutton:_signUpBtn];
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    int pageWidth = self.view.frame.size.width;
    int pageX = pageIndex*pageWidth-scrollView.contentInset.left;
    if (targetContentOffset->x<pageX) {
        if (pageIndex>0) {
            pageIndex--;
        }
    }
    else if(targetContentOffset->x>pageX){
        if (pageIndex<images.count) {
            pageIndex++;
        }
    }
    targetContentOffset->x = pageIndex*pageWidth-scrollView.contentInset.left;
    NSLog(@"%d %d", pageIndex, (int)targetContentOffset->x);
}


- (IBAction)changePage:(id)sender
{
    [UIView beginAnimations:nil context:NULL];
    self.scrollView.contentOffset = CGPointMake(_scrollView.frame.size.width * self.pageControl.currentPage, 0);
    [UIView commitAnimations];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGPoint offset = self.scrollView.contentOffset;
    self.pageControl.currentPage = offset.x / scrollView.frame.size.width ;
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

- (IBAction)signInBtnAction:(id)sender {
    
    SignInViewController *signIn = [self.storyboard instantiateViewControllerWithIdentifier:@"SignInViewController"];
    [self.navigationController pushViewController:signIn animated:YES];
    
    
}
- (IBAction)signUpBtnAction:(id)sender {
    
    SignUpViewController *signIn = [self.storyboard instantiateViewControllerWithIdentifier:@"SignUpViewController"];
    [self.navigationController pushViewController:signIn animated:YES];
}
- (IBAction)termsOfServiceBtnAction:(id)sender {
    
    WebViewViewController *signIn = [self.storyboard instantiateViewControllerWithIdentifier:@"WebViewViewController"];
    signIn.navTitle = @"Terms and Conditions";
    signIn.urlToLoad = @"https://datesauce.com/userApi/terms";
    [self.navigationController pushViewController:signIn animated:YES];
}

@end
