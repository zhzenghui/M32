//
//  ShareViewController.h
//  M32
//
//  Created by i-Bejoy on 13-11-24.
//  Copyright (c) 2013年 zeng hui. All rights reserved.
//

#import "BaseViewController.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "WXApi.h"
#import "WeiboSDK.h"


@interface ShareViewController : BaseViewController
{
    
    UIView *shareView;

}

@property(nonatomic, strong) NSDictionary *shareDict;


@end
