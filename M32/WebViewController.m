//
//  WebViewController.m
//  M32
//
//  Created by i-Bejoy on 13-12-8.
//  Copyright (c) 2013年 zeng hui. All rights reserved.
//

#import "WebViewController.h"
#import "SVProgressHUD.h"
#import "ZHNavigationViewController.h"


@interface WebViewController ()

@end

@implementation WebViewController



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
    
    
    
    
    UIButton *leftBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [leftBarButton addTarget:self action:@selector(popViewController) forControlEvents:UIControlEventTouchUpInside];
    [leftBarButton setImage:[UIImage imageNamed:@"news_share_close"] forState:UIControlStateNormal];
    leftBarButton.frame = NavitionRectMake(14, 30, 27, 25);
    
    
    UIButton *rightBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    

    
    
    
    [navigationBarView addSubview:leftBarButton];
    [navigationBarView addSubview:rightBarButton];
    
    
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
    
    

    
    [contentWebView loadRequest:[NSURLRequest requestWithURL:self.url]];
    
    
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
