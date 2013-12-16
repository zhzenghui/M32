//
//  NewsViewController.m
//  M32
//
//  Created by i-Bejoy on 13-11-18.
//  Copyright (c) 2013年 zeng hui. All rights reserved.
//

#import "NewsViewController.h"
#import "ZHNavigationViewController.h"
#import "NewsCell.h"
#import "TypeTableView.h"

#import "AFNetworking.h"
#import "SVPullToRefresh.h"
#import "IIViewDeckController.h"
#import "UIImageView+WebCache.h"
#import "UIButton+Utilities.h"

#import "NewsDetailViewController.h"


@interface NewsViewController ()
{
    int curPage;
    int maxPage;
    bool isInfiniteScroll;
}
         
@end

@implementation NewsViewController





#pragma mark - Actions


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
        __weak NewsViewController *weakSelf = self;
        
        [self.tableView addInfiniteScrollingWithActionHandler:^{
            [weakSelf insertRowAtBottom];
        
        
            [weakSelf.tableView.infiniteScrollingView stopAnimating];

        }];
    }
}

- (void)updateReaded:(NSArray *)array
{

    if (_dataArray == nil) {
        _dataArray = [[NSMutableArray alloc] init];
    }

    bool isInsert = true;
    
    for (NSDictionary *dict in array) {
        isInsert = true;

        NSMutableDictionary *d = [NSMutableDictionary dictionaryWithDictionary:dict];

        for (int i =0; i <newsReadArray.count; i++) {
            
            int iid =  [[[newsReadArray objectAtIndex:i] objectForKey:@"id"] intValue];
            
            if ( [[dict objectForKey:@"id"] intValue]== iid ) {
                
                [d setValue:[NSNumber numberWithInt:1] forKey:@"readed"];
                
                [_dataArray addObject:d];
                isInsert = false;
                break;
            }
            
        }

        if (isInsert) {
            [_dataArray addObject:dict];
        }
    }
    
}

- (void)insertReadArr
{
    
}

- (void)loadNetWorkData
{


    if ( currentType == 0   ) {
        currentType = -1;
    }
    
    NSString *url = [NSString stringWithFormat:@"%@info/getInfoList/%d/%d/%d/", KHomeUrl, (unsigned int)currentType, KPageSize, curPage];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {

        
        NSArray *array = [responseObject objectForKey:@"list"];
        __weak NewsViewController *weakSelf = self;

        
        
        if (array .count != 0) {
            if (_dataArray.count == 0) {


                [self updateReaded:array];
                
                [self reloadTable];
                [weakSelf.tableView.pullToRefreshView stopAnimating];
                [weakSelf.tableView.infiniteScrollingView stopAnimating];



            }
            else {


                NSMutableArray *indexPaths = [NSMutableArray array];
                
                for (int i = 0; i< array.count ; i++) {

                    [indexPaths addObject:[NSIndexPath indexPathForRow:weakSelf.dataArray.count+i inSection:0]];

                }
//                [self addArray:array];
                [self updateReaded:array];

                
                [weakSelf.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationTop];
//                [weakSelf.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:weakSelf.dataArray.count-2 inSection:0]
//                                          atScrollPosition:UITableViewScrollPositionTop animated:YES];
                [weakSelf.tableView.infiniteScrollingView stopAnimating];

            }
            [self addBottom];


        }
        else {
            curPage --;
            [weakSelf.tableView.pullToRefreshView stopAnimating];
            [weakSelf.tableView.infiniteScrollingView stopAnimating];

        }
        
        

        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        __weak NewsViewController *weakSelf = self;

        [weakSelf.tableView.pullToRefreshView stopAnimating];
    
    }];
}

- (void)loadSubCate:(int)cateID
{
    
    NSString *url = [NSString stringWithFormat:@"%@info/getCateList/%d/", KHomeUrl, cateID];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
//        NSArray *array = [responseObject objectForKey:@"list"];

        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);

        
    }];
}

- (void)showCam:(id)sender
{
}

- (void)previewBounceLeftView {
    [self.viewDeckController previewBounceView:IIViewDeckLeftSide];
}

