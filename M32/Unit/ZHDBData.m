//
//  ZHDBData.m
//  Dyrs
//
//  Created by mbp  on 13-9-9.
//  Copyright (c) 2013年 zeng hui. All rights reserved.
//

#import "ZHDBData.h"
#import "ZHDBControl.h"

#import "ZHaroModel.h"

ZHDBData *dbData;


@implementation ZHDBData

+ (ZHDBData *)share
{
    if (dbData == nil)
    {
        dbData = [[ZHDBData alloc] init];
    }
    
    return dbData;
}

- (id) init
{
    self = [super init];
    if (self)
    {
        
        if ([[ZHDBControl share] checkDB]) {            
            NSString *dbPath = nil;
            if (KisDyrs) {
                dbPath = [KDocumentDirectory stringByAppendingPathComponent:@"dyrs.db"];
            }
            else {
                dbPath = [KDocumentDirectory stringByAppendingPathComponent:@"haro.db"];
            }
            db = [[FMDatabase alloc]initWithPath:dbPath];
            
        }
    }
    return self;
}

- (void)dealloc
{
    
    if (![db open]) {
        return;
    }
    db = nil;
}


#pragma mark  命令执行

- (void)stringToDBSqlString:(NSString *)sqlString
{
    
    if (!sqlString) {
        return;
    }
    
    if ([db open]) {
        
        bool statue =  [db executeUpdate:
                        sqlString];
        if (statue) {
            
        }
        else {
            DLog(@"statue:%i error: %@", statue, sqlString);
        }
        
    }
    else {
        DLog(@"db Not  open");
    }
}

- (void)dictToDB:(NSDictionary *)dict sqlString:(NSString *)sqlString
{
    if (!sqlString) {
        return;
    }
    
    if ([db open]) {

        bool statue =  [db executeUpdate:
                        sqlString withParameterDictionary:dict];
        
        if (statue) {
        }
        else {
            DLog(@"statue:%i error: %@,  \n lasterror:%@", statue, sqlString, db.lastError);
        }
    }
}

#pragma mark - insert  update  delete

- (void)deleteDictToDB:(NSDictionary *)dict  tableName:(Tables_name)tableName
{
    NSString *sqlString = nil;
    
    switch (tableName) {
        case UserTable:
        {
            sqlString = [NSString stringWithFormat:@"DELETE from user  \
                         WHERE user_id = :user_id"];
            break;
        }
        case ChannelTable:
        {
            sqlString = [NSString stringWithFormat:@"DELETE from Channel  \
                         WHERE user_id = :user_id"];
            break;
        }
        case Channel_viewTable:
        {
            sqlString = [NSString stringWithFormat:@"DELETE from Channel_View  \
                         WHERE user_id = :user_id"];
            break;
        }
        case DepartmentTable:
        {
            sqlString = [NSString stringWithFormat:@"DELETE from Department  \
                         WHERE dept_id = :dept_id"];
            break;
        }
        case ImagesTable:
        {
            sqlString = [NSString stringWithFormat:@"DELETE from Images  \
                         WHERE image_id = :image_id"];
            break;
        }
        case ValuesTable:
        {
            sqlString = [NSString stringWithFormat:@"DELETE from values  \
                         WHERE id = :id"];
            break;
        }
        case MemberTable:
        {
            sqlString = [NSString stringWithFormat:@"DELETE from Member  \
                         WHERE member_id = :member_id"];
            break;
        }
        case CasesTable:
        {
            sqlString = [NSString stringWithFormat:@"DELETE from Cases  \
                         WHERE case_id = :case_id"];
            break;
        }
        case CategoryTable:
        {
            sqlString = [NSString stringWithFormat:@"DELETE from Category  \
                         WHERE id = :case_id"];
            break;
        }
        case AccessoriesTable:
        {
            sqlString = [NSString stringWithFormat:@"DELETE from Accessories  \
                         WHERE acces_id = :acces_id"];
            break;
        }
        default:
            break;
    }
    
    [self dictToDB:dict sqlString:sqlString];
    
    
}

