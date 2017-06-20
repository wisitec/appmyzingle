//
//  ChatView.m
//  Binder
//
//  Created by Ramesh on 25/06/16.
//  Copyright © 2016 WePop Info Solutions Pvt. Ltd. All rights reserved.
//
#import "ChatView.h"
#import "ViewController.h"
#import "RootViewController.h"
//#import <SocketIOClientSwift/SocketIOClientSwift-Swift.h>
@import SocketIO;
#import <SocketIO/SocketIO-Swift.h>
//#import <SocketIOClientSwift/>
#import "AppDelegate.h"
#import "MBProgressHUD.h"
#import "AsyncImageView.h"
#import "SingleViewInChatting.h"
#import "Constants.h"
#import "CommenMethods.h"

@interface iMessage: NSObject

-(id) initIMessageWithName:(NSString *)name
                   message:(NSString *)message
                      time:(NSString *)time
                      type:(NSString *)type;

@property (strong, nonatomic) NSString *userName;
@property (strong, nonatomic) NSString *userMessage;
@property (strong, nonatomic) NSString *userTime;
@property (strong, nonatomic) NSString *messageType;

@end
@implementation iMessage

-(id) initIMessageWithName:(NSString *)name
                   message:(NSString *)message
                      time:(NSString *)time
                      type:(NSString *)type
{
    self = [super init];
    if(self)
    {
        self.userName = name;
        self.userMessage = message;
        self.userTime = time;
        self.messageType = type;
    }
    
    return self;
}

@end

@interface ChatView ()<UITextViewDelegate>
{
    SocketIOClient* socket;
    int nMsgCount;
    UITextField *currentTextView;
    UITextView *currentTextView1;
    bool keyboardIsShown;
    UITapGestureRecognizer *tapGesture;
    UIScrollView *scrollView;
    // AppDelegate *appDelegate;
    UIView *viewNavBar;
    
    
}
@property (weak, nonatomic) IBOutlet UITableView *chatTable;
@property (weak, nonatomic) IBOutlet UITextView *chatTextView;
@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *chatTextViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewBottomConstraint;

/*Uncomment second line and comment first to use XIB instead of code*/
@property (strong,nonatomic) ChatTableViewCell *chatCell;
//@property (strong,nonatomic) ChatTableViewCellXIB *chatCell;

@property (strong,nonatomic) ContentView *handler;

@end

@implementation ChatView
{
    AppDelegate *appDelegate;
    NSMutableArray *currentMessages;
    ChatCellSettings *chatCellSettings;
    NSArray *arrMessageList;
    
}
@synthesize chatCell,strReciverID,strReciverName,strReciverPic, strTotalMsg;

#pragma mark -
#pragma mark - Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    nMsgCount=300;

    NSLog(@"%@",strReciverID);
    
 
    NSString *ImageURL = strReciverPic;
    
    NSURL *picURL = [NSURL URLWithString:ImageURL];
    NSData *data = [NSData dataWithContentsOfURL:picURL];
    UIImage *image = [UIImage imageWithData:data];
    _recieverPicImgView.image = image;
    
    if ([ImageURL  isEqual: @""]) {
        
        _recieverPicImgView.image = [UIImage imageNamed:@"PersonMsg"];
    }
    
    _recieverPicImgView.layer.cornerRadius = _recieverPicImgView.frame.size.height/2;
    _recieverPicImgView.clipsToBounds = YES;
    
    NSString *name = strReciverName;
    _recieverNameLbl.text = name;
    
    currentMessages = [[NSMutableArray alloc] init];
    chatCellSettings = [ChatCellSettings getInstance];
    
    NSURL* url = [[NSURL alloc] initWithString:WEB_SOCKET];
    socket = [[SocketIOClient alloc] initWithSocketURL:url config:@{@"log": @YES,@"forcePolling":@YES}];
                                                        
    
