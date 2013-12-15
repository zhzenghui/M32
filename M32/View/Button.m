//
//  Button.m
//  NetWork
//
//  Created by mbp  on 13-8-2.
//  Copyright (c) 2013年 zeng hui. All rights reserved.
//

#import "Button.h"

static Button *button;

@implementation Button

+ (id)share
{
    if (button) {
        return button;
    }
    button = [[Button alloc] init];
    return button;
}

- (id) init
{
    self = [super init];
    if (self)
    {
    }
    return self;
}

- (UIButton *)addSelfView:(UIView *)view
                     rect:(CGRect)rect
                      tag:(int)tag
                   action:(SEL)action
                imagePath:(NSString *)imagePath
     highlightedImagePath:(NSString *)highlightedImagePath
{
    
    NSString  *path1 = nil;
    NSString  *path2 = nil;
    UIImage* img = nil;
    UIImage* img2 = nil;
    
    
    if (imagePath) {
        path1 = [MAINBUNDLE pathForResource:imagePath ofType:@"png"];
        img =  [[UIImage alloc] initWithContentsOfFile:path1];
    }
    
    if (highlightedImagePath) {
        path2 = [MAINBUNDLE pathForResource:highlightedImagePath ofType:@"png"];
        img2 =  [[UIImage alloc] initWithContentsOfFile:path2];
    }

    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    
    if (img) {
        [button setImage:img forState:UIControlStateNormal];

    }
    if (img2) {
        [button setImage:img2 forState:UIControlStateHighlighted];
    }
    
    
    button.frame = rect;
    button.tag = tag;
    
    [view addSubview:button];
    
    return button;
}




- (UIButton *)addSelfView:(UIView *)view
               rect:(CGRect)rect
                      tag:(int)tag
                   action:(SEL)action
                imagePath:(NSString *)imagePath
{

    
    return [self addSelfView:view rect:rect tag:tag action:action imagePath:imagePath highlightedImagePath:nil];
}




- (UIButton *)addSelfView:(UIView *)view
               rect:(CGRect)rect
                      tag:(int)tag
                   action:(SEL)action

{
    return [self addSelfView:view rect:rect tag:tag action:action imagePath:nil highlightedImagePath:nil];
}

@end
