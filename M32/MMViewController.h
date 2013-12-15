//
//  MMViewController.h
//  M32
//
//  Created by i-Bejoy on 13-11-18.
//  Copyright (c) 2013年 zeng hui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavigationViewController.h"
#import "TableView.h"

@interface MMViewController : NavigationViewController<UITableViewDataSource, UITableViewDelegate>


@property(nonatomic,retain) TableView *tableView;


@end
