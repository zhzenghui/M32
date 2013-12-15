//
//  Cookie.m
//  M32
//
//  Created by i-Bejoy on 13-12-6.
//  Copyright (c) 2013年 zeng hui. All rights reserved.
//

#import "Cookie.h"

@implementation Cookie


+ (id)getCookie:(NSString *)keyName
{
	if(![keyName isEqualToString:@""] && keyName != nil)
	{

        NSMutableArray *array = (NSMutableArray *)[KNSUserDefaults objectForKey:keyName];
        
        if (array == nil) {
            array = [[NSMutableArray alloc] init];
        }
		return array;
	}
	
	return @"";
}



+ (BOOL)setCookie:(NSString *)keyName dict:(NSDictionary *)value isRepeat:(BOOL)isRepeat
{
    bool isInsert = true;

    NSMutableArray *array = [KNSUserDefaults objectForKey:keyName];
    
    if ([KNSUserDefaults objectForKey:keyName]) {
        
        array = [NSMutableArray arrayWithArray:[KNSUserDefaults objectForKey:keyName]];
    }
    else {
        
        array = [[NSMutableArray alloc] init];
    }
    
    if ( value ) {
        for (NSDictionary *d in array) {
            
            if ([[d objectForKey:@"id"] intValue] == [[value objectForKey:@"id"] intValue] &&
                [[d objectForKey:@"FavType"] intValue] == [[value objectForKey:@"FavType"] intValue] &&
                [[d objectForKey:@"userid"] intValue] == SharedAppUser.ID
                ) {
                isInsert = false;
            }
        }
        
        
        if ( isInsert ) {
            [array addObject:value];
            [Cookie setCookie:keyName value:array];
            
        }
    }
    
    return isInsert;
}

+ (void)setCookie:(NSString *)keyName dict:(NSDictionary *)value
{
    
    NSMutableArray *array;
    
    if ([KNSUserDefaults objectForKey:keyName]) {
        
        array = [NSMutableArray arrayWithArray:[KNSUserDefaults objectForKey:keyName]];
    }
    else {
        
        array = [[NSMutableArray alloc] init];
    }
    
    [array addObject:value];
    [KNSUserDefaults setObject:array forKey:keyName];
    [KNSUserDefaults synchronize];
}

+ (void)setCookie:(NSString *)keyName value:(id)value;
{
    
    if ([[value class] isSubclassOfClass:[NSDictionary class]]) {
        
        if ([KNSUserDefaults objectForKey:keyName]) {
            
            NSMutableArray *array = [NSMutableArray arrayWithArray:[KNSUserDefaults objectForKey:keyName]];
            

            [array addObject:value];
            [KNSUserDefaults setObject:array forKey:keyName];
        }
        else {
            
            NSMutableArray *array = [[NSMutableArray alloc] init];
            [array addObject:value];
            [KNSUserDefaults setObject:array forKey:keyName];

        }
    }
    else {
        [KNSUserDefaults setObject:value forKey:keyName];
    }

    [KNSUserDefaults synchronize];
    
    
}






@end
