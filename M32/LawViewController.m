//
//  LawViewController.m
//  
//

#import "LawViewController.h"
#import "IIViewDeckController.h"
#import "ZHNavigationViewController.h"
#import "FileViewController.h"


#import "SVPullToRefresh.h"


@interface LawViewController ()
{
    
    UITextField *keyWordTextField;
    UIView *lawTypeView;
    
    
    int curPage;
    int maxPage;
    bool isInfiniteScroll;
}

@end



@implementation LawViewController



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

- (void)addBottom
{
    
    if (_dataArray.count == 4 && !isInfiniteScroll) {
        
        isInfiniteScroll = true;
        __weak LawViewController *weakSelf = self;
        
        [weakSelf.tableView addInfiniteScrollingWithActionHandler:^{
            [weakSelf insertRowAtBottom];
        }];
    }
}




- (void)loadNetWorkData
{
    
    
//    Cookieregulation/getRegualtionList?level=%@&step=%@&key=%@&numPerPage=%@&curPage=%@, 1, KPageSize, curPage
    
    NSMutableString *mString =[NSMutableString string];
    
    
    NSString *step = [NSString string];
    
    if (currentSetp != -1) {
        step = [NSString stringWithFormat:@"&step=%d", currentSetp];
        [mString appendString:step];
    }
    
    NSString *keyWord = [NSString string];
    if (keyWordTextField.text.length != 0 ) {
        keyWord = [NSString stringWithFormat:@"&key=%@", keyWordTextField.text];
        
        keyWord = [keyWord stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [mString appendString:keyWord];

    }
    

    NSString *url = [NSString stringWithFormat:@"%@regulation/getRegualtionList?%@&numPerPage=%d&curPage=%d", KHomeUrl, mString, KPageSize, curPage];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        NSArray *array = [responseObject objectForKey:@"list"];
        __weak LawViewController *weakSelf = self;
        
        
        if (array.count == 0 && keyWordTextField.text.length != 0) {
            
            noResults = YES;
            [self.tableView reloadData];

        }
        else {
            noResults = NO;
        }
        keyWordTextField.text = @"";

        
        
        
        if (array .count != 0) {
            if (_dataArray.count == 0) {
                
                _dataArray = [NSMutableArray arrayWithArray:array];
                [self.tableView reloadData];
                
                

                date_lable.text = [NSString stringWithFormat: @"共%d条", [[responseObject objectForKey:@"num"] intValue]];

                
            }
            else {
                
                
                NSMutableArray *indexPaths = [NSMutableArray array];
                
                for (int i = 0; i< array.count ; i++) {
                    
                    [indexPaths addObject:[NSIndexPath indexPathForRow:weakSelf.dataArray.count+i inSection:0]];
                    
                }
                [self addArray:array];
                
                
                [weakSelf.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationTop];
                [weakSelf.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:weakSelf.dataArray.count-2 inSection:0]
                                          atScrollPosition:UITableViewScrollPositionTop animated:YES];
                [weakSelf.tableView.infiniteScrollingView stopAnimating];
                
                
                [self addBottom];

            }
            
        }
        else {
            

            curPage --;
            [weakSelf.tableView.pullToRefreshView stopAnimating];
            [weakSelf.tableView.infiniteScrollingView stopAnimating];
            
            date_lable.text = [NSString stringWithFormat: @"共0条"];

            [self.tableView reloadData];
        }
        
        
        [weakSelf.tableView.pullToRefreshView stopAnimating];

        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        __weak LawViewController *weakSelf = self;

        [weakSelf.tableView.pullToRefreshView stopAnimating];
        [weakSelf.tableView.infiniteScrollingView stopAnimating];
    }];
    
    
    
}


- (void)setSeachTypeText
{
    
}

#pragma mark - 

