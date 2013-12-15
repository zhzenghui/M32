//
//  DailyViewController.h
//  M32
//
//  Created by i-Bejoy on 13-11-20.
//  Copyright (c) 2013年 zeng hui. All rights reserved.
//

#import "BaseViewController.h"

@interface DailyViewController : BaseViewController<UITableViewDataSource, UITableViewDelegate>



@property(nonatomic,retain) UITableView *tableView;

@property(nonatomic,retain) NSMutableArray *dataArray;



@end
