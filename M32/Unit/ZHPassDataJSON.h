//
//  ZHPassDataJSON.h
//  NetWork
//
//  Created by mbp  on 13-8-9.
//  Copyright (c) 2013年 zeng hui. All rights reserved.
//



#import <Foundation/Foundation.h>


@protocol ZHPassDataJSONDelegate;

@interface ZHPassDataJSON : NSObject
{
    
    

}
@property (nonatomic, assign) id <ZHPassDataJSONDelegate> delegate;




/*  数据的json dict   ，进行解析 */
- (void)jsonToDB:(NSDictionary *)jsonDict;

@end


@protocol ZHPassDataJSONDelegate <NSObject>


- (void)passDidFinish:(NSDictionary *)jsonDict;

@end