//    socket = [[SocketIOClient alloc] initWithSocketURL:url options:@{@"log": @YES, @"forcePolling": @YES}];
    
    //    [socket on:@"connect" callback:^(NSArray* data, SocketAckEmitter* ack) {
    //        NSLog(@"socket connected");
    //    }];
    
    
    [socket on:@"connect" callback:^(NSArray *data, SocketAckEmitter *ack) {
        NSLog(@"socket connected");

        NSString *identi = [NSString stringWithFormat:@"%@",[CommenMethods getUserDefaultsKey:@"id"]];
        identi = [@"sender" stringByAppendingString:identi];
    
        [socket emit:@"update sender" with:@[@{@"sender": identi}]];
    }];
    
    [socket on:@"sender updated" callback:^(NSArray *data, SocketAckEmitter *ack) {
        NSLog(@"sender updated");
    }];
    
    [socket connect];
    
    
    //Get Message
    
    [socket on:@"message" callback:^(NSArray *data, SocketAckEmitter *ack)
     {
         
         NSDictionary *dictLocal=[data objectAtIndex:0];
         NSString *strMessage=[dictLocal valueForKey:@"message"];
         //[self addNewEventWithNickName:@"Ramesh -> " AndMessage:strMessage AndWhoSendMsg:@"sender"];
         
         iMessage *receiveMessage;
         
         
//         NSString *strValue=[dictLocal valueForKey:@"time"];
//         
//         NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
//         formatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'";
//         NSLocale* posix = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
//         formatter.locale = posix;
         
//         NSDate *date=[formatter dateFromString:strValue];
         
//         NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//         dateFormatter.dateFormat = @"hh:mm a";
//         //[dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
//         
//         NSString *strTime=[dateFormatter stringFromDate:date];
         
         
         
         // receiveMessage = [[iMessage alloc] initIMessageWithName:strReciverName message:strMessage time:@"23:14" type:@"other"];
         receiveMessage = [[iMessage alloc] initIMessageWithName:@"" message:strMessage time:@"" type:@"other"];
         
         [self updateTableView:receiveMessage];
     }];
    
    // register for keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    
    UITapGestureRecognizer * tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyBoard)];
    // tapRecognizer.cancelsTouchesInView = NO;
    [self.chatTable addGestureRecognizer:tapRecognizer];
    
    
    
    [chatCellSettings setSenderBubbleColorHex:@"00A2B7"];
    [chatCellSettings setReceiverBubbleColorHex:@"00A2B7"];
    [chatCellSettings setSenderBubbleNameTextColorHex:@"FFFFFF"];
    [chatCellSettings setReceiverBubbleNameTextColorHex:@"FFFFFF"];
    [chatCellSettings setSenderBubbleMessageTextColorHex:@"FFFFFF"];
    [chatCellSettings setReceiverBubbleMessageTextColorHex:@"FFFFFF"];
    [chatCellSettings setSenderBubbleTimeTextColorHex:@"FFFFFF"];
    [chatCellSettings setReceiverBubbleTimeTextColorHex:@"FFFFFF"];
    
    [chatCellSettings setSenderBubbleFontWithSizeForName:[UIFont boldSystemFontOfSize:11]];
    [chatCellSettings setReceiverBubbleFontWithSizeForName:[UIFont boldSystemFontOfSize:11]];
    [chatCellSettings setSenderBubbleFontWithSizeForMessage:[UIFont systemFontOfSize:14]];
    [chatCellSettings setReceiverBubbleFontWithSizeForMessage:[UIFont systemFontOfSize:14]];
    [chatCellSettings setSenderBubbleFontWithSizeForTime:[UIFont systemFontOfSize:11]];
    [chatCellSettings setReceiverBubbleFontWithSizeForTime:[UIFont systemFontOfSize:11]];
    
    [chatCellSettings senderBubbleTailRequired:YES];
    [chatCellSettings receiverBubbleTailRequired:YES];
    
    
    
    
    [[self chatTable] setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    
    //Instantiating custom view that adjusts itself to keyboard show/hide
//    self.handler = [[ContentView alloc] initWithTextView:self.chatTextView ChatTextViewHeightConstraint:self.chatTextViewHeightConstraint contentView:self.contentView ContentViewHeightConstraint:self.contentViewHeightConstraint andContentViewBottomConstraint:self.contentViewBottomConstraint];
    //
    /*Uncomment second para and comment first to use XIB instead of code*/
    //Registering custom Chat table view cell for both sending and receiving
    [[self chatTable] registerClass:[ChatTableViewCell class] forCellReuseIdentifier:@"chatSend"];
    
    [[self chatTable] registerClass:[ChatTableViewCell class] forCellReuseIdentifier:@"chatReceive"];
    
    //Setting the minimum and maximum number of lines for the textview vertical expansion
    [self.handler updateMinimumNumberOfLines:1 andMaximumNumberOfLine:3];
    
    //Tap gesture on table view so that when someone taps on it, the keyboard is hidden
    //    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    //
    //    [self.chatTable addGestureRecognizer:gestureRecognizer];
    
//    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
//    [refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
//    [_chatTable addSubview:refreshControl];
    
    
    self.chatTextView.delegate=self;
    
}

#pragma mark - Keyboard Delegate

