//
//  NetWork.m
//  NetWork
//
//  Created by mbp  on 13-8-2.
//  Copyright (c) 2013年 zeng hui. All rights reserved.
//

#import "NetWork.h"
#import "Reachability.h"


static NetWork *netWork;
@implementation NetWork

@synthesize isConnect = _isConnect;

- (id) init
{
    self = [super init];
    if (self)
    {
    }
    return self;
}


+ (id)shareNetWork
{
    if (netWork) {
        return netWork;
    }
    netWork = [[NetWork alloc] init];
    return netWork;
}


-(BOOL)CheckNetwork   {
    Reachability * reach = [Reachability reachabilityWithHostname:@"www.baidu.com"];
    NetworkStatus networkStatus = [reach currentReachabilityStatus];
    
    if ( networkStatus == NotReachable ) {
        _isConnect = NO;
        return NO;
    }
    else {
        _isConnect = YES;
        return YES;
    }
    return YES;
}

#pragma make User


/* 验证本地用户信息
 *
 */
- (BOOL)checkLocalUsername:(NSString *)userName PWD:(NSString *)pwd
{
    
    if ( [[[KNSUserDefaults objectForKey:KCurrentUser] objectForKey:@"pwd"] isEqualToString:pwd]) {
        
        return YES;
    }
    return NO;
}

/* 检查本地是否存在用户信息
 *
 */
- (BOOL)checkLocalUserInfo:(NSString *)userName
{
    
    if ( [KNSUserDefaults objectForKey:userName] ) {
        
        return YES;
    }
    return NO;
}

/* 检查本地用户信息过期
 *  yes  可用
 *  no   不可用
 */
- (BOOL)checkLocalUserInfoExpired:(NSString *)userName
{
    
    //I am setting it as today's date, assumed tha app installed today
    NSDate *installedDate = [NSDate dateFromString:[[Users share] expiredDate]];
    
    
    //now finding and setting expiry date
    NSCalendar *calendar=[[NSCalendar alloc] initWithCalendarIdentifier: NSGregorianCalendar];
    NSDateComponents *components=[NSDateComponents new];
    components.month=1;
    NSDate *expiryDate=[calendar dateByAddingComponents:components toDate:installedDate options:0];
    

    NSLog(@"Ins : %@, Exp : %@", installedDate, expiryDate);

    
    NSDate *now = [NSDate date];
    
    if (!([now compare:expiryDate] == NSOrderedAscending)) {
        NSLog(@"*** Expired ***");
        return NO;

    }
    else{
        NSLog(@"*** This is trial version ***");
        return YES;
    }
    return NO;
}

/*  检查本地数据Version
 *  如果第一次登陆isFirstLogin=YES
 *  不允许跳过更新
 */

- (Users *)getUserInfo:(NSDictionary *)dictUser
{
    
    return [[Users share] getUserInfo: dictUser];
}


#pragma mark Login

- (BOOL)checkLocalIsFirstVersion
{
    return YES;
}

- (void)login
{
    
    
}



@end