- (void)updataDictToDB:(NSDictionary *)userDict  tableName:(Tables_name)tableName
{
    
    NSMutableString *sqlString = [NSMutableString string];
    
    
    
    switch (tableName) {
        case UserTable:
        {

            [sqlString appendString:@"update user set "];
            
            
            [sqlString appendFormat:@"name='%@',", [userDict objectForKey:@"name"]];
            [sqlString appendFormat:@"account='%@',", [userDict objectForKey:@"account"]];
            [sqlString appendFormat:@"version='%@',", [userDict objectForKey:@"version"]];
            [sqlString appendFormat:@"dept_id='%@'", [userDict objectForKey:@"dept_id"]];
            
            
            
            [sqlString appendFormat:@"WHERE user_id = %@", [userDict objectForKey:@"user_id"]];
            
            
            break;
        }
        case ChannelTable:
        {
            
            sqlString = [NSMutableString stringWithFormat:@"update Channel set \
                         channel_id=:channel_id, name=:name, array_order=:array_order,\
                         status=:status, create_time=:create_time \
                         \
                         WHERE user_id = :user_id;"];
            break;
        }
        case Channel_viewTable:
        {
            sqlString = [NSMutableString stringWithFormat:@"update Channel_View set \
                         user_id=:user_id, channel_id=:channel_id \
                         \
                         WHERE user_id = :user_id;"];
            break;
        }
        case DepartmentTable:
        {
            [sqlString appendString:@"update Department set "];
            
            
            [sqlString appendFormat:@"name='%@',", [userDict objectForKey:@"name"]];
            [sqlString appendFormat:@"info='%@',", [userDict objectForKey:@"info"]];
            [sqlString appendFormat:@"shop_name='%@',", [userDict objectForKey:@"shop_name"]];
            [sqlString appendFormat:@"team_name='%@',", [userDict objectForKey:@"team_name"]];
            
            
            [sqlString appendFormat:@"status='%@',", [userDict objectForKey:@"status"]];
            [sqlString appendFormat:@"create_time='%@', ", [userDict objectForKey:@"create_time"]];
            [sqlString appendFormat:@"district_id='%@'", [userDict objectForKey:@"district_id"]];

            
            
            [sqlString appendFormat:@"WHERE dept_id = %@", [userDict objectForKey:@"dept_id"]];
            
            break;
        }
        case ImagesTable:
        {
            
            [sqlString appendString:@"update Images set "];
            
            
            [sqlString appendFormat:@"name='%@',", [userDict objectForKey:@"name"]];
            [sqlString appendFormat:@"object_type='%@',", [userDict objectForKey:@"object_type"]];
            [sqlString appendFormat:@"object_id='%@',", [userDict objectForKey:@"object_id"]];
            [sqlString appendFormat:@"url='%@',", [userDict objectForKey:@"url"]];
            
            [sqlString appendFormat:@"status='%@',", [userDict objectForKey:@"status"]];
            [sqlString appendFormat:@"create_time='%@'", [userDict objectForKey:@"create_time"]];
            
            
            
            [sqlString appendFormat:@"WHERE image_id = %@", [userDict objectForKey:@"image_id"]];
            
            break;
        }
        case ValuesTable:
        {
            sqlString = [NSMutableString stringWithFormat:@"update values set  \
                         id=:id, key_key=:key_key, key_value=:key_value, user_id=:user_id\
                         \
                         WHERE id = :id;"];
            
            break;
        }
        case MemberTable:
        {
            
            [sqlString appendString:@"update Member set "];
            
            
            [sqlString appendFormat:@"name='%@',", [userDict objectForKey:@"name"]];
            [sqlString appendFormat:@"infor='%@',", [userDict objectForKey:@"infor"]];
            [sqlString appendFormat:@"dept_id='%@',", [userDict objectForKey:@"dept_id"]];
            [sqlString appendFormat:@"type='%@',", [userDict objectForKey:@"type"]];
            
            [sqlString appendFormat:@"status='%@',", [userDict objectForKey:@"status"]];
            [sqlString appendFormat:@"create_time='%@'", [userDict objectForKey:@"create_time"]];
            
            
            
            [sqlString appendFormat:@"WHERE member_id = %@", [userDict objectForKey:@"member_id"]];
            
            
            
            break;
        }
        case CasesTable:
        {
            
            [sqlString appendString:@"update Cases set "];
            
            
            [sqlString appendFormat:@"name='%@',", [userDict objectForKey:@"name"]];
            [sqlString appendFormat:@"info='%@',", [userDict objectForKey:@"info"]];
            [sqlString appendFormat:@"dept_id='%@',", [userDict objectForKey:@"dept_id"]];
            [sqlString appendFormat:@"house_type_id='%@',", [userDict objectForKey:@"house_type_id"]];
            [sqlString appendFormat:@"area_id='%@',", [userDict objectForKey:@"area_id"]];
            [sqlString appendFormat:@"style_id='%@',", [userDict objectForKey:@"style_id"]];
            [sqlString appendFormat:@"member_id='%@',", [userDict objectForKey:@"member_id"]];
            [sqlString appendFormat:@"price='%@',", [userDict objectForKey:@"price"]];
            
            [sqlString appendFormat:@"status='%@',", [userDict objectForKey:@"status"]];
            [sqlString appendFormat:@"create_time='%@'", [userDict objectForKey:@"create_time"]];
            
            
            
            [sqlString appendFormat:@"WHERE case_id = %@", [userDict objectForKey:@"case_id"]];
            
            
            break;
        }
        case CategoryTable:
        {
            sqlString = [NSMutableString stringWithFormat:@"update Category set \
                         id=:id, name=:name, fid=:fid, level=:level, last=:last,\
                         type=:type, status=:status, create_time=:create_time \
                         WHERE id = :id;"];
            

            
            
            break;
        }
        case AccessoriesTable:
        {
//            sqlString = [NSString stringWithFormat:@"update Accessories set \
//                         id=:id, title=:title, info=:info, cate_id=:cate_id,  \
//                         status=:status, create_time=:create_time \
//                         \
//                         WHERE id = :id;"];
            
            [sqlString appendString:@"update Accessories set "];
            
//            [sqlString appendString:@"acces_id, "];
//            [sqlString appendString:@"title, "];
//            [sqlString appendString:@"infor, "];
//            [sqlString appendString:@"cate_id, "];
//            
//            [sqlString appendString:@"status,"];
//            [sqlString appendString:@"create_time"];


            [sqlString appendFormat:@"acces_id='%@',", [userDict objectForKey:@"acces_id"]];
            [sqlString appendFormat:@"title='%@',", [userDict objectForKey:@"title"]];
            [sqlString appendFormat:@"infor='%@',", [userDict objectForKey:@"infor"]];

            [sqlString appendFormat:@"cate_id='%@',", [userDict objectForKey:@"cate_id"]];
            [sqlString appendFormat:@"status='%@',", [userDict objectForKey:@"status"]];
            [sqlString appendFormat:@"create_time='%@'", [userDict objectForKey:@"create_time"]];

            
            [sqlString appendFormat:@"WHERE acces_id = %@", [userDict objectForKey:@"acces_id"]];
            
            break;
        }
        case UserHaroTable:
        {
            sqlString = [NSMutableString stringWithFormat:@"update User set \
                         user_id=:user_id, district_id=:district_id, namer=:namer, email=:email, password=:password, type=:type, create_time=:create_time,  statu=:status \
                         \
                         WHERE user_id = :user_id;"];
            break;
        }
        case ProductTable:
        {
            sqlString = [NSMutableString stringWithFormat:@"update Product set \
                         product_id=:product_id, cate_id=:cate_id, series=:series, no=:no, color=:color, info_cne=:info_cn, info_en=:info_en,  price=:price, standard=:standard, wood=:wood, process=:process, deal=:deal,\
                         level=:level, array_order=:array_order, status=:status, create_time=:create_time\
                         \
                         WHERE product_id = :product_id;"];
            break;
        }
        case CategoryHaroTable:
        {
            sqlString = [NSMutableString stringWithFormat:@"update Category set \
                         cate_id=:cate_id, name=:name, array_order=:array_order, status=:status, typed=:type, \
                         \
                         WHERE cate_id = :cate_id;"];
            break;
        }
        case PictureTable:
        {
            sqlString = [NSMutableString stringWithFormat:@"update Picture set \
                         picture_id=:picture_id, product_id=:product_id, cate_id=:cate_id, type=:type, text=:text, name=:name \
                         \
                         WHERE picture_id = :picture_id;"];
            break;
        }
        case SceneTable:
        {
            sqlString = [NSMutableString stringWithFormat:@"update Scene set \
                         scene_id=:scene_id, name=:name, status=:status, array_order=:array_order \
                         \
                         WHERE scene_id = :scene_id;"];
            break;
        }
        case LayerTable:
        {
            sqlString = [NSMutableString stringWithFormat:@"update Layer set \
                         layer_id=:layer_id, scene_id=:scene_id, name=:name, level=:level, status=:status, array_order=:array_order \
                         \
                         WHERE layer_id = :layer_id;"];
            break;
        }
        case ContentTable:
        {
            sqlString = [NSMutableString stringWithFormat:@"update Content set \
                         content_id=:content_id, product_id=:product_id, scene_id=:scene_id, layer_id=:layer_id, dir=:dir, name=:name, status=:status,  type=:type, array_order=:array_order \
                         \
                         WHERE content_id = :content_id;"];
            break;
        }
        case CustomTable:
        {
            sqlString = [NSMutableString stringWithFormat:@"update Custom set \
                         custom_id=:custom_id, province_id=:province_id, dealer_id=:dealer_id, shop_id=:shop_id, user_id=:user_id, name=:name, tel=:tel,  address=:address, remark=:remark, create_time=:create_time, array_order=:array_order, time=:time, budget=:budget,\
                         status=:status \
                         \
                         WHERE custom_id = :custom_id;"];
            break;
        }
        case FavoriteTable:
        {
            sqlString = [NSMutableString stringWithFormat:@"update Favorite set \
                         custom_id=:custom_id, cate_id=:cate_id, product_id=:product_id, create_time=:create_time \
                         \
                         WHERE custom_id = :custom_id;"];
            break;
        }
            
            
        default:
            break;
    }
    
    
    
    
    [self stringToDBSqlString:sqlString];
    
}