- (void)openTypeLaw:(UIButton *)button
{

    [self.tableView reloadData];

    currentSetp = -1;
    
    [keyWordTextField resignFirstResponder];

    
    

    
    
    __weak LawViewController *weakSelf = self;

    
    if (lawTypeView.alpha == 1) {

        if (button.tag == 100) {
            
            [keyWordTextField resignFirstResponder];
            
            if ( keyWordTextField.text.length == 0) {
                
                [[Message share] messageAlert:@"请填写搜索关键词"];
                
                return;
            }
            lawTypeView.alpha = 0;

            type_lable.text = [NSString stringWithFormat: @"搜索：%@", keyWordTextField.text];
            [weakSelf.tableView triggerPullToRefresh];

            return;
        }
        
        
        lawTypeView.alpha = 0;

        currentSetp = button.tag;

        NSString *s = [NSString string];
        switch (currentSetp) {
            case 0:
            {
                s = @"研制";
                break;
            }
            
            case 1:
            {
                s = @"研制";
                break;
            }
                
            case 2:
            {
                s = @"生产";
                break;
            }
                
            case 3:
            {
                s = @"临床";
                break;
            }
                
            case 4:
            {
                s = @"注册";
                break;
            }
                
            case 5:
            {
                s = @"经销";
                break;
            }
                
            case 6:
            {
                s = @"使用";
                break;
            }
                
            case 7:
            {
                s = @"研制";
                break;
            }
                
            default:
                break;
        }
        

        date_lable.text = [NSString stringWithFormat: @"共%d条", 0];
        type_lable.text = [NSString stringWithFormat: @"生命周期 > %@", s];


        [weakSelf.tableView triggerPullToRefresh];
    }
    else {
        lawTypeView.alpha = 1;
    }

}

- (void)loadLawTypeView
{
    
    
    
    lawTypeView = [[UIView alloc] initWithFrame:RectMake2x(0, 40, 640, 1096)];
    if (iOS7) {
        lawTypeView.frame = RectMake2x(0, 40, 640, 1096);
    }
    else {
        lawTypeView.frame = RectMake2x(0, 0, 640, 1096);

    }
    lawTypeView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"law_bg"]];

//    背景 及其  textView
    UIImageView *seach_View = [[UIImageView alloc] initWithFrame:RectMake2x(0, 88, 640, 86)];
    seach_View.image = [UIImage imageNamed:@"law_menubar_seach_textfield"];
    
    [lawTypeView addSubview:seach_View];
    
    
    
    
//    搜索
    keyWordTextField = [[UITextField alloc] init];
    keyWordTextField.frame = RectMake2x(66, 25+88, 320, 33);
    keyWordTextField.delegate = self;
    keyWordTextField.placeholder = @"填写关键词";
    
    [lawTypeView addSubview:keyWordTextField];
    
    
    
    UIButton *seach = [UIButton buttonWithType:UIButtonTypeCustom];
    [seach addTarget:self action:@selector(openTypeLaw:) forControlEvents:UIControlEventTouchUpInside];
    [seach setImage:[UIImage imageNamed:@"law_menubar_seach_button"] forState:UIControlStateNormal];
    seach.tag = 100;
    seach.frame = RectMake2x(475, 102, 127, 55);
    
    [lawTypeView addSubview:seach];
    
    
//    圆圈⭕️
//    研制
    UIButton *yanzhi = [UIButton buttonWithType:UIButtonTypeCustom];
    yanzhi.tag = 1;
    [yanzhi addTarget:self action:@selector(openTypeLaw:) forControlEvents:UIControlEventTouchUpInside];
    [yanzhi setImage:[UIImage imageNamed:@"law_develop_1"] forState:UIControlStateNormal];
    [yanzhi setImage:[UIImage imageNamed:@"law_develop"] forState:UIControlStateHighlighted];

    yanzhi.frame = RectMake2x(89, 210, 276, 200);
    
    [lawTypeView addSubview:yanzhi];
    
    
