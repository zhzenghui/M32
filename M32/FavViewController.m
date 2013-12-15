//
//  FavViewController.m
//  M32
//
//  Created by i-Bejoy on 13-11-24.
//  Copyright (c) 2013年 zeng hui. All rights reserved.
//

#import "FavViewController.h"

#import "NewsDetailViewController.h"
#import "FileViewController.h"
#import "DailyDetailViewController.h"

@interface FavViewController ()
{
    UIView *cView;
    
}
@end

@implementation FavViewController

- (void)popViewController
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)loadData
{
    [_dataArray removeAllObjects];
    
    NSMutableArray *array =  [Cookie getCookie:@"fav"];
    
    for (NSDictionary *dict in array ) {
    
        if ([[dict objectForKey:@"FavType"] intValue] == currentFavType && [[dict objectForKey:@"userid"] intValue] == SharedAppUser.ID ) {
            [_dataArray addObject:dict];
        }
    }
    
    
    [_tableView reloadData];
}

- (void)deleteDataArray
{
    
}

- (void)openFav:(UIButton *)button
{
    


    switch (button.tag) {
        case 100:
        {
            currentFavType = FavType_News;
            break;
        }
        case 101:
        {

            currentFavType = FavType_Law;
            break;
        }
        case 102:
        {
            currentFavType = FavType_Daily;
            break;
        }
        default:
            break;
    }

    

    [self loadData];
}

- (void)setEditing:(BOOL)flag animated:(BOOL)animated
{
    [super setEditing:flag animated:animated];
    if (flag == YES){
        // Change views to edit mode.
    }
    else {
        // Save the changes if needed and change the views to noneditable.
    }
}


- (void)edit:(UIButton *)button
{
    
    if (self.tableView.isEditing) {
        [self.tableView setEditing:NO animated:YES];
    }else {
        [self.tableView setEditing:YES animated:YES];
    }

    [self.tableView reloadData];
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
    titleLable.text = @"我的收藏";
    titleLable.textAlignment = NSTextAlignmentCenter;
    titleLable.font = [UIFont boldSystemFontOfSize:20];
    titleLable.textColor = [UIColor whiteColor];
    [navigationBarView addSubview:titleLable];
    
    
    UIButton *leftBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [leftBarButton addTarget:self action:@selector(popViewController) forControlEvents:UIControlEventTouchUpInside];
    [leftBarButton setImage:[UIImage imageNamed:@"news_conent_arrowup"] forState:UIControlStateNormal];
    leftBarButton.frame = NavitionRectMake(0, 0, 81/2, 44);
    [navigationBarView addSubview:leftBarButton];
    
    
    UIButton *rightBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [rightBarButton addTarget:self action:@selector(edit:) forControlEvents:UIControlEventTouchUpInside];
    [rightBarButton setTitle:@"编辑" forState:UIControlStateNormal];
    rightBarButton.frame = NavitionRectMake(275, 0, 44, 44);
    
    
    [navigationBarView addSubview:leftBarButton];
    [navigationBarView addSubview:rightBarButton];
    
    

    
    
    
    [self.baseView  addSubview:navigationBarView];
    

    
}


