//
//  ProfileViewController.m
//  DateSauce
//
//  Created by veena on 5/30/17.
//  Copyright © 2017 appoets. All rights reserved.
//

#import "ProfileViewController.h"
#import "EditProfileViewController.h"
#import "RootViewController.h"
#import "ViewController.h"
#import "AppDelegate.h"
#import "AFNHelper.h"
#import <AFNetworking/AFNetworking.h>
#import "Constants.h"
#import "CommenMethods.h"

@interface ProfileViewController ()<UIScrollViewDelegate>{
    
    AppDelegate *appDelegate;
    NSMutableArray *imagesArray;
    int pageIndex;
}

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    appDelegate =(AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    pageIndex = 0;
   
    self.imageScrollView.scrollEnabled = YES;
    self.imageScrollView.pagingEnabled = NO;
    self.imageScrollView.clipsToBounds = YES;
    self.imageScrollView.delegate = self;
    
    [self getProfile];
    
    [self setUpDesign];
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
        if (pageIndex<imagesArray.count) {
            pageIndex++;
        }
    }
    targetContentOffset->x = pageIndex*pageWidth-scrollView.contentInset.left;
    NSLog(@"%d %d", pageIndex, (int)targetContentOffset->x);
}

-(void)setUpDesign{
    
    [_topView.layer setShadowColor:[UIColor blackColor].CGColor];
    [_topView.layer setShadowOpacity:0.3];
    [_topView.layer setShadowRadius:5.0];
    [_topView.layer setShadowOffset:CGSizeMake(2.0, 2.0)];
    [_topMostView setFrame:CGRectMake(self.view.frame.origin.x, 0, self.view.frame.size.width, self.topMostView.frame.size.height)];
    [_profileScrollView addSubview:self.topMostView];
    
    [_profileScrollView setContentSize:CGSizeMake(_topMostView.frame.size.width, _topMostView.frame.size.height)];
    
    [self.view bringSubviewToFront:self.editProfileBtn];
    
    _editProfileBtn.layer.cornerRadius = _editProfileBtn.frame.size.height/2;
    [_editProfileBtn.layer setShadowColor:[UIColor blackColor].CGColor];
    [_editProfileBtn.layer setShadowOpacity:0.3];
    [_editProfileBtn.layer setShadowRadius:5.0];
    [_editProfileBtn.layer setShadowOffset:CGSizeMake(2.0, 2.0)];
    
    _pageControlUsed = NO;
    
    self.imageScrollView.delegate = self;
    self.imageScrollView.showsHorizontalScrollIndicator = NO;
    self.imageScrollView.showsVerticalScrollIndicator = NO;

    self.imageScrollView.backgroundColor = [UIColor clearColor];
    
    [self.navigationController setNavigationBarHidden:YES];
}

