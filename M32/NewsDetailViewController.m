//
//  NewsDetailViewController.m
//  M32
//
//  Created by i-Bejoy on 13-11-21.
//  Copyright (c) 2013年 zeng hui. All rights reserved.
//






#import "NewsDetailViewController.h"
#import "ZHNavigationViewController.h"


#import "AFNetworking.h"
#import "UIImageView+WebCache.h"
#import "IIViewDeckController.h"

#import "SVProgressHUD.h"
#import "ShareView.h"
#import "WebViewController.h"



//#define KheaderHeight 346


@interface NewsDetailViewController ()
{
    int KheaderHeight;
    ShareView *shareView;
    
    NSMutableArray *favMArray;
    
    
    UIButton *rightBarButton;
    UIButton *leftBarButton;
    
    
}
@end

@implementation NewsDetailViewController

- (void)popViewController
{
    if (self.zhNavigationController) {
        [self.zhNavigationController popViewController];
    }
    else {
        [self.navigationController popViewControllerAnimated:YES];
    }


}

- (void)loadCate:(NSArray *)dict
{
    //
    NSMutableString *type = [NSMutableString string];
    
    if (_currentSuperType != -1) {
        [type appendFormat:@"%@", [[self cateArrayForID:_currentSuperType] objectForKey:@"name"]];
    }
    
    if (_currentType != -1) {
        
        if (_currentSuperType != -1) {
            [type appendFormat:@" > "];

        }
        [type appendFormat:@"%@", [[self cateArrayForID:_currentType] objectForKey:@"name"]];
    }
    if (type.length !=0) {
        type_lable.text = type;
    }
    else {
        type_lable.text = @"全部";
    }

}

- (void)loadPage :(NSDictionary *)dict
{

//    NSString *title = [dict objectForKey:@"title"];s
//    NSString *author =  [dict objectForKey:@"author"];
    
//    NSString *html = [NSString stringWithFormat:@"<html><body><h3>%@</h3>%@ <br />%@</body></html>", title, author, [dict objectForKey:@"content"]];

    NSString *url = [NSString stringWithFormat:@"http://115.29.37.109/api/info/%d/show.html" , [[dict objectForKey:@"id"] intValue]];;


    [contentWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
    
    
    
    
    long long timestmp = [[dict objectForKey:@"showtime"] longLongValue]/1000;
    date_lable.text = [NSDate dateWithTimestamp:timestmp];


    [self loadCate:[dict objectForKey:@"categoryList"]];
    
    
    NSString *icon = [NSString stringWithFormat:@"%@%@", KUrl, [dict objectForKey:@"icon"]];
    [title_ImageView setImageWithURL:[NSURL URLWithString:icon]];
    
    
    commentArray = [[NSMutableArray alloc] initWithArray: [dict objectForKey:@"commentList"]];
    

    
    
    [commentTableView reloadData];
    
    
    


}

- (void)zanInfo
{
    
    NSString *url = [NSString stringWithFormat:@"%@info/addEnjoy", KHomeUrl];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *para = @{@"infoId": [_newsDict objectForKey:@"id"]};
    
    [manager POST:url parameters:para success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"zan: %@", responseObject);
        
        NSDictionary *dict = responseObject;
        _newsDict = dict;
        
        if ([[dict objectForKey:@"result"] intValue] == 1 ) {
            [[Message share] messageAlert:@"添加喜欢成功"];
            
        }
        else {
            [[Message share] messageAlert:@"添加喜欢失败"];
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"news: %@", error);
        
        [SVProgressHUD dismiss];

        
    }];
}



- (void)loadInfo
{


    
    NSString *url = [NSString stringWithFormat:@"%@info/getInfoDetail/%@/", KHomeUrl, [_newsDict objectForKey:@"id"]];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"news: %@", responseObject);
        NSDictionary *dict = [responseObject objectForKey:@"model"];

        [self loadPage:dict];

        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [SVProgressHUD dismiss];

    }];
    
}


- (void)getNewsDetail {
    
    [self loadInfo];
    
}


#pragma mark - like

