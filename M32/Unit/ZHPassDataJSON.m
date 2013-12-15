//
//  ZHPassDataJSON.m
//  NetWork
//
//  Created by mbp  on 13-8-9.
//  Copyright (c) 2013年 zeng hui. All rights reserved.
//

#import "ZHPassDataJSON.h"
#import "ZHDBData.h"
#import "ZHdyrsModel.h"
#import "ZHaroModel.h"




ZHPassDataJSON *instanceControl;

@implementation ZHPassDataJSON


+ (ZHPassDataJSON *)share
{
    if (instanceControl == nil)
    {
        instanceControl = [[ZHPassDataJSON alloc] init];
    }
    
    return instanceControl;
}


- (id) init
{
    self = [super init];
    if (self){
    }
    return self;
}






- (void)jsonSqlType:(NSDictionary *)tableSqlDict  tableName:(Tables_name)tableName
{
    
    if ([[[tableSqlDict objectForKey:@"sqltype"] stringValue] isEqualToString:Kinsert]) {
        
        [[ZHDBData share] insertDictToDB:tableSqlDict tableName:tableName];
    }
    else if ([[[tableSqlDict objectForKey:@"sqltype"] stringValue] isEqualToString:Kupdate]) {
        
        [[ZHDBData share] updataDictToDB:tableSqlDict tableName:tableName];
    }
    else if ([[[tableSqlDict objectForKey:@"sqltype"] stringValue] isEqualToString:Kdelete]) {
        [[ZHDBData share] deleteDictToDB:tableSqlDict tableName:tableName];
    }
}


/*
 *  遍历  所有
 *
 *
 */
- (void)insertToDB:(NSArray *)array tableName:(Tables_name)tableName
{
    
    for (NSDictionary *userDict in array) {
        
        [self jsonSqlType:userDict tableName:tableName];
    }
}


/*
 
 判断该表数据是否存在后
 
 以   table  为键名的   取得表数据
 
 */
- (void)jsonToTableDB:(NSDictionary *)jsonDict
{
    
    
    if ([jsonDict objectForKey:@"user"])
    {
        [self insertToDB:[jsonDict objectForKey:@"user"] tableName:UserTable];
    }
    
    
    if ([jsonDict objectForKey:@"member"])
    {
        [self insertToDB:[jsonDict objectForKey:@"member"] tableName:MemberTable];
    }
    
    if ([jsonDict objectForKey:@"acces"])
    {
        [self insertToDB:[jsonDict objectForKey:@"acces"] tableName:AccessoriesTable];
    }
    
    
    if ([jsonDict objectForKey:@"images"])
    {
        [self insertToDB:[jsonDict objectForKey:@"images"] tableName:ImagesTable];
    }
    
    if ([jsonDict objectForKey:@"cases"])
    {
        [self insertToDB:[jsonDict objectForKey:@"cases"] tableName:CasesTable];
    }
    
    
    if ([jsonDict objectForKey:@"dept"])
    {
        [self insertToDB:[jsonDict objectForKey:@"dept"] tableName:DepartmentTable];
    }
    
    if ([jsonDict objectForKey:@"category"])
    {
        [self insertToDB:[jsonDict objectForKey:@"category"] tableName:CategoryTable];
    }
    
    
    if ([jsonDict objectForKey:@"acces"])
    {
        [self insertToDB:[jsonDict objectForKey:@"acces"] tableName:AccessoriesTable];
    }
    
}




- (void)jsonToDB:(NSDictionary *)jsonDict
{
    
    
    dispatch_queue_t queue = dispatch_queue_create("com.ple.queue", NULL);
    dispatch_async(queue, ^(void) {
        

        [self jsonToTableDB:jsonDict];
            
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.delegate performSelector:@selector(passDidFinish:)];
            
        });
        
        
    });
    

}





@end
