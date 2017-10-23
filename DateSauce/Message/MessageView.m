//
//  MessageView.m
//  Binder
//
//  Created by Wepop on 22/06/16.
//  Copyright © 2016 WePop Info Solutions Pvt. Ltd. All rights reserved.
//

#import "MessageView.h"
#import "AppDelegate.h"
#import "MBProgressHUD.h"
#import "AsyncImageView.h"
#import "SignInViewController.h"
#import "RootViewController.h"
#import "ChatView.h"
#import "Colors.h"
#import "REFrostedViewController.h"

@interface MessageView ()
{
    UIView *viewMessage, *viewNoMsgsMatches;
    UIScrollView *sclVwMatches;
    UITableView *tableMessgaes;
    NSString *strid, *strToken, *strSattus;
    AppDelegate *appDelegate;
    NSArray *arrNewMatches, *arrMessages;
    UIFont *fontname13, *fontname14,*fontname15,*fontname17, *fontname18, *fontname15_16;
    NSString *strReciverID,*strReciverName,*strRecivePic, *strMsgCnt;
    BOOL loaded;
}
@end

@implementation MessageView

#pragma mark -
#pragma mark - Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    strid=[defaults valueForKey:@"id"];
    strToken=[defaults valueForKey:@"token"];
    strSattus=[defaults valueForKey:@"status"];
}
//-(void)viewWillAppear:(BOOL)animated
//{
////    if([_isFrom isEqualToString:@"chat"]){
////    if (!loaded)
////    {
////        loaded = YES;
////        [appDelegate onStartLoader];
////        
////        webservice *service=[[webservice alloc]init];
////        service.delegate=self;
////        service.tag=1;
////        NSString *strSend=[NSString stringWithFormat:@"?id=%@&token=%@",strid,strToken];
////        
////        [service executeWebserviceWithMethod1:METHOD_MESSAGES withValues:strSend];
////    }
////    }
////    else {
//    
//    
//        [appDelegate onStartLoader];
//        
//        webservice *service=[[webservice alloc]init];
//        service.delegate=self;
//        service.tag=1;
//        NSString *strSend=[NSString stringWithFormat:@"?id=%@&token=%@",strid,strToken];
//        
//        [service executeWebserviceWithMethod1:METHOD_MESSAGES withValues:strSend];
////    }
//    
//}
-(void)viewWillAppear:(BOOL)animated{
    
    
    [appDelegate onStartLoader];
    
    webservice *service=[[webservice alloc]init];
    service.delegate=self;
    service.tag=1;
    NSString *strSend=[NSString stringWithFormat:@"?id=%@&token=%@",strid,strToken];
    
    [service executeWebserviceWithMethod1:METHOD_MESSAGES withValues:strSend];

    
    self.navigationController.navigationBar.hidden = false;
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setFrame:CGRectMake(0,0,25,25)];
    backButton.userInteractionEnabled = YES;
    //[backButton setImage:[UIImage imageNamed:@"menu"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(menuClicked:) forControlEvents:UIControlEventTouchUpInside];
    _menuButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    _menuButtonItem.tag = 0;
    self.navigationItem.leftBarButtonItem = _menuButtonItem;
    
    
    self.navigationController.navigationBar.opaque = YES;
    [self.navigationController.navigationBar setTranslucent:NO];
    
    
    UIView *iv = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 165, 40)];
    [iv setBackgroundColor:[UIColor clearColor]];
    self.navigationItem.titleView = iv;
    
    UIImageView * titleImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 165,40)];
    titleImage.image = [UIImage imageNamed:@"logo"];
    titleImage.backgroundColor = [UIColor clearColor];
    
    [iv addSubview:titleImage];
    
    UIButton *rightButton = [[UIButton alloc] initWithFrame: CGRectMake(0, 0,50, 25)];
    //UIImage *rightButtonImage = [UIImage imageNamed:@"chat-conversation"];
    [rightButton setTitle:@"EDIT" forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightButton.titleLabel setFont:[UIFont fontWithName:@"OpenSans-Regular" size:14]];
   // [rightButton setBackgroundImage:rightButtonImage  forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(editClicked:) forControlEvents:UIControlEventTouchUpInside];
    //rightButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    UIBarButtonItem* ambulanceButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItems =[NSArray arrayWithObjects:ambulanceButtonItem, nil];
    
    
    
}
-(void)onPageLoad
{
        fontname13 = [UIFont fontWithName:@"OpenSans-Semibold" size:13];
        fontname14 = [UIFont fontWithName:@"OpenSans-Semibold" size:14];
        fontname15 = [UIFont fontWithName:@"OpenSans" size:15];
        fontname15_16 = [UIFont fontWithName:@"OpenSans-Semibold" size:14];
        fontname17 = [UIFont fontWithName:@"OpenSans-Semibold" size:17];
        fontname18 = [UIFont fontWithName:@"OpenSans-Semibold" size:18];
    
        
        [viewMessage removeFromSuperview];
        [viewNoMsgsMatches removeFromSuperview];
        
        viewMessage=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        viewMessage.backgroundColor=[UIColor whiteColor];
        [self.view addSubview:viewMessage];
    
        int yPos=10;
        
        UILabel *lblNewMatches=[[UILabel alloc]initWithFrame:CGRectMake(10,yPos, self.view.frame.size.width-20, 20)];
        lblNewMatches.text=@"New Matches";
        lblNewMatches.textAlignment=NSTextAlignmentLeft;
        [lblNewMatches setFont:fontname15_16];
        lblNewMatches.textColor= [UIColor colorWithRed:253.0/255.0 green:82.0/255.0 blue:138.0/255.0 alpha:1.0];
        [viewMessage addSubview:lblNewMatches];
        
        yPos+=19;
        [sclVwMatches removeFromSuperview];
        sclVwMatches=[[UIScrollView alloc]initWithFrame:CGRectMake(0, yPos, self.view.frame.size.width, 130)];
        sclVwMatches.backgroundColor=[UIColor clearColor];
        [viewMessage addSubview:sclVwMatches];
        
        int xPosScrl=15;
        
        if (arrNewMatches.count!=0)
        {
            for (int i=0; i<arrNewMatches.count; i++)
            {
                NSDictionary *dictMatch=[arrNewMatches objectAtIndex:i];
                
                UIImageView *imageview=[[UIImageView alloc]initWithFrame:CGRectMake(xPosScrl,10,  80, 80)];
                NSString *strImageURL=[dictMatch valueForKey:@"picture"];
                imageview.image=[UIImage imageNamed:@"PersonMsg.png"];
                if (![strImageURL isEqualToString:@""])
                {
                    AsyncImageView *async=[[AsyncImageView alloc]initWithFrame:CGRectMake(0, 0, imageview.frame.size.width, imageview.frame.size.height)];
                    [async loadImageFromURL:[NSURL URLWithString:strImageURL]];
                    async.backgroundColor=[UIColor clearColor];
                    [imageview addSubview:async];
                }
                
                imageview.layer.cornerRadius=40;
                imageview.clipsToBounds=YES;
                [sclVwMatches addSubview:imageview];
                
                
                UIButton *btnPhotoEdit=[UIButton buttonWithType:UIButtonTypeCustom];
                btnPhotoEdit.frame=CGRectMake(xPosScrl,10,  80, 80);
             
                [btnPhotoEdit setBackgroundColor:[UIColor clearColor]];
                [btnPhotoEdit addTarget:self action:@selector(onMatchClick:) forControlEvents:UIControlEventTouchDown];
                btnPhotoEdit.layer.cornerRadius=40;
                btnPhotoEdit.tag=i;
                btnPhotoEdit.clipsToBounds=YES;
                [sclVwMatches addSubview:btnPhotoEdit];
                
                
                NSString * strName = [dictMatch valueForKey:@"name"];
                NSArray * arrName = [strName componentsSeparatedByString:@" "];
                
                UILabel *lblName=[[UILabel alloc]initWithFrame:CGRectMake(xPosScrl,90,  80, 20)];
                lblName.text=[arrName objectAtIndex:0];
                lblName.textAlignment=NSTextAlignmentCenter;
                [lblName setFont:fontname14];
                lblName.textColor=[UIColor blackColor];
                [sclVwMatches addSubview:lblName];
                
                xPosScrl+=100;
                
            }
        }
        else
        {
            UITextView *TxtVDescription=[[UITextView alloc]initWithFrame:CGRectMake(15, 10, self.view.frame.size.width-30, 50 )];
            TxtVDescription.text=@"“There is no new matches”.";
            [TxtVDescription setFont:fontname15];
            TxtVDescription.userInteractionEnabled=NO;
            TxtVDescription.textColor=[UIColor grayColor];
            TxtVDescription.textAlignment=NSTextAlignmentCenter;
            [sclVwMatches addSubview:TxtVDescription];
        }
        
        sclVwMatches.contentSize=CGSizeMake(xPosScrl+25, 130);
        
        yPos+=130;
        UILabel *lblLine=[[UILabel alloc]initWithFrame:CGRectMake(0, yPos, self.view.frame.size.width, 1)];
        [[lblLine layer]setBorderWidth:0.3];
        [[lblLine layer]setBorderColor:[UIColor lightGrayColor].CGColor];
        [viewMessage addSubview:lblLine];
        
        yPos+=5;
        
        UILabel *lblMessages=[[UILabel alloc]initWithFrame:CGRectMake(10,yPos, self.view.frame.size.width-20, 20)];
        lblMessages.text=@"Messages";
        lblMessages.textAlignment=NSTextAlignmentLeft;
        [lblMessages setFont:fontname15_16];
        lblMessages.textColor=[UIColor colorWithRed:253.0/255.0 green:82.0/255.0 blue:138.0/255.0 alpha:1.0];
        [viewMessage addSubview:lblMessages];
        
        yPos+=25;
        
        if (arrMessages.count!=0)
        {
            
            tableMessgaes=[[UITableView alloc]initWithFrame:CGRectMake(5, yPos, self.view.frame.size.width-10, self.view.frame.size.height-yPos)];
            tableMessgaes.delegate=self;
            tableMessgaes.dataSource=self;
            tableMessgaes.separatorStyle=UITableViewCellSeparatorStyleNone;
            
            [viewMessage addSubview:tableMessgaes];
        }
        else
        {
            UITextView *TxtVDescription=[[UITextView alloc]initWithFrame:CGRectMake(15, yPos, self.view.frame.size.width-30, 50 )];
            TxtVDescription.text=@"“They swiped right for a reason. Start talking to your matches”.";
            [TxtVDescription setFont:fontname15];
            TxtVDescription.userInteractionEnabled=NO;
            TxtVDescription.textColor=[UIColor grayColor];
            TxtVDescription.textAlignment=NSTextAlignmentCenter;
            [viewMessage addSubview:TxtVDescription];
        }
    
}
-(void)menuClicked:(id)sender{
    // Dismiss keyboard (optional)
    //
//    [self.view endEditing:YES];
//    [self.frostedViewController.view endEditing:YES];
//    
//    // Present the view controller
//    //
//    [self.frostedViewController presentMenuViewController];
    [self.navigationController popViewControllerAnimated:true];
    
}
-(IBAction)editClicked:(id)sender{
    
}
-(IBAction)onMatchClick:(id)sender
{
    UIButton *btn=(UIButton *) sender;
    NSDictionary *dictLocal=[arrNewMatches objectAtIndex:btn.tag];
    strReciverID=[dictLocal valueForKey:@"id"];
    strReciverName=[dictLocal valueForKey:@"name"];
    strRecivePic=[dictLocal valueForKey:@"picture"];
    
    strMsgCnt=@"0";
    
    ChatView *chat = [self.storyboard instantiateViewControllerWithIdentifier:@"ChatView"];
    chat.strReciverID=strReciverID;
    chat.strReciverName=strReciverName;
    chat.strReciverPic=strRecivePic;
    chat.strTotalMsg=strMsgCnt;
    [self.navigationController pushViewController:chat animated:YES];
}