//    生产
    UIButton *shengchan = [UIButton buttonWithType:UIButtonTypeCustom];
    shengchan.tag = 2;
    [shengchan addTarget:self action:@selector(openTypeLaw:) forControlEvents:UIControlEventTouchUpInside];
    [shengchan setImage:[UIImage imageNamed:@"law_produce_1"] forState:UIControlStateNormal];
    [shengchan setImage:[UIImage imageNamed:@"law_produce"] forState:UIControlStateHighlighted];
    
    shengchan.frame = RectMake2x(329, 210, 232, 217);
    
    [lawTypeView addSubview:shengchan];
    
//    临床
    UIButton *linchuang = [UIButton buttonWithType:UIButtonTypeCustom];
    linchuang.tag = 3;
    [linchuang addTarget:self action:@selector(openTypeLaw:) forControlEvents:UIControlEventTouchUpInside];
    [linchuang setImage:[UIImage imageNamed:@"law_clinical_1"] forState:UIControlStateNormal];
    [linchuang setImage:[UIImage imageNamed:@"law_clinical"] forState:UIControlStateHighlighted];
    
    linchuang.frame = RectMake2x(434, 355, 160, 275);
    
    [lawTypeView addSubview:linchuang];
    
//    注册
    UIButton *registion = [UIButton buttonWithType:UIButtonTypeCustom];
    registion.tag = 4;
    [registion addTarget:self action:@selector(openTypeLaw:) forControlEvents:UIControlEventTouchUpInside];
    [registion setImage:[UIImage imageNamed:@"law_registration_1"] forState:UIControlStateNormal];
    [registion setImage:[UIImage imageNamed:@"law_registration"] forState:UIControlStateHighlighted];

    registion.frame = RectMake2x(277, 559, 275, 200);
    
    [lawTypeView addSubview:registion];
    
//    经销
    UIButton *distribute = [UIButton buttonWithType:UIButtonTypeCustom];
    distribute.tag = 5;
    [distribute addTarget:self action:@selector(openTypeLaw:) forControlEvents:UIControlEventTouchUpInside];
    [distribute setImage:[UIImage imageNamed:@"law_distribute_1"] forState:UIControlStateNormal];
    [distribute setImage:[UIImage imageNamed:@"law_distribute"] forState:UIControlStateHighlighted];
    
    distribute.frame = RectMake2x(80, 544, 233, 215);
    
    [lawTypeView addSubview:distribute];
    
//    使用
    UIButton *use = [UIButton buttonWithType:UIButtonTypeCustom];
    use.tag = 6;
    [use addTarget:self action:@selector(openTypeLaw:) forControlEvents:UIControlEventTouchUpInside];
    [use setImage:[UIImage imageNamed:@"law_use_1"] forState:UIControlStateNormal];
    [use setImage:[UIImage imageNamed:@"law_use"] forState:UIControlStateHighlighted];
    
    use.frame = RectMake2x(46, 337, 162, 279);
    
    [lawTypeView addSubview:use];
    
    
    
//    监管环境
    UIButton *jianguan = [UIButton buttonWithType:UIButtonTypeCustom];
    jianguan.tag = 7;
    [jianguan addTarget:self action:@selector(openTypeLaw:) forControlEvents:UIControlEventTouchUpInside];
    [jianguan setImage:[UIImage imageNamed:@"law_regulatory_environment"] forState:UIControlStateNormal];
    jianguan.frame = RectMake2x(35, 736, 175, 176);
    
    [lawTypeView addSubview:jianguan];
    
    
//    体外
    UIButton *tiwai = [UIButton buttonWithType:UIButtonTypeCustom];
    tiwai.tag = 8;
    [tiwai addTarget:self action:@selector(openTypeLaw:) forControlEvents:UIControlEventTouchUpInside];
    [tiwai setImage:[UIImage imageNamed:@"law_vitro_diagnostics"] forState:UIControlStateNormal];
    tiwai.frame = RectMake2x(435, 742, 165, 165);
    
    [lawTypeView addSubview:tiwai];
    
    
    [self.baseView addSubview:lawTypeView];

    
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
    }
    return self;
}

#pragma mark - View lifecycle