- (void)insertDictToDB:(NSDictionary *)dict  tableName:(Tables_name)tableName
{
    
    NSMutableString *sqlString = [NSMutableString string];
    
    switch (tableName) {
        case UserTable:
        {
            [sqlString appendString:@"INSERT INTO user ("];
            
            [sqlString appendString:@"user_id, "];
            [sqlString appendString:@"name, "];
            [sqlString appendString:@"account, "];
            [sqlString appendString:@"dept_id, "];
            [sqlString appendString:@"password"];
            
            
            [sqlString appendString:@")"];
            [sqlString appendString:@"VALUES ("];
            
            [sqlString appendFormat:@"'%@',", [dict objectForKey: @"user_id"]];
            [sqlString appendFormat:@"'%@',", [dict objectForKey: @"name"]];
            [sqlString appendFormat:@"'%@',", [dict objectForKey: @"account"]];
            [sqlString appendFormat:@"'%@',", [dict objectForKey: @"dept_id"]];
            [sqlString appendFormat:@"'%@'", [dict objectForKey: @"password"]];
            
            
            [sqlString appendString:@")"];
            
            break;
        }
        case ChannelTable:
        {
            sqlString = [NSMutableString stringWithFormat:@"INSERT INTO Channel (channel_id, name, array_order, status, create_time) VALUES (:channel_id, :name, :array_order, :status, :create_time)"];
            break;
        }
        case Channel_viewTable:
        {
            sqlString = [NSMutableString stringWithFormat:@"INSERT INTO Channel_View (user_id, channel_id) VALUES (:user_id, :channel_id)"];
            break;
            
        }
        case DepartmentTable:
        {
            
            [sqlString appendString:@"INSERT INTO Department ("];
            
            [sqlString appendString:@"dept_id, "];
            [sqlString appendString:@"name, "];
            [sqlString appendString:@"info, "];
            [sqlString appendString:@"shop_name, "];
            [sqlString appendString:@"team_name,"];
            [sqlString appendString:@"district_id,"];

            [sqlString appendString:@"status,"];
            [sqlString appendString:@"create_time"];
            
            
            [sqlString appendString:@")"];
            [sqlString appendString:@"VALUES ("];
            
            [sqlString appendFormat:@"'%@',", [dict objectForKey: @"dept_id"]];
            [sqlString appendFormat:@"'%@',", [dict objectForKey: @"name"]];
            [sqlString appendFormat:@"'%@',", [dict objectForKey: @"info"]];
            [sqlString appendFormat:@"'%@',", [dict objectForKey: @"shop_name"]];
            [sqlString appendFormat:@"'%@',", [dict objectForKey: @"team_name"]];
            [sqlString appendFormat:@"'%@',", [dict objectForKey: @"district_id"]];

            [sqlString appendFormat:@"'%@',", [dict objectForKey: @"status"]];
            [sqlString appendFormat:@"'%@'", [dict objectForKey: @"create_time"]];
            
            
            [sqlString appendString:@")"];
            
            break;
            
        }
        case ImagesTable:
        {
            [sqlString appendString:@"INSERT INTO Images ("];
            
            [sqlString appendString:@"image_id, "];
            [sqlString appendString:@"name, "];
            [sqlString appendString:@"url, "];
            [sqlString appendString:@"object_type, "];
            [sqlString appendString:@"object_id,"];
            [sqlString appendString:@"status,"];
            [sqlString appendString:@"create_time"];
            
            
            [sqlString appendString:@")"];
            [sqlString appendString:@"VALUES ("];
            
            [sqlString appendFormat:@"'%@',", [dict objectForKey: @"image_id"]];
            [sqlString appendFormat:@"'%@',", [dict objectForKey: @"name"]];
            [sqlString appendFormat:@"'%@',", [dict objectForKey: @"url"]];
            [sqlString appendFormat:@"'%@',", [dict objectForKey: @"object_type"]];
            [sqlString appendFormat:@"'%@',", [dict objectForKey: @"object_id"]];
            [sqlString appendFormat:@"'%@',", [dict objectForKey: @"status"]];
            [sqlString appendFormat:@"'%@'", [dict objectForKey: @"create_time"]];
            
            
            [sqlString appendString:@")"];
            
            break;
        }
        case ValuesTable:
        {
            sqlString = [NSMutableString stringWithFormat:@"INSERT INTO values (id, key_key, key_value, user_id) VALUES (:id, :key_key, :key_value, :user_id)"];
            break;
        }
        case MemberTable:
        {
            [sqlString appendString:@"INSERT INTO Member ("];
            
            [sqlString appendString:@"member_id, "];
            [sqlString appendString:@"name, "];
            [sqlString appendString:@"infor, "];
            [sqlString appendString:@"dept_id, "];
            [sqlString appendString:@"type,"];
            
            [sqlString appendString:@"status,"];
            [sqlString appendString:@"create_time"];
            
            
            [sqlString appendString:@")"];
            [sqlString appendString:@"VALUES ("];
            
            [sqlString appendFormat:@"'%@',", [dict objectForKey: @"member_id"]];
            [sqlString appendFormat:@"'%@',", [dict objectForKey: @"name"]];
            [sqlString appendFormat:@"'%@',", [dict objectForKey: @"infor"]];
            [sqlString appendFormat:@"'%@',", [dict objectForKey: @"dept_id"]];
            [sqlString appendFormat:@"'%@',", [dict objectForKey: @"type"]];
            
            [sqlString appendFormat:@"'%@',", [dict objectForKey: @"status"]];
            [sqlString appendFormat:@"'%@'", [dict objectForKey: @"create_time"]];
            
            
            [sqlString appendString:@")"];
            break;
        }
        case CasesTable:
        {
            [sqlString appendString:@"INSERT INTO Cases ("];
            
            [sqlString appendString:@"case_id, "];
            [sqlString appendString:@"info, "];
            [sqlString appendString:@"name, "];
            [sqlString appendString:@"house_type_id, "];
            [sqlString appendString:@"area_id, "];
            [sqlString appendString:@"style_id, "];
            [sqlString appendString:@"city_id, "];
            [sqlString appendString:@"dept_id, "];
            [sqlString appendString:@"member_id, "];
            [sqlString appendString:@"price, "];
            
            [sqlString appendString:@"status,"];
            [sqlString appendString:@"create_time"];
            
            
            [sqlString appendString:@")"];
            [sqlString appendString:@"VALUES ("];
            
            [sqlString appendFormat:@"'%@',", [dict objectForKey: @"case_id"]];
            [sqlString appendFormat:@"'%@',", [dict objectForKey: @"info"]];
            [sqlString appendFormat:@"'%@',", [dict objectForKey: @"name"]];
            [sqlString appendFormat:@"'%@',", [dict objectForKey: @"house_type_id"]];
            [sqlString appendFormat:@"'%@',", [dict objectForKey: @"area_id"]];
            [sqlString appendFormat:@"'%@',", [dict objectForKey: @"style_id"]];
            [sqlString appendFormat:@"'%@',", [dict objectForKey: @"city_id"]];
            [sqlString appendFormat:@"'%@',", [dict objectForKey: @"dept_id"]];
            [sqlString appendFormat:@"'%@',", [dict objectForKey: @"member_id"]];
            [sqlString appendFormat:@"'%@',", [dict objectForKey: @"price"]];
            
            
            [sqlString appendFormat:@"'%@',", [dict objectForKey: @"status"]];
            [sqlString appendFormat:@"'%@'", [dict objectForKey: @"create_time"]];
            
            
            [sqlString appendString:@")"];
            
            
            
            break;
        }
        case CategoryTable:
        {
            sqlString = [NSMutableString stringWithFormat:@"INSERT INTO Category (cate_id, name, fid, level, last, status) VALUES (:cate_id, :name, :fid, :level, :last, :status)"];
            break;
        }
        case AccessoriesTable:
        {
            [sqlString appendString:@"INSERT INTO Accessories ("];
            
            [sqlString appendString:@"acces_id, "];
            [sqlString appendString:@"title, "];
            [sqlString appendString:@"infor, "];
            [sqlString appendString:@"cate_id, "];
            
            [sqlString appendString:@"status,"];
            [sqlString appendString:@"create_time"];
            
            
            [sqlString appendString:@")"];
            [sqlString appendString:@"VALUES ("];
            
            [sqlString appendFormat:@"'%@',", [dict objectForKey: @"acces_id"]];
            [sqlString appendFormat:@"'%@',", [dict objectForKey: @"title"]];
            [sqlString appendFormat:@"'%@',", [dict objectForKey: @"infor"]];
            [sqlString appendFormat:@"'%@',", [dict objectForKey: @"cate_id"]];
            
            
            [sqlString appendFormat:@"'%@',", [dict objectForKey: @"status"]];
            [sqlString appendFormat:@"'%@'", [dict objectForKey: @"create_time"]];
            
            
            [sqlString appendString:@")"];
            
            break;
            
        }
        case ProductTable:
        {
            
            [sqlString appendString:@"INSERT OR REPLACE INTO Product ("];
            [sqlString appendString:@"cate_id, \
             color, \
             info_cn, \
             info_en, \
             level, \
             no, \
             price, \
             product_id, \
             series, \
             standard\
             "];
            [sqlString appendString:@")  VALUES ("];
            [sqlString appendFormat:@"'%@', ", [dict objectForKey:@"cate_id"]];
            [sqlString appendFormat:@"'%@', ", [dict objectForKey:@"color"]];
            [sqlString appendFormat:@"'%@', ", [dict objectForKey:@"info_cn"]];
            [sqlString appendFormat:@"'%@', ", [dict objectForKey:@"info_en"]];
            [sqlString appendFormat:@"'%@', ", [dict objectForKey:@"level"]];
            [sqlString appendFormat:@"'%@', ", [dict objectForKey:@"no"]];
            [sqlString appendFormat:@"'%@', ", [dict objectForKey:@"price"]];
            [sqlString appendFormat:@"'%@', ", [dict objectForKey:@"product_id"]];
            [sqlString appendFormat:@"'%@', ", [dict objectForKey:@"series"]];
            [sqlString appendFormat:@"'%@'", [dict objectForKey:@"standard"]];
            [sqlString appendString:@") "];
            break;
        }
        case CategoryHaroTable:
        {
            [sqlString appendString: @"INSERT INTO Category (cate_id, name, array_order, status, type) VALUES ("];
            [ sqlString appendFormat:@"'%@','%@','%@','%@','%@')",[dict objectForKey:@"cate_id"], [dict objectForKey:@"name"], [dict objectForKey:@"array_order"], [dict objectForKey:@"status"], [dict objectForKey:@"type"]];
            break;
        }
        case PictureTable:
        {
            [sqlString appendString: @"INSERT OR REPLACE INTO Picture (picture_id, product_id, cate_id, type, dir) VALUES ("];
            [sqlString appendFormat:@"'%@','%@','%@','%@','%@')",[dict objectForKey:@"picture_id"], [dict objectForKey:@"product_id"], [dict objectForKey:@"cate_id"], [dict objectForKey:@"type"], [dict objectForKey:@"url"]];
            
            break;
        }
        case SceneTable:
        {
            sqlString = [NSMutableString stringWithFormat:@"INSERT INTO Scene (scene_id, name, status, array_order) VALUES (:scene_id, :name, :status, :array_order)"];
            break;
        }
        case LayerTable:
        {
            sqlString = [NSMutableString stringWithFormat:@"INSERT INTO layer (layer_id, scene_id, name, level, status, array_order) VALUES (:layer_id, :scene_id, :name, :level, :status, :array_order)"];
            break;
        }
            
        case ContentTable:
        {
            [sqlString appendString: @"INSERT OR REPLACE INTO Content (content_id, product_id, scene_id, layer_id, name) VALUES ("];
            [sqlString appendFormat:@"'%@','%@','%@','%@','%@')",[dict objectForKey:@"content_id"], [dict objectForKey:@"product_id"], [dict objectForKey:@"scene_id"], [dict objectForKey:@"layer_id"], [dict objectForKey:@"url"]];
            break;
        }
        case CustomTable:
        {
            sqlString = [NSMutableString stringWithFormat:@"INSERT INTO Custom (custom_id, province_id, dealer_id, shop_id, user_id, name, tel, address, remark, create_time, array_order, time, budget, status) VALUES (:custom_id, :province_id, :dealer_id, :shop_id, :user_id, :name, :tel, :address, :remark, :create_time, :array_order, :time, :budget, :status)"];
            break;
        }
        case UserHaroTable:
        {
            [sqlString appendString: @"INSERT OR REPLACE INTO User (user_id, district_id, name, email, password, type, create_time, status) VALUES ("];
            [sqlString appendFormat:@"%@,%@,%@,%@,%@,%@,%@,%@",[dict objectForKey:@"user_id"], [dict objectForKey:@"district_id"], [dict objectForKey:@"name"], [dict objectForKey:@"email"], [dict objectForKey:@"password"], [dict objectForKey:@"type"], [dict objectForKey:@"create_time"],[dict objectForKey:@"status"]];
            break;
        }
        default:
            break;
    }
    
    
    [self stringToDBSqlString:sqlString];
}

