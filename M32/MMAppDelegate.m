//
//  MMAppDelegate.m
//  M32
//
//  Created by i-Bejoy on 13-11-18.
//  Copyright (c) 2013年 zeng hui. All rights reserved.
//

#import "MMAppDelegate.h"

#import "IIViewDeckController.h"

#import "NewsViewController.h"
#import "LeftViewController.h"
#import "RightViewController.h"
#import "ZHNavigationViewController.h"

#import "WeiboSDK.h"



@implementation MMAppDelegate

- (IIViewDeckController*)generateControllerStack {
    
    
    
    LeftViewController* leftController = [[LeftViewController alloc] init];
    RightViewController* rightController = [[RightViewController alloc] init];
    
    NewsViewController *centerController = [[NewsViewController alloc] init];
    ZHNavigationViewController *navVC = [[ZHNavigationViewController alloc] initWithRootViewController:centerController];
    

    IIViewDeckController* deckController =  [[IIViewDeckController alloc] initWithCenterViewController:navVC
                                                                                    leftViewController:leftController
                                                                                   rightViewController:rightController];
    deckController.rightSize = 210;
    deckController.leftSize = 210;
    
    [deckController disablePanOverViewsOfClass:NSClassFromString(@"_UITableViewHeaderFooterContentView")];
    return deckController;
    
    
}



- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    self.user = [[Users alloc] init];

    
//    全局的数据
    
//    [KNSUserDefaults setObject:nil forKey:@"fav"];
//
    SharedAppUser.ID = 8;
    SharedAppUser.name = @"zeng";
    
    
    
    
    IIViewDeckController* deckController = [self generateControllerStack];
    self.leftController = deckController.leftController;
    self.centerController = deckController.centerController;
    
    /* To adjust speed of open/close animations, set either of these two properties. */
    // deckController.openSlideAnimationDuration = 0.15f;
    // deckController.closeSlideAnimationDuration = 0.5f;
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:deckController];
    nav.navigationBarHidden = YES;
    self.window.rootViewController = nav;
    [self.window makeKeyAndVisible];
    
    
    
    [WXApi registerApp:KwxAppID];
    [WeiboSDK enableDebugMode:YES];
    [WeiboSDK registerApp:kSinaAppKey];
    
    
    
    
    return YES;
}


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




- (void)didReceiveWeiboRequest:(WBBaseRequest *)request
{
    if ([request isKindOfClass:WBProvideMessageForWeiboRequest.class])
    {
//        ProvideMessageForWeiboViewController *controller = [[[ProvideMessageForWeiboViewController alloc] init] autorelease];
//        [self.viewController presentModalViewController:controller animated:YES];
    }
}

- (void)didReceiveWeiboResponse:(WBBaseResponse *)response
{
    if ([response isKindOfClass:WBSendMessageToWeiboResponse.class])
    {
        NSString *title = @"发送结果";
        NSString *message = [NSString stringWithFormat:@"响应状态: %d\n响应UserInfo数据: %@\n原请求UserInfo数据: %@",
                             response.statusCode, response.userInfo, response.requestUserInfo];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
    }
    else if ([response isKindOfClass:WBAuthorizeResponse.class])
    {
        NSString *title = @"认证结果";
        NSString *message = [NSString stringWithFormat:@"响应状态: %d\nresponse.userId: %@\nresponse.accessToken: %@\n响应UserInfo数据: %@\n原请求UserInfo数据: %@",
                             response.statusCode, [(WBAuthorizeResponse *)response userID], [(WBAuthorizeResponse *)response accessToken], response.userInfo, response.requestUserInfo];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        
        self.user.accessToken = [(WBAuthorizeResponse *)response accessToken];
        
        [alert show];
    }
}




- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{

    return [WeiboSDK handleOpenURL:url delegate:self ];

    
    return [WXApi handleOpenURL:url delegate:self];
}

#define KsourceApplicationSina @"com.sina.weibo"

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    
    if ([sourceApplication isEqualToString:KsourceApplicationSina]) {
        return [WeiboSDK handleOpenURL:url delegate:self];
    }
    
    
    return [WXApi handleOpenURL:url delegate:self];
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
