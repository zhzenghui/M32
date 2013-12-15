//
//  NetWork.h
//  NetWork
//
//  Created by mbp  on 13-8-2.
//  Copyright (c) 2013年 zeng hui. All rights reserved.
//
#if H
#define PROJECT_NAME @"H"
#else
#define PROJECT_NAME @"D"
#endif


#import <Foundation/Foundation.h>



@interface NetWork : NSObject
{
    
}





@property(nonatomic ,assign) bool isConnect;
@property(nonatomic ,assign) bool isFirstLogin;


+ (id)shareNetWork;


- (BOOL)CheckNetwork;


/* 验证本地用户信息
 *
 */
- (BOOL)checkLocalUsername:(NSString *)userName PWD:(NSString *)pwd;

/* 检查本地是否存在用户信息
 *
 */
- (BOOL)checkLocalUserInfo:(NSString *)userName;

/* 检查本地用户信息过期
 
 */
- (BOOL)checkLocalUserInfoExpired:(NSString *)userName;

/*  检查本地数据Version
 *  如果第一次登陆isFirstLogin=YES
 *  不允许跳过更新
 */
- (BOOL)checkLocalIsFirstVersion;


- (void)login;




@end