- (void)previewBounceRightView {
    [self.viewDeckController previewBounceView:IIViewDeckRightSide];
}

- (void)previewBounceTopView {
    [self.viewDeckController previewBounceView:IIViewDeckTopSide];
}

- (void)previewBounceBottomView {
    [self.viewDeckController previewBounceView:IIViewDeckBottomSide];
}

- (void)cateArrayForID:(int)cateID
{
    
    NSMutableArray *cArray = [NSMutableArray array];
    
    NSDictionary *d = @{@"id": [NSNumber numberWithInt: currentSuperType], @"name":@"全部资讯", @"lastInfoNum":[NSNumber numberWithInt:0]};
    [cArray addObject:d];
    
    
    for (NSDictionary *dict in cateArray) {
        
        if ([[dict objectForKey:@"parentId"] intValue]  == cateID) {
            [cArray addObject:dict];
        }
    }
    
    typeTableView.dataArray = cArray;
    [typeTableView reloadData];

    if (currentSelectCell == nil) {
        [typeTableView setSelectCell:[NSIndexPath indexPathForItem:0 inSection:0]];
    }
    else {
        [typeTableView setSelectCell:currentSelectCell];
    }

    
}


- (void)openSubNews:(int)tag
{

    [self cateArrayForID:tag];
    
    if (typeView.frame.origin.y == 105/2) {
        
    }
    
    typeView.alpha = 1;
    [UIView animateWithDuration:KDuration animations:^{

        if (iOS7) {
            typeView.frame = NavitionRectMake(0, 105, 320, 471);;
        }
        else {
            typeView.frame = NavitionRectMake(0, 77, 320, 471);;
            
        }
    }];
}

- (void)closeSubNews
{
    
    [UIView animateWithDuration:KDuration animations:^{

        if (iOS7) {
            typeView.frame = NavitionRectMake(0, -471, 320, 471);;
        }
        else {
            typeView.frame = NavitionRectMake(0, -471, 320, 471);;
            
        }

    }completion:^(BOOL finished) {
        if (finished) {
            typeView.alpha = 1;
        }
    }];

}

- (void)updateCateButton:(UIButton *)button
{
    for (int i = 1; i< 6; i++) {
        UIButton *b = (UIButton *) [self.baseView  viewWithTag:i];
        b.selected = NO;

    }
    
    button.selected = YES;
}

- (void)todoSomething:(UIButton *)button
{
    
    
//    NSLog(@"%d", button.tag);

    currentType =  button.tag;
    curPage = 1;
    
    [_dataArray removeAllObjects];
    [self.tableView reloadData];
    
    __weak NewsViewController *weakSelf = self;

    
    [weakSelf.tableView triggerPullToRefresh ];

}

- (void)openNewsType:(UIButton *)button
{
    [button setRemind:NO];

    if (currentButton == button) {
        currentType = 1;
        [self closeSubNews];
        currentButton = nil;
        return;
    }
    
    
    [self closeSubNews];
    currentButton = button;

    currentSuperType = -1;

    [self updateCateButton:button];


    
//    __weak NewsViewController *weakSelf = self;


    
    switch (button.tag) {
        case CateType_Type:
        case CateType_Regulatory:
        case CateType_Identity:
        {

            currentSuperType =  button.tag;
            [self openSubNews:button.tag];
            break;
        }
        case CateType_New:
        case CateType_International:
        {

            
            [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(todoSomething:) object:button];
            
            [self performSelector:@selector(todoSomething:) withObject:button afterDelay:0.3f];
            


            break;
        }

        default:
            break;
    }
    

}