#pragma mark - accessories


- (NSMutableArray *)accessories:(int)fid level:(int)level
{
    NSMutableArray *dataArray = [[NSMutableArray alloc] init];
    
    
    NSString *sqlString = [NSString stringWithFormat:
                           @"select *from category where fid = '%d' and level = '%d'", fid, level];
    
    if (level == 1) {
        sqlString = [NSString stringWithFormat:
                     @"select *from category where id = '%d' and level = '%d'", fid, level];
    }
        
    if (![db open]) {
        
        DLog (@"Could not open db.");
    }
    else {
        
        
        FMResultSet *rs = [db executeQuery:sqlString];
        
        while ([rs next]) {
            
            Category1 *image = [[Category1 alloc] init];
            image.ID = [rs intForColumn:@"id"];
            image.name = [rs stringForColumn:@"name"];
            image.fid = [rs intForColumn:@"fid"];
            image.level = [rs intForColumn:@"level"];
            image.last = [rs intForColumn:@"last"];
            image.status = [rs intForColumn:@"status"];
//            image.create_time = [rs stringForColumn:@"create_time"];
            
            
            [dataArray addObject:image];
            
            
        }
        
        
        [rs close];
        [db close];
        
    }
    
    
    return dataArray;
    
}

- (NSMutableArray *)getAccessoriesLevel1:(int)fid
{
    return [self accessories:fid level:1];
}

