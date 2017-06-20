//
//  MessageViewController.m
//  DateSauce
//
//  Created by veena on 6/15/17.
//  Copyright © 2017 appoets. All rights reserved.
//

#import "MessageViewController.h"
#import "AppDelegate.h"
#import "CommenMethods.h"
#import "AFNHelper.h"
#import "Constants.h"
#import "RootViewController.h"
#import "MessageTableViewCell.h"
#import "ChatView.h"

@interface MessageViewController (){
    
    AppDelegate *appDelegate;
}

@end

@implementation MessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    appDelegate =(AppDelegate *)[[UIApplication sharedApplication] delegate];

}

-(void)viewWillAppear:(BOOL)animated{
    [self getMessages];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrMessages.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"MessageTableViewCell";
    MessageTableViewCell *cell = [_messageListTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        cell = [[MessageTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    
    NSDictionary *dictMsg=[arrMessages objectAtIndex:indexPath.row];
    
    NSString *strImageURL=[dictMsg valueForKey:@"picture"];
    cell.recipientImage.image=[UIImage imageNamed:@"PersonMsg.png"];
    if (![strImageURL isEqualToString:@""])
    {
        
    }
    
    cell.recipientImage.layer.cornerRadius=25;
    cell.recipientImage.clipsToBounds=YES;
    
    cell.recipientNameLbl.text=[dictMsg valueForKey:@"name"];
    
    //cell.lblMssg.text=[dictMsg valueForKey:@"message"];
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dictLocal=[arrMessages objectAtIndex:indexPath.row];
    strReciverID=[dictLocal valueForKey:@"id"];
    strReciverName=[dictLocal valueForKey:@"name"];
    strRecivePic=[dictLocal valueForKey:@"picture"];
    strMsgCnt=[dictLocal valueForKey:@"total_message"];
    
    ChatView *chat = [self.storyboard instantiateViewControllerWithIdentifier:@"ChatView"];
    chat.strReciverID=strReciverID;
    chat.strReciverName=strReciverName;
    chat.strReciverPic=strRecivePic;
    chat.strTotalMsg=strMsgCnt;
    [self.navigationController pushViewController:chat animated:YES];
}


- (void)getMessages
{
    if([appDelegate internetConnected])
    {
        NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
        
        NSString *identi=[user valueForKey:@"id"];
        
        NSString *token=[user valueForKey:@"token"];
        
        NSDictionary * params=@{@"id":identi,@"token":token};
        

        [appDelegate onStartLoader];
        AFNHelper *afn=[[AFNHelper alloc]initWithRequestMethod:GET_METHOD];
        [afn getDataFromPath:MD_GET_MESSAGES withParamData:params withBlock:^(id response, NSDictionary *Error,NSString *strCode) {
            [appDelegate onEndLoader];
            NSLog(@"HELLO%@", response);
            if([[response valueForKey:@"success"]boolValue] == 1)
            {
                arrMessages=[response valueForKey:@"messages"];
                arrNewMatches=[response valueForKey:@"new_matches"];
                if (arrNewMatches.count!=0 || arrMessages.count!=0)
                {
                    viewNoMsgsMatches.hidden = YES;
                    //[self onPageLoad];
                    [self.messageListTableView reloadData];
                }
                else
                {
                    viewNoMsgsMatches.hidden = NO;

                    [self NoMsgsMatches];
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
                    [appDelegate onEndLoader];
                    [CommenMethods alertviewController_title:@"" MessageAlert:NSLocalizedString(@"ERRORMSG", nil) viewController:self okPop:NO];
                }
                else
                {
                    if ([Error objectForKey:@"email"]) {
                        [appDelegate onEndLoader];
                        [CommenMethods alertviewController_title:@"" MessageAlert:[[Error objectForKey:@"email"] objectAtIndex:0]  viewController:self okPop:NO];
                    }
                    else if ([Error objectForKey:@"password"]) {
                        [appDelegate onEndLoader];
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

- (void)NoMsgsMatches
{
        //[viewNoMsgsMatches removeFromSuperview];
        [self.messageListTableView setHidden:YES];
    
        viewNoMsgsMatches=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        viewNoMsgsMatches.backgroundColor=[UIColor whiteColor];
        [self.view addSubview:viewNoMsgsMatches];
        
        UIButton *btnLike=[UIButton buttonWithType:UIButtonTypeCustom];
        btnLike.frame=CGRectMake((self.view.frame.size.width/2)-100, (self.view.frame.size.height/2)-140, 200, 200);
        UIImage *imgLogo=[UIImage imageNamed:@"LikeMessage.png"];
        [btnLike setImage:imgLogo forState:UIControlStateNormal];
        btnLike.userInteractionEnabled=NO;
        [viewNoMsgsMatches addSubview:btnLike];
        
        UILabel *lblHead=[[UILabel alloc]initWithFrame:CGRectMake(15, (self.view.frame.size.height/2)+70, self.view.frame.size.width-30, 30 )];
        lblHead.text=@"Keep Swiping";
//        [lblHead setFont:fontname17];
        lblHead.textColor=[UIColor blackColor];
        lblHead.textAlignment=NSTextAlignmentCenter;
        [viewNoMsgsMatches addSubview:lblHead];
        
        
        
        UILabel *lblDescription=[[UILabel alloc]initWithFrame:CGRectMake(15, (self.view.frame.size.height/2)+105, viewNoMsgsMatches.frame.size.width-30, 25 )];
        lblDescription.text=@"“Start swiping to get more matches!”";
//        [lblDescription setFont:fontname15];
        lblDescription.textColor=[UIColor grayColor];
        lblDescription.textAlignment=NSTextAlignmentCenter;
        // [lblDescription sizeToFit];
        [viewNoMsgsMatches addSubview:lblDescription];
        
        
        
        
        //  int h=lblDescription.frame.size.height;
        

    
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