- (void)loadTypeMenu
{
    
  
    UIButton *button = [self addSelfView:self.baseView  rect:NavitionRectMake2x(0, 128, 640/5, 86) tag:CateType_Type
               action:@selector(openNewsType:)
            imagePath:@"type_class-0"
 highlightedImagePath:@"type_class-1"
    SelectedImagePath:@"type_class-1"];
    [button setSelected:YES];

    [self addSelfView:self.baseView  rect:NavitionRectMake2x(640/5, 128, 640/5, 86) tag:CateType_Regulatory
               action:@selector(openNewsType:)
            imagePath:@"type_Regulatory-0"
 highlightedImagePath:@"type_Regulatory-1"
    SelectedImagePath:@"type_Regulatory-1"];
    
   [self addSelfView:self.baseView  rect:NavitionRectMake2x((640/5)*2, 128, 640/5, 86) tag:CateType_Identity
               action:@selector(openNewsType:)
            imagePath:@"type_Identity-0"
 highlightedImagePath:@"type_Identity-1"
    SelectedImagePath:@"type_Identity-1"];

    
    
    
    UIButton *b = [self addSelfView:self.baseView  rect:NavitionRectMake2x((640/5)*3, 128, 640/5, 86) tag:CateType_New
               action:@selector(openNewsType:)
            imagePath:@"type_new-0"
 highlightedImagePath:@"type_new-1"
    SelectedImagePath:@"type_new-1"];

    [b setRemindImage:[UIImage imageNamed:@"type_remind"]];

    
    UIButton *b1 = [self addSelfView:self.baseView  rect:NavitionRectMake2x((640/5)*4, 128, 640/5, 86) tag:CateType_International
               action:@selector(openNewsType:)
            imagePath:@"type_International-0"
 highlightedImagePath:@"type_International-1"
    SelectedImagePath:@"type_International-1"];
    [b1 setRemindImage:[UIImage imageNamed:@"type_remind"]];


}



#pragma mark - view cycle

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


- (void)cateArrayTag
{
    

    
    
    for (NSDictionary *dict in cateArray) {
        
        if ([[dict objectForKey:@"parentId"] intValue]  == 0) {

            if ([[dict objectForKey:@"lastInfoNum"] intValue]> 0) {
            
                int iid = [[dict objectForKey:@"id"] intValue];
                
                
                UIButton *button = (UIButton *)[self.baseView viewWithTag:iid];
            
                [button setRemind:YES];
            }
        
        }
    }
    

}

- (void)loadCate
{
    NSString *dateString = [NSDate stringFromDate:[NSDate date] withFormat:@"YYYYMMddHHmmss"];
    if ( [KNSUserDefaults objectForKey:@"last_date"]) {
        dateString =  [KNSUserDefaults objectForKey:@"last_date"] ;
    }

    
 
    NSString *url = [NSString stringWithFormat:@"%@info/getFullCateList/%@/", KHomeUrl, dateString     ];
    [KNSUserDefaults setObject: [NSDate stringFromDate:[NSDate date] withFormat:@"YYYYMMddHHmmss"] forKey:@"last_date"];

    
    
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        cateArray =[NSMutableArray arrayWithArray:[responseObject objectForKey:@"list"]];
        [self cateArrayTag];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);

    }];
    
    
    
}

