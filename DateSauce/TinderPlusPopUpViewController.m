//
//  TinderPlusPopUpViewController.m
//  DateSauce
//
//  Created by umama on 9/7/17.
//  Copyright © 2017 appoets. All rights reserved.
//

#import "TinderPlusPopUpViewController.h"
#import "RootViewController.h"
#import <AFNetworking/AFNetworking.h>
#import "AppDelegate.h"
#import "Constants.h"
#import "CommenMethods.h"

@interface TinderPlusPopUpViewController ()<UIScrollViewDelegate>

@end

@implementation TinderPlusPopUpViewController{
    int pageIndex;
    NSMutableArray *images;
    NSString *pro_User, *amount;
    AppDelegate *appDelegate;
}


- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        _payPalConfiguration = [[PayPalConfiguration alloc] init];
        _payPalConfiguration.acceptCreditCards = NO;
        _payPalConfiguration.payPalShippingAddressOption = PayPalShippingAddressOptionPayPal;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor clearColor];
    self.modalPresentationStyle = UIModalPresentationCurrentContext;
    self.modalPresentationStyle = UIModalPresentationFormSheet;
    
    appDelegate =(AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
    pro_User=[user valueForKey:@"pro_user"];
    
    if([pro_User isEqualToString:@"1"]){
        
        [_continueBtn setTitle:@"CLOSE" forState:UIControlStateNormal];
    }
    
    [self getUserAmount];
    
    pageIndex = 0;
    
    _continueBtn.layer.cornerRadius = _continueBtn.frame.size.height/2;
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = _continueBtn.layer.bounds;
    
    gradientLayer.colors = [NSArray arrayWithObjects:
                            (id)[UIColor colorWithRed:254/255.0 green:81/255.0 blue:67/255.0 alpha:1.0].CGColor,
                            (id)[UIColor colorWithRed:253/255.0 green:63/255.0 blue:76/255.0 alpha:1.0].CGColor,
                            (id)[UIColor colorWithRed:235/255.0 green:68/255.0 blue:97/255.0 alpha:1.0].CGColor,
                            nil];
    
    gradientLayer.locations = [NSArray arrayWithObjects:
                               [NSNumber numberWithFloat:0.0f],
                               [NSNumber numberWithFloat:0.5f],
                               [NSNumber numberWithFloat:1.0f],
                               nil];
    
    gradientLayer.cornerRadius = _continueBtn.layer.cornerRadius;
    [_continueBtn.layer addSublayer:gradientLayer];
    
    self.scrollView.pagingEnabled = NO;
    self.scrollView.clipsToBounds = YES;
    self.scrollView.delegate = self;
    self.scrollView.scrollEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.backgroundColor = [UIColor clearColor];
    
    images = [[NSMutableArray alloc]initWithObjects:[UIImage imageNamed:@"paywall_ads"],[UIImage imageNamed:@"paywall_like"],[UIImage imageNamed:@"paywall_passport"],[UIImage imageNamed:@"paywall_super"],[UIImage imageNamed:@"paywall_undo"], nil];
    
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
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapReceived:)];
    [tapGestureRecognizer setDelegate:self];
    [self.view addGestureRecognizer:tapGestureRecognizer];
    

}


-(void)tapReceived:(UITapGestureRecognizer *)tapGestureRecognizer
{
    [self dismissViewControllerAnimated:YES completion:nil];
}



- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    int pageWidth = self.scrollView.frame.size.width;
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


