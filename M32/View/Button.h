//
//  Button.h
//  NetWork
//
//  Created by mbp  on 13-8-2.
//  Copyright (c) 2013年 zeng hui. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Button : NSObject



+ (id)share;



- (UIButton *)addSelfView:(UIView *)view
               rect:(CGRect)rect
                      tag:(int)tag
                   action:(SEL)action
                imagePath:(NSString *)imagePath
     highlightedImagePath:(NSString *)highlightedImagePath;

- (UIButton *)addSelfView:(UIView *)view
               rect:(CGRect)rect
                      tag:(int)tag
                   action:(SEL)action;


- (UIButton *)addSelfView:(UIView *)view rect:(CGRect)rect
                      tag:(int)tag
                   action:(SEL)action
                imagePath:(NSString *)imagePath;



@end
