//
//  LawViewController.h
//  
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface LawViewController : BaseViewController<UITableViewDataSource, UITableViewDelegate>
{
    int currentSetp;
    
    
    UILabel *type_lable;
    UILabel *date_lable;
    
}


@property(nonatomic,retain) UITableView *tableView;

@property(nonatomic,retain) NSMutableArray *dataArray;



@end
