//
//  ZHdyrsModel.h
//  NetWork
//
//  Created by mbp  on 13-8-9.
//  Copyright (c) 2013年 zeng hui. All rights reserved.
//



//#ifdef KProjectNameDyrs


#import <Foundation/Foundation.h>



#pragma mark - Channel

@interface Channel : NSObject

@property(nonatomic, assign) int channel_id;
@property(nonatomic, retain) NSString *name;
@property(nonatomic, assign) int array_order;

@property(nonatomic, assign) int status;
@property(nonatomic, retain) NSString *create_time;


@end


#pragma mark - ChannelView

@interface ChannelView : NSObject

@property(nonatomic, assign) int user_id;
@property(nonatomic, assign) int channel_id;

@end


#pragma mark - Department

@interface Department : NSObject

@property(nonatomic, assign) int ID;
@property(nonatomic, retain) NSString *name;
@property(nonatomic, retain) NSString *info;
@property(nonatomic, retain) NSString *shop_name;
@property(nonatomic, assign) int district_id;

@property(nonatomic, retain) NSString *team_name;


@property(nonatomic, assign) int status;
@property(nonatomic, retain) NSString *create_time;

@end


#pragma mark - User

@interface UserDyrs : NSObject
{
    
}

@property(nonatomic, assign) int user_id;
@property(nonatomic, assign) int gender;
@property(nonatomic, retain) NSString *name;
@property(nonatomic, retain) NSString *account;
@property(nonatomic, retain) NSString *password;

@property(nonatomic, assign) int type;
@property(nonatomic, assign) int dept_id;



@property(nonatomic, assign) int status;
@property(nonatomic, retain) NSString *create_time;

//   汉诺地板 使用
@property(nonatomic, retain) NSString *expiredDate;




@end


#pragma mark - images

@interface Images : NSObject


@property(nonatomic, assign) int ID;
@property(nonatomic, retain) NSString *name;
@property(nonatomic, retain) NSString *url;
@property(nonatomic, assign) int object_type;

@property(nonatomic, assign) int object_id;

@property(nonatomic, assign) int status;
@property(nonatomic, retain) NSString *create_time;

@end

#pragma mark - setting

@interface values : NSObject

@property(nonatomic, assign) int ID;
@property(nonatomic, retain) NSString *key_key;
@property(nonatomic, retain) NSString *key_value;
@property(nonatomic, assign) int user_id;

@end

#pragma mark - personnel

@interface Member : NSObject

@property(nonatomic, assign) int ID;
@property(nonatomic, retain) NSString *name;
@property(nonatomic, retain) NSString *info;
@property(nonatomic, assign) int dept_id;

@property(nonatomic, assign) int gender;
@property(nonatomic, assign) int type;


@property(nonatomic, assign) int status;
@property(nonatomic, retain) NSString *create_time;


@end

#pragma mark - cases

@interface Cases : NSObject


@property(nonatomic, assign) int ID;
@property(nonatomic, retain) NSString *name;
@property(nonatomic, retain) NSString *info;
@property(nonatomic, assign) int house_type_id;

@property(nonatomic, assign) int area_id;
@property(nonatomic, assign) int style_id;
@property(nonatomic, assign) int city_id;
@property(nonatomic, assign) int dept_id;

@property(nonatomic, assign) int member_id;
@property(nonatomic, assign) double price;


@property(nonatomic, assign) int status;
@property(nonatomic, retain) NSString *create_time;

@end

#pragma mark - Category

@interface Category1 : NSObject

@property(nonatomic, assign) int ID;
@property(nonatomic, retain) NSString *name;
@property(nonatomic, assign) int fid;
@property(nonatomic, assign) int level;
@property(nonatomic, assign) int last;

@property(nonatomic, assign) int status;
@property(nonatomic, retain) NSString *create_time;

@end

#pragma mark - Accessories

@interface Accessories : NSObject

@property(nonatomic, assign) int ID;
@property(nonatomic, retain) NSString *title;
@property(nonatomic, retain) NSString *info;
@property(nonatomic, assign) int cate_id;

@property(nonatomic, assign) int status;
@property(nonatomic, retain) NSString *create_time;

@end





@interface ZHdyrsModel : NSObject

@end


//#endif

