//
//  User.m
//  NetWork
//
//  Created by mbp  on 13-8-2.
//  Copyright (c) 2013年 zeng hui. All rights reserved.
//

#import "Users.h"
#import "ZHPassDataJSON.h"
#import "ZHDBData.h"


static Users *user;

@implementation Users
{
    ZHPassDataJSON *passJson;
}
//@synthesize ID;
//@synthesize name;
//@synthesize account;
//@synthesize dept_id;
//@synthesize role;
//@synthesize version;
//@synthesize created_at;
//@synthesize updated_at;
//@synthesize expiredDate;

+ (id)share
{
    if (user) {
        return user;
    }
    user = [[Users alloc] init];


    return user;
}

- (id) init
{
    self = [super init];
    if (self)
    {
        [self reloadUserInfo];
    }
    return self;
}

- (Users *)reloadUserInfo
{
//    if ([KNSUserDefaults objectForKey:KCurrentUser]) {
//        NSDictionary *userDict = [KNSUserDefaults objectForKey:KCurrentUser];
//        [self dictToUser:userDict];
//    }

    passJson = [[ZHPassDataJSON alloc] init];

    return self;
}




- (void)jsonToUser
{
    
}

- (Users *)getUserInfoForAccount:(NSString *)accountString
{
    return [[ZHDBData share] getUserInfoForAccount:accountString];
}

- (Users *)getUserInfo:(NSDictionary *)userDict
{
    return  [[ZHDBData share] getUser:userDict];
}

- (Department *)getUserDeptInfo:(Users *)user
{
    
    return [[ZHDBData share] getUserDeptInfo:user];
}


- (void)insertUser:(NSDictionary *)userDict
{
    
    [[ZHDBData share] saveUser:userDict];
}



- (void)deleteUser:(NSString *)userID
{
    
}


- (NSDictionary *)userToDict:(Users *)user
{
    NSMutableDictionary  *userDict = [NSMutableDictionary dictionary];
    
    [userDict setValue:[NSNumber numberWithInt:user.ID]  forKey:@"user_id"];
    [userDict setValue:user.name forKey:@"name"];
    [userDict setValue:[NSNumber numberWithLongLong:user.version]  forKey:@"version"];
    [userDict setValue:user.account forKey:@"account"];
    [userDict setValue:[NSNumber numberWithInt:user.dept_id]  forKey:@"dept_id"];


    return userDict;
}


- (Users *)dictToUser:(NSDictionary *)userDict
{

    self.ID =  [[userDict objectForKey:@"user_id"] intValue];
    self.name = [userDict objectForKey:@"name"];
    self.version = [[userDict objectForKey:@"version"] longLongValue];
    self.account = [userDict objectForKey:@"account"];
    self.dept_id = [[userDict objectForKey:@"dept_id"] intValue];
//    self.role = [userDict objectForKey:@"role"];
//    self.created_at = [userDict objectForKey:@"created_at"];
//    self.updated_at = [userDict objectForKey:@"updated_at"];
//    self.expiredDate = [userDict objectForKey:@"expiredDate"];
    
    return self;
}


- (NSMutableDictionary *)currentUser
{
    
    return [KNSUserDefaults objectForKey:KCurrentUser];
}

- (void)saveCurrentUser:(NSMutableDictionary *)userDict
{
    
    
//    if (KisHaro) {
//        [userDict setValue:[NSDate date] forKey:@"expiredDate"];
//    }

//    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:userDict];
//    NSMutableDictionary *currentUserDict = [KNSUserDefaults objectForKey:KCurrentUser];
//
//    
//    if ( ! [currentUserDict objectForKey:KCurrentUser_version]) {
//        [dict setValue:@"0" forKey:KCurrentUser_version];
//
//    }
//    else {
//        [dict setValue:[currentUserDict objectForKey:KCurrentUser_version] forKey:KCurrentUser_version];
//    }
//
//    
//    [KNSUserDefaults setValue:dict forKey:[dict objectForKey:@"name"]];
//    [KNSUserDefaults setValue:dict forKey:KCurrentUser];
    
    [self reloadUserInfo];
}

- (void)deleteCurrentUser:(NSDictionary *)userDict
{
    [KNSUserDefaults setValue:nil forKey:[userDict objectForKey:@"name"]];
    [KNSUserDefaults setValue:nil forKey:KCurrentUser];
}

@end
