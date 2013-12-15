//
//  ZHaroModel.h
//  Dyrs
//
//  Created by mbp  on 13-8-19.
//  Copyright (c) 2013年 zeng hui. All rights reserved.
//

#import <Foundation/Foundation.h>

 

//#ifdef KProjectNameHaro 



/*product 
 ( 
 product_id INTEGER DEFAULT '0', 
 cate_id INTEGER DEFAULT NULL, 
 series TEXT DEFAULT NULL, 
 no TEXT DEFAULT NULL, 
 color INTEGER DEFAULT NULL,
 info_cn TEXT DEFAULT NULL, 
 info_en TEXT DEFAULT NULL,
 price DOUBLE DEFAULT NULL, 
 standard TEXT DEFAULT NULL, 
 wood TEXT DEFAULT NULL, 
 process TEXT DEFAULT NULL, 
 deal TEXT DEFAULT NULL,
 level TEXT DEFAULT NULL, 
 array_order INTEGER DEFAULT NULL, 
 status INTEGER DEFAULT NULL,
 create_time INTEGER DEFAULT NULL );
*/
#pragma mark - Product


@interface Product : NSObject


@property(nonatomic, assign) int product_id;
@property(nonatomic, assign) int cate_id;
@property(nonatomic, retain) NSString *series;
@property(nonatomic, retain) NSString *no;
@property(nonatomic, assign) int color;


@property(nonatomic, retain) NSString *info_cn;
@property(nonatomic, retain) NSString *info_en;
@property(nonatomic, assign) double price;
@property(nonatomic, retain) NSString *standard;
@property(nonatomic, retain) NSString *wood;

@property(nonatomic, retain) NSString *process;
@property(nonatomic, retain) NSString *deal;
@property(nonatomic, retain) NSString *level;

@property(nonatomic, assign) int array_order;
@property(nonatomic, assign) int status;
@property(nonatomic, assign) int create_time;

@end

#pragma mark - Category

@interface CategoryHaro : NSObject



@property(nonatomic, assign) int cate_id;
@property(nonatomic, retain) NSString *name;
@property(nonatomic, assign) int array_order;
@property(nonatomic, assign) int status;
@property(nonatomic, assign) int type;



@end


#pragma mark - picture

/*
 picture(  picture_id INTEGER DEFAULT '0', 
 product_id INTEGER DEFAULT NULL, 
 cate_id INTEGER DEFAULT NULL,
 type INTEGER DEFAULT NULL, dir 
 TEXT DEFAULT NULL, 
 name TEXT DEFAULT NULL );
*/
@interface Picture : NSObject



@property(nonatomic, assign) int picture_id;
@property(nonatomic, assign) int product_id;
@property(nonatomic, assign) int cate_id;
@property(nonatomic, assign) int type;

@property(nonatomic, retain) NSString *dir;
@property(nonatomic, retain) NSString *url;

@property(nonatomic, retain) NSString *text;
@property(nonatomic, retain) NSString *name;

@end



/*scene( 
 scene_id INTEGER DEFAULT '0', 
 name TEXT DEFAULT NULL, 
 status INTEGER DEFAULT NULL, 
 array_order INTEGER DEFAULT NULL );
*/
@interface Scene : NSObject

@property(nonatomic, assign) int scene_id;
@property(nonatomic, retain) NSString *name;
@property(nonatomic, assign) int status;
@property(nonatomic, assign) int array_order;

@end

/*
 CREATE TABLE 
 layer ( 
 layer_id INTEGER DEFAULT '0', 
 scene_id INTEGER DEFAULT NULL, 
 name TEXT DEFAULT NULL, 
 level INTEGER DEFAULT NULL, 
 status INTEGER DEFAULT NULL, 
 array_order INTEGER DEFAULT NULL );
*/

@interface Layer : NSObject

@property(nonatomic, assign) int layer_id;
@property(nonatomic, assign) int scene_id;
@property(nonatomic, retain) NSString *name;
@property(nonatomic, assign) int level;
@property(nonatomic, assign) int status;
@property(nonatomic, assign) int array_order;

