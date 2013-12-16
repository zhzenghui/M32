//
//  DailyDetailViewController.m
//  M32
//
//  Created by i-Bejoy on 13-11-23.
//  Copyright (c) 2013年 zeng hui. All rights reserved.
//

#import "DailyDetailViewController.h"
#import "IIViewDeckController.h"
#import "ZHNavigationViewController.h"
#import "WebViewController.h"
#import "ShareView.h"
#import "NewsDetailViewController.h"
#import "AboutViewController.h"

@interface DailyDetailViewController ()
{
    ShareView *shareView;
    UIView *aboutView;
    
    
    UIButton *about;
    UIButton *relation;
    
}
@end

@implementation DailyDetailViewController

- (void)popViewController
{
    if (self.zhNavigationController) {
        
            [self.zhNavigationController popViewController];
    }
    else {
        [self.navigationController popViewControllerAnimated:YES];
    }

    
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
    
    
    
    
    
    leftBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [leftBarButton addTarget:self.viewDeckController  action:@selector(toggleLeftView) forControlEvents:UIControlEventTouchUpInside];
    [leftBarButton setImage:[UIImage imageNamed:@"nav-左标"] forState:UIControlStateNormal];
    leftBarButton.frame = NavitionRectMake(5, 20, 44, 44);
    
    
    rightBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [rightBarButton addTarget:self.viewDeckController action:@selector(toggleRightView) forControlEvents:UIControlEventTouchUpInside];
    [rightBarButton setImage:[UIImage imageNamed:@"nav-右标"] forState:UIControlStateNormal];
    rightBarButton.frame = NavitionRectMake(275, 20, 44, 44);
    
    
    [navigationBarView addSubview:leftBarButton];
    [navigationBarView addSubview:rightBarButton];
    
    
    
    [self.baseView  addSubview:navigationBarView];
    
    
}





- (void)fav
{
    
    if (SharedAppUser.ID == 0) {
        [[Message share] messageAlert:@"登陆后，才可以收藏哦！"];
        return;
    }

    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict  setValue:[NSNumber numberWithInt:FavType_Daily] forKey:@"FavType"];
    [dict setValue:[_dailyDict objectForKey:@"id"] forKey:@"id"];
    [dict setValue:[_dailyDict objectForKey:@"title"] forKey:@"title"];
    [dict setValue:[NSDate stringFromDate:[NSDate date] withFormat:@"YYYY/MM/dd"] forKey:@"date"];
    [dict setValue:[NSString stringWithFormat:@"%d", SharedAppUser.ID] forKey:@"userid"];

    [Cookie setCookie:@"fav" dict:dict isRepeat:YES];
    
    [[Message share] messageAlert:@"收藏成功!"];
}


#pragma mark - share

- (void)shareViewController
{
    
    if (shareView == nil) {
        shareView = [[ShareView alloc] initWithFrame:RectMake2x(0, screenHeight-64, 640, screenHeight)];
        
        [self.baseView addSubview:shareView];
    }
    
    
    [UIView animateWithDuration:KDuration animations:^{
        
        shareView.frame = RectMake2x(0, 128, 640, (2*screenHeight)-128);
        
    }];
    
}



- (void)commentBarView
{
    
    UIView *commentBarView = [[UIView alloc] initWithFrame:CGRectMake(0, self.baseView.frame.size.height-44, 320, 44)];
    commentBarView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"daily_toolbar_write_bar"]];
    [self.baseView addSubview:commentBarView];

    
    
    
    UIButton *fasongButton = [UIButton buttonWithType:UIButtonTypeCustom];
    fasongButton.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"news_conent_arrowup"]];
    [fasongButton addTarget:self action:@selector(popViewController) forControlEvents:UIControlEventTouchUpInside];
    
    fasongButton.frame = RectMake2x(0, 0, 81, 88);
    [commentBarView addSubview:fasongButton];
    
    
    favButton = [UIButton buttonWithType:UIButtonTypeCustom];
    favButton.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"news_conent_fav"]];
    [favButton addTarget:self action:@selector(fav) forControlEvents:UIControlEventTouchUpInside];
    
    favButton.frame = RectMake2x(484, 15, 65, 60);
    [commentBarView addSubview:favButton];
    
    UIButton *shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    shareButton.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"news_conent_share"]];
    [shareButton addTarget:self action:@selector(shareViewController) forControlEvents:UIControlEventTouchUpInside];
    
    shareButton.frame = RectMake2x(567, 15, 65, 60);
    [commentBarView addSubview:shareButton];
    

    commentView = [[UIView alloc] initWithFrame:RectMake2x(0, screenHeight*2, 640, 290)];
    commentView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"news_comment_write_bg"]];
    
