//
//  User.h
//  NetWork
//
//  Created by mbp  on 13-8-2.
//  Copyright (c) 2013年 zeng hui. All rights reserved.
//


#define Kuser_user_id @"user_id"
#define Kuser_name @"name"
#define Kuser_account @"account"
#define Kuser_dept_id @"dept_id"
#define Kuser_version @"version"


#import <Foundation/Foundation.h>
#import "ZHdyrsModel.h"

@interface Users : NSObject

@property(nonatomic, assign) NSInteger ID;
@property(nonatomic, retain) NSString *name;
@property(nonatomic, retain) NSString *account;
@property(nonatomic, assign) NSInteger dept_id;
@property(nonatomic, retain) NSString *role;
@property(nonatomic, assign) long long version;
@property(nonatomic, retain) NSString *last_date;
@property(nonatomic, retain) NSString *created_at;
@property(nonatomic, retain) NSString *updated_at;
@property(nonatomic, retain) NSString *expiredDate;
@property(nonatomic, retain) NSString *accessToken;

@property(nonatomic, retain) Department *dept;


+ (id)share;


- (void)jsonToUser;

- (void)insertUser:(NSDictionary *)userDict;


- (void)deleteUser:(NSString *)userID;


- (Users *)getUserInfo:(NSDictionary *)userDict;
- (Department *)getUserDeptInfo:(Users *)userDict;



- (NSDictionary *)userToDict:(Users *)user;
- (Users *)dictToUser:(NSDictionary *)userDict;
- (NSMutableDictionary *)currentUser;


- (void)saveCurrentUser:(NSMutableDictionary *)userDict;
- (void)deleteCurrentUser:(NSDictionary *)userDict;


@end