- (NSMutableArray *)getAccessoriesLevel2:(int)fid
{
    return [self accessories:fid level:2];
}

#pragma mark - acc type

- (NSMutableArray *)access:(int)cate_id
{
    NSMutableArray *dataArray = [[NSMutableArray alloc] init];
    
    NSString *sqlString = [NSString stringWithFormat:
                           @"select *from 'accessories' where cate_id=%d", cate_id];
    
    
    if (![db open]) {
        
        DLog (@"Could not open db.");
    }
    else {
        
        
        FMResultSet *rs = [db executeQuery:sqlString];
        
        while ([rs next]) {
            
            Accessories *image = [[Accessories alloc] init];
            image.ID = [rs intForColumn:@"acces_id"];
            image.title = [rs stringForColumn:@"title"];
//            image.info = [rs stringForColumn:@"info"];
            image.cate_id = [rs intForColumn:@"cate_id"];
            image.status = [rs intForColumn:@"status"];
//            image.create_time = [rs stringForColumn:@"create_time"];
            
            [dataArray addObject:image];
            
            
        }
        
        
        [rs close];
        [db close];
        
    }
    
    
    return dataArray ;
}

- (NSMutableArray *)getAccessTypeImage:(int)o_id
{
    return [self getImageO_id:o_id o_type:ImageType_AccessType];
}

- (Images *)getAccessImage:(int)o_id
{
    NSArray *array = [self getImageO_id:o_id o_type:ImageType_Access];
    if ([array count] > 0) {
        return [array objectAtIndex:0];
    }
    return nil;
}
#pragma mark - dept

- (Images *)getDesignerAvatarImage:(int)o_id
{
    NSMutableArray *a = [self getImageO_id:o_id o_type:ImageType_Designer_Avart];
    
    if ( a.count ==0) {
        return nil;
    }
    return [a objectAtIndex:0];
}

- (Images *)getDesignerBigAvatarImage:(int)o_id
{
    NSMutableArray *a = [self getImageO_id:o_id o_type:ImageType_Designer_BigAvart];

    if ( a.count ==0) {
        return nil;
    }
    return [a objectAtIndex:0];
}

- (Images *)getManageAvatarImage:(int)o_id;
{
    NSMutableArray *a = [self getImageO_id:o_id o_type:ImageType_Designer_BigAvart];
    
    if ( a.count ==0) {
        return nil;
    }
    return [a objectAtIndex:0];
}

