//
//  ZHDBData.h
//  Dyrs
//
//  Created by mbp  on 13-9-9.
//  Copyright (c) 2013年 zeng hui. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "ZHdyrsModel.h"

#define FMDBQuickCheck(SomeBool) { if (!(SomeBool)) { NSLog(@"Failure on line %d", __LINE__); abort(); } }


#define ImageType_Dept                  0
#define ImageType_Case                  1
#define ImageType_Designer_BigAvart     2
#define ImageType_AccessType            3
#define ImageType_Access                4
#define ImageType_Designer_Avart        5


#define Member_Manage     0
#define Member_Designer     1
#define Member_DesignerVIP     2

    

@interface ZHDBData : NSObject
{
    FMDatabase *db;

}

+ (ZHDBData *)share;

- (void)insertDictToDB:(NSDictionary *)dict  tableName:(Tables_name)tableName;
- (void)updataDictToDB:(NSDictionary *)userDict  tableName:(Tables_name)tableName;
- (void)deleteDictToDB:(NSDictionary *)dict  tableName:(Tables_name)tableName;



/****************       配饰分类	   ****************/

- (NSMutableArray *)accessories:(int)fid level:(int)level;
- (NSMutableArray *)getAccessoriesLevel1:(int)fid;
- (NSMutableArray *)getAccessoriesLevel2:(int)fid;


/****************       配饰	   ****************/

- (NSMutableArray *)access:(int)cate_id;
- (Images *)getAccessImage:(int)o_id;
- (NSMutableArray *)getAccessTypeImage:(int)o_id;



/****************       部门   	****************/

- (Images *)getDesignerAvatarImage:(int)o_id;
- (Images *)getDesignerBigAvatarImage:(int)o_id;
- (Images *)getManageAvatarImage:(int)o_id;

- (NSMutableArray *)getDeginers:(int)dept_id;
- (NSMutableArray *)getManagers:(int)dept_id;
- (NSMutableArray *)getDeginerVIPs:(int)dept_id;

- (Department *)getUserDeptInfo:(Users *)user;

- (NSMutableArray *)getDeptImage:(int)o_id;


/****************       方案   	****************/

- (NSMutableArray *)getDesigerCases:(int)member_id;
- (NSMutableArray *)getCases:(int)dept_id
                    style_id:(int)style_id
                     area_id:(int)area_id
               house_type_id:(int)house_type_id
                seachKeyWork:(NSString *)seachKeyWork;

- (NSMutableArray *)getCases:(int)dept_id;
- (NSMutableArray *)getCaseImages:(int)o_id;
- (Images *)getCaseImage:(int)o_id;






/****************       用户  	****************/

- (Users *)getUserInfoForAccount:(NSString *)account;
- (Users *)getUser:(NSDictionary *)userDict;

/*   更新用户信息*/
- (BOOL)updateUser:(Users *)userInfo;

/*  登陆成功 保存用户 */
- (void)saveUser:(NSDictionary *)userDict;


/****************	Member	****************/

- (Member *)getMemberID:(int)mid;


/*
 images
 
 */
/****************	Mutable Dictionary	****************/

/*  下载完文件后，更新所有该版本的文件 2 -> 0*/
- (void)dyrsUpdatedStatue;

/*  照片 更新 3 ->  2*/
- (BOOL)updateImagesSccess:(Images *)image;

/*  获得 所有需要更新的文件，  即 状态为3 的image */
- (NSMutableArray *)getAllUpdateImage;
- (NSMutableArray *)getAllUpdateContent;
- (NSMutableArray *)getAllUpdatePicture;



@end