- (void)likeNews:(UIButton *)button
{
    NSLog(@"linked");
    
    [self zanInfo];
    
    
    [UIView animateWithDuration:KLongDuration animations:^{
        button.frame =RectMake2x(401, -15, 65, 60);
        button.alpha = 0;
    } completion:^(BOOL finished) {
        
        button.frame =RectMake2x(401, 15, 65, 60);
        button.alpha = 1;
        
        button.enabled = NO;
    }];
}

#pragma mark - fav

- (void)favNews:(UIButton *)button
{
    NSLog(@"fav news");
    
    if (SharedAppUser.ID == 0) {
        [[Message share] messageAlert:@"登陆后，才可以收藏哦！"];
        return;
    }

    button.enabled = NO;
    button.alpha = .2;
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict  setValue:[NSNumber numberWithInt:FavType_News] forKey:@"FavType"];
    [dict setValue:[_newsDict objectForKey:@"id"] forKey:@"id"];
    [dict setValue:[_newsDict objectForKey:@"title"] forKey:@"title"];
    [dict setValue:[NSString stringWithFormat:@"%d", SharedAppUser.ID] forKey:@"userid"];
    
    [dict setValue:[NSDate stringFromDate:[NSDate date] withFormat:@"YYYY/MM/dd"] forKey:@"date"];

    
    [Cookie setCookie:@"fav" dict:dict isRepeat:YES];
    
    
    [[Message share] messageAlert:@"添加收藏成功"];

    
}



#pragma mark - share

- (void)shareViewController
{

    
    if (shareView == nil) {
        shareView = [[ShareView alloc] initWithFrame:RectMake2x(0, screenHeight-64, 640, screenHeight)];
        [self.baseView addSubview:shareView];
    }

    
    [UIView animateWithDuration:KDuration animations:^{
       
        shareView.frame = RectMake2x(0, 128, 640, (2*screenHeight)-128);
        
    }];
}


#pragma mark - comment

- (void)zanComment:(UIButton *)button
{

    UITableViewCell *cell = (UITableViewCell *)[[[button superview] superview] superview];
    NSIndexPath *index = [commentTableView indexPathForCell:cell];
    
    NSDictionary *commDict = [commentArray objectAtIndex:index.row];
    
    
    
    NSString *url = [NSString stringWithFormat:@"%@info/zanComment", KHomeUrl];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *para = @{@"id": [commDict objectForKey:@"id"]};
    
    [manager POST:url parameters:para success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"zan: %@", responseObject);
        
        NSDictionary *dict = responseObject;
        NSLog(@"%@", dict);
        if ([[dict objectForKey:@"result"] intValue] == 1 ) {
            [[Message share] messageAlert:@"赞评论成功"];

            
            UILabel *label = (UILabel *)[cell.contentView viewWithTag:102];
            UIImageView *img = (UIImageView *)[cell.contentView viewWithTag:103];
            img.image = [UIImage imageNamed:@"news_comment_praise"];
            
            int like = [label.text intValue];
            button.enabled = NO;
            label.text = [NSString stringWithFormat:@"%d赞", like+1];
            

        }
        else {
            NSLog(@"%@", [dict objectForKey:@"message"]);

            [[Message share] messageAlert:@"赞加评论失败"];
        }
        

        

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"news: %@", error);

    }];
}

- (void)updateCommentView
{
    
    CGFloat hight = commentArray.count * 126;
    if (commentArray == 0) {
        hight = 100;
        
    }

    commentTableView.frame = RectMake(0, KheaderHeight/2 + contentWebView.frame.size.height, 320, commentTableView.contentSize.height);

    
//    [commentTableView setContentSize:CGSizeMake(320, hight/2)];
    
    
    
    [content setContentSize:CGSizeMake(320, content.contentSize.height + contentWebView.frame.size.height+ hight -600)];
    

}

