//
//  MMAppDelegate.h
//  M32
//
//  Created by i-Bejoy on 13-11-18.
//  Copyright (c) 2013年 zeng hui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZH3M2Model.h"
#import "WXApi.h"
#import "WeiboSDK.h"

@class IIViewDeckController;


@interface MMAppDelegate : UIResponder <UIApplicationDelegate, WXApiDelegate, WeiboSDKDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UIViewController *centerController;
@property (strong, nonatomic) UIViewController *leftController;




@property (nonatomic, strong) Users *user;



- (IIViewDeckController*)generateControllerStack;


@end