- (void)loadView
{
    [super loadView];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    
    
    [self loadCate];
    currentType = -1;
    currentSuperType = -1;
    
    

    
    cateArray = [[NSMutableArray alloc] init];
    
    newsReadArray = [Cookie getCookie:@"news"];

    
    
    
    
    
    curPage = 1;
    isInfiniteScroll = false;

    _dataArray = [[NSMutableArray alloc] init];
    _tableView = [[TableView alloc] init];
    _tableView.delegate = self;
    _tableView.dataSource =  self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.showsPullToRefresh = NO;
    
    if (iOS7) {
        _tableView.frame = NavitionRectMake(0, 105, 320, 471);;
    }
    else {
        _tableView.frame = NavitionRectMake(0, 77, 320, 471);;

    }

    
    [self.baseView  addSubview:_tableView];
    
    
    


    typeView = [[UIView alloc] initWithFrame:NavitionRectMake(0, 105, 320,  471 )];
    
    if (iOS7) {
        typeView.frame = NavitionRectMake(0, 105, 320, 471);;
    }
    else {
        typeView.frame = NavitionRectMake(0, 77, 320, 471);;
        
    }
    
    typeView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"黑底"]];
    typeView.alpha = 0;
    
    
    typeTableView = [[TypeTableView alloc] init];
    typeTableView.frame = NavitionRectMake(0, 0, 320, 471);
    typeTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    typeTableView.typeTableViewdelegate = self;
    [typeView addSubview:typeTableView];
    
    [self.baseView  addSubview:typeView];
    
    
    
    [self setNavigationBarView];
    [self loadTypeMenu];
    
    if (iOS7) {
        
        UIImageView *statuebar_gb_ImageView = [[UIImageView alloc] init];
        statuebar_gb_ImageView.image = [UIImage imageNamed:@"statuebar_bg.jpg"];
        statuebar_gb_ImageView.frame = NavitionRectMake(0, 0, 320, 20);
        
        [self.view addSubview:statuebar_gb_ImageView];
    }
    
    
    UIView *adView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    
    if (iOS7) {
        adView.frame = NavitionRectMake(0, screenHeight-44, 320, 44);
    }
    else {
        adView.frame = NavitionRectMake(0, screenHeight-64, 320, 44);

        
    }
    adView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"广告条"]];
    
    [self.baseView  addSubview:adView];
    
    

    if ([KNSUserDefaults objectForKey:@"showed"] == nil) {
        


        UIScrollView *scroll = [[UIScrollView alloc] initWithFrame:self.view.frame];
        scroll.delegate = self;
        [scroll setContentSize:CGSizeMake(320 *2, screenHeight)];
        [self.view addSubview: scroll];
        
        
        UIImageView *simageView = [[UIImageView alloc] initWithFrame:self.view.frame];
        
        if (screenHeight != 568) {
            
            simageView.image = [UIImage imageNamed:@"桥页-640x960"];
        }
        else {
            
            simageView.image = [UIImage imageNamed:@"广告页面"];
        }
        [scroll addSubview:simageView];
        
        
        
        [self.view addSubview:scroll];
    }
    else {
        [SharedApplication setStatusBarStyle:UIStatusBarStyleBlackTranslucent];
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];

    }
    
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];


    
    
    __weak NewsViewController *weakSelf = self;
    

    [self.tableView addPullToRefreshWithActionHandler:^{
        [weakSelf insertRowAtTop];
    }];
    
    // setup infinite scrolling