- (void) fasongComment
{
    
    
    NSString *text = textView.text;
    NSLog( @"po  %@", text);
    
    if (text.length == 0) {
        [[Message share] messageAlert:@"请填写评论内容"];
        
        return;
    }
    
    
    
    
    [self closeCommentView];
    


    

    
    NSString *url = [NSString stringWithFormat:@"%@info/addComment", KHomeUrl];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *para = @{@"infoId": [_newsDict objectForKey:@"id"],
                           @"content":text,
                           @"userId": [NSString stringWithFormat:@"%d", SharedAppUser.ID]};
    
    
    [manager POST:url parameters:para success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"fasong: %@", responseObject);
        
        NSDictionary *dict = responseObject;
        NSLog(@"%@", dict);
        if ([[dict objectForKey:@"result"] intValue] == 1 ) {
            [[Message share] messageAlert:@"添加评论成功"];
            
            
            
            NSDictionary *dict = @{@"nickName": SharedAppUser.name, @"content": text, @"upNum": [NSNumber numberWithInt: 1], @"id": [responseObject objectForKey:@"id"]};
            [commentArray insertObject:dict atIndex:0];
            
            [commentTableView reloadData];
            
            [self updateCommentView];
        }
        else {
            [[Message share] messageAlert:@"添加评论失败"];
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    

}


- (void) openCommentview
{
    [UIView animateWithDuration:KDuration animations:^{

    commentView.frame = RectMake2x(0, 414, 640, 290);
    
    if (screenHeight > 480) {
        commentView.frame = RectMake2x(0, 414, 640, 290);

    }
    else {
        commentView.frame = RectMake2x(0, 414-176, 640, 290);

    }
    
    }];

    [textView becomeFirstResponder];
}

- (void) closeCommentView
{
    [textView resignFirstResponder];


    [UIView animateWithDuration:.5 animations:^{
        commentView.frame = RectMake2x(0, screenHeight*2, 640, 290);
    }];


}


#pragma mark - att

- (void)openAT:(UIButton *)button
{
    atArray = [_newsDict objectForKey:@"attachmentList"];

    NSDictionary *dict = [atArray objectAtIndex:button.tag];
//    NSString *urlString = [NSString stringWithFormat:@"%@%@", KUrl,  [dict objectForKey:@"fileUrl"]];
    
    FileViewController *newsDetail = [[FileViewController alloc] init];
    newsDetail.dict =  dict;
//    newsDetail.url = [NSURL URLWithString: urlString ];
    [self.zhNavigationController pushViewController:newsDetail];
    
    
}

- (void)atView:(float)height
{
    
    //    附件的数组
    
    if ([_newsDict objectForKey:@"attachmentList"] != [NSNull null]) {
        

        atArray = [_newsDict objectForKey:@"attachmentList"];
        
        if ( atArray) {
            int h = 70;
            
            for (int i = 0; i < atArray.count; i++) {
                
                NSDictionary *fileDict = (NSDictionary *) [atArray objectAtIndex:i];
                
                
                UIButton *fujian = [UIButton buttonWithType:UIButtonTypeCustom];
                [fujian addTarget:self action:@selector(openAT:) forControlEvents:UIControlEventTouchUpInside];

                NSString *fileName = [fileDict objectForKey:@"fileName"];
                
                NSRange rPdf = [fileName rangeOfString:@"pdf"];
                
                NSRange rDoc = [fileName rangeOfString:@"doc"];
                NSRange rDocx = [fileName rangeOfString:@"docx"];
                
//                NSRange rXls = [fileName rangeOfString:@"pdf"];
                
                if (rPdf.length != 0) {
                    [fujian setImage:[UIImage imageNamed:@"news_conent_pdf"] forState:UIControlStateNormal];

                }
                else if (rDoc.length != 0 || rDocx.length != 0) {
                    [fujian setImage:[UIImage imageNamed:@"news_conent_doc"] forState:UIControlStateNormal];
                    
                }
//                else if (rXls.length != 0 ) {
////                    zanImageView.image = [UIImage imageNamed:@"law_filetype_xls"];
//                    [fujian setImage:[UIImage imageNamed:@"news_conent_pdf"] forState:UIControlStateNormal];
//
//                }

                fujian.tag = i;
                fujian.frame = RectMake2x(0, KheaderHeight + height*2 + h -94, 640, 70);
                [content addSubview:fujian];
                
                
                
                UILabel *ztName = [[UILabel alloc] initWithFrame:RectMake2x(108, 24, 492, 26)];
                ztName.text = [fileDict objectForKey:@"fileName"];
                ztName.font = [UIFont systemFontOfSize:12];
                [fujian addSubview:ztName];
                h =h+74;
                
            }


            KheaderHeight = KheaderHeight + h -94;
        }
    
        
    }
    
}

#pragma mark -  init View


- (void)commentView
{
    
    
    
    
    commentArray = [[NSMutableArray alloc] init];
    
    commentTableView = [[UITableView alloc]   initWithFrame:RectMake2x(0, 1556, 640, 1000)];
    commentTableView.delegate = self;
    commentTableView.dataSource = self;
    commentTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    [content addSubview:commentTableView];
    
    
    
}

- (void)commentBarView
{
    
    UIView *commentBarView = [[UIView alloc] initWithFrame:CGRectMake(0, self.baseView.frame.size.height-44, 320, 44)];
    commentBarView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"news_comment_write_bar"]];
    
    
    UIButton *fasongButton = [UIButton buttonWithType:UIButtonTypeCustom];
    fasongButton.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"news_conent_arrowup"]];
    [fasongButton addTarget:self action:@selector(popViewController) forControlEvents:UIControlEventTouchUpInside];

    fasongButton.frame = RectMake2x(0, 0, 81, 88);
    [commentBarView addSubview:fasongButton];
    
    
    UIButton *openCommentViewButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [openCommentViewButton addTarget:self action:@selector(openCommentview) forControlEvents:UIControlEventTouchUpInside];
    openCommentViewButton.frame = RectMake2x(85, 17, 300, 88);
    [commentBarView addSubview:openCommentViewButton];
    
    
    
    UIButton *likeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [likeButton setImage:[UIImage imageNamed:@"news_content_like"] forState:UIControlStateNormal];
    [likeButton addTarget:self action:@selector(likeNews:) forControlEvents:UIControlEventTouchUpInside];

    likeButton.frame = RectMake2x(401, 15, 65, 60);
    [commentBarView addSubview:likeButton];
    
    
    
    favButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [favButton setImage:[UIImage imageNamed:@"news_conent_fav"] forState:UIControlStateNormal];
    [favButton addTarget:self action:@selector(favNews:) forControlEvents:UIControlEventTouchUpInside];

    favButton.frame = RectMake2x(484, 15, 65, 60);
    [commentBarView addSubview:favButton];
    
    UIButton *shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    shareButton.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"news_conent_share"]];
    [shareButton addTarget:self action:@selector(shareViewController) forControlEvents:UIControlEventTouchUpInside];
    
    shareButton.frame = RectMake2x(567, 15, 65, 60);
    [commentBarView addSubview:shareButton];
    
    
    
    [self.baseView addSubview:commentBarView];
    
    
    commentView = [[UIView alloc] initWithFrame:RectMake2x(0, screenHeight*2, 640, 290)];
    commentView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"news_comment_write_bg"]];
    
    
    
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    closeButton.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"news_share_close"]];
    [closeButton setImage:[UIImage imageNamed:@"news_share_close"] forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(closeCommentView) forControlEvents:UIControlEventTouchUpInside];
    closeButton.frame = RectMake2x(20, 10, 88, 88);
    [commentView addSubview:closeButton];
    
    
    UIButton *fsButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    fsButton.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"news_share_save"]];
    [fsButton setImage:[UIImage imageNamed:@"news_share_save"] forState:UIControlStateNormal];
    [fsButton addTarget:self action:@selector(fasongComment) forControlEvents:UIControlEventTouchUpInside];
    fsButton.frame = RectMake2x(540, 10, 88, 88);
    [commentView addSubview:fsButton];
    
    
    
    textView = [[UITextView alloc] initWithFrame:RectMake2x(31, 100, 579, 156)];
    textView.text = @"" ;
    [commentView addSubview:textView];
    
    
    
    
    [self.baseView addSubview:commentView];
}

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
    
    

    leftBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [leftBarButton addTarget:self.viewDeckController action:@selector(toggleLeftView) forControlEvents:UIControlEventTouchUpInside];
    [leftBarButton setImage:[UIImage imageNamed:@"nav-左标"] forState:UIControlStateNormal];
    leftBarButton.frame = NavitionRectMake(5, 20, 44, 44);
    
    
    rightBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [rightBarButton addTarget:self.viewDeckController action:@selector(toggleRightView) forControlEvents:UIControlEventTouchUpInside];
    [rightBarButton setImage:[UIImage imageNamed:@"nav-右标"] forState:UIControlStateNormal];
    rightBarButton.frame = NavitionRectMake(275, 20, 44, 44);
    
    
    [navigationBarView addSubview:leftBarButton];
    [navigationBarView addSubview:rightBarButton];
    
        
    
    [self.baseView  addSubview:navigationBarView];
    
    
}



