//
//  LawViewController.h
//  
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface LawViewController : BaseViewController<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>
{
    int currentSetp;
    
    
    UILabel *type_lable;
    UILabel *date_lable;
    
    
    bool noResults;
}


@property(nonatomic,retain) UITableView *tableView;

@property(nonatomic,retain) NSMutableArray *dataArray;



@end