- (NSMutableArray *)getDeginers:(int)dept_id
{
    return [self getMemberID:dept_id o_type:Member_Designer];
}

- (NSMutableArray *)getManagers:(int)dept_id
{
    return [self getMemberID:dept_id o_type:Member_Manage];
}

- (NSMutableArray *)getDeginerVIPs:(int)dept_id
{
    return [self getMemberID:dept_id o_type:Member_DesignerVIP];
}

- (Department *)getUserDeptInfo:(Users *)user
{
    
    
    NSMutableString *sqlString = [NSMutableString string];
    
    [sqlString appendString:@"select * from Department where "];
    [sqlString appendFormat:@"dept_id = '%d'",  user.dept_id];
    
    
    Department *dept = [[Department alloc] init];
    
    if (![db open]) {
        
        DLog (@"Could not open db.");
    }
    else {
        FMResultSet *rs = [db executeQuery:sqlString];
        
        while ([rs next]) {
            
            dept.ID =  [rs intForColumn:@"dept_id"];
            dept.info =  [rs stringForColumn:@"info"];
            dept.name =  [rs stringForColumn:@"name"];
            dept.shop_name =  [rs stringForColumn:@"shop_name"];
            dept.district_id = [rs intForColumn:@"district_id"];
            dept.status =  [rs intForColumn:@"status"];
            dept.create_time =  [rs stringForColumn:@"create_time"];
            
        }
        
        [rs close];
        [db close];
    }
    
    
    return dept ;
}

- (NSMutableArray *)getDeptImage:(int)o_id
{
    return [self getImageO_id:o_id o_type:ImageType_Dept];
}

#pragma mark - cases

- (NSMutableArray *)getDesigerCases:(int)member_id
{
    
    NSMutableArray *dataArray = [[NSMutableArray alloc] init];
    
    
    NSString *sqlString = [NSString stringWithFormat:
                           @"select * from cases where status= 0 and member_id = '%d'",
                           member_id];
    
    
    if (![db open]) {
        
        DLog (@"Could not open db.");
    }
    else {
        
        
        FMResultSet *rs = [db executeQuery:sqlString];
        
        
        while ([rs next]) {
            
            Cases *image = [[Cases alloc] init];
            image.ID = [rs intForColumn:@"case_id"];
            image.name = [rs stringForColumn:@"name"];
            image.info = [rs stringForColumn:@"info"];
            image.house_type_id = [rs intForColumn:@"house_type_id"];
            image.area_id = [rs intForColumn:@"area_id"];
            image.style_id = [rs intForColumn:@"style_id"];
            image.city_id = [rs intForColumn:@"city_id"];
            image.dept_id = [rs intForColumn:@"dept_id"];
            image.member_id = [rs intForColumn:@"member_id"];
            image.price = [rs doubleForColumn:@"price"];
            image.member_id = [rs intForColumn:@"member_id"];
            image.status = [rs intForColumn:@"status"];
            image.create_time = [rs stringForColumn:@"create_time"];
            
            
            [dataArray addObject:image];
            
            
        }
        
        
        [rs close];
        [db close];
        
    }
    
    
    return dataArray;
}


- (NSMutableArray *)getCases:(int)dept_id
                    style_id:(int)style_id
                     area_id:(int)area_id
               house_type_id:(int)house_type_id
                seachKeyWork:(NSString *)seachKeyWork

{
    
    NSMutableArray *dataArray = [[NSMutableArray alloc] init];
    

    
    NSMutableString *sqlString = [NSMutableString stringWithFormat:@"select * from cases where "];
    [sqlString appendFormat:@"status= 0 and dept_id= '%d' ", dept_id] ;

    if (style_id != -1) {
        [sqlString appendFormat:@"and style_id = '%d' ", style_id] ;
    }
    if (area_id != -1) {
        [sqlString appendFormat:@"and area_id = '%d' ", area_id] ;
    }
    if (house_type_id != -1) {
        [sqlString appendFormat:@"and house_type_id = '%d' ", house_type_id] ;
    }
    if (seachKeyWork != nil && ![seachKeyWork isEqualToString:@""]) {
        [sqlString appendFormat:@"and name like '%%%@%%' ", seachKeyWork] ;
    }
    
    if (![db open]) {
        
        DLog (@"Could not open db.");
    }
    else {
        
        FMResultSet *rs = [db executeQuery:sqlString];
        
        while ([rs next]) {
            Cases *image = [[Cases alloc] init];
            image.ID = [rs intForColumn:@"case_id"];
            image.name = [rs stringForColumn:@"name"];
            image.info = [rs stringForColumn:@"info"];
            image.house_type_id = [rs intForColumn:@"house_type_id"];
            
            image.area_id = [rs intForColumn:@"area_id"];
            image.style_id = [rs intForColumn:@"style_id"];
            image.city_id = [rs intForColumn:@"city_id"];
            image.dept_id = [rs intForColumn:@"dept_id"];
            
            image.member_id = [rs intForColumn:@"member_id"];
            image.price = [rs doubleForColumn:@"price"];
            image.member_id = [rs intForColumn:@"member_id"];
            image.status = [rs intForColumn:@"status"];
            image.create_time = [rs stringForColumn:@"create_time"];
            
            [dataArray addObject:image];
            
            
        }
        
        
        [rs close];
        [db close];
        
    }
    
    
    return dataArray;
}


- (NSMutableArray *)getCases:(int)dept_id
{
    
    NSMutableArray *dataArray = [[NSMutableArray alloc] init];
    
    
    NSString *sqlString = [NSString stringWithFormat:
                           @"select * from cases where status= 0 and dept_id=  \
                           '%d'",
                           dept_id];
    
    
    if (![db open]) {
        
        DLog (@"Could not open db.");
    }
    else {
        
        FMResultSet *rs = [db executeQuery:sqlString];
        
        while ([rs next]) {
            Cases *image = [[Cases alloc] init];
            image.ID = [rs intForColumn:@"case_id"];
            image.name = [rs stringForColumn:@"name"];
            image.info = [rs stringForColumn:@"info"];
            image.house_type_id = [rs intForColumn:@"house_type_id"];
            
            image.area_id = [rs intForColumn:@"area_id"];
            image.style_id = [rs intForColumn:@"style_id"];
            image.city_id = [rs intForColumn:@"city_id"];
            image.dept_id = [rs intForColumn:@"dept_id"];
            
            image.member_id = [rs intForColumn:@"member_id"];
            image.price = [rs doubleForColumn:@"price"];
            image.member_id = [rs intForColumn:@"member_id"];
            image.status = [rs intForColumn:@"status"];
            image.create_time = [rs stringForColumn:@"create_time"];
            
            [dataArray addObject:image];
            
            
        }
        
        
        [rs close];
        [db close];
        
    }
    
    
    return dataArray;
}

