//
//  DailyViewController.m
//  M32
//
//  Created by i-Bejoy on 13-11-20.
//  Copyright (c) 2013年 zeng hui. All rights reserved.
//

#import "DailyViewController.h"
#import "ZHNavigationViewController.h"
#import "DailyDetailViewController.h"
#import "IIViewDeckController.h"

#import "SVPullToRefresh.h"


@interface DailyViewController ()
{
    int curPage;
    
    bool isInfiniteScroll;

}
@end

@implementation DailyViewController



- (void)insertRowAtTop {
    
    [_dataArray removeAllObjects];
    _dataArray = nil;
    [self.tableView reloadData];

    curPage = 1;
    
    [self loadNetWorkData];
    
}


- (void)insertRowAtBottom {
    
    curPage ++;
    
    [self loadNetWorkData];
    
}


- (void)addArray:(NSArray *)array
{
    
    for (id dict in array) {
        [_dataArray addObject:dict];
    }
    
    
}

- (void)reloadTable
{
    [self.tableView reloadData];
}

- (void)addBottom
{
    
    if (_dataArray.count == 4 && !isInfiniteScroll) {
        
        isInfiniteScroll = true;
        __weak DailyViewController *weakSelf = self;
        
        [self.tableView addInfiniteScrollingWithActionHandler:^{
            [weakSelf insertRowAtBottom];
        }];
    }
}


- (void)loadNetWorkData
{
    
    
    
    NSString *url = [NSString stringWithFormat:@"%@journal/getJournalList/%d/%d/", KHomeUrl, KPageSize, curPage];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        NSArray *array = [responseObject objectForKey:@"list"];
        __weak DailyViewController *weakSelf = self;
        
        
        
        if (array .count != 0) {
            if (_dataArray.count == 0) {
                
                _dataArray = [NSMutableArray arrayWithArray:array];
                [self reloadTable];
                [weakSelf.tableView.pullToRefreshView stopAnimating];
                
            }
            else {
                
                
                NSMutableArray *indexPaths = [NSMutableArray array];
                
                for (int i = 0; i< array.count ; i++) {
                    
                    [indexPaths addObject:[NSIndexPath indexPathForRow:weakSelf.dataArray.count+i inSection:0]];
                    
                }
                [self addArray:array];
                
                
                [weakSelf.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationTop];
//                [weakSelf.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:weakSelf.dataArray.count-2 inSection:0]
//                                          atScrollPosition:UITableViewScrollPositionTop animated:YES];
                [weakSelf.tableView.infiniteScrollingView stopAnimating];
                
            }
            
            [self addBottom];
        }
        else {
            curPage --;
            [weakSelf.tableView.infiniteScrollingView stopAnimating];
            
        }
        
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
    
    
}