- (void)loadView
{
    [super loadView];
    


    
    curPage = 1;
    isInfiniteScroll = false;

    
    UIView *cView = [[UIView alloc] initWithFrame:RectMake2x(0, 128, 640, 30)];
    cView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"type_bg"]];
    
    
    [self.baseView addSubview:cView];
//    UIImageView *type_bgImageView = [[UIImageView alloc] initWithFrame:RectMake2x(0, 0, 640, 30)];
//    type_bgImageView.image = [UIImage imageNamed:@"type_bg"];
//    type_bgImageView.alpha = 0;
//    [cView addSubview:type_bgImageView];
    
    
    
    type_lable = [[UILabel alloc] initWithFrame:RectMake2x(31, 4, 220, 22)];
    [type_lable setFont:[UIFont systemFontOfSize:11]];
    [cView addSubview:type_lable];
    
    date_lable = [[UILabel alloc] initWithFrame:RectMake2x(552, 4,128, 22)];
    date_lable.textColor = [UIColor redColor];
    [date_lable setFont:[UIFont systemFontOfSize:11]];
    [cView addSubview:date_lable];
    
    

    
    
    if (! iOS7) {
        self.baseView.frame = CGRectMake(0, -20, screenWidth, screenHeight);
    }

    _tableView = [[UITableView alloc] init];
    _tableView.delegate = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.dataSource =  self;
    
    _tableView.frame = NavitionRectMake(0, 79, 320,  screenHeight-64-44-15);;
    
    [self.baseView  addSubview:_tableView];
    
    
    

    
    UIView *adView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    
    if (iOS7) {
        adView.frame = NavitionRectMake(0, screenHeight-44, 320, 44);
    }
    else {
        adView.frame = NavitionRectMake(0, screenHeight-64, 320, 44);
        
        
    }
    
    adView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"daily_toolbar_write_bar"]];
    [self.baseView  addSubview:adView];

    
    
    UIButton *fasongButton = [UIButton buttonWithType:UIButtonTypeCustom];
    fasongButton.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"news_conent_arrowup"]];
    [fasongButton addTarget:self action:@selector(openTypeLaw:) forControlEvents:UIControlEventTouchUpInside];
    
    fasongButton.frame = RectMake2x(0, 0, 81, 88);
    [adView addSubview:fasongButton];
    
    
//    UIButton *openTypeView = [UIButton buttonWithType:UIButtonTypeCustom];
//    [openTypeView addTarget:self action:@selector(openTypeLaw:) forControlEvents:UIControlEventTouchUpInside];
//    openTypeView.frame = adView.frame;
//    
//    [adView addSubview:openTypeView];
    
//    UIButton *sousuo = [UIButton buttonWithType:UIButtonTypeCustom];
//    [sousuo addTarget:self action:@selector(openTypeLaw:) forControlEvents:UIControlEventTouchUpInside];
//    [sousuo setImage:[UIImage imageNamed:@"law_seachbar_seach"] forState:UIControlStateNormal];
//    sousuo.frame = RectMake2x(482, 17, 120, 57);
//    
//    [adView addSubview:sousuo];

    
    
    
    [self loadLawTypeView];
    
    [self setNavigationBarView];
    
    


}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    noResults = NO;
    
    
    currentSetp = -1;
    
    __weak LawViewController *weakSelf = self;
    
    // setup pull-to-refresh
    [weakSelf.tableView addPullToRefreshWithActionHandler:^{
        [weakSelf insertRowAtTop];
    }];
//    [weakSelf.tableView triggerPullToRefresh];

    
    _dataArray = [[NSMutableArray alloc]  init];

    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
   
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    
//    __weak LawViewController *weakSelf = self;
//    
//    [weakSelf.tableView triggerPullToRefresh];
    
}

