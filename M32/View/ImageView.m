//
//  ImageView.m
//  NetWork
//
//  Created by mbp  on 13-8-2.
//  Copyright (c) 2013年 zeng hui. All rights reserved.
//

#import "ImageView.h"
#import "CommonMethod.h"
#import "Unit.h"


static ImageView *imageView;


@implementation ImageView

+ (id)share
{
    if (imageView) {
        return imageView;
    }
    imageView = [[ImageView alloc] init];
    return imageView;
}

- (id) init
{
    self = [super init];
    if (self)
    {
    }
    return self;
}


- (UIImageView *)addSelfView:(UIView *)view imagePathName:(NSString *)imagePathName pathNameType:(NSString *)pathNameType rect:(CGRect)frame
{
    
    NSString  *path1 = [MAINBUNDLE pathForResource:imagePathName ofType:pathNameType];
    
    UIImage* img =  [[UIImage alloc] initWithContentsOfFile:path1];
    
    UIImageView  *imageView= [[UIImageView alloc] initWithFrame:frame];
    imageView.image  = img;

    [view addSubview:imageView];
    
    return  imageView;
}

- (UIImageView *)addSelfView:(UIView *)view imagePathNamePNG:(NSString *)imagePathName rect:(CGRect)frame
{
    return [self addSelfView:view imagePathName:imagePathName pathNameType:@"png" rect:frame];
    
}

- (UIImageView *)addSelfView:(UIView *)view imagePathNameJPG:(NSString *)imagePathName rect:(CGRect)frame
{
    return [self addSelfView:view imagePathName:imagePathName pathNameType:@"jpg" rect:frame];
}


@end