@end


/*( content_id INTEGER DEFAULT '0', 
 product_id INTEGER DEFAULT NULL, 
 scene_id INTEGER DEFAULT NULL, 
 layer_id INTEGER DEFAULT NULL, 
 dir TEXT DEFAULT NULL, 
 name TEXT DEFAULT NULL, 
 status INTEGER DEFAULT NULL, 
 type INTEGER DEFAULT NULL, 
 array_order INTEGER DEFAULT NULL );
*/
#pragma mark - Content

@interface Content : NSObject



@property(nonatomic, assign) int content_id;
@property(nonatomic, assign) int product_id;
@property(nonatomic, assign) int scene_id;
@property(nonatomic, assign) int layer_id;

@property(nonatomic, retain) NSString *dir;
@property(nonatomic, retain) NSString *name;
@property(nonatomic, retain) NSString *url;

@property(nonatomic, assign) int status;
@property(nonatomic, assign) int type;
@property(nonatomic, assign) int array_order;



@end


/*( custom_id INTEGER DEFAULT '0', 
 province_id INTEGER DEFAULT NULL,
 dealer_id INTEGER DEFAULT NULL, 
 shop_id INTEGER DEFAULT NULL, 
 user_id INTEGER DEFAULT NULL, 
 name TEXT DEFAULT NULL, 
 tel TEXT DEFAULT NULL,
 address TEXT DEFAULT NULL, 
 remark TEXT DEFAULT NULL, 
 
 create_time INTEGER DEFAULT NULL, 
 array_order INTEGER DEFAULT NULL, 
 time TEXT DEFAULT NULL, 
 budget TEXT DEFAULT NULL, 
 status INTEGER DEFAULT NULL );
*/

#pragma mark - Custom

@interface Custom : NSObject


@property(nonatomic, assign) int custom_id;
@property(nonatomic, assign) int province_id;
@property(nonatomic, assign) int dealer_id;
@property(nonatomic, assign) int shop_id;

@property(nonatomic, assign) int user_id;
@property(nonatomic, retain) NSString *name;
@property(nonatomic, retain) NSString *tel;
@property(nonatomic, retain) NSString *address;

@property(nonatomic, retain) NSString *remark;
@property(nonatomic, assign) int create_time;
@property(nonatomic, assign) int array_order;
@property(nonatomic, retain) NSString *time;

@property(nonatomic, retain) NSString *budget;
@property(nonatomic, assign) int status;

@end


/*user(  
 user_id INTEGER DEFAULT '0', 
 district_id INTEGER DEFAULT NULL, 
 name TEXT DEFAULT NULL, 
 email TEXT DEFAULT NULL, 
 password TEXT DEFAULT NULL, 
 type INTEGER DEFAULT NULL, 
 create_time TEXT DEFAULT NULL, 
 status INTEGER DEFAULT NULL );
*/

#pragma mark - User

@interface UserHaro : NSObject

@property(nonatomic, assign) int user_id;
@property(nonatomic, assign) int district_id;

@property(nonatomic, retain) NSString *name;
@property(nonatomic, retain) NSString *email;
@property(nonatomic, retain) NSString *password;

@property(nonatomic, assign) int type;
@property(nonatomic, assign) int create_time;
@property(nonatomic, assign) int status;

@end


/*favorite(  
 custom_id INTEGER DEFAULT NULL, 
 cate_id INTEGER DEFAULT NULL, 
 product_id INTEGER DEFAULT NULL, 
 create_time TEXT DEFAULT NULL );
 */
#pragma mark - Favorite

@interface Favorite : NSObject

@property(nonatomic, assign) int custom_id;
@property(nonatomic, assign) int cate_id;
@property(nonatomic, assign) int product_id;
@property(nonatomic, assign) int create_time;

@end

@interface ZHaroModel : NSObject

@end



//#endif