- (void)hideOrShow {
    [[UIApplication sharedApplication] setStatusBarHidden:![UIApplication sharedApplication].isStatusBarHidden withAnimation:UIStatusBarAnimationSlide];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (noResults) {
        return 1;
    }
    return [_dataArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 85;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"law_cell_bg"]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        UIImageView *zanImageView = [[UIImageView alloc] init];
        zanImageView.tag = 103;
        zanImageView.frame = RectMake2x(40, 38, 53, 49);
        [cell.contentView addSubview:zanImageView];
        
        
        
        UILabel *nameLable = [[UILabel alloc] initWithFrame:RectMake2x(121, 27, 478, 68)];
        nameLable.tag = 100;
        [nameLable setFont:[UIFont systemFontOfSize:14]];
        [nameLable setNumberOfLines:0];
        nameLable.lineBreakMode = NSLineBreakByTruncatingTail;
        
        [cell.contentView addSubview:nameLable];
        
        
        
        
        UILabel *contentLable = [[UILabel alloc] initWithFrame:RectMake2x(122, 80, 510, 97)];
        [contentLable setNumberOfLines:0];
        contentLable.lineBreakMode = NSLineBreakByTruncatingTail;
        contentLable.textColor = colorAlpha(0, 0, 0, .6);
        contentLable.tag = 101;
        [contentLable setFont:[UIFont systemFontOfSize:11]];
        contentLable.textColor = [UIColor grayColor];
        [cell.contentView addSubview:contentLable];
        

        

    }
    
    if ( noResults ) {
            cell.textLabel.text = @"没有搜索到任何结果";
            
            return cell;
    }

    
    UILabel *nameLable = (UILabel *)[cell.contentView viewWithTag:100];
    UILabel *contentLable = (UILabel *)[cell.contentView viewWithTag:101];
    UIImageView *zanImageView = (UIImageView *)[cell.contentView viewWithTag:103];
    
    NSDictionary *dict = [_dataArray objectAtIndex:indexPath.row];
    
    nameLable.text = [dict objectForKey:@"title"];
    
    
    long long timestmp1 = [[dict objectForKey:@"publishTime"] longLongValue]/1000;
    long long timestmp2 = [[dict objectForKey:@"reissueTime"] longLongValue]/1000;

    
//    法规的等级     发布机构      实施日期       发布日期
    NSString *string = [NSString stringWithFormat:@"法规等级:%@ 发布机构:%@\n实施日期:%@ 发布日期:%@ ",
                        [dict objectForKey:@"level"],
                        [dict objectForKey:@"org"],
                        [NSDate dateWithTimestamp:timestmp1],
                        [NSDate dateWithTimestamp:timestmp2]];
    
    contentLable.text = string;
    
    
    
    NSString *fileName = [[dict objectForKey:@"attachment"] objectForKey:@"fileName"];
    
    NSRange rPdf = [fileName rangeOfString:@"pdf"];
    
    NSRange rDoc = [fileName rangeOfString:@"doc"];
    NSRange rDocx = [fileName rangeOfString:@"docx"];

    NSRange rXls = [fileName rangeOfString:@"pdf"];

    if (rPdf.length != 0) {
        zanImageView.image = [UIImage imageNamed:@"law_filetype_pdf"];
    }
    else if (rDoc.length != 0 || rDocx.length != 0) {
        zanImageView.image = [UIImage imageNamed:@"law_filetype_word"];
    }
    else if (rXls.length != 0 ) {
        zanImageView.image = [UIImage imageNamed:@"law_filetype_xls"];

    }



    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSDictionary *dict = [_dataArray objectAtIndex:indexPath.row];
    
    FileViewController *newsDetail = [[FileViewController alloc] init];
    newsDetail.dict = @{@"fileUrl": [[dict objectForKey:@"attachment"] objectForKey:@"fileUrl"],
                        @"fileName": [[dict objectForKey:@"attachment"] objectForKey:@"fileName"],
                        @"title": [dict objectForKey:@"title"]};
    
    [self.zhNavigationController pushViewController:newsDetail];
    
}

#pragma mark - Table view delegate

- (void)didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    

}

#pragma mark - textField

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    currentSetp = -1;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - webView


- (void)webViewDidStartLoad:(UIWebView *)webView
{
    
}


- (void)webViewDidFinishLoad:(UIWebView *)webView
{

}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    
}

@end
