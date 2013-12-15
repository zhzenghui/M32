//
//  DailyDetailViewController.h
//  M32
//
//  Created by i-Bejoy on 13-11-23.
//  Copyright (c) 2013年 zeng hui. All rights reserved.
//

#import "BaseViewController.h"

@interface DailyDetailViewController : BaseViewController<UIWebViewDelegate>
{
    UIWebView *contentWebView;
    UIView *commentView;

    
    UIImageView *title_ImageView;
    UIImageView *type_bgImageView;
    
    UILabel *type_lable;
    UILabel *date_lable;

    
    UIScrollView *content ;

    
    UIButton *rightBarButton;
    UIButton *leftBarButton;
    
    UIButton *favButton;
}

@property(nonatomic,retain) NSDictionary *dailyDict;


@end
