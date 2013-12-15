//
//  FileViewController.h
//  M32
//
//  Created by i-Bejoy on 13-11-23.
//  Copyright (c) 2013年 zeng hui. All rights reserved.
//

#import "BaseViewController.h"
#import "ShareView.h"

@interface FileViewController : BaseViewController<UIWebViewDelegate>
{
    UIWebView *contentWebView;
    ShareView *shareView;

    UIButton *favButton;
}

@property(nonatomic,retain) NSURL *url;
@property(nonatomic,retain) NSDictionary *dict;

@end
