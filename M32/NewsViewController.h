//
//  NewsViewController.h
//  M32
//
//  Created by i-Bejoy on 13-11-18.
//  Copyright (c) 2013年 zeng hui. All rights reserved.
//




enum {
    CateType_,
    CateType_Type = 1,
    CateType_Regulatory = 2,
    CateType_Identity = 3,
    CateType_International = 4,
    CateType_New = 5
    
};
typedef UInt32 CateType;



#import <UIKit/UIKit.h>
#import "BaseTableViewController.h"
#import "TableView.h"
#import "TypeTableView.h"

@interface NewsViewController : BaseViewController<UITableViewDataSource, UITableViewDelegate, TypeTableViewDelegate>
{
    TypeTableView *typeTableView;
    UIView *typeView;
    
    
    int currentType;
    int currentSuperType;
    
    NSIndexPath *currentSelectCell;
    
    
    UIButton *currentButton;
    
    
    NSMutableArray *newsReadArray;

    NSMutableArray *cateArray;
    
    
    
}
@property(nonatomic,retain) TableView *tableView;

@property(nonatomic,retain) NSMutableArray *dataArray;


@end