- (NSDictionary *)cateArrayForID:(int)cateID
{
    
    for (NSDictionary *dict in _cateArray) {
        
        if ([[dict objectForKey:@"id"] intValue]  == cateID) {

            return dict;
        }
    }

    return nil;
}


#pragma mark - view

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - view cycle


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _currentSuperType = -1;
    _currentType = -1;
    favMArray = [Cookie getCookie:@"fav"];


    
    
    if (iOS7) {
        
        UIImageView *statuebar_gb_ImageView = [[UIImageView alloc] init];
        statuebar_gb_ImageView.image = [UIImage imageNamed:@"statuebar_bg.jpg"];
        statuebar_gb_ImageView.frame = NavitionRectMake(0, 0, 320, 20);
        
        [self.view addSubview:statuebar_gb_ImageView];
    }
    
    
    
    content  = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, 320, screenHeight-64)];
    
    content.contentSize = CGSizeMake(320, 600);
    [self.baseView  addSubview:content];
    
    
    title_ImageView = [[UIImageView alloc] initWithFrame:RectMake2x(0, 0, 640, 316)];
    title_ImageView.image = [UIImage imageNamed:@"type_bg"];
    
    [content addSubview:title_ImageView];

    

    
    
    
    type_bgImageView = [[UIImageView alloc] initWithFrame:RectMake2x(0, 286, 640, 30)];
    type_bgImageView.image = [UIImage imageNamed:@"type_bg"];
    
    [content addSubview:type_bgImageView];
    
    type_lable = [[UILabel alloc] initWithFrame:RectMake2x(39, 4, 220, 22)];
    [type_lable setFont:[UIFont systemFontOfSize:11]];
    type_lable.text = @"分类 》 新品";
    [type_bgImageView addSubview:type_lable];
    
    date_lable = [[UILabel alloc] initWithFrame:RectMake2x(492, 4, 128, 22)];
    [date_lable setFont:[UIFont systemFontOfSize:11]];
    date_lable.text = @"0000-11-22";
    [type_bgImageView addSubview:date_lable];
    
    
    self.baseView.backgroundColor = [UIColor whiteColor];
    //    内容
    
    
    
    
    contentWebView = [[UIWebView alloc] init];
    contentWebView.frame = RectMake2x(0, 316, 640, 600);
    contentWebView.delegate = self;
    [content addSubview:contentWebView];
    

    
    [self setNavigationBarView];

    //    评论
    
    [self commentView];
    
    
    //    评论框
    
    [self commentBarView];
    
    
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];

}