//    
//    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    closeButton.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"news_share_close"]];
//    [closeButton addTarget:self action:@selector(closeCommentView) forControlEvents:UIControlEventTouchUpInside];
//    closeButton.frame = RectMake2x(26, 18, 64, 59);
//    [commentView addSubview:closeButton];
//    
//    
//    UIButton *fsButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    fsButton.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"news_share_save"]];
//    [fsButton addTarget:self action:@selector(fasongComment) forControlEvents:UIControlEventTouchUpInside];
//    fsButton.frame = RectMake2x(550, 18, 65, 60);
//    [commentView addSubview:fsButton];
//    
    
    

    
    
    
    
    [self.baseView addSubview:commentView];
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.baseView.backgroundColor = [UIColor whiteColor];
    
    content  = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 88, 320, screenHeight-128)];
    
    content.contentSize = CGSizeMake(320, 600);
    [self.baseView  addSubview:content];

    
    
    type_bgImageView = [[UIImageView alloc] initWithFrame:RectMake2x(0, 88, 640, 30)];
    type_bgImageView.image = [UIImage imageNamed:@"type_bg"];
    
    [self.baseView addSubview:type_bgImageView];
    
    

    
    

    
    contentWebView = [[UIWebView alloc] initWithFrame:RectMake2x(0, 0, 640, 30)];
    
    contentWebView.delegate = self;
    
    [content addSubview:contentWebView];

    
    
    
    
    type_lable = [[UILabel alloc] initWithFrame:RectMake2x(39, 4, 220, 22)];
    [type_lable setFont:[UIFont systemFontOfSize:11]];
    type_lable.text = @"分类 》 新品";
    [type_bgImageView addSubview:type_lable];

    date_lable = [[UILabel alloc] initWithFrame:RectMake2x(492, 4, 128, 22)];
    [date_lable setFont:[UIFont systemFontOfSize:11]];
    date_lable.text = @"";
    [type_bgImageView addSubview:date_lable];

    

    
    
    aboutView = [[UIView alloc] initWithFrame:RectMake(0, 100, 320, 98)];
    [content addSubview:aboutView];
    
    
    about = [UIButton buttonWithType:UIButtonTypeCustom];
    about.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"about"]];
    [about addTarget:self action:@selector(aboutMe) forControlEvents:UIControlEventTouchUpInside];
    
    about.frame = RectMake2x(25, 0, 284, 98);
    

    relation = [UIButton buttonWithType:UIButtonTypeCustom];
    relation.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"relation_news"]];
    relation.frame = RectMake2x(325, 0, 284, 98);
    [relation addTarget:self action:@selector(relation) forControlEvents:UIControlEventTouchUpInside];

    
    [aboutView addSubview:about];
    [aboutView addSubview:relation];

    

//284  98
    
    
    [self setNavigationBarView];
    
    [self commentBarView];
    
    
    if (iOS7) {
        
        UIImageView *statuebar_gb_ImageView = [[UIImageView alloc] init];
        statuebar_gb_ImageView.image = [UIImage imageNamed:@"statuebar_bg.jpg"];
        statuebar_gb_ImageView.frame = NavitionRectMake(0, 0, 320, 20);
        
        [self.view addSubview:statuebar_gb_ImageView];
    }
    
}

- (void)relation
{
    if ([_dailyDict objectForKey:@"infoId"] != nil) {
        
        
        NewsDetailViewController *n = [[NewsDetailViewController alloc] init];
        n.newsDict = @{@"id":[_dailyDict objectForKey:@"infoId"]};
        
        
        if (self.zhNavigationController) {
            
            [self.zhNavigationController pushViewController:n];
        }
        else {
            [self.navigationController pushViewController:n animated:YES];
        }
    }
}

- (void)aboutMe
{
    
    AboutViewController  * dailyController = [[AboutViewController alloc] init];
    [self presentViewController:dailyController animated:YES completion:^{
    }];

    
}


