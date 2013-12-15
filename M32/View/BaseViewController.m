//
//  BaseViewController.m
//  Dyrs
//
//  Created by mbp  on 13-8-22.
//  Copyright (c) 2013年 zeng hui. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController


- (void)back:(UIButton *)button
{
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return (toInterfaceOrientation == UIInterfaceOrientationLandscapeRight|| toInterfaceOrientation == UIDeviceOrientationLandscapeLeft);
}

- (void)resetBlackTitle
{

    
    self.titleLabel.textColor = [UIColor blackColor];
    self.subTitleLabel.textColor = [UIColor blackColor];
    
    
    [self.rightButton setImage:nil forState:UIControlStateNormal];

//    [self.rightButton setImage:[UIImage imageNamed:@"logo-black"] forState:UIControlStateNormal];
    
}

- (void)resetWhiteTitle
{
    
    
//    self.titleLabel.frame = CGRectMake(28, 28, 187, 20);
//    self.subTitleLabel.frame = CGRectMake(138, 34, 281, 13);
//    
    
    
    self.titleLabel.textColor = [UIColor whiteColor];
    self.subTitleLabel.textColor = [UIColor whiteColor];
    
    
    [self.rightButton setImage:nil forState:UIControlStateNormal];

//    [self.rightButton setImage:[UIImage imageNamed:@"logo-white"] forState:UIControlStateNormal];
    
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

- (UIImageView *)addSelfView:(UIView *)view imagePathName:(NSString *)imagePathName rect:(CGRect)frame
{
    UIImage* img =  [[UIImage alloc] initWithContentsOfFile:imagePathName];
    
    UIImageView  *imageView= [[UIImageView alloc] initWithFrame:frame];
    imageView.image  = img;
    [view addSubview:imageView];
    
    return  imageView;
}


- (UIButton *)addSelfView:(UIView *)view
                     rect:(CGRect)rect
                      tag:(int)tag
                   action:(SEL)action
                imagePath:(NSString *)imagePath
     highlightedImagePath:(NSString *)highlightedImagePath
{
    


    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
//    button.backgroundColor = [UIColor redColor];

    [button setImage:[UIImage imageNamed:imagePath] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:highlightedImagePath] forState:UIControlStateSelected];

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
     highlightedImagePath:(NSString *)highlightedImagePath
     SelectedImagePath:(NSString *)SelectedImagePath

{
    
    
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
//    button.backgroundColor = [UIColor clearColor];
//    [button.layer setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.5].CGColor];
    
    CALayer *layer = button.layer;
    layer.backgroundColor = [[UIColor clearColor] CGColor];
 
    
    
    
    [button setImage:[UIImage imageNamed:imagePath] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:highlightedImagePath] forState:UIControlStateHighlighted];
    [button setImage:[UIImage imageNamed:SelectedImagePath] forState:UIControlStateSelected];

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



- (void)addMemu
{
    
}



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.view .backgroundColor = [UIColor whiteColor];
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(28, 28, 87, 19)];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.backgroundColor  = [UIColor clearColor];
        [_titleLabel setFont:[UIFont systemFontOfSize:19]];
        
        _subTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(138, 34, 51, 13)];
        _subTitleLabel.textColor = [UIColor blackColor];
        _subTitleLabel.backgroundColor  = [UIColor clearColor];
        [_subTitleLabel setFont:[UIFont systemFontOfSize:13]];
        
        [self.view addSubview:_titleLabel];
        [self.view addSubview:_subTitleLabel];
        

        
        
        self.titleLabel.frame = CGRectMake(28, 28, 187, 20);
        self.subTitleLabel.frame = CGRectMake(138, 34, 281, 13);

    }
    return self;
}

- (void)loadView
{
    [super loadView];
    
    
    _baseView = [[UIView alloc] initWithFrame:self.view.frame];

    _baseView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);

//    if (iOS7) {
//        _baseView.frame = RectMake2x(0, 20, 640, 600);
//    }
//    else {
//        _baseView.frame = RectMake2x(0, 0, 640, 600);
//    }

    

    
    [self.view addSubview:_baseView];
}




- (void)viewDidLoad
{
    [super viewDidLoad];

    self.baseView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"user_bg"]];

    [_titleLabel setText:@""];
    [_subTitleLabel setText:@""];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    
    
    if (iOS7) {
        
        UIImageView *statuebar_gb_ImageView = [[UIImageView alloc] init];
        statuebar_gb_ImageView.image = [UIImage imageNamed:@"statuebar_bg.jpg"];
        statuebar_gb_ImageView.frame = NavitionRectMake(0, 0, 320, 20);
        
        [self.view addSubview:statuebar_gb_ImageView];
    }
    
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
