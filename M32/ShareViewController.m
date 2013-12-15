//
//  ShareViewController.m
//  M32
//
//  Created by i-Bejoy on 13-11-24.
//  Copyright (c) 2013年 zeng hui. All rights reserved.
//

#import "ShareViewController.h"
#import "ZHNavigationViewController.h"
#import "WeiboSDK.h"


@interface ShareViewController ()

@end

@implementation ShareViewController


- (void)popViewController
{
    [self.zhNavigationController popModelViewController];
}


- (void) alertWithTitle: (NSString *)_title_ msg: (NSString *)msg
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:_title_
                                                    message:msg
                                                   delegate:nil
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil];
    [alert show];
}


#pragma mark - share



#pragma mark - email

//点击按钮后，触发这个方法
-(void)sendEMail
{
    Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
    
    if (mailClass != nil)
    {
        if ([mailClass canSendMail])
        {
            [self displayComposerSheet];
        }
        else
        {
            [self launchMailAppOnDevice];
        }
    }
    else
    {
        [self launchMailAppOnDevice];
    }
}
//可以发送邮件的话
-(void)displayComposerSheet
{
    MFMailComposeViewController *mailPicker = [[MFMailComposeViewController alloc] init];
    
    mailPicker.mailComposeDelegate = self;
    
    //设置主题
    [mailPicker setSubject: @"eMail主题"];
    
    // 添加发送者
    NSArray *toRecipients = [NSArray arrayWithObject: @"first@example.com"];
    //NSArray *ccRecipients = [NSArray arrayWithObjects:@"second@example.com", @"third@example.com", nil];
    //NSArray *bccRecipients = [NSArray arrayWithObject:@"fourth@example.com", nil];
    [mailPicker setToRecipients: toRecipients];
    //[picker setCcRecipients:ccRecipients];
    //[picker setBccRecipients:bccRecipients];
    
    // 添加图片
    UIImage *addPic = [UIImage imageNamed: @"123.jpg"];
    NSData *imageData = UIImagePNGRepresentation(addPic);            // png
    // NSData *imageData = UIImageJPEGRepresentation(addPic, 1);    // jpeg
    [mailPicker addAttachmentData: imageData mimeType: @"" fileName: @"123.jpg"];
    
    NSString *emailBody = @"eMail 正文";
    [mailPicker setMessageBody:emailBody isHTML:YES];
    


    [self presentViewController:mailPicker animated:YES completion:^{
        
    }];
}
-(void)launchMailAppOnDevice
{
    NSString *recipients = @"mailto:&subject=my email!";
    //@"mailto:first@example.com?cc=second@example.com,third@example.com&subject=my email!";
    NSString *body = @"&body=email body!";
    
    NSString *email = [NSString stringWithFormat:@"%@%@", recipients, body];
    email = [email stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    
    [[UIApplication sharedApplication] openURL: [NSURL URLWithString:email]];
}

- (void)mailComposeController:(MFMailComposeViewController *)controller
          didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    NSString *msg;
    
    switch (result)
    {
        case MFMailComposeResultCancelled:
            msg = @"邮件发送取消";
            break;
        case MFMailComposeResultSaved:
            msg = @"邮件保存成功";
            [self alertWithTitle:nil msg:msg];
            break;
        case MFMailComposeResultSent:
            msg = @"邮件发送成功";
            [self alertWithTitle:nil msg:msg];
            break;
        case MFMailComposeResultFailed:
            msg = @"邮件发送失败";
            [self alertWithTitle:nil msg:msg];
            break;
        default:
            break;
    }
    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)shareEmailView
{
    [self sendEMail];
    NSLog(@"share email");
}




#pragma mark - message


- (void)displaySMS:(NSString *)message  {
    
    MFMessageComposeViewController*picker = [[MFMessageComposeViewController alloc] init];
    picker.messageComposeDelegate= self;
    picker.navigationBar.tintColor= [UIColor blackColor];
    picker.body = message; // 默认信息内容
    // 默认收件人(可多个)
    //picker.recipients = [NSArray arrayWithObject:@"12345678901", nil];
    
    [self presentViewController:picker animated:YES completion:^{
        
    }];
}