- (void)loadNetWorkData
{
    
    
    
    NSString *url = [NSString stringWithFormat:@"%@journal/getJournalDetail/%d/", KHomeUrl, [[_dailyDict objectForKey:@"id"] intValue]];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        NSDictionary *dict = [responseObject objectForKey:@"model"];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"YYYY/MM/dd aHH:mm"];
        
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:[[dict objectForKey:@"showTime"] longLongValue]/1000];
        
        NSString *formattedDateString = [dateFormatter stringFromDate:date];
        
        
        
        NSString *s = [NSString stringWithFormat: @"%@  %@", formattedDateString, [dict objectForKey:@"address"]];


        NSString *html = [NSString stringWithFormat:@"<html><style type='text/css'>\
                          body,html,div,h1{\
                          margin:0;\
                          padding:0;\
                          }\
                          \
                          .newsTex {\
                          margin: auto;\
                          width: 100%%;\
                              text-align:left;\
                          }\
                          \
                          .newsTex h1 {\
                          \
                              font-family: '微软雅黑','黑体';\
                              font-size: 22px;\
                          }\
                          .msgbar {\
                          color: #999999;\
                              font-size: 12px;\
                          margin:10px auto;\
                          }\
                          .newsCon {\
                              fonts-size:14px;\
                          }\
                          .main{\
                          height:auto;\
                          margin:20px 10px 10px 10px;\
                          }\
                          </style>\
                          <body>\
                          <div class='main'>\
                            <div class='newsTex'><h1>%@</h1></div>\
                          <div class='msgbar'>%@</div> \
                            <div class='newsCon'> %@</div> \
                          </div>\
                          </body></html>", [dict objectForKey:@"title"], s ,[dict objectForKey:@"content"]];

        
        [contentWebView loadHTMLString:html baseURL:nil];
        
        type_lable.text = [NSString stringWithFormat: @"日志 > %@", [NSDate dateWithTimestamp:[[dict objectForKey:@"showTime"] longLongValue]/1000]];

        
        if ([dict objectForKey:@"infoId"] == [NSNull null] || [dict objectForKey:@"infoId"] == nil) {
            relation.alpha = 0;
            
        }
        
        if ([[dict objectForKey:@"contract"] intValue]== 0) {
            about.alpha = 0;
        }
        
        _dailyDict = dict;
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
    
    
}



- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    
    [self checkFav];
    
    if (iOS7) {
        if (self.zhNavigationController) {
            content.frame = RectMake2x(0, 128+30, 640, (screenHeight*2)-206);
            type_bgImageView.frame = RectMake2x(0, 128, 640, 30);
            
        }
        else {
            content.frame = RectMake2x(0, 88+50, 640, (screenHeight*2)-206);
            type_bgImageView.frame = RectMake2x(0, 128, 640, 30);
            
            
            CGRect r = content.frame;
            r.origin = CGPointMake(r.origin.x, r.origin.y-20);
            
            content.frame = r;
            
            
            leftBarButton.alpha = 0;
            rightBarButton.alpha = 0;
            
            
            favButton.enabled = NO;
            favButton.alpha = .2;
        }
    }
    else {
        content.frame = RectMake2x(0, 88+30, 640, (screenHeight*2)-206);
        
    }

    [self loadNetWorkData];
//    NSString *html = [NSString stringWithFormat:@"<html><body>%@</body></html>", [_dailyDict objectForKey:@"content"]];
//    
//    [contentWebView loadHTMLString:html baseURL:nil];
//    
//    type_lable.text = [NSString stringWithFormat: @"日志 > %@", [NSDate dateWithTimestamp:[[_dailyDict objectForKey:@"showTime"] longLongValue]/1000]];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




- (void)checkFav
{
    
    bool isFav = false;
    
    NSMutableArray *array =  [Cookie getCookie:@"fav"];
    
    for ( NSMutableDictionary *dict in array) {
        
        if ([[dict objectForKey:@"id"] intValue] == [[_dailyDict objectForKey:@"id"] intValue] &&
            [[dict objectForKey:@"FavType"] intValue] == FavType_Daily ) {
            
            isFav = true;
            
        }
    }
    
    if (isFav) {
        
        favButton.enabled = NO;
        favButton.alpha = .2;
    }
    
}



#pragma mark -  webView

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType;
{
    if(navigationType==UIWebViewNavigationTypeLinkClicked)//判断是否是点击链接
    {
        NSLog( @"%@", request);
        
        NSString *urlString = [request.URL absoluteString];
        
        if (urlString) {
            urlString = [urlString substringWithRange:NSMakeRange(0, 4)].lowercaseString;
        }
        
        if ( ! [urlString isEqualToString:@"http"]) {
            
            return NO;
        }
        WebViewController *w = [[WebViewController alloc] init];
        
        w.url = request.URL;
        [self.zhNavigationController pushViewController:w];
        return NO;
    }
    else{
        return YES;
    }
    
    
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    
    NSLog( @"%@", webView.request.URL);
    
    
}


- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    
    
    CGRect frame = webView.frame;
    
    CGSize fittingSize = [webView sizeThatFits:CGSizeZero];
    
    frame.size = fittingSize;
    
    webView.frame = frame;
    
    [content setContentSize:CGSizeMake(320,  fittingSize.height+98)    ];
    
    
    
    CGRect f = aboutView.frame;
    f.origin = CGPointMake(0, fittingSize.height);
    
    aboutView.frame = f;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    
}


@end