-(void)viewWillAppear:(BOOL)animated{
    
    [PayPalMobile preconnectWithEnvironment:PayPalEnvironmentNoNetwork];
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


- (IBAction)continueBtnAction:(id)sender {
    
    if([pro_User  isEqualToString: @"0"]) {
        
        PayPalPayment *payment = [[PayPalPayment alloc] init];
        payment.amount = [[NSDecimalNumber alloc] initWithString:amount];
        payment.currencyCode = @"USD";
        payment.shortDescription = @"Total Amount(JetPack)";
        payment.intent = PayPalPaymentIntentSale;
        
        
        PayPalPaymentViewController *paymentViewController = [[PayPalPaymentViewController alloc] initWithPayment:payment
                                                                                                    configuration:self.payPalConfiguration
                                                                                                         delegate:self];
        [self presentViewController:paymentViewController animated:YES completion:nil];
    }
   else {
       
       [self dismissViewControllerAnimated:YES completion:nil];
    }
}


- (void)payPalPaymentViewController:(PayPalPaymentViewController *)paymentViewController
                 didCompletePayment:(PayPalPayment *)completedPayment {
    // Payment was processed successfully; send to server for verification and fulfillment.
    [self verifyCompletedPayment:completedPayment];
    
    // Dismiss the PayPalPaymentViewController.
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)payPalPaymentDidCancel:(PayPalPaymentViewController *)paymentViewController
{
    // The payment was canceled; dismiss the PayPalPaymentViewController.
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)verifyCompletedPayment:(PayPalPayment *)completedPayment
{
    // Send the entire confirmation dictionary
    [appDelegate onStartLoader];
    NSData *confirmation = [NSJSONSerialization dataWithJSONObject:completedPayment.confirmation
                                                           options:0
                                                             error:nil];
    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:confirmation options:NSJSONReadingAllowFragments error:nil];
    NSLog(@"COMPLETE STRIPE...%@", jsonDict);
    
    NSDictionary *responseDict = [jsonDict valueForKey:@"response"];
    NSString *paypalId = [responseDict valueForKey:@"id"];
    NSString *stateStr = [responseDict valueForKey:@"state"];
    
    if ([stateStr isEqualToString:@"approved"])
    {
        NSString*url=[NSString stringWithFormat:@"%@userApi/pay_by_paypal", SERVICE_URL];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString*identi= [defaults valueForKey:@"id"];
        NSString*token=[defaults valueForKey:@"token"];
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        NSDictionary* params = @{@"id":identi,@"token":token,@"paypal_id":paypalId,@"paid_status":@"1"};
        [manager POST:url parameters:params progress:nil success:^(NSURLSessionDataTask *task, id responseObject)
         {
             [appDelegate onEndLoader];
             NSLog(@"responseObject ..%@", responseObject);
             
             if([[responseObject valueForKey:@"success"]boolValue])
             {
                 
                 NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
                 [user setValue:@"1" forKey:@"pro_user"];
                 
                 [self dismissViewControllerAnimated:YES completion:nil];
                 
             }
             else
             {
                 NSString *errorCode = [[responseObject valueForKey:@"error_code"]stringValue];
                 
                 if ([errorCode isEqualToString:@"104"])
                 {
                     NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
                     [user removeObjectForKey:@"isLoggedin"];
                     
                     RootViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"RootViewController"];
                     [self.navigationController pushViewController:controller animated:YES];
                 }
                 else
                 {
                     UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Alert!" message:@"Something went wrong, Please try again" preferredStyle:UIAlertControllerStyleAlert];
                     UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                     [alertController addAction:ok];
                     [self presentViewController:alertController animated:YES completion:nil];
                 }
             }
         }
              failure:^(NSURLSessionDataTask *task, NSError *error)
         {
             [appDelegate onEndLoader];
             
         }];
    }
    else
    {
        
    }
}


-(void)getUserAmount {
    
    if([appDelegate internetConnected])
    {
        NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
        NSString *identi=[user valueForKey:@"id"];
        NSString *token=[user valueForKey:@"token"];
        
        NSString *urlStr = [NSString stringWithFormat:@"%@?id=%@&token=%@",MD_USER_AMOUNT,identi,token];
        
        AFNHelper *afn=[[AFNHelper alloc]initWithRequestMethod:GET_METHOD];
        [afn getDataFromPath:urlStr withParamData:nil withBlock:^(id response, NSDictionary *Error,NSString *strCode) {

            if([[response valueForKey:@"success"]boolValue] == 1)
            {
                
                NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
                [user setValue:[response valueForKey:@"user_type"] forKey:@"amount"];
                
                amount = [response valueForKey:@"amount"];
                
                _amountLbl.text = [NSString stringWithFormat:@"$ %@ / month",[response valueForKey:@"amount"]];
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
