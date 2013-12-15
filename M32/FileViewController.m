//
//  FileViewController.m
//  M32
//
//  Created by i-Bejoy on 13-11-23.
//  Copyright (c) 2013年 zeng hui. All rights reserved.
//

#import "FileViewController.h"
#import "ZHNavigationViewController.h"
#import "SVProgressHUD.h"


@interface FileViewController ()
{
    UILabel *titleLable;
}
@end

@implementation FileViewController



- (void)popViewController
{
    if (self.zhNavigationController) {
        [self.zhNavigationController popViewController];
    }
    else {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}


- (void)openShareView
{
    if (shareView == nil) {
        shareView = [[ShareView alloc] initWithFrame:RectMake2x(0, screenHeight-64, 640, screenHeight)];

        [self.baseView addSubview:shareView];
    }
    
    
    [UIView animateWithDuration:KDuration animations:^{
        
        shareView.frame = RectMake2x(0, 128, 640, (2*screenHeight)-128);
        
    }];
}


- (void)fav
{
    
    if (SharedAppUser.ID == 0) {
        [[Message share] messageAlert:@"登陆后，才可以收藏哦！"];
        return;
    }

    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:[NSNumber numberWithInt:FavType_Law] forKey:@"FavType"];
    [dict setValue:[_dict objectForKey:@"id"] forKey:@"id"];
    [dict setValue:[_dict objectForKey:@"title"] forKey:@"title"];
    [dict setValue:[NSDate stringFromDate:[NSDate date] withFormat:@"YYYY/MM/dd"] forKey:@"date"];
    [dict setValue:[NSString stringWithFormat:@"%d", SharedAppUser.ID] forKey:@"userid"];

    [dict setValue:[_dict  objectForKey:@"fileUrl"] forKey:@"fileUrl"];
//    [dict setValue:[_dict  objectForKey:@"fileName"]  forKey:@"fileName"];

                     
    [Cookie setCookie:@"fav" dict:dict isRepeat:YES];
    
    [[Message share] messageAlert:@"收藏成功！"];

}

- (void)setNavigationBarView
{
    
    
    UIView  *navigationBarView = [[UIView alloc] init];
    if (iOS7) {
        navigationBarView.frame = CGRectMake(0, 20, 640, 44);
    }
    else {
        navigationBarView.frame = CGRectMake(0, 0, 640, 44);
    }
    
    
    NSString *navImageName = [NSString string];
    if (iOS7) {
        navImageName = @"nav-bg-1";
    }else {
        navImageName = @"nav-bg";
    }
    UIImage *img = [UIImage imageNamed:navImageName] ;
    
    navigationBarView.backgroundColor = [UIColor colorWithPatternImage:img];
    
    
    
    
    UIButton *leftBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [leftBarButton addTarget:self action:@selector(popViewController) forControlEvents:UIControlEventTouchUpInside];
    [leftBarButton setImage:[UIImage imageNamed:@"news_share_close"] forState:UIControlStateNormal];
    leftBarButton.frame = NavitionRectMake(10, 0, 44, 44);
    
    
    UIButton *rightBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [rightBarButton addTarget:self action:@selector(openShareView) forControlEvents:UIControlEventTouchUpInside];
    [rightBarButton setImage:[UIImage imageNamed:@"news_share"] forState:UIControlStateNormal];
    rightBarButton.frame = NavitionRectMake(270, 0, 44, 44);
    
    
    favButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [favButton addTarget:self action:@selector(fav) forControlEvents:UIControlEventTouchUpInside];
    [favButton setImage:[UIImage imageNamed:@"news_conent_fav"] forState:UIControlStateNormal];
    favButton.frame = NavitionRectMake(228, 0, 44, 44);
    [navigationBarView addSubview:favButton];

    
    
    
    [navigationBarView addSubview:leftBarButton];
    [navigationBarView addSubview:rightBarButton];
    
    titleLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    titleLable.text = @"PDF";
    titleLable.textAlignment = NSTextAlignmentCenter;
    titleLable.font = [UIFont boldSystemFontOfSize:20];
    titleLable.textColor = [UIColor whiteColor];
    [navigationBarView addSubview:titleLable];
    
    
    
    
    [self.baseView  addSubview:navigationBarView];
    
    
    
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

    
    contentWebView = [[UIWebView alloc] init];
    contentWebView.frame = RectMake2x(0, 88+40, 640, screenHeight*2-88);
    contentWebView.delegate = self;
    contentWebView.scalesPageToFit = YES;
    [self.baseView addSubview:contentWebView];
    
    
    
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    
    [self setNavigationBarView];

    
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    
    
    
    
    
    
    if ( ! self.zhNavigationController) {

        favButton.enabled = NO;
        favButton.alpha = .2;
        
    }
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@", KUrl,  [_dict objectForKey:@"fileUrl"]];
    
    
    
//    NSString *fileName = [_dict objectForKey:@"fileUrl"];
//    
//    NSRange rPdf = [fileName rangeOfString:@"pdf"];
//    
//    NSRange rDoc = [fileName rangeOfString:@"doc"];
//    NSRange rDocx = [fileName rangeOfString:@"docx"];
//    
//    NSRange rXls = [fileName rangeOfString:@"pdf"];
    
//    if (rPdf.length != 0) {
//        zanImageView.image = [UIImage imageNamed:@"law_filetype_pdf"];
//    }
//    else if (rDoc.length != 0 || rDocx.length != 0) {
//        zanImageView.image = [UIImage imageNamed:@"law_filetype_word"];
//    }
//    else if (rXls.length != 0 ) {
//        zanImageView.image = [UIImage imageNamed:@"law_filetype_xls"];
//        
//    }
    

    
    
    
    self.url = [NSURL URLWithString: urlString ];

    [contentWebView loadRequest:[NSURLRequest requestWithURL:_url]];

    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)webViewDidStartLoad:(UIWebView *)webView
{
    
}


- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [SVProgressHUD dismiss];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    
}



@end