- (void)checkFav
{
    
    bool isFav = false;
    
    NSMutableArray *array =  [Cookie getCookie:@"fav"];
    
    for ( NSMutableDictionary *dict in array) {
        
        if ([[dict objectForKey:@"id"] intValue] == [[_newsDict objectForKey:@"id"] intValue] &&
            [[dict objectForKey:@"FavType"] intValue] == FavType_News ) {
            
            isFav = true;
            
        }
    }
    
    if (isFav) {
        
        favButton.enabled = NO;
        favButton.alpha = .2;
    }
    
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
   



    [self checkFav];
    
    if ( ! self.zhNavigationController) {
        CGRect r = content.frame;
        r.origin = CGPointMake(r.origin.x, r.origin.y-20);
        
        content.frame = r;
        
        
        leftBarButton.alpha = 0;
        rightBarButton.alpha = 0;
        
        
        favButton.enabled = NO;
        favButton.alpha = .2;
        
    }

    [self getNewsDetail];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:YES];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *cView = [[UIView alloc] initWithFrame:RectMake2x(0, 0, 640, 60)];
    cView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"news_comment_bar"]];
    return cView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (commentArray.count > 0) {
        return [commentArray count];
    }
    else {
        return 1;
    }

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (commentArray.count == 0) {
        return 100;
    }
    NSDictionary *dict = [commentArray objectAtIndex:indexPath.row] ;
    NSString *text = [dict objectForKey:@"content"];
    CGSize fSize = [text sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(560/2, 11111)];

    
    return fSize.height+ 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        
        
        
        UIImageView *avater  = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"fav_cell_user_avater"]];
        avater.frame = RectMake2x(31, 24, 33, 30);
        avater.tag = 99;
        [cell.contentView addSubview:avater];
        
        
        UILabel *nameLable = [[UILabel alloc] initWithFrame:RectMake2x(72, 19, 560, 37)];
        nameLable.textColor = [UIColor blueColor];
        nameLable.font = [UIFont systemFontOfSize:14];
        nameLable.tag = 100;
        [cell.contentView addSubview:nameLable];
        
        
        UILabel *contentLable = [[UILabel alloc] initWithFrame:RectMake2x(42, 77, 560, 200)];
        [contentLable setNumberOfLines:0];
        contentLable.font = [UIFont systemFontOfSize:14];
        contentLable.textColor = colorAlpha(0, 0, 0, .7);
        contentLable.lineBreakMode = NSLineBreakByTruncatingTail;
        contentLable.tag = 101;
        [cell.contentView addSubview:contentLable];
        
        
        UILabel *likeLable = [[UILabel alloc] initWithFrame:RectMake2x(463, 19, 100, 30)];
        likeLable.textColor =  [UIColor grayColor];
        likeLable.tag = 102;
        likeLable.textAlignment = NSTextAlignmentRight;
        likeLable.font = [UIFont systemFontOfSize:14];
        [cell.contentView addSubview:likeLable];
        
        
        UIImageView *zanImageView = [[UIImageView alloc] init];
        zanImageView.tag = 103;
        zanImageView.frame = RectMake2x(564, 19, 40, 37);
        [cell.contentView addSubview:zanImageView];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = RectMake2x(534, 0, 88, 88);
        
        [button addTarget:self action:@selector(zanComment:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:button];
        

//        
//        UILabel *nameLable = [[UILabel alloc] initWithFrame:RectMake2x(72, 24, 560, 27)];
//        nameLable.tag = 101;
//        [nameLable setFont:[UIFont systemFontOfSize:12]];
//        nameLable.textColor = color(93, 104, 194);
//        [cell.contentView addSubview:nameLable];
//        
//        
//        UILabel *dateLable = [[UILabel alloc] initWithFrame:RectMake2x(0, 24, 600, 27)];
//        dateLable.tag = 102;
//        dateLable.textAlignment = NSTextAlignmentRight;
//        [dateLable setFont:[UIFont systemFontOfSize:12]];
//        dateLable.textColor = color(93, 104, 194);
//        [cell.contentView addSubview:dateLable];
//        
//        
//        
//        UILabel *contentLable = [[UILabel alloc] initWithFrame:RectMake2x(40, 48, 560, 100)];
//        [contentLable setNumberOfLines:3];
//        contentLable.lineBreakMode = NSLineBreakByTruncatingTail;
//        contentLable.tag = 103;
//        [contentLable setFont:[UIFont systemFontOfSize:15]];
//        [cell.contentView addSubview:contentLable];
//        
//        
//        UILabel *infoLable = [[UILabel alloc] initWithFrame:RectMake2x(39, 84, 560, 73)];
//        infoLable.tag = 104;
//        [infoLable setFont:[UIFont systemFontOfSize:15]];
//        infoLable.textColor = [UIColor grayColor];
//        [cell.contentView addSubview:infoLable];
//        
//        UIButton *b = [UIButton buttonWithType:UIButtonTypeCustom];
//        b.tag = 105;
//        [b setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        b.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"comment_cell_open_newsButton"]];
//        b.frame = RectMake2x(31, 211, 579, 44);
//        
//        [cell.contentView addSubview:b];
        
        
    }
    

    UIImageView *avtarImageView = (UIImageView *)[cell.contentView viewWithTag:103];
    UILabel *nameLable = (UILabel *)[cell.contentView viewWithTag:100];
    UILabel *contentLable = (UILabel *)[cell.contentView viewWithTag:101];
    UILabel *likeLable = (UILabel *)[cell.contentView viewWithTag:102];
    UIImageView *zanImageView = (UIImageView *)[cell.contentView viewWithTag:103];
    
    
    if (commentArray.count == 0) {
        avtarImageView.alpha = 0;
        cell.textLabel.text = @"暂无评论";
        cell.textLabel.textColor = [UIColor grayColor];
        return cell;
    }
    
    
    cell.textLabel.text = @"";
    avtarImageView.alpha = 1;
    
    
    
    NSDictionary *dict = [commentArray objectAtIndex:indexPath.row] ;
    
    nameLable.text = [dict objectForKey:@"nickName"];
    contentLable.text = [dict objectForKey:@"content"];
    CGSize fSize = [contentLable.text sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(560/2, 11111)];
    CGRect r = contentLable.frame;
    r.size = fSize;
    contentLable.frame  = r;
    
    likeLable.text = [NSString stringWithFormat:@"%@赞", [dict objectForKey:@"upNum"]];
    
    if ( [dict objectForKey:@"zan"] ) {
        
        zanImageView.image = [UIImage imageNamed:@"news_comment_praise"];
    }
    else {
        
        zanImageView.image = [UIImage imageNamed:@"news_comment_unpraise"];
    }

    return cell;
}