- (NSMutableArray *)getCaseImages:(int)o_id
{
    return [self getImageO_id:o_id o_type:1];
}

- (Images *)getCaseImage:(int)o_id;
{
    NSMutableArray *a = [self getImageO_id:o_id o_type:1];
    
    if ( a.count ==0) {
        return nil;
    }
    return [a objectAtIndex:0];
    
}


#pragma mark - user


- (Users *)getUserInfoForAccount:(NSString *)account
{
    NSDictionary *dict =[NSDictionary dictionaryWithObjectsAndKeys:account, @"account", nil];
    
    
    return [self getUser:dict];
}

- (Users *)getUser:(NSDictionary *)userDict
{
    Users *user = [[Users alloc] init];
    
    NSMutableString *sqlString = [NSMutableString string];
    
    [sqlString appendString:@"select * from user where "];
    if ([userDict objectForKey:@"account"]) {
        [sqlString appendFormat:@"account = '%@'",  [userDict objectForKey:@"account"]];
    }
    if ([userDict objectForKey:@"password"]) {
        [sqlString appendFormat:@"and password = '%@'", [userDict objectForKey:@"password"]];
    }
    
    
    if (![db open]) {
        
        DLog (@"Could not open db.");
    }
    else {
        FMResultSet *rs = [db executeQuery:sqlString];
        
        while ([rs next]) {
            
            user.ID =  [rs intForColumn:Kuser_user_id];
            user.dept_id =  [rs intForColumn:Kuser_dept_id];
            user.name =  [rs stringForColumn:Kuser_name];
            user.account =  [rs stringForColumn:Kuser_account];
            user.version = [rs longLongIntForColumn:Kuser_version]; ;
        }
        
        [rs close];
        [db close];
    }
    
    
    return user ;
}

- (BOOL)updateUser:(Users *)userInfo
{
    NSDictionary *userDict = [[Users share] userToDict:userInfo];
    [self updataDictToDB:userDict tableName:UserTable];
    
    return YES;
}


- (void)saveUser:(NSDictionary *)userDict
{
    if (![db open]) {
        
        DLog (@"Could not open db.");
    }
    else {
        [self insertDictToDB:userDict tableName:UserTable];
    }
    
}

#pragma mark - images

- (NSMutableArray *)getImageO_id:(int)o_id o_type:(int)o_type
{
    
    NSMutableArray *dataArray = [[NSMutableArray alloc] init];
    
    
    NSString *sqlString = [NSString stringWithFormat:
                           @"select * from images where status= 0 and object_id= '%d' and object_type=%d", o_id, o_type];
    
    
    if (![db open]) {
        
        DLog (@"Could not open db.");
    }
    else {
        
        
        FMResultSet *rs = [db executeQuery:sqlString];
        
        
        while ([rs next]) {
            
            Images *image = [[Images alloc] init];
            image.ID = [rs intForColumn:@"image_id"];
            image.name = [rs stringForColumn:@"name"];
            image.url = [rs stringForColumn:@"url"];
            
            image.object_id = [rs intForColumn:@"object_id"];
            image.object_type = [rs intForColumn:@"object_type"];
            image.status = [rs intForColumn:@"status"];
            
            image.create_time = [rs stringForColumn:@"create_time"];
            
            
            [dataArray addObject:image];
            
        }
        
        
        [rs close];
        [db close];
        
    }
    
    
    return dataArray;
}



- (BOOL)updateImagesSccess:(Images *)image
{
    
    
    NSMutableDictionary *imageDict = [NSMutableDictionary dictionary];
    [imageDict setValue:[NSNumber numberWithInt:image.ID] forKey:@"image_id"];
    [imageDict setValue:image.name forKey:@"name"];
    [imageDict setValue:image.url forKey:@"url"];
    [imageDict setValue:[NSNumber numberWithInt:image.object_type] forKey:@"object_type"];
    [imageDict setValue:[NSNumber numberWithInt:image.object_id] forKey:@"object_id"];
    [imageDict setValue:[NSNumber numberWithInt:image.status] forKey:@"status"];
    [imageDict setValue:image.create_time forKey:@"create_time"];
    
    [self updataDictToDB:imageDict tableName:ImagesTable];
    
    
    return YES;
}


/*
 默认为 3 未下载，
 下载完成  2
 更新完成时， 调用更新所有状态为2（更新未完成）的所有数据
 更新为  0 （正常）
 */
- (void)dyrsUpdatedStatue
{
    
    NSMutableString *sqlString = [NSMutableString string];
    
    //  accessories
    [sqlString appendString:@"UPDATE accessories SET status = 0 WHERE status = 2 or status = 1;"];
    //  cases
    [sqlString appendString:@"UPDATE cases SET status = 0 WHERE status = 2 or status = 1;"];
    //  category
    [sqlString appendString:@"UPDATE category SET status = 0 WHERE status = 2 or status = 1;"];
    //  channel
    [sqlString appendString:@"UPDATE channel SET status = 0 WHERE status = 2 or status = 1;"];
    //  channel_view
    //    [sqlString appendString:@"UPDATE channel_view SET status = 0 WHERE status = 2 or status = 1;"];
    //  department
    [sqlString appendString:@"UPDATE department SET status = 0 WHERE status = 2 or status = 1;"];
    //  images
    [sqlString appendString:@"UPDATE images SET status = 0 WHERE status = 2 or status = 1;"];
    //  user
    [sqlString appendString:@"UPDATE user SET status = 0 WHERE status = 2 or status = 1;"];
    //  values
    //    [sqlString appendString:@"UPDATE values SET status = 0 WHERE status = 2 or status = 1;"];
    
    [sqlString appendString:@"UPDATE member SET status = 0 WHERE status = 2 or status = 1;"];
    
    
    if (![db open]) {
        DLog (@"Could not open db.");
    }
    else {
        
        NSArray *a = [sqlString componentsSeparatedByString:@";"];
        for (int i = 0; i < [a count]; i++)
        {
            BOOL rc = [db executeUpdate:[a objectAtIndex:i]];
            
            
            if (!rc) {
                NSLog(@"ERROR==========: %d - %@", db.lastErrorCode, db.lastErrorMessage);
            }
            
            
        }
        
        [db close];
    }
}

