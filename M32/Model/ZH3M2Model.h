//
//  ZH3M2Model.h
//  M32
//
//  Created by i-Bejoy on 13-11-26.
//  Copyright (c) 2013年 zeng hui. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZH3M2Model : NSObject


@end




@interface User3m2 : NSObject
{
    
    
}

@property(nonatomic, assign) int user_id;
@property(nonatomic, assign) int gender;
@property(nonatomic, retain) NSString *name;
@property(nonatomic, retain) NSString *account;
@property(nonatomic, retain) NSString *password;

@property(nonatomic, assign) int type;
@property(nonatomic, assign) int dept_id;

@property(nonatomic, retain) NSString *accessToken;


@property(nonatomic, assign) int status;
@property(nonatomic, retain) NSString *create_time;

//   汉诺地板 使用
@property(nonatomic, retain) NSString *expiredDate;




@end