- (void)setNavigationBarView
{
    
    
    UIView  *navigationBarView = [[UIView alloc] init];
    if (iOS7) {
        navigationBarView.frame = CGRectMake(0, 0, 640, 64);
    }
    else {
        navigationBarView.frame = CGRectMake(0, 0, 640, 44);
    }
    
    
    NSString *navImageName = [NSString string];
    if (iOS7) {
        navImageName = @"nav-bg-7";
    }else {
        navImageName = @"nav-bg";
    }
    UIImage *img = [UIImage imageNamed:navImageName] ;
    
    navigationBarView.backgroundColor = [UIColor colorWithPatternImage:img];
    
    
    
    
    
    UIButton *leftBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [leftBarButton addTarget:self.viewDeckController action:@selector(toggleLeftView) forControlEvents:UIControlEventTouchUpInside];
    [leftBarButton setImage:[UIImage imageNamed:@"nav-左标"] forState:UIControlStateNormal];
    leftBarButton.frame = NavitionRectMake(5, 20, 44, 44);
    
    
    UIButton *rightBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [rightBarButton addTarget:self.viewDeckController action:@selector(toggleRightView) forControlEvents:UIControlEventTouchUpInside];
    [rightBarButton setImage:[UIImage imageNamed:@"nav-右标"] forState:UIControlStateNormal];
    rightBarButton.frame = NavitionRectMake(275, 20, 44, 44);
    
    
    [navigationBarView addSubview:leftBarButton];
    [navigationBarView addSubview:rightBarButton];
    
    
    
    
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



- (void)loadView
{
    [super loadView];
    
    curPage = 1;
    isInfiniteScroll = false;
    
    
    
    if (! iOS7) {
        self.baseView.frame = CGRectMake(0, -20, screenWidth, screenHeight);
    }
    
    [self setNavigationBarView];
    
    
    _tableView = [[UITableView alloc] init];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.delegate = self;
    _tableView.dataSource =  self;
    
    _tableView.frame = NavitionRectMake(0, 64+(71/2), 320, screenHeight-64-(71/2));;
    
    [self.baseView  addSubview:_tableView];
    
    if (iOS7) {
        
        UIImageView *statuebar_gb_ImageView = [[UIImageView alloc] init];
        statuebar_gb_ImageView.image = [UIImage imageNamed:@"statuebar_bg.jpg"];
        statuebar_gb_ImageView.frame = NavitionRectMake(0, 0, 320, 20);
        
        [self.view addSubview:statuebar_gb_ImageView];
    }
    
    
    
//    [SharedApplication setStatusBarStyle:UIStatusBarStyleBlackTranslucent];
    
    
    
    
    //    typeView = [[UIView alloc] initWithFrame:NavitionRectMake(0, 97, 320,  471 )];
    //    typeView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"黑底"]];
    //    typeView.alpha = 0;
    //
    //
    //    typeTableView = [[TypeTableView alloc] init];
    //    typeTableView.frame = NavitionRectMake(0, 0, 320, 471);
    //    typeTableView.typeTableViewdelegate = self;
    //    [typeView addSubview:typeTableView];
    //
    //    [self.baseView  addSubview:typeView];
    
    
    
    
    //    UIView *adView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    //
    //    adView.frame = NavitionRectMake(0, screenHeight-44, 320, 44);
    //    adView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"广告条"]];
    //    
    //    [self.baseView  addSubview:adView];
    
    
    UIView *cView = [[UIView alloc] initWithFrame:RectMake2x(0, 128, 640, 71)];
    cView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"fav_title"]];
    
    
    
    UILabel *l1 = [[UILabel alloc] initWithFrame:RectMake2x(20, 0, 640, 71)];
    l1.text = @"日志";
    l1.font = [UIFont boldSystemFontOfSize:15];
    
    [cView addSubview:l1];
    
    
    UILabel *l2 = [[UILabel alloc] initWithFrame:RectMake2x(-20, 0, 640, 71)];
    l2.textAlignment = NSTextAlignmentRight;
    l2.font = [UIFont boldSystemFontOfSize:15];
    l2.text = [NSDate stringFromDate:[NSDate date] withFormat:@"YYYY"];

    [cView addSubview:l2];
    
    
    
    
    [self.baseView addSubview:cView];
    
    
    
    
    UIView *adView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    
    if (iOS7) {
        adView.frame = NavitionRectMake(0, screenHeight-44, 320, 44);
    }
    else {
        adView.frame = NavitionRectMake(0, screenHeight-64, 320, 44);
        
        
    }
    adView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"广告条"]];
    
    [self.baseView  addSubview:adView];
    
    
    
}




- (void)viewDidLoad
{
    [super viewDidLoad];


    
    __weak DailyViewController *weakSelf = self;
    
    // setup pull-to-refresh
    [self.tableView addPullToRefreshWithActionHandler:^{
        [weakSelf insertRowAtTop];
    }];
    
    [weakSelf.tableView triggerPullToRefresh];

    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 259/2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"daliy_cell_bg"]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