- (NSMutableArray *)getAllUpdateContent
{
    
    NSMutableArray *dataArray = [[NSMutableArray alloc] init];
    
    
    NSString *sqlString = [NSString stringWithFormat:@"select * from Content where status= 3"];
    
    
    if (![db open]) {
        
        DLog (@"Could not open db.");
    }
    else {
        
        
        FMResultSet *rs = [db executeQuery:sqlString];
        
        
        
        
        while ([rs next]) {
            
//            Content *image = [[Content alloc] init];
            //            image.picture_id = [rs intForColumn:@"picture_id"];
            //            image.name = [rs stringForColumn:@"name"];
            //            image.url = [rs stringForColumn:@"url"];
            //            image.dir = [rs stringForColumn:@"dir"];
            //            image.text = [rs stringForColumn:@"text"];
            //
            //            image.product_id = [rs intForColumn:@"product_id"];
            //            image.cate_id = [rs intForColumn:@"cate_id"];
            //            image.type = [rs intForColumn:@"type"];
            
            
            
//            [dataArray addObject:image];
            

            
        }
        
        
        [rs close];
        [db close];
        
    }
    
    
    return dataArray ;
}


- (NSMutableArray *)getAllUpdateImage
{
    
    NSMutableArray *dataArray = [[NSMutableArray alloc] init];
    
    
    NSString *sqlString = [NSString stringWithFormat:@"select * from images where status= 3"];
    
    
    if (![db open]) {
        
        DLog (@"Could not open db.");
    }
    else {
        
        
        FMResultSet *rs = [db executeQuery:sqlString];
        
        
        while ([rs next]) {
            
            Images *image = [[Images alloc] init];
            image.ID = [rs intForColumn:@"image_id"];
            image.name = [rs stringForColumn:@"name"];
            image.url = [rs stringForColumn:@"url"];
            
            image.object_id = [rs intForColumn:@"object_id"];
            image.object_type = [rs intForColumn:@"object_type"];
            image.status = [rs intForColumn:@"status"];
            
            image.create_time = [rs stringForColumn:@"create_time"];
            
            
            [dataArray addObject:image];
            

            
        }
        
        
        [rs close];
        [db close];
        
    }
    
    
    return dataArray;
}

- (NSMutableArray *)getAllUpdatePicture
{
    
    NSMutableArray *dataArray = [[NSMutableArray alloc] init];
    
    
    NSString *sqlString = [NSString stringWithFormat:@"select * from picture where status= 3"];
    
    
    if (![db open]) {
        
        DLog (@"Could not open db.");
    }
    else {
        
        
        FMResultSet *rs = [db executeQuery:sqlString];
        
        
        
        while ([rs next]) {
            
            Picture *image = [[Picture alloc] init];
            image.picture_id = [rs intForColumn:@"picture_id"];
            image.name = [rs stringForColumn:@"name"];
            image.url = [rs stringForColumn:@"url"];
            image.dir = [rs stringForColumn:@"dir"];
            image.text = [rs stringForColumn:@"text"];
            
            image.product_id = [rs intForColumn:@"product_id"];
            image.cate_id = [rs intForColumn:@"cate_id"];
            image.type = [rs intForColumn:@"type"];
            
            
            
            [dataArray addObject:image];
            
            
        }
        
        
        [rs close];
        [db close];
        
    }
    
    
    return dataArray;
}


#pragma mark - member

- (Member *)getMemberID:(int)mid
{
    
    
    NSMutableString *sqlString = [NSMutableString stringWithFormat:
                                  @"select * from member where member_id=%d", mid];
       
    

    Member *image = [[Member alloc] init];
    
    if (![db open]) {
        
        DLog (@"Could not open db.");
    }
    else {
        
        
        FMResultSet *rs = [db executeQuery:sqlString];
        
        while ([rs next]) {
            

            image.ID = [rs intForColumn:@"member_id"];
            image.name = [rs stringForColumn:@"name"];
            image.info = [rs stringForColumn:@"infor"];
            
            image.dept_id = [rs intForColumn:@"dept_id"];
            image.type = [rs intForColumn:@"type"];
            //            image.gender = [rs intForColumn:@"gender"];
            image.status = [rs intForColumn:@"status"];
            
            image.create_time = [rs stringForColumn:@"create_time"];
            
        }
        
        
        [rs close];
        [db close];
        
    }
    
    
    return image ;

}

- (NSMutableArray *)getMemberID:(int)dept_id o_type:(int)type
{
    
    NSMutableArray *dataArray = [[NSMutableArray alloc] init];
    
    NSMutableString *sqlString = [NSMutableString stringWithFormat:
                           @"select * from member where status= 0 and dept_id=%d", dept_id];
    if (type == 1  || type == 2 ) {
     
        [sqlString appendString:@" and  type=1 "];
    }
    else if ( type == 0 ) {
        [sqlString appendString:@" and  type=0 "];
    }
    
    if (![db open]) {
        
        DLog (@"Could not open db.");
    }
    else {
        
        
        FMResultSet *rs = [db executeQuery:sqlString];
        
        while ([rs next]) {
            
            Member *image = [[Member alloc] init];
            image.ID = [rs intForColumn:@"member_id"];
            image.name = [rs stringForColumn:@"name"];
            image.info = [rs stringForColumn:@"infor"];
            
            image.dept_id = [rs intForColumn:@"dept_id"];
            image.type = [rs intForColumn:@"type"];
//            image.gender = [rs intForColumn:@"gender"];
            image.status = [rs intForColumn:@"status"];
            
            image.create_time = [rs stringForColumn:@"create_time"];
            
            
            [dataArray addObject:image];
            
            
        }
        
        
        [rs close];
        [db close];
        
    }
    
    
    return dataArray;
}

@end
