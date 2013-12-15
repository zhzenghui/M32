//
//  CommentViewController.m
//  M32
//
//  Created by i-Bejoy on 13-11-24.
//  Copyright (c) 2013年 zeng hui. All rights reserved.
//

#import "CommentViewController.h"
#import "NewsDetailViewController.h"
#import "ZHNavigationViewController.h"


@interface CommentViewController ()

@end

@implementation CommentViewController

- (void)popViewController
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}


- (void)setNavigationBarView
{
    
    
    UIView  *navigationBarView = [[UIView alloc] init];
    if (iOS7) {
        navigationBarView.frame = CGRectMake(0, 20, 640, 64);
    }
    else {
        navigationBarView.frame = CGRectMake(0, 0, 640, 44);
    }
    
    
    NSString *navImageName = [NSString string];
    if (iOS7) {
        navImageName = @"nav-bg-1";
    }else {
        navImageName = @"nav-bg";
    }
    UIImage *img = [UIImage imageNamed:navImageName] ;
    
    navigationBarView.backgroundColor = [UIColor colorWithPatternImage:img];
    
    
    
    UILabel *titleLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    titleLable.text = SharedAppUser.name;
    titleLable.textAlignment = NSTextAlignmentCenter;
    titleLable.font = [UIFont boldSystemFontOfSize:20];
    titleLable.textColor = [UIColor whiteColor];
    [navigationBarView addSubview:titleLable];
    
    
    
    
    UIButton *leftBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [leftBarButton addTarget:self action:@selector(popViewController) forControlEvents:UIControlEventTouchUpInside];
    [leftBarButton setImage:[UIImage imageNamed:@"news_conent_arrowup"] forState:UIControlStateNormal];
    leftBarButton.frame = NavitionRectMake(0, 0, 81/2, 44);
    [navigationBarView addSubview:leftBarButton];
    
    [self.baseView  addSubview:navigationBarView];
    
    
    
//    UIButton *rightBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    
//    [rightBarButton addTarget:self action:@selector(toggleRightView) forControlEvents:UIControlEventTouchUpInside];
//    [rightBarButton setImage:[UIImage imageNamed:@"nav-右标"] forState:UIControlStateNormal];
//    rightBarButton.frame = NavitionRectMake(280, 30, 27, 25);
//    
//    
//    [navigationBarView addSubview:rightBarButton];
//    
    
    
    
    [self.baseView  addSubview:navigationBarView];
    
    

    

    
}



- (void)loadNetWorkData
{
    

    NSString *url = [NSString stringWithFormat:@"%@info/getUserCommentList/%d", KHomeUrl, SharedAppUser.ID];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {

        _dataArray = [responseObject objectForKey:@"list"];
        
        [_tableView reloadData];
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
    
    
}



- (void)loadView
{
    [super loadView];
    
    if (iOS7) {
        
        UIImageView *statuebar_gb_ImageView = [[UIImageView alloc] init];
        statuebar_gb_ImageView.image = [UIImage imageNamed:@"statuebar_bg.jpg"];
        statuebar_gb_ImageView.frame = NavitionRectMake(0, 0, 320, 20);
        
        [self.view addSubview:statuebar_gb_ImageView];
    }
    
    
    [self setNavigationBarView];
    
    [SharedApplication setStatusBarStyle:UIStatusBarStyleBlackTranslucent];

    
    _tableView = [[UITableView alloc] init];
    _tableView.delegate = self;
    _tableView.dataSource =  self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.frame = NavitionRectMake(0, 64, 320, screenHeight-64);;
    
    [self.baseView  addSubview:_tableView];
    
    
    
    
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
    
    
    
    
    _dataArray = [[NSMutableArray alloc]  init];
    
    
    [self loadNetWorkData];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


#pragma mark - Table view data source
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 69/2;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *cView = [[UIView alloc] initWithFrame:RectMake2x(0, 0, 640, 69)];
    cView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"fav_title"]];
    
    UILabel *commentLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 69/2)];
    commentLabel.textAlignment = NSTextAlignmentCenter;
    commentLabel.text = @"我的跟贴";
    [cView addSubview: commentLabel];
    
    return cView;
}


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
//    return 285/2;
    NSDictionary *dict = [_dataArray objectAtIndex:indexPath.row] ;
    NSString *text = [dict objectForKey:@"content"];
    CGSize fSize = [text sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(560/2, 11111)];
    
    
    return fSize.height+ 120;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