- (IBAction)changePage:(id)sender
{
    [UIView beginAnimations:nil context:NULL];
    self.imageScrollView.contentOffset = CGPointMake(_imageScrollView.frame.size.width * self.imagePageControl.currentPage, 0);
    [UIView commitAnimations];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGPoint offset = self.imageScrollView.contentOffset;
    self.imagePageControl.currentPage = offset.x / _imageScrollView.frame.size.width ;
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
-(void)getProfile {
    
if([appDelegate internetConnected])
{
    NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
    NSString *identi=[user valueForKey:@"id"];
    NSString *token=[user valueForKey:@"token"];

    NSDictionary * params=@{@"id":identi,@"token":token};
    
    [appDelegate onStartLoader];
    AFNHelper *afn=[[AFNHelper alloc]initWithRequestMethod:GET_METHOD];
    [afn getDataFromPath:MD_GETPROFILE withParamData:params withBlock:^(id response, NSDictionary *Error,NSString *strCode) {
        [appDelegate onEndLoader];
        if([[response valueForKey:@"success"]boolValue] == 1)
        {
            _nameAgeLbl.text = [NSString stringWithFormat:@"%@, %@",[[response objectForKey:@"user"]valueForKey:@"name"],[[response objectForKey:@"user"]valueForKey:@"age"]];
            _companyLabel.text = [NSString stringWithFormat:@"%@",[[response objectForKey:@"user"]valueForKey:@"work"]];
            if([_companyLabel.text isEqual: @""]){
                
                 _companyLabel.text = [NSString stringWithFormat:@"%@",[[response objectForKey:@"user"]valueForKey:@"school"]];
                 _schoolLbl.text = @"";
                 _distanceLabel.text = @"";
            }else {
            _schoolLbl.text = [NSString stringWithFormat:@"%@",[[response objectForKey:@"user"]valueForKey:@"school"]];
            }
            if([_schoolLbl.text isEqual: @""]&&[_companyLabel.text isEqual: @""]){
                
                _companyLabel.text = @"less than a mile away";
                _schoolLbl.text = @"";
                _distanceLabel.text = @"";
            }else {
                if([_schoolLbl.text isEqual: @""]){
                    
                    _schoolLbl.text = @"less than a mile away";
                    _distanceLabel.text = @"";
                    
                }
                else {
                    _distanceLabel.text = @"less than a mile away";
                }
                
            }

            _descriptionLbl.text = [NSString stringWithFormat:@"%@",[[response objectForKey:@"user"]valueForKey:@"description"]];
            
            imagesArray = [[NSMutableArray alloc]init];
            
            NSString *ImageURL = [[response objectForKey:@"user"]valueForKey:@"picture"];
            
            if([ImageURL  isEqual: @""]){
                
                
            }
            else {
                
            NSURL *picURL = [NSURL URLWithString:ImageURL];
            NSData *data = [NSData dataWithContentsOfURL:picURL];
            UIImage *image = [UIImage imageWithData:data];
            [imagesArray addObject:image];
            }
            
            NSArray *otherImages = [[response objectForKey:@"user"]objectForKey:@"images"];
            
            for(int i= 0; i<[otherImages count]; i++){
                
                if([[otherImages objectAtIndex:i]  isEqual: @"https://datesauce.com/flamerui/img/user.png"]){
                    
                }
                else{
                    NSURL *picURL = [NSURL URLWithString:[otherImages objectAtIndex:i]];
                    NSData *data = [NSData dataWithContentsOfURL:picURL];
                    UIImage *image = [UIImage imageWithData:data];
                    [imagesArray addObject:image];
                }
            }
            
            CGFloat xValue = 0;
            for (UIImage *image in imagesArray) {
                
                UIImageView *imageViewObject = [[UIImageView alloc] initWithFrame:CGRectMake(xValue, 0, _imageScrollView.frame.size.width, _imageScrollView.frame.size.height)];
                
                imageViewObject.image = image;
                [self.imageScrollView addSubview:imageViewObject];
                
                xValue += self.imageScrollView.frame.size.width;
                
            }
            
            
            [self.imageScrollView setContentSize:CGSizeMake(xValue, self.imageScrollView.frame.size.height)];
            
            // This statement connect and execute the changePage: method's code
            [self.imagePageControl addTarget:self action:@selector(changePage:) forControlEvents:UIControlEventValueChanged];
            self.imagePageControl.currentPage = 0;
            self.imagePageControl.numberOfPages = imagesArray.count;
            
            [self.view bringSubviewToFront:self.imagePageControl];
        
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
- (IBAction)backBtnAction:(id)sender {
    
    ViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"ViewController"];
    controller.IsFrom = @"profile";
    [self.navigationController pushViewController:controller animated:YES];
}

- (IBAction)editProfileBtnAction:(id)sender {
    
    EditProfileViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"EditProfileViewController"];
    controller.isFrom = @"profile";
    [self.navigationController pushViewController:controller animated:YES];
}
@end