- (void)sendsms:(NSString *)message {
    
    Class messageClass = (NSClassFromString(@"MFMessageComposeViewController"));
    NSLog(@"can send SMS [%d]", [messageClass canSendText]);
    
    if (messageClass != nil) {
        if ([messageClass canSendText]) {
            [self displaySMS:message];
        } else {
            [self alertWithTitle:nil msg:@"设备没有短信功能"];
        }
    } else {
        [self alertWithTitle:nil msg:@"iOS版本过低，iOS4.0以上才支持程序内发送短信"];
    }
    
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller
                 didFinishWithResult:(MessageComposeResult)result {
    NSString*msg;
    
    switch (result) {
        case MessageComposeResultCancelled:
            msg = @"发送取消";
            break;
        case MessageComposeResultSent:
            msg = @"发送成功";
            [self alertWithTitle:nil msg:msg];
            break;
        case MessageComposeResultFailed:
            msg = @"发送失败";
            [self alertWithTitle:nil msg:msg];
            break;
        default:
            break;
    }
    
    NSLog(@"发送结果：%@", msg);
    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];}

- (void)shareMessageView
{
    NSLog(@"share message");
    
}


#pragma mark - wx


-(void) onResp:(BaseResp*)resp
{
    if([resp isKindOfClass:[SendMessageToWXResp class]])
    {
        NSString *strTitle = resp.errCode ? @"Error" : @"Success";
        NSString *strError = @"There was an issue sharing your message. Please try again.";
        NSString *strSuccess = @"Your message was successfully shared!";
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle
                                                        message:resp.errCode ? strError : strSuccess
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil, nil];
        [alert show];
    }
}


- (void) sendWXTextContent :(int)scene
{
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.text = @"Beneath it were the words: Stay Hungry. Stay Foolish. It was their farewell message as they signed off. Stay Hungry. Stay Foolish.";
    req.bText = YES;

    req.scene = scene;
    
    [WXApi sendReq:req];
}


//朋友圈
- (void)shareWXTimeline
{
    NSLog(@"share wx timeline");

    [self sendWXTextContent:WXSceneTimeline];
}
//  好友

- (void)shareWXSession
{
    NSLog(@"share wx");

    
    [self sendWXTextContent:WXSceneSession];
    
}

- (void)shareWeiBoView
{
    NSLog(@"share weibo");

    
    if ([SharedAppUser.accessToken isEqualToString:@""] ) {
        
        WBAuthorizeRequest *request = [WBAuthorizeRequest request];
        request.redirectURI = kSinaRedirectURI;
        request.scope = @"all";
        request.userInfo = @{@"SSO_From": @"ShareViewController",
                             @"Other_Info_1": [NSNumber numberWithInt:123],
                             @"Other_Info_2": @[@"obj1", @"obj2"],
                             @"Other_Info_3": @{@"key1": @"obj1", @"key2": @"obj2"}};
        [WeiboSDK sendRequest:request];
    }
    
    else {
        WBMessageObject *message = [WBMessageObject message];
        
        message.text = @"test";
        

        WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest  requestWithMessage:message];
        request.userInfo = @{@"ShareMessageFrom":@"ShareViewController"};
        
        [WeiboSDK sendRequest:request];

    }

    
}

- (void)openShareView
{
    [UIView animateWithDuration:.3 animations:^{
        
        shareView.frame = RectMake2x(0, screenHeight*2-497, 640, 497);
    }];
}

- (void)closeShareView
{
    [UIView animateWithDuration:.3 animations:^{
        
        shareView.frame = RectMake2x(0, screenHeight*2, 640, 497);
    }];
}



