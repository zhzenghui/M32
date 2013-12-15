//
//  AboutViewController.m
//  M32
//
//  Created by i-Bejoy on 13-12-9.
//  Copyright (c) 2013年 zeng hui. All rights reserved.
//

#import "AboutViewController.h"
#import "IIViewDeckController.h"

@interface AboutViewController ()

@end

@implementation AboutViewController

- (void)popViewController
{

    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)setNavigationBarView
{
    
    
    UIView  *navigationBarView = [[UIView alloc] init];
    if (iOS7) {
        navigationBarView.frame = NavitionRectMake(0, 0, 640, 64);
    }
    else {
        navigationBarView.frame = NavitionRectMake(0, 0, 640, 44);
    }
    
    
    NSString *navImageName = [NSString string];
    if (iOS7) {
        navImageName = @"nav-bg-7";
    }else {
        navImageName = @"nav-bg";
    }
    UIImage *img = [UIImage imageNamed:navImageName] ;
    
    navigationBarView.backgroundColor = [UIColor colorWithPatternImage:img];
    
    
    
    
//    UIButton *leftBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    
//    [leftBarButton addTarget:self action:@selector(popViewController) forControlEvents:UIControlEventTouchUpInside];
//    [leftBarButton setImage:[UIImage imageNamed:@"nav-左标"] forState:UIControlStateNormal];
//    leftBarButton.frame = NavitionRectMake(14, 30, 27, 25);

    UIButton *fasongButton = [UIButton buttonWithType:UIButtonTypeCustom];
    fasongButton.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"news_conent_arrowup"]];
    [fasongButton addTarget:self action:@selector(popViewController) forControlEvents:UIControlEventTouchUpInside];
    
    fasongButton.frame = RectMake2x(0, 40, 81, 88);
    

    
    [navigationBarView addSubview:fasongButton];
    
    
    [self.baseView  addSubview:navigationBarView];
    
    
    
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self setNavigationBarView];
    
    
    if (iOS7) {
        
        UIImageView *statuebar_gb_ImageView = [[UIImageView alloc] init];
        statuebar_gb_ImageView.image = [UIImage imageNamed:@"statuebar_bg.jpg"];
        statuebar_gb_ImageView.frame = NavitionRectMake(0, 0, 320, 20);
        
        [self.baseView addSubview:statuebar_gb_ImageView];
    }
    
    sv = [[UIScrollView alloc] init];

    sv.frame = RectMake2x(40, 168, 560, (screenHeight*2 )-168);
    [sv setContentSize:CGSizeMake(560/2, 1329/2+80)];
    sv.showsHorizontalScrollIndicator = NO;
    sv.showsVerticalScrollIndicator = NO;

    self.baseView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"aboutour"]];
    [self.baseView addSubview:sv];
    
    
    
    UIImageView *aboutImageView = [[UIImageView alloc] init];
    aboutImageView.frame = RectMake2x(0, 0, 560, 1329);

    aboutImageView.image = [UIImage imageNamed:@"aboutour_wenzi"];
    [sv addSubview:aboutImageView];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