#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
//    NewsDetailViewController *newsDetail = [[NewsDetailViewController alloc] init];
//    [self.zhNavigationController pushViewController:newsDetail];
    
}


- (void)didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark -  webView

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType;
{
    if(navigationType==UIWebViewNavigationTypeLinkClicked)//判断是否是点击链接
    {
        NSLog( @"%@", request);
        
        NSString *urlString = [request.URL absoluteString];
        
        if (urlString) {
            urlString = [urlString substringWithRange:NSMakeRange(0, 4)].lowercaseString;
        }

        if ( ! [urlString isEqualToString:@"http"]) {
            
            return NO;
        }
        WebViewController *w = [[WebViewController alloc] init];

        w.url = request.URL;
        [self.zhNavigationController pushViewController:w];
        return NO;
    }
    else{
        return YES;
    }


    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    
    NSLog( @"%@", webView.request.URL);

    
}


- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    
    
    [SVProgressHUD dismiss];

    if ( ! [[_newsDict objectForKey:@"icon"]  isEqual:[NSNull null]]) {
        
        if ( [_newsDict objectForKey:@"icon"] == nil  ) {
            
            KheaderHeight = 26;
            
            type_bgImageView .frame = RectMake2x(0, 0, 640, 30);
            contentWebView.frame = RectMake2x(0, 30, 640, 600);
        }
    }
    else {
        KheaderHeight = 346;
        
    }
    
    
    CGRect frame = webView.frame;
    
    CGSize fittingSize = [webView sizeThatFits:CGSizeZero];
    
    frame.size = fittingSize;
    
    webView.frame = frame;
    

    
    //    add  附件
    
    [self atView:fittingSize.height];
    
//    CGFloat hight = commentArray.count * 126;
//    if (commentArray == 0) {
//        hight = 100;
//    }
//
//    commentTableView.frame = RectMake(0, KheaderHeight/2 + fittingSize.height, 320, hight/2);
//    [commentTableView setContentSize:CGSizeMake(320, hight/2)];
//    
//
//    
//    [content setContentSize:CGSizeMake(320, content.contentSize.height + fittingSize.height+ hight)    ];

    [self updateCommentView];
    

    
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    
}

@end