- (void)shareViewBar
{
    
    shareView = [[UIView alloc] initWithFrame:RectMake2x(0, screenHeight*2-497, 640, 497)];
    shareView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"news_share_bg"]];
    
    
    
    
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    closeButton.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"news_share_close"]];
    [closeButton addTarget:self action:@selector(closeShareView) forControlEvents:UIControlEventTouchUpInside];
    closeButton.frame = RectMake2x(288, 404, 65, 60);
    [shareView addSubview:closeButton];
    
    
    UIButton *emailButton = [UIButton buttonWithType:UIButtonTypeCustom];
    emailButton.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"news_share_email"]];
    [emailButton addTarget:self action:@selector(shareEmailView) forControlEvents:UIControlEventTouchUpInside];
    emailButton.frame = RectMake2x(70, 105, 68, 96);
    [shareView addSubview:emailButton];
    
    
    UIButton *messageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    messageButton.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"news_share_message"]];
    [messageButton addTarget:self action:@selector(shareMessageView) forControlEvents:UIControlEventTouchUpInside];
    messageButton.frame = RectMake2x(215, 105, 68, 96);
    [shareView addSubview:messageButton];
    
    
    UIButton *wxButton = [UIButton buttonWithType:UIButtonTypeCustom];
    wxButton.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"news_share_wx"]];
    [wxButton addTarget:self action:@selector(shareWXSession) forControlEvents:UIControlEventTouchUpInside];
    wxButton.frame = RectMake2x(361, 105, 68, 96);
    [shareView addSubview:wxButton];
    
    
     UIButton *renrenButton = [UIButton buttonWithType:UIButtonTypeCustom];
    renrenButton.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"news_share_wx"]];
    [renrenButton addTarget:self action:@selector(shareWXTimeline) forControlEvents:UIControlEventTouchUpInside];
    renrenButton.frame = RectMake2x(506, 105, 68, 96);
    [shareView addSubview:renrenButton];
    
    
    
    
    UIButton *weiBoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    weiBoButton.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"news_share_weibo"]];
    [weiBoButton addTarget:self action:@selector(shareWeiBoView) forControlEvents:UIControlEventTouchUpInside];
    weiBoButton.frame = RectMake2x(70, 245, 68, 96);
    [shareView addSubview:weiBoButton];
    
    
    
    [self.baseView addSubview:shareView];
    
    
    
    
}




#pragma mark - view 

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)setNavigationBarView
{
    
    
    UIView  *navigationBarView = [[UIView alloc] init];
    if (iOS7) {
        navigationBarView.frame = CGRectMake(0, 0, 640, 64);
    }
    else {
        navigationBarView.frame = CGRectMake(0, 0, 640, 44);
    }
    
    
    NSString *navImageName = [NSString string];
    if (iOS7) {
        navImageName = @"nav-bg-7";
    }else {
        navImageName = @"nav-bg";
    }
    UIImage *img = [UIImage imageNamed:navImageName] ;
    
    navigationBarView.backgroundColor = [UIColor colorWithPatternImage:img];
    
    
    
    
    UIButton *leftBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [leftBarButton addTarget:self action:@selector(popViewController) forControlEvents:UIControlEventTouchUpInside];
    [leftBarButton setImage:[UIImage imageNamed:@"news_share_close"] forState:UIControlStateNormal];
    leftBarButton.frame = NavitionRectMake(14, 30, 27, 25);
    
    
    UIButton *rightBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
//    [rightBarButton addTarget:self action:@selector(openShareView) forControlEvents:UIControlEventTouchUpInside];
    [rightBarButton setImage:[UIImage imageNamed:@"news_share"] forState:UIControlStateNormal];
    rightBarButton.frame = NavitionRectMake(280, 30, 27, 25);
    
    
    [navigationBarView addSubview:leftBarButton];
    [navigationBarView addSubview:rightBarButton];
    
    
    [self.baseView  addSubview:navigationBarView];
    

}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
     self.view.opaque = YES;
    self.baseView.backgroundColor = [UIColor clearColor];

    //    share
    [self shareViewBar];
}




- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    
    [self setNavigationBarView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