//        UIImageView *zanImageView = [[UIImageView alloc] init];
//        zanImageView.tag = 103;
//        zanImageView.frame = RectMake2x(40, 40, 53, 49);
//        [cell.contentView addSubview:zanImageView];
        
        
        
        UILabel *nameLable = [[UILabel alloc] initWithFrame:RectMake2x(220, 62, 348, 30)];
        nameLable.tag = 100;
        [nameLable setNumberOfLines:2];
        nameLable.lineBreakMode = NSLineBreakByTruncatingTail;
        
        [cell.contentView addSubview:nameLable];
        
        
        UILabel *contentLable = [[UILabel alloc] initWithFrame:RectMake2x(220, 134, 348, 97)];
        [contentLable setNumberOfLines:2];
        contentLable.lineBreakMode = NSLineBreakByTruncatingTail;
        contentLable.tag = 101;
        [contentLable setFont:[UIFont systemFontOfSize:12]];
        contentLable.textColor = [UIColor grayColor];
        [cell.contentView addSubview:contentLable];
        
        
        
        UILabel *dateYueLable = [[UILabel alloc] initWithFrame:RectMake2x(90, 138, 100, 35)];
        dateYueLable.textColor =  [UIColor grayColor];
        [dateYueLable setFont:[UIFont boldSystemFontOfSize:14]];
        dateYueLable.tag = 102;
        [cell.contentView addSubview:dateYueLable];
        

        UILabel *dateRiLable = [[UILabel alloc] initWithFrame:RectMake2x(86, 56, 100, 71)];
        dateRiLable.textColor =  [UIColor whiteColor];
        [dateRiLable setFont:[UIFont boldSystemFontOfSize:29]];
        dateRiLable.tag = 104;
        [cell.contentView addSubview:dateRiLable];
        
    }
    
    
    UILabel *nameLable = (UILabel *)[cell.contentView viewWithTag:100];
    UILabel *contentLable = (UILabel *)[cell.contentView viewWithTag:101];
    UILabel *dateYueLable = (UILabel *)[cell.contentView viewWithTag:102];
    UILabel *dateRiLable = (UILabel *)[cell.contentView viewWithTag:104];

//    UIImageView *zanImageView = (UIImageView *)[cell.contentView viewWithTag:103];
    
    NSDictionary *dict = [_dataArray objectAtIndex:indexPath.row];
    

    NSString *dateString = [NSDate dateWithTimestamp:[[dict objectForKey:@"showTime"] longLongValue]/1000];
    
    
    dateYueLable.text = [NSString stringWithFormat:@"%@月", [dateString substringWithRange:NSMakeRange(5, 2)]];;
    dateRiLable.text = [NSString stringWithFormat:@"%@", [dateString substringWithRange:NSMakeRange(8, 2)]];
    

    
    nameLable.text = [dict objectForKey:@"title"];
    [nameLable sizeToFit];

//    CGSize fSize = [nameLable.text sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(362/2, 11111)];
//    CGRect r = nameLable.frame;
//    if (fSize.height < 20) {
//        fSize.height = 20;
//    }
//    if (fSize.height > 60) {
//        fSize.height = 60;
//        
//    }
//    r.size = fSize;
//    
//    nameLable.frame  = r;
    
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[[dict objectForKey:@"showTime"] longLongValue]/1000];
    
    NSString *formattedDateString = [dateFormatter stringFromDate:date];
    

    
    NSString *s = [NSString stringWithFormat: @"%@/%@", formattedDateString, [dict objectForKey:@"address"]];
    contentLable.text = s ;
    
    
//    if (1) {
//        zanImageView.image = [UIImage imageNamed:@"law_filetype_pdf"];
//    }
//    else {
//        zanImageView.image = [UIImage imageNamed:@"law_filetype_word"];
//        zanImageView.image = [UIImage imageNamed:@"law_filetype_xls"];
//    }
    
    
    
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    DailyDetailViewController *newsDetail = [[DailyDetailViewController alloc] init];
    newsDetail.dailyDict = [_dataArray objectAtIndex:indexPath.row];
    
    [self.zhNavigationController pushViewController:newsDetail];
    
}

#pragma mark - Table view delegate

- (void)didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
}


@end