//    [self.tableView addInfiniteScrollingWithActionHandler:^{
//        [weakSelf insertRowAtBottom];
//    }];

    [weakSelf.tableView triggerPullToRefresh];

    
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];


}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
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
    if (currentType == CateType_New) {
        return 169/2;
    }
    return 126;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    NewsCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[NewsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.contentImageView.alpha = 0;
    

    

    NSDictionary *dict = [_dataArray objectAtIndex:indexPath.row];


    
    
    if (  currentType == CateType_New ) {
        
        [cell setCellType:CellTypeNew];
    }
    else {
        [cell setCellType:CellTypeText];

        if (  ![[dict objectForKey:@"icon"]  isEqual:[NSNull null]]) {
            
            if ([dict objectForKey:@"icon"] != nil) {
                
                [cell setCellType:CellTypeImageText];
                
                [cell.contentImageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", KUrl,[dict objectForKey:@"icon"]]]];
                cell.contentImageView.alpha = 1;
            }
        }


    }

    if (  [dict objectForKey:@"readed"] != nil) {
        
        [cell setReaded:YES];
    }
    else {
        [cell setReaded:NO];
    }
    
    int  level = [[dict objectForKey:@"level"] intValue];

    switch (level) {
        case 1:
        {
            [cell levelImageView:CellLevelGreen];
            break;
        }
        case 2:
        {
            [cell levelImageView:CellLevelBlue];
            break;
        }
        case 3:
        {
            [cell levelImageView:CellLevelPurple];
            break;
        }
        case 4:
        {
            [cell levelImageView:CellLevelOrange];
            break;
        }
        case 5:
        {
            [cell levelImageView:CellLevelRed];
            break;
        }
        default:
            break;
    }
    
    cell.selected = YES;
    
    cell.titleLabel.text = [dict objectForKey:@"title"];
    cell.contentLabel.text = [dict objectForKey:@"summary"];
    long long timestmp = [[dict objectForKey:@"showTime"] longLongValue]/1000;
    cell.dateLabel.text = [NSDate dateWithTimestamp:timestmp];
    
    
    if (  ! [[dict objectForKey:@"favNum"]  isEqual:[NSNull null]]) {
        cell.likeLabel.text = [NSString stringWithFormat:@"%d", [[dict objectForKey:@"enjoy"] intValue]];
    }
    else {
        cell.likeLabel.text = @"0";
    }

    
    return cell;
}


#pragma mark - Table view delegate

- (void)updateRead:(NSDictionary *)dict
{
    if ([dict  objectForKey:@"readed"] != nil) {
        return;
    }
    
    NSMutableDictionary *d = [NSMutableDictionary dictionaryWithDictionary:dict];
    
    
    for (int i = 0; i< _dataArray.count; i++) {
        NSDictionary *dataDict = [_dataArray objectAtIndex:i];

        
        if ( [[d objectForKey:@"id"] intValue] == [[dataDict objectForKey:@"id"] intValue]) {
            [d setValue:@"1" forKey:@"readed"];
            [_dataArray replaceObjectAtIndex:i withObject:d];
        }
        
    }
}

- (void)addRead:(NSDictionary *)dict
{
    
    [self updateRead:dict];

    
    bool isInsert = true;
    
    if ( dict ) {
        NSMutableDictionary *dict1 = [NSMutableDictionary dictionary];
        
        for (NSDictionary *d in newsReadArray) {
            
            if ([[d objectForKey:@"id"] intValue] == [[dict objectForKey:@"id"] intValue]) {
                isInsert = false;
            }
        }
        
        
        if ( isInsert ) {
            [dict1 setValue:[dict objectForKey:@"id"] forKey:@"id"];
            [newsReadArray addObject:dict1];


            [Cookie setCookie:@"news" value:newsReadArray];
            
        }
    }
    
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    
    NewsDetailViewController *newsDetail = [[NewsDetailViewController alloc] init];
    newsDetail.newsDict =  [_dataArray objectAtIndex:indexPath.row ];
    newsDetail.currentSuperType = currentSuperType;
    newsDetail.currentType = currentType;
    newsDetail.cateArray =  cateArray ;
    
    
    [self.zhNavigationController pushViewController:newsDetail];

    
    
    [self addRead:[_dataArray objectAtIndex:indexPath.row]];

    
    NewsCell *cell = (NewsCell *) [self.tableView cellForRowAtIndexPath:indexPath];
    [cell setReaded:YES];
}

#pragma mark - Table view delegate


- (void)updateCaArray:(NSDictionary *)cateDict
{

    
    for (int i = 0; i< cateArray.count; i++) {

        NSDictionary *dict =  [cateArray objectAtIndex:i];
        
        
        
        if ([[dict  objectForKey:@"id"] intValue] == [[cateDict objectForKey:@"id"] intValue]) {

            [cateArray replaceObjectAtIndex:i withObject:cateDict];
        }
    }
    
}

- (void)didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    

    
    [self closeSubNews];
    
    
    
    
    NSDictionary *dict = [typeTableView.dataArray objectAtIndex:indexPath.row];
    
    currentSelectCell = indexPath;

    if (indexPath.row == 0) {

        currentType = -1;
    }
    else {
        currentType =  [[dict objectForKey:@"id"] intValue];
        currentButton = nil;
        
//        update array
        [self updateCaArray:dict];

    }

    curPage = 1;
    [_dataArray removeAllObjects];
    [self.tableView reloadData];
    
    
    __weak NewsViewController *weakSelf = self;
    [weakSelf.tableView triggerPullToRefresh];
    
    
    
    
}

#pragma - scroll View 


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if ([KNSUserDefaults objectForKey:@"showed"] == nil) {

        
//        NSString *str = [KNSUserDefaults objectForKey:@"showed"];
        
            [KNSUserDefaults setObject:@"11" forKey:@"showed"];

            
            [UIView animateWithDuration:KDuration animations:^{
                scrollView .alpha = 0;
                
                
                
            }completion:^(BOOL finished) {
                if (finished) {
                    [scrollView removeFromSuperview];
                    [SharedApplication setStatusBarStyle:UIStatusBarStyleBlackTranslucent];
                    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
                    
                }
            }];
            
        
    }

}



@end