-(void)NoMsgsMatches
{
        [viewMessage removeFromSuperview];
        [viewNoMsgsMatches removeFromSuperview];
        
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
        lblHead.text=@"Get Swiping";
        [lblHead setFont:fontname17];
        lblHead.textColor=[UIColor blackColor];
        lblHead.textAlignment=NSTextAlignmentCenter;
        [viewNoMsgsMatches addSubview:lblHead];
        
        
        
        UILabel *lblDescription=[[UILabel alloc]initWithFrame:CGRectMake(15, (self.view.frame.size.height/2)+105, viewNoMsgsMatches.frame.size.width-30, 25 )];
        lblDescription.text=@"“Start swiping to get more matches!”";
        [lblDescription setFont:fontname15];
        lblDescription.textColor=[UIColor grayColor];
        lblDescription.textAlignment=NSTextAlignmentCenter;
        [viewNoMsgsMatches addSubview:lblDescription];
        
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -
#pragma mark - TableView Delegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    long ret;
        ret=70;
    return  ret;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return arrMessages.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        
        
    }
    
        NSDictionary *dictMsg=[arrMessages objectAtIndex:indexPath.row];
        
        
        UIImageView *imageview=[[UIImageView alloc]initWithFrame:CGRectMake(5,5,  50, 50)];
        NSString *strImageURL=[dictMsg valueForKey:@"picture"];
        imageview.image=[UIImage imageNamed:@"PersonMsg.png"];
        if (![strImageURL isEqualToString:@""])
        {
            AsyncImageView *async=[[AsyncImageView alloc]initWithFrame:CGRectMake(0, 0, imageview.frame.size.width, imageview.frame.size.height)];
            [async loadImageFromURL:[NSURL URLWithString:strImageURL]];
            async.backgroundColor=[UIColor clearColor];
            [imageview addSubview:async];
        }
        
        imageview.layer.cornerRadius=25;
        imageview.clipsToBounds=YES;
        [cell addSubview:imageview];
        
        
        UILabel *lblName=[[UILabel alloc]initWithFrame:CGRectMake(70,5,  150, 25)];
        lblName.text=[dictMsg valueForKey:@"name"];
        lblName.textAlignment=NSTextAlignmentLeft;
        [lblName setFont:fontname17];
        lblName.textColor=[UIColor blackColor];
        [cell addSubview:lblName];
        
        UILabel *lblMssg=[[UILabel alloc]initWithFrame:CGRectMake(70,30,  150, 25)];
        lblMssg.text=[dictMsg valueForKey:@"message"];
        lblMssg.textAlignment=NSTextAlignmentLeft;
        [lblMssg setFont:fontname15];
        lblMssg.textColor=[UIColor blackColor];
        [cell addSubview:lblMssg];
    
       UILabel *lblLine=[[UILabel alloc]initWithFrame:CGRectMake(70, 64, self.view.frame.size.width-90, 1)];
       [[lblLine layer]setBorderWidth:0.3];
       [[lblLine layer]setBorderColor:[UIColor lightGrayColor].CGColor];
       [cell addSubview:lblLine];
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
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


#pragma mark -
#pragma mark - WebService Delegate

-(void)receivedErrorWithMessage:(NSString *)message
{
    [appDelegate onEndLoader];
    
    UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"Datesauce" message:message preferredStyle:UIAlertControllerStyleAlert];
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
    [appDelegate onEndLoader];
    
    if (webservice.tag==1)
    {
        if ([[dictResponse valueForKey:@"success"] boolValue]==true)
        {
           
            arrMessages=[dictResponse valueForKey:@"messages"];
            arrNewMatches=[dictResponse valueForKey:@"new_matches"];
            if (arrNewMatches.count!=0 || arrMessages.count!=0)
            {
                 [self onPageLoad];
            }
            else
            {
                [self NoMsgsMatches];
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
            
            
            UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"Datesauce" message:[dictResponse valueForKey:@"error"] preferredStyle:UIAlertControllerStyleAlert];
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


@end
