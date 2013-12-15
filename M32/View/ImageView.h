//
//  ImageView.h
//  NetWork
//
//  Created by mbp  on 13-8-2.
//  Copyright (c) 2013年 zeng hui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommonMethod.h"

@interface ImageView : NSObject

- (UIImageView *)addSelfView:(UIView *)view imagePathNamePNG:(NSString *)imagePathName rect:(CGRect)frame;
- (UIImageView *)addSelfView:(UIView *)view imagePathNameJPG:(NSString *)imagePathName rect:(CGRect)frame;

+ (id)share;


@end