//        cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"comment_cell_bg"]];
        

        UIImageView *avater  = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"fav_cell_user_avater"]];
        avater.frame = RectMake2x(31, 24, 33, 30);
        [cell.contentView addSubview:avater];
        
        
        UILabel *nameLable = [[UILabel alloc] initWithFrame:RectMake2x(72, 24, 560, 31)];
        nameLable.tag = 101;
        nameLable.textColor = [UIColor blueColor];
        nameLable.font = [UIFont systemFontOfSize:14];
        [cell.contentView addSubview:nameLable];
        
        
        UILabel *dateLable = [[UILabel alloc] initWithFrame:RectMake2x(0, 24, 600, 27)];
        dateLable.tag = 102;
        dateLable.textAlignment = NSTextAlignmentRight;
        [dateLable setFont:[UIFont systemFontOfSize:12]];
        dateLable.textColor = color(93, 104, 194);
        [cell.contentView addSubview:dateLable];
        
        
        
        UILabel *contentLable = [[UILabel alloc] initWithFrame:RectMake2x(40, 172, 560, 100)];
        [contentLable setNumberOfLines:0];
        contentLable.lineBreakMode = NSLineBreakByTruncatingTail;
        contentLable.tag = 103;
        contentLable.font = [UIFont systemFontOfSize:14];
        contentLable.textColor = colorAlpha(0, 0, 0, .7);
        [cell.contentView addSubview:contentLable];
        
        
        UILabel *infoLable = [[UILabel alloc] initWithFrame:RectMake2x(40, 52, 560, 100)];
        infoLable.tag = 104;
        [infoLable setFont:[UIFont systemFontOfSize:15]];
        infoLable.textColor = [UIColor grayColor];
        [cell.contentView addSubview:infoLable];
        
        
        
        UIButton *b = [UIButton buttonWithType:UIButtonTypeCustom];
        b.tag = 105;
        b.userInteractionEnabled = NO;
        [b setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        b.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"comment_cell_open_newsButton"]];
        b.frame =RectMake2x(39, 83, 560, 73);
        
        
        
        [cell.contentView addSubview:b];
        
    }
    
    if (indexPath.row%2 == 0) {
        cell.contentView.backgroundColor = colorAlpha(0, 0, 0, .05);
    }
    else {
        cell.contentView.backgroundColor = [UIColor whiteColor];
    }
    
    UILabel *nameLable = (UILabel *)[cell.contentView viewWithTag:101];
    UILabel *contentLable = (UILabel *)[cell.contentView viewWithTag:103];
    UILabel *dateLable = (UILabel *)[cell.contentView viewWithTag:102];
    UIButton *button = (UIButton *)[cell.contentView viewWithTag:105];
    //    UILabel *infoLable = (UILabel *)[cell.contentView viewWithTag:104];
    
    
    NSDictionary *dict = [_dataArray objectAtIndex:indexPath.row];
    
    nameLable.text = SharedAppUser.name;
    contentLable.text = [[_dataArray objectAtIndex:indexPath.row] objectForKey:@"content"];
    dateLable.text = [[_dataArray objectAtIndex:indexPath.row] objectForKey:@"date"];
    NSString *string = [[_dataArray objectAtIndex:indexPath.row] objectForKey:@"title"];
    [button setTitle:string forState:UIControlStateNormal];
//    dateLable.text = [NSDate dateWithTimestamp:[[[_dataArray objectAtIndex:indexPath.row] objectForKey:@"date"] longLongValue]/1000];
    
    long long timestmp = [[dict objectForKey:@"createTime"] longLongValue]/1000;
    dateLable.text = [NSDate dateWithTimestamp:timestmp];


    contentLable.text = [dict objectForKey:@"content"];
    [contentLable sizeToFit];
    CGSize fSize = [contentLable.text sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(560/2, 11111)];
    CGRect r = contentLable.frame;
    r.size = fSize;
    contentLable.frame  = r;

    
    
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NewsDetailViewController *n = [[NewsDetailViewController alloc] init];
    n.newsDict = @{@"id":  [[_dataArray objectAtIndex:indexPath.row] objectForKey:@"infoId"]};
//    [self.zhNavigationController pushViewController:n ];
    [self.navigationController pushViewController:n animated:YES];
    
}

#pragma mark - Table view delegate

- (void)didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
}


@end