- (void)loadView
{
    [super loadView];
//    [SharedApplication setStatusBarStyle:UIStatusBarStyleBlackTranslucent];
    if (iOS7) {
        
        UIImageView *statuebar_gb_ImageView = [[UIImageView alloc] init];
        statuebar_gb_ImageView.image = [UIImage imageNamed:@"statuebar_bg.jpg"];
        statuebar_gb_ImageView.frame = NavitionRectMake(0, 0, 320, 20);
        
        [self.view addSubview:statuebar_gb_ImageView];
    }
    
    [self setNavigationBarView];
    
    
    _tableView = [[UITableView alloc] init];
    _tableView.delegate = self;
    _tableView.dataSource =  self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    _tableView.frame = NavitionRectMake(0, 64, 320, 471);;
    
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
    _dataArray = [[NSMutableArray alloc] init];

    [self loadData];
    
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
    cView = [[UIView alloc] initWithFrame:RectMake2x(0, 0, 640, 69)];
    cView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"fav_title"]];
    
    
    
    UIButton *newsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [newsButton addTarget:self action:@selector(openFav:) forControlEvents:UIControlEventTouchUpInside];
    [newsButton setImage:[UIImage imageNamed:@"fav_news_0"] forState:UIControlStateNormal];
    [newsButton setImage:[UIImage imageNamed:@"fav_news_1"] forState:UIControlStateSelected];
    newsButton.tag = 100;
    newsButton.frame = RectMake2x(128, 0, 131, 64);
    [cView addSubview:newsButton];
    
    
    UIButton *lawButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [lawButton addTarget:self action:@selector(openFav:) forControlEvents:UIControlEventTouchUpInside];
    [lawButton setImage:[UIImage imageNamed:@"fav_law_0"] forState:UIControlStateNormal];
    [lawButton setImage:[UIImage imageNamed:@"fav_law_1"] forState:UIControlStateSelected];
    lawButton.tag  = 101;
    lawButton.frame = RectMake2x(253, 0, 127, 64);
    [cView addSubview:lawButton];
    
    
    UIButton *dailyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [dailyButton addTarget:self action:@selector(openFav:) forControlEvents:UIControlEventTouchUpInside];
    [dailyButton setImage:[UIImage imageNamed:@"fav_daily_0"] forState:UIControlStateNormal];
    [dailyButton setImage:[UIImage imageNamed:@"fav_daily_1"] forState:UIControlStateSelected];
    dailyButton.tag  = 102;

    dailyButton.frame = RectMake2x(381, 0, 130, 64);
    [cView addSubview:dailyButton];
    
    switch (currentFavType) {
        case FavType_News:
            newsButton.selected = YES;
            break;
        case FavType_Law:
            lawButton.selected = YES;
            break;
        case FavType_Daily:
            dailyButton.selected = YES;
            break;
            
        default:
            break;
    }
    

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

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return 169/2;
//}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
//    if (commentArray.count == 0) {
//        return 169/2;
//    }
    NSDictionary *dict = [_dataArray objectAtIndex:indexPath.row] ;
    NSString *text = [dict objectForKey:@"title"];
    CGSize fSize = [text sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(540/2, 11111)];
    
    
    return fSize.height+ 70;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    

    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];

        UIImageView *avater  = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"fav_cell_user_avater"]];
        avater.frame = RectMake2x(31, 24, 33, 30);
        [cell.contentView addSubview:avater];
        
        
        UILabel *nameLable = [[UILabel alloc] initWithFrame:RectMake2x(72, 24, 560, 31)];
        nameLable.tag = 101;
        [nameLable setFont:[UIFont systemFontOfSize:13]];
        nameLable.textColor = color(93, 104, 194);
        [cell.contentView addSubview:nameLable];
        

        UILabel *dateLable = [[UILabel alloc] initWithFrame:RectMake2x(-40, 24, 600, 27)];
        dateLable.tag = 102;
        dateLable.textAlignment = NSTextAlignmentRight;
        [dateLable setFont:[UIFont systemFontOfSize:12]];
        dateLable.textColor = color(93, 104, 194);
        [cell.contentView addSubview:dateLable];
        
        
        
        UILabel *contentLable = [[UILabel alloc] initWithFrame:RectMake2x(40, 68, 520, 100)];
        [contentLable setNumberOfLines:3];
        contentLable.lineBreakMode = NSLineBreakByTruncatingTail;
        contentLable.tag = 103;
        contentLable.textColor = colorAlpha(0, 0, 0, .7);
        [contentLable setFont:[UIFont systemFontOfSize:15]];
        [cell.contentView addSubview:contentLable];
        
        
        UILabel *infoLable = [[UILabel alloc] initWithFrame:RectMake2x(39, 84, 560, 73)];
        infoLable.tag = 104;
        [infoLable setFont:[UIFont systemFontOfSize:15]];
        infoLable.textColor = [UIColor grayColor];
        [cell.contentView addSubview:infoLable];

    }
    

    
    if (indexPath.row%2 == 0) {
        cell.backgroundColor = colorAlpha(0, 0, 0, .05);
    }
    else {
        cell.backgroundColor = color(255, 255, 255);
    }
    
    UILabel *nameLable = (UILabel *)[cell.contentView viewWithTag:101];
    UILabel *contentLable = (UILabel *)[cell.contentView viewWithTag:103];
    UILabel *dateLable = (UILabel *)[cell.contentView viewWithTag:102];
//    UILabel *infoLable = (UILabel *)[cell.contentView viewWithTag:104];

    
    

                     
                     
    
    nameLable.text = SharedAppUser.name;
    contentLable.text = [[_dataArray objectAtIndex:indexPath.row] objectForKey:@"title"];
    dateLable.text = [[_dataArray objectAtIndex:indexPath.row] objectForKey:@"date"];

//    dateLable.text = [[_dataArray objectAtIndex:indexPath.row] objectForKey:@"info"];

    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        
        NSDictionary *dict = [_dataArray objectAtIndex:indexPath.row];


        NSMutableArray *array = [[NSMutableArray alloc] initWithArray:[Cookie getCookie:@"fav"]];
        [array removeObject:dict];
        
        [_dataArray removeObject:dict];
        
        [Cookie setCookie:@"fav" value:array];
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];

        
        
    }

}
#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    switch (currentFavType) {
        case FavType_News:
        {
            NewsDetailViewController *n = [[NewsDetailViewController alloc] init];
            n.newsDict = @{@"id":  [[_dataArray objectAtIndex:indexPath.row] objectForKey:@"id"]};
            [self.navigationController pushViewController:n animated:YES];
            
            break;
        }
        case FavType_Law:
        {
            FileViewController *n = [[FileViewController alloc] init];
            
            n.dict = @{@"fileUrl":  [[_dataArray objectAtIndex:indexPath.row] objectForKey:@"fileUrl"]};
            [self.navigationController pushViewController:n animated:YES];
            
            break;
        }
        case FavType_Daily:
        {
            DailyDetailViewController *n = [[DailyDetailViewController alloc] init];
            n.dailyDict =  [_dataArray objectAtIndex:indexPath.row] ;
            [self.navigationController pushViewController:n animated:YES];
            
            break;
        }
        default:
            break;
    }

    
}

#pragma mark - Table view delegate

- (void)didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
}


@end
