//
//  NewsDetailViewController.h
//  M32
//
//  Created by i-Bejoy on 13-11-21.
//  Copyright (c) 2013年 zeng hui. All rights reserved.
//




#import "BaseViewController.h"
#import "FileViewController.h"

@interface NewsDetailViewController : BaseViewController<UITableViewDataSource, UITableViewDelegate, UIWebViewDelegate>
{
    UIImageView *title_ImageView;
    UIImageView *type_bgImageView;

    UILabel *type_lable;
    UILabel *date_lable;
    
    
    
    UIWebView *contentWebView;
    UIScrollView *content ;
    
    NSArray *atArray;
    NSMutableArray *commentArray;
    
    
    UITableView *commentTableView;
    UIView *commentView;
    UITextView *textView;
    
    UIButton *favButton;
    
}

@property(nonatomic, strong) NSDictionary *newsDict;
@property(nonatomic, assign) int currentSuperType;
@property(nonatomic, assign) int currentType;
@property(nonatomic, strong) NSMutableArray *cateArray;

@end