- (void)keyboardWillShow:(NSNotification*)noti
{
    CGSize keyboardSize = [[[noti userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    _contentView.frame = CGRectMake(_contentView.frame.origin.x, self.view.frame.size.height-keyboardSize.height-_contentView.frame.size.height, _contentView.frame.size.width, _contentView.frame.size.height);
    
    UITableView *tableView = (UITableView *)[self.view viewWithTag:10001];
    UIEdgeInsets contentInsets;
    if (UIInterfaceOrientationIsPortrait([[UIApplication sharedApplication] statusBarOrientation])) {
        contentInsets = UIEdgeInsetsMake(0.0, 0.0, (keyboardSize.height), 0.0);
    } else {
        contentInsets = UIEdgeInsetsMake(0.0, 0.0, (keyboardSize.width), 0.0);
    }
    
    tableView.contentInset = contentInsets;
    tableView.scrollIndicatorInsets = contentInsets;
    
    NSIndexPath *editingIndexPath = [NSIndexPath indexPathForRow:[currentMessages count]-1 inSection:0];;
    [tableView scrollToRowAtIndexPath:editingIndexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
   
}

- (void)keyboardWillHide:(NSNotification*)noti
{
    _contentView.frame = CGRectMake(_contentView.frame.origin.x, self.view.frame.size.height-_contentView.frame.size.height, _contentView.frame.size.width, _contentView.frame.size.height);
    
    UITableView *tableView = (UITableView *)[self.view viewWithTag:10001];

    [UIView animateWithDuration:3.0f animations:^{
        tableView.contentInset = UIEdgeInsetsZero;
        tableView.scrollIndicatorInsets = UIEdgeInsetsZero;
    }];
}

-(void)viewWillAppear:(BOOL)animated
{
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    
    if([appDelegate.isFrmMessage isEqualToString:@"yes"])
    {
        //UIFont *fontname15 = [UIFont fontWithName:@"Roboto-Regular" size:15];
        UIFont *fontname16 = [UIFont fontWithName:@"Exo2-Regular" size:15];
        //UIFont *fontname18 = [UIFont fontWithName:@"Roboto-Medium" size:18];
        
        viewNavBar=[[UIView alloc]initWithFrame:CGRectMake(50, 1, 250, 40)];
        viewNavBar.backgroundColor=[UIColor clearColor];
        [self.navigationController.view addSubview:viewNavBar];
        
        
        UIImageView *imgRecvrPic=[[UIImageView alloc] initWithFrame:CGRectMake(10,1, 38, 38)];
        
        imgRecvrPic.image=[UIImage imageNamed:@"user.png"];
        
        
        if ([strReciverPic isEqualToString:@"https://datesauce.com//flamerui/img/user.png"])
        {
            imgRecvrPic.image=[UIImage imageNamed:@"user.png"];
        }
        else
        {
            AsyncImageView *async = [[AsyncImageView alloc]initWithFrame:CGRectMake(0, 0, imgRecvrPic.frame.size.width, imgRecvrPic.frame.size.height)];
            [async loadImageFromURL:[NSURL URLWithString:strReciverPic]];
            async.backgroundColor=[UIColor clearColor];
            [imgRecvrPic addSubview:async];
        }
        imgRecvrPic.layer.cornerRadius = 19;
        imgRecvrPic.clipsToBounds = YES;
        [viewNavBar addSubview:imgRecvrPic];
        
        
        
        UILabel *lblRecvrName=[[UILabel alloc]initWithFrame:CGRectMake(55, 1, 200, 38)];
        lblRecvrName.text=strReciverName;
        lblRecvrName.textAlignment=NSTextAlignmentLeft;
        [lblRecvrName setFont:fontname16];
        lblRecvrName.textColor=[UIColor blackColor];
        //lblFinding.tag=4002;
        [viewNavBar addSubview:lblRecvrName];
        
        
        UIButton *btnSingle=[UIButton buttonWithType:UIButtonTypeCustom];
        btnSingle.frame=viewNavBar.frame;
        [btnSingle addTarget:self action:@selector(onSingle:) forControlEvents:UIControlEventTouchDown];
        btnSingle.backgroundColor=[UIColor clearColor];
        [viewNavBar addSubview:btnSingle];
        
    }
    else if([appDelegate.is_from_push isEqualToString:@"yes"])
    {
        strTotalMsg=[appDelegate.dictNotiDetails valueForKey:@"total_message"];
        
        strReciverID=[appDelegate.dictNotiDetails valueForKey:@"Msg_Sender_id"];
        strReciverName=[appDelegate.dictNotiDetails valueForKey:@"Msg_Sender_Name"];
        strReciverPic=[appDelegate.dictNotiDetails valueForKey:@"Msg_Sender_Picture"];
        // strReciverPic=@"https://datesauce.com/uploads/c5722006a8eeb95a6eb235f5470d8fa7aa74ed18.jpg";
        
        //UIFont *fontname15 = [UIFont fontWithName:@"Roboto-Regular" size:15];
        UIFont *fontname16 = [UIFont fontWithName:@"Exo2-Regular" size:15];
        //UIFont *fontname18 = [UIFont fontWithName:@"Roboto-Medium" size:18];
        
        viewNavBar=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 42)];
        viewNavBar.backgroundColor=[UIColor colorWithRed:248/255.0 green:249/255.0 blue:248/255.0 alpha:1.0];
        [[viewNavBar layer]setBorderWidth:1.0];
        [[viewNavBar layer]setBorderColor:[UIColor colorWithRed:233/255.0 green:233/255.0 blue:233/255.0 alpha:1.0].CGColor];
        [self.navigationController.view addSubview:viewNavBar];
        
        UIButton *btnLogin=[UIButton buttonWithType:UIButtonTypeCustom];
        btnLogin.frame=CGRectMake(5, 5, 30, 30);
        UIImage *imgLogin=[UIImage imageNamed:@"BackButtonArrowBlack.png"];
        btnLogin.tintColor=[UIColor blackColor];
        [btnLogin setBackgroundImage:imgLogin forState:UIControlStateNormal];
        [btnLogin addTarget:self action:@selector(onBack) forControlEvents:UIControlEventTouchDown];
        [viewNavBar addSubview:btnLogin];
        
        //        UIBarButtonItem *barBtn = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"BackButtonArrow.png"] style:UIBarButtonItemStylePlain target:self action:@selector(onBack)];
        //        barBtn.tintColor=[UIColor blackColor];
        //        [self.navigationItem setLeftBarButtonItem:barBtn ];
        
        
        UIImageView *imgRecvrPic=[[UIImageView alloc] initWithFrame:CGRectMake(55,1, 38, 38)];
        
        imgRecvrPic.image=[UIImage imageNamed:@"user.png"];
        
        
        if ([strReciverPic isEqualToString:@"https://datesauce.com/flamerui/img/user.png"])
        {
            imgRecvrPic.image=[UIImage imageNamed:@"user.png"];
        }
        else
        {
            AsyncImageView *async = [[AsyncImageView alloc]initWithFrame:CGRectMake(0, 0, imgRecvrPic.frame.size.width, imgRecvrPic.frame.size.height)];
            [async loadImageFromURL:[NSURL URLWithString:strReciverPic]];
            async.backgroundColor=[UIColor clearColor];
            [imgRecvrPic addSubview:async];
        }
        imgRecvrPic.layer.cornerRadius = 19;
        imgRecvrPic.clipsToBounds = YES;
        [viewNavBar addSubview:imgRecvrPic];
        
        
        
        UILabel *lblRecvrName=[[UILabel alloc]initWithFrame:CGRectMake(105, 1, 200, 38)];
        lblRecvrName.text=strReciverName;
        lblRecvrName.textAlignment=NSTextAlignmentLeft;
        [lblRecvrName setFont:fontname16];
        lblRecvrName.textColor=[UIColor blackColor];
        //lblFinding.tag=4002;
        [viewNavBar addSubview:lblRecvrName];
        
        
        UIButton *btnSingle=[UIButton buttonWithType:UIButtonTypeCustom];
        btnSingle.frame=CGRectMake(55, 0, self.view.frame.size.width-55, 40);
        [btnSingle addTarget:self action:@selector(onSingle:) forControlEvents:UIControlEventTouchDown];
        btnSingle.backgroundColor=[UIColor clearColor];
        [viewNavBar addSubview:btnSingle];
        
        //        [[self navigationController] setNavigationBarHidden:NO animated:YES];
        //        self.navigationController.navigationBar.translucent = NO;
        
        
    }
    
    [self onCallWebService];
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    
    [viewNavBar removeFromSuperview];
    
    
}

- (IBAction)backEvent:(id)sender {
    [self.navigationController popViewControllerAnimated:true];
}

-(void)onBack
{
    appDelegate.isFrmMessage=@"";
    appDelegate.strIsFrmChat=@"yes";
    [self keyboardWillHide:nil];
    
    if([appDelegate.is_from_push isEqualToString:@"yes"])
    {
        [self performSegueWithIdentifier:@"ChatView_BinderHome" sender:self];
    }
    else
    {
        
        [self dismissViewControllerAnimated:YES completion:nil];
//        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (IBAction)closeChat:(id)sender {
    appDelegate.isFrmMessage=@"";
    appDelegate.strIsFrmChat=@"yes";
    [self keyboardWillHide:nil];
    
    if([appDelegate.is_from_push isEqualToString:@"yes"])
    {
        [self performSegueWithIdentifier:@"ChatView_BinderHome" sender:self];
    }
    else
    {
        
        [self dismissViewControllerAnimated:YES completion:nil];
        //        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)onCallWebService {

    webservice *service=[[webservice alloc]init];
    service.tag=1;
    service.delegate=self;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *strid=[defaults valueForKey:@"id"];
    NSString *strToken=[defaults valueForKey:@"token"];
    NSString *strRecId = strReciverID;
    
    
    int nTotMsg;
    if ([strTotalMsg intValue]!=0)
    {
        
        nTotMsg=[strTotalMsg intValue]-nMsgCount;
        if (nTotMsg<0)
            nTotMsg=0;
    }
    else
    {
        nTotMsg=0;
    }
    
    if (nTotMsg>=0)
    {
        [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        
        NSString *strSend3=[NSString stringWithFormat:@"%d",nTotMsg];
        
        NSString *strValues=[NSString stringWithFormat:@"{\"id\":\"%@\",\"token\":\"%@\",\"receiver_id\":\"%@\",\"limit\":\"%@\",\"skip\":\"%@\"}",strid,strToken,strReciverID,@"300",strSend3];
        
        [service executeWebserviceWithMethod:METHOD_GET_USER_MESSAGES withValues:strValues];
    }
    
}
-(void)onLoadUserMessages {
    
    for (int i=0; i<arrMessageList.count; i++)
    {
        NSDictionary *dictLocal=[arrMessageList objectAtIndex:i];
        if ([[dictLocal valueForKey:@"type"] isEqualToString:@"sent"])
        {
            iMessage *sendMessage;
            
            NSString *strValue=[dictLocal valueForKey:@"time"];
            
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
            formatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'";
            NSLocale* posix = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
            formatter.locale = posix;
            
            NSDate *date=[formatter dateFromString:strValue];
            
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            dateFormatter.dateFormat = @"hh:mm a";
            //[dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
            
            NSString *strTime=[dateFormatter stringFromDate:date];
            
            sendMessage = [[iMessage alloc] initIMessageWithName:@"" message:[dictLocal valueForKey:@"message"] time:strTime type:@"self"];
            [self updateTableView:sendMessage];
        }
        else  if ([[dictLocal valueForKey:@"type"] isEqualToString:@"received"])
        {
            NSString *strValue=[dictLocal valueForKey:@"time"];
            
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
            formatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'";
            NSLocale* posix = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
            formatter.locale = posix;
            
            NSDate *date=[formatter dateFromString:strValue];
            
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            dateFormatter.dateFormat = @"hh:mm a";
            //[dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
            
            NSString *strTime=[dateFormatter stringFromDate:date];
            iMessage *receiveMessage;
            // receiveMessage = [[iMessage alloc] initIMessageWithName:strReciverName message:strMessage time:@"23:14" type:@"other"];
            receiveMessage = [[iMessage alloc] initIMessageWithName:@"" message:[dictLocal valueForKey:@"message"] time:strTime type:@"other"];
            [self updateTableView:receiveMessage];
        }
    }
}

- (void)onLoadUserMessages1
{
    for (int i=0; i<arrMessageList.count; i++)
    {
        NSDictionary *dictLocal=[arrMessageList objectAtIndex:i];
        if ([[dictLocal valueForKey:@"type"] isEqualToString:@"sent"])
        {
            iMessage *sendMessage;
            
            NSString *strValue=[dictLocal valueForKey:@"time"];
            
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
            formatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'";
            NSLocale* posix = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
            formatter.locale = posix;
            
            NSDate *date=[formatter dateFromString:strValue];
            
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            dateFormatter.dateFormat = @"hh:mm a";
            //[dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
            
            NSString *strTime=[dateFormatter stringFromDate:date];
            
            sendMessage = [[iMessage alloc] initIMessageWithName:@"" message:[dictLocal valueForKey:@"message"] time:strTime type:@"self"];
            [self updateTableView1:sendMessage];
        }
        else  if ([[dictLocal valueForKey:@"type"] isEqualToString:@"received"])
        {
            NSString *strValue=[dictLocal valueForKey:@"time"];
            
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
            formatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'";
            NSLocale* posix = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
            formatter.locale = posix;
            
            NSDate *date=[formatter dateFromString:strValue];
            
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            dateFormatter.dateFormat = @"hh:mm a";
            //[dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
            
            NSString *strTime=[dateFormatter stringFromDate:date];
            iMessage *receiveMessage;
            // receiveMessage = [[iMessage alloc] initIMessageWithName:strReciverName message:strMessage time:@"23:14" type:@"other"];
            receiveMessage = [[iMessage alloc] initIMessageWithName:@"" message:[dictLocal valueForKey:@"message"] time:strTime type:@"other"];
            [self updateTableView1:receiveMessage];
        }
    }
}


- (void)refresh:(UIRefreshControl *)refreshControl
{
    
    
    webservice *service=[[webservice alloc]init];
    service.tag=2;
    service.delegate=self;
    
    
    //        appDelegate.strSwipeLong=@"13.0551";
    //        appDelegate.strSwipeLat=@"80.2221";
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *strid=[defaults valueForKey:@"id"];
    NSString * strToken=[defaults valueForKey:@"token"];
    
    nMsgCount+=300;
    
    int nTotMsg;
    if ([strTotalMsg intValue]!=0)
    {
        
        nTotMsg=[strTotalMsg intValue]-nMsgCount;
        if (nTotMsg<0)
            nTotMsg=0;
        
    }
    else
    {
        nTotMsg=0;
    }
    
    if (nTotMsg>=0)
    {
        [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        
        NSString *strSend3=[NSString stringWithFormat:@"%d",nTotMsg];
        
        NSString *strValues=[NSString stringWithFormat:@"{\"id\":\"%@\",\"token\":\"%@\",\"receiver_id\":\"%@\",\"limit\":\"%@\",\"skip\":\"%@\"}",strid,strToken,strReciverID,@"300",strSend3];
        
        [service executeWebserviceWithMethod:METHOD_GET_USER_MESSAGES withValues:strValues];
        [refreshControl endRefreshing];
        
    }
}

#pragma mark -
#pragma mark - Actions
-(IBAction)onSingle:(id)sender
{
    // [self keyboardWillHide:nil];
    [self performSegueWithIdentifier:@"Chat_SingleView" sender:self];
    
}




//#pragma mark - Keyboard Delegate
//-(void)keyboardWillShow:(NSNotification*)noti
//{
//    /*
//     NSDictionary *userInfo = [noti userInfo];
//     
//     // Get the origin of the keyboard when it's displayed.
//     NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
//     
//     // Get the top of the keyboard as the y coordinate of its origin in self's view's coordinate system. The bottom of the text view's frame should align with the top of the keyboard's final position.
//     CGRect keyboardRect = [aValue CGRectValue];
//     keyboardRect = [self.view convertRect:keyboardRect fromView:nil];
//     
//     
//     //if disconnect , reconnect again
//     //  [self checkConnection];
//     
//     [UIView beginAnimations:@"keyboardAnimation" context:nil];
//     [UIView setAnimationDuration:0.4];
//     CGRect frame = _contentView.frame;
//     frame.origin.y = frame.origin.y - keyboardRect.size.height;
//     _contentView.frame = frame;
//     
//     //    frame = txtView.frame;
//     //    frame.size.height = frame.size.height - keyboardRect.size.height;
//     //    txtView.frame = frame;
//     //
//     //    frame = btnSend.frame;
//     //    frame.origin.y = _txtMessage.frame.origin.y;
//     //    btnSend.frame = frame;
//     [UIView commitAnimations];
//     */
//    
//    CGSize keyboardSize = [[[noti userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
//    NSNumber *rate = noti.userInfo[UIKeyboardAnimationDurationUserInfoKey];
//    
//    UIEdgeInsets contentInsets;
//    if (UIInterfaceOrientationIsPortrait([[UIApplication sharedApplication] statusBarOrientation])) {
//        contentInsets = UIEdgeInsetsMake(0.0, 0.0, (keyboardSize.height), 0.0);
//    } else {
//        contentInsets = UIEdgeInsetsMake(0.0, 0.0, (keyboardSize.width), 0.0);
//    }
//    
//    [UIView animateWithDuration:rate.floatValue animations:^{
//        self.chatTable.contentInset = contentInsets;
//        self.chatTable.scrollIndicatorInsets = contentInsets;
//    }];
//    
//    NSIndexPath* ip = [NSIndexPath indexPathForRow:[self.chatTable numberOfRowsInSection:0]-1 inSection:0];
//    
//    if (ip.length > 2) {
//        [self.chatTable scrollToRowAtIndexPath:ip atScrollPosition:UITableViewScrollPositionTop animated:YES];
//    }
//    
//    [UIView animateWithDuration:rate.floatValue animations:^{
//        self.chatTable.contentInset = UIEdgeInsetsZero;
//        self.chatTable.scrollIndicatorInsets = UIEdgeInsetsZero;
//    }];
//}
//
//-(void)keyboardWillHide:(NSNotification*)noti
//{
//    /*
//     NSDictionary *userInfo = [noti userInfo];
//     
//     // Get the origin of the keyboard when it's displayed.
//     NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
//     
//     // Get the top of the keyboard as the y coordinate of its origin in self's view's coordinate system. The bottom of the text view's frame should align with the top of the keyboard's final position.
//     CGRect keyboardRect = [aValue CGRectValue];
//     keyboardRect = [self.view convertRect:keyboardRect fromView:nil];
//     
//     [UIView beginAnimations:@"keyboardAnimation" context:nil];
//     [UIView setAnimationDuration:0.4];
//     CGRect frame = _contentView.frame;
//     frame.origin.y = frame.origin.y + keyboardRect.size.height;
//     _contentView.frame = frame;
//     
//     //    frame =txtView.frame;
//     //    frame.size.height = frame.size.height + keyboardRect.size.height;
//     //    txtView.frame = frame;
//     
//     //    frame = btnSend.frame;
//     //    frame.origin.y = _txtMessage.frame.origin.y;
//     //    btnSend.frame = frame;
//     [UIView commitAnimations];
//     */
//    
//    NSNumber *rate = noti.userInfo[UIKeyboardAnimationDurationUserInfoKey];
//    [UIView animateWithDuration:rate.floatValue animations:^{
//        self.chatTable.contentInset = UIEdgeInsetsZero;
//        self.chatTable.scrollIndicatorInsets = UIEdgeInsetsZero;
//    }];
//}

- (IBAction)onsendMessage:(id)sender {
    
    if ([self.chatTextView.text length]!=0)
    {
        NSString *proid  = strReciverID;
        NSString *identi = [CommenMethods getUserDefaultsKey:@"id"];
        //        NSString*identi= [CommenMethods getUserDefaultsKey:@"id"];
//        NSString *reqid = [CommenMethods getUserDefaultsKey:@"request_id"];

        [socket emit:@"send message" with:@[@{@"sender": identi,@"receiver": proid,@"message": self.chatTextView.text}]];
        
        
        if([self.chatTextView.text length]!=0)
        {
            iMessage *sendMessage;
            
            NSDate *now = [NSDate date];
            
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            dateFormatter.dateFormat = @"hh:mm a";
            [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
            
            NSString *strTime=[dateFormatter stringFromDate:now];
            NSLog(@"The Current Time is %@",[dateFormatter stringFromDate:now]);
            
            //   sendMessage = [[iMessage alloc] initIMessageWithName:appDelegate.strName message:self.chatTextView.text time:@"23:14" type:@"self"];
            sendMessage = [[iMessage alloc] initIMessageWithName:@"" message:self.chatTextView.text time:@"" type:@"self"];
            
            [self updateTableView:sendMessage];
            [self.chatTextView setText:@""];
        }
    }
    
    lblText.hidden=NO;
    [btnSend setBackgroundImage:[UIImage imageNamed:@"chat_send_normal.png"] forState:UIControlStateNormal];
}

- (IBAction)backBtnAction:(id)sender
{
    appDelegate.isFrmMessage=@"";
    appDelegate.strIsFrmChat=@"yes";
    [self keyboardWillHide:nil];
    
    [self.navigationController popViewControllerAnimated:YES];
//    ViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"ViewController"];
//    controller.IsFrom = @"chat";
//    [self.navigationController pushViewController:controller animated:YES];
}

- (IBAction)btnReportUnmatchAction:(id)sender {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil
                                                                   message:nil
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *unmatch = [UIAlertAction actionWithTitle:@"Unmatch"
                                                         style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
                                 {
                                     [self unmatch];
                                 }];
    UIAlertAction *report = [UIAlertAction actionWithTitle:@"Report"
                                                          style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
                                  {
                               
                                  }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel"
                                                     style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
                             {
                                 [self dismissViewControllerAnimated:YES completion:NULL];
                             }];
    
    [alert addAction:unmatch];
    [alert addAction:report];
    [alert addAction:cancel];
    
    [alert.view setTintColor:[UIColor colorWithRed:235/255.0 green:68/255.0 blue:97/255.0 alpha:1.0]];
    
    [self presentViewController:alert animated:YES completion:nil];
    

}

- (void) updateTableView1:(iMessage *)msg
{
    // [self.chatTextView setText:@""];
    //   [self.handler textViewDidChange:self.chatTextView];
    
    [self.chatTable beginUpdates];
    
    NSIndexPath *row1 = [NSIndexPath indexPathForRow:currentMessages.count inSection:0];
    
    [currentMessages insertObject:msg atIndex:0];
    
    [self.chatTable insertRowsAtIndexPaths:[NSArray arrayWithObjects:row1, nil] withRowAnimation:UITableViewRowAnimationTop];
    
    [self.chatTable endUpdates];
    
    //Always scroll the chat table when the user sends the message
    if([self.chatTable numberOfRowsInSection:0]!=0)
    {
        NSIndexPath* ip = [NSIndexPath indexPathForRow:[self.chatTable numberOfRowsInSection:0]-1 inSection:0];
        [self.chatTable scrollToRowAtIndexPath:ip atScrollPosition:UITableViewScrollPositionTop animated:UITableViewRowAnimationLeft];
    }
}


- (void) updateTableView:(iMessage *)msg
{
    
    [self.handler textViewDidChange:self.chatTextView];
    
    [self.chatTable beginUpdates];
    
    NSIndexPath *row1 = [NSIndexPath indexPathForRow:currentMessages.count inSection:0];
    
    [currentMessages insertObject:msg atIndex:currentMessages.count];
    
    [self.chatTable insertRowsAtIndexPaths:[NSArray arrayWithObjects:row1, nil] withRowAnimation:UITableViewRowAnimationBottom];
    
    [self.chatTable endUpdates];
    
    //Always scroll the chat table when the user sends the message
    if([self.chatTable numberOfRowsInSection:0]!=0)
    {
        NSIndexPath* ip = [NSIndexPath indexPathForRow:[self.chatTable numberOfRowsInSection:0]-1 inSection:0];
        [self.chatTable scrollToRowAtIndexPath:ip atScrollPosition:UITableViewScrollPositionBottom animated:UITableViewRowAnimationLeft];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDatasource methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return currentMessages.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    tableView.tag = 10001;
    
    iMessage *message = [currentMessages objectAtIndex:indexPath.row];
    
    appDelegate.strPicture=[USER_DEFAULTS objectForKey:@"picture"];
    
    NSLog(@"%@",appDelegate.strPicture);
    
    if ([strReciverPic isEqualToString:@""])
    {
        strReciverPic=@"https://datesauce.com/flamerui/img/user.png";
    }
    
    
    if([message.messageType isEqualToString:@"self"])
    {
        /*Uncomment second line and comment first to use XIB instead of code*/
        chatCell = (ChatTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"chatSend"];
        //chatCell = (ChatTableViewCellXIB *)[tableView dequeueReusableCellWithIdentifier:@"chatSend"];
        //chatCell = [[ChatTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"chatSend"];
        
        
        chatCell.chatMessageLabel.text = message.userMessage;
        
        chatCell.chatNameLabel.text = message.userName;
        
        chatCell.chatTimeLabel.text = message.userTime;
        
        AsyncImageView *async = [[AsyncImageView alloc]initWithFrame:CGRectMake(0, 0, chatCell.chatUserImage.frame.size.width, chatCell.chatUserImage.frame.size.height)];
        [async loadImageFromURL:[NSURL URLWithString:appDelegate.strPicture]];
        async.backgroundColor=[UIColor clearColor];
        [chatCell.chatUserImage addSubview:async];
        
        // chatCell.chatUserImage.image = [UIImage imageNamed:@"defaultUser"];
        
        /*Comment this line is you are using XIB*/
        chatCell.authorType = iMessageBubbleTableViewCellAuthorTypeSender;
    }
    else
    {
        /*Uncomment second line and comment first to use XIB instead of code*/
        chatCell = (ChatTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"chatReceive"];
        //chatCell = (ChatTableViewCellXIB *)[tableView dequeueReusableCellWithIdentifier:@"chatReceive"];
        // chatCell = [[ChatTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"chatReceive"];
        
        chatCell.chatMessageLabel.text = message.userMessage;
        
        chatCell.chatNameLabel.text = message.userName;
        
        chatCell.chatTimeLabel.text = message.userTime;
        
        AsyncImageView *async = [[AsyncImageView alloc]initWithFrame:CGRectMake(0, 0, chatCell.chatUserImage.frame.size.width, chatCell.chatUserImage.frame.size.height)];
        [async loadImageFromURL:[NSURL URLWithString:strReciverPic]];
        async.backgroundColor=[UIColor clearColor];
        [chatCell.chatUserImage addSubview:async];
        
        // chatCell.chatUserImage.image = [UIImage imageNamed:@"defaultUser"];
        
        /*Comment this line is you are using XIB*/
        chatCell.authorType = iMessageBubbleTableViewCellAuthorTypeReceiver;
    }
    
    return chatCell;
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    iMessage *message = [currentMessages objectAtIndex:indexPath.row];
    
    CGSize size;
    
    CGSize Namesize;
    CGSize Timesize;
    CGSize Messagesize;
    
    NSArray *fontArray = [[NSArray alloc] init];
    
    //Get the chal cell font settings. This is to correctly find out the height of each of the cell according to the text written in those cells which change according to their fonts and sizes.
    //If you want to keep the same font sizes for both sender and receiver cells then remove this code and manually enter the font name with size in Namesize, Messagesize and Timesize.
    if([message.messageType isEqualToString:@"self"])
    {
        fontArray = chatCellSettings.getSenderBubbleFontWithSize;
    }
    else
    {
        fontArray = chatCellSettings.getReceiverBubbleFontWithSize;
    }
    
    //Find the required cell height
    Namesize = [@"Name" boundingRectWithSize:CGSizeMake(220.0f, CGFLOAT_MAX)
                                     options:NSStringDrawingUsesLineFragmentOrigin
                                  attributes:@{NSFontAttributeName:fontArray[0]}
                                     context:nil].size;
    
    
    
    Messagesize = [message.userMessage boundingRectWithSize:CGSizeMake(220.0f, CGFLOAT_MAX)
                                                    options:NSStringDrawingUsesLineFragmentOrigin
                                                 attributes:@{NSFontAttributeName:fontArray[1]}
                                                    context:nil].size;
    
    
    Timesize = [@"Time" boundingRectWithSize:CGSizeMake(220.0f, CGFLOAT_MAX)
                                     options:NSStringDrawingUsesLineFragmentOrigin
                                  attributes:@{NSFontAttributeName:fontArray[2]}
                                     context:nil].size;
    
    
    size.height = Messagesize.height + Namesize.height + Timesize.height +
    28.0f;
    
    return size.height;
}


#pragma mark - Webservice Delegate
-(void) receivedErrorWithMessage:(NSString *)message
{
    // [loaderView.view removeFromSuperview];
    [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
    
    UIAlertController *alert=[UIAlertController alertControllerWithTitle:APP_NAME message:message preferredStyle:UIAlertControllerStyleAlert];
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
-(void) receivedResponse:(NSDictionary *)dictResponse fromWebservice:(webservice *)webservice
{
    NSLog(@"Previous messages - %@",dictResponse);
    [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
    
    if (webservice.tag==1)
    {
        if ([[dictResponse valueForKey:@"success"] boolValue]==true)
        {
            
            if ([[dictResponse valueForKey:@"error_code"]integerValue] !=409)
            {
                arrMessageList=[dictResponse valueForKey:@"messages"];
                [self onLoadUserMessages];
                
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
            
            
            UIAlertController *alert=[UIAlertController alertControllerWithTitle:APP_NAME message:[dictResponse valueForKey:@"error"] preferredStyle:UIAlertControllerStyleAlert];
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
            
            if ([[dictResponse valueForKey:@"error_code"]integerValue] !=409)
            {
                arrMessageList=[dictResponse valueForKey:@"messages"];
                [self onLoadUserMessages1];
                
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
            
            
            UIAlertController *alert=[UIAlertController alertControllerWithTitle:APP_NAME message:[dictResponse valueForKey:@"error"] preferredStyle:UIAlertControllerStyleAlert];
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

#pragma mark -
#pragma mark - Keyboard

-(void)dismissKeyBoard
{
    //[self keyboardWillHide:nil];
    // [_txtMessage resignFirstResponder];
    [self.chatTextView resignFirstResponder];
}

-(BOOL) textFieldShouldReturn:(UITextView *)textField{
    
    // [self keyboardWillHide:nil];
    
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    // NSLog(@"Text View Chars: %lu",(unsigned long)text.length);
    
    
    if ([text isEqualToString:@" "])
    {
        if (![textView.text isEqualToString:@""])
        {
            if([text isEqualToString:@"\n"])
            {
                [textView resignFirstResponder];
                return NO;
            }
            if (text.length!=0)
            {
                lblText.hidden=YES;
                [btnSend setBackgroundImage:[UIImage imageNamed:@"chat_send_pressed.png"] forState:UIControlStateNormal];
            }
            else
            {
                if (range.location==0)
                {
                    lblText.hidden=NO;
                    [btnSend setBackgroundImage:[UIImage imageNamed:@"chat_send_normal.png"] forState:UIControlStateNormal];
                }
                
            }
            
        }
        else
        {
            return false;
        }
    }
    else
    {
        if([text isEqualToString:@"\n"])
        {
            [textView resignFirstResponder];
            return NO;
        }
        if (text.length!=0)
        {
            lblText.hidden=YES;
            [btnSend setBackgroundImage:[UIImage imageNamed:@"chat_send_pressed.png"] forState:UIControlStateNormal];
        }
        else
        {
            if (range.location==0)
            {
                lblText.hidden=NO;
                [btnSend setBackgroundImage:[UIImage imageNamed:@"chat_send_normal.png"] forState:UIControlStateNormal];
            }
            
        }
        
    }
    
    
    return YES;
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    //
    //    // unregister for keyboard notifications while not visible.
    //    [[NSNotificationCenter defaultCenter] removeObserver:self
    //                                                    name:UIKeyboardDidShowNotification
    //                                                  object:nil];
    //    // unregister for keyboard notifications while not visible.
    //    [[NSNotificationCenter defaultCenter] removeObserver:self
    //                                                    name:UIKeyboardWillHideNotification
    //                                                  object:nil];
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([[segue identifier] isEqualToString:@"Chat_SingleView"])
    {
        SingleViewInChatting *Single=[segue destinationViewController];
        Single.strRecvId=strReciverID;
        Single.strReciverName=strReciverName;
        
    }
    
}

- (void)unmatch
{
    if([appDelegate internetConnected])
    {
        NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
        NSString *identi=[user valueForKey:@"id"];
        NSString *token=[user valueForKey:@"token"];
        NSString *unmatchUserId=strReciverID;
        
        NSDictionary * params=@{@"id":identi,@"token":token,@"unmatch_user_id":unmatchUserId};
        
        [appDelegate onStartLoader];
        AFNHelper *afn=[[AFNHelper alloc]initWithRequestMethod:POST_METHOD];
        [afn getDataFromPath:MD_USER_UNMATCH withParamData:params withBlock:^(id response, NSDictionary *Error,NSString *strCode) {
            [appDelegate onEndLoader];
            if([[response valueForKey:@"success"]boolValue] == 1)
            {
                ViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"ViewController"];
                controller.IsFrom = @"chat";
                [self.navigationController pushViewController:controller animated:YES];
                //[self.navigationController popViewControllerAnimated:YES];
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

@end
