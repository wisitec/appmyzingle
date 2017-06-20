//
//  ViewController.m
//  DateSauce
//
//  Created by veena on 5/30/17.
//  Copyright © 2017 appoets. All rights reserved.
//

#import "ViewController.h"
#import "YSLContainerViewController.h"
#import "UserDetailsViewController.h"
#import "DateSauceViewController.h"
#import "MessageViewController.h"
#import "MessageView.h"

@interface ViewController ()<YSLContainerViewControllerDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // SetUp ViewControllers
    
    UserDetailsViewController *sampleVC1 = [self.storyboard instantiateViewControllerWithIdentifier:@"UserDetailsViewController"];
    sampleVC1.title = @"user";
    
    DateSauceViewController *sampleVC2 = [self.storyboard instantiateViewControllerWithIdentifier:@"DateSauceViewController"];
    sampleVC2.title = @"matches";
    
    MessageView *sampleVC3 = [self.storyboard instantiateViewControllerWithIdentifier:@"MessageView"];
    if([_IsFrom  isEqualToString: @"chat"])
    {
        sampleVC3.isFrom = @"chat";
    }
    sampleVC3.title = @"message";
    
    // ContainerView
    float statusHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
//    float navigationHeight = self.navigationController.navigationBar.frame.size.height;
    
    YSLContainerViewController *containerVC = [[YSLContainerViewController alloc]initWithControllers:@[sampleVC1,sampleVC2,sampleVC3]
                                                                                        topBarHeight:statusHeight
                                                                                parentViewController:self];
    containerVC.delegate = self;
    containerVC.menuItemFont = [UIFont fontWithName:@"Futura-Medium" size:0];
    containerVC.isFrom = @"1";
    
    if([_IsFrom  isEqualToString: @"chat"])
    {
        containerVC.isFrom = @"2";
    }
    
    if([_IsFrom  isEqualToString: @"editprofile"] || [_IsFrom  isEqualToString: @"settings"] || [_IsFrom  isEqualToString: @"profile"]){
        
        containerVC.isFrom = @"0";
    }
   
    [self.view addSubview:containerVC.view];
}

#pragma mark -- YSLContainerViewControllerDelegate
- (void)containerViewItemIndex:(NSInteger)index currentController:(UIViewController *)controller
{
    NSLog(@"current Index : %ld",(long)index);
    NSLog(@"current controller : %@",controller);
    [controller viewWillAppear:YES];
//    [controller viewDidLoad];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
