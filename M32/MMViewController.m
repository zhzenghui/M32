//
//  MMViewController.m
//  M32
//
//  Created by i-Bejoy on 13-11-18.
//  Copyright (c) 2013年 zeng hui. All rights reserved.
//

#import "MMViewController.h"
#import "IIViewDeckController.h"

@interface MMViewController ()

@end

@implementation MMViewController


- (void)showCam:(id)sender {
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


#pragma mark - view cycle
- (void)loadView
{
    [super loadView];
    
    _tableView = [[TableView alloc] init];
    _tableView.delegate = self;
    _tableView.dataSource =  self;

    _tableView.frame = RectMake(0, 97, 320, 471);;
    
    [self.view addSubview:_tableView];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [SharedApplication setStatusBarStyle:UIStatusBarStyleBlackTranslucent];


    [self.leftBarButton addTarget:self.viewDeckController action:@selector(toggleLeftView) forControlEvents:UIControlEventTouchUpInside];
    [self.leftBarButton setImage:[UIImage imageNamed:@"nav-左标"] forState:UIControlStateNormal];
    self.leftBarButton.frame = NavitionRectMake(14, 30, 27, 25);
    
    
    
    [self.rightBarButton addTarget:self.viewDeckController action:@selector(toggleRightView) forControlEvents:UIControlEventTouchUpInside];
    [self.rightBarButton setImage:[UIImage imageNamed:@"nav-右标"] forState:UIControlStateNormal];
    self.rightBarButton.frame = NavitionRectMake(280, 30, 27, 25);
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4 + arc4random() % 10;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return section == 0 ? 1 : 3 + arc4random() % 50;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return section > 0 ? [NSString stringWithFormat:@"%d", section-1] : nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    if (indexPath.section == 0) {
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.textLabel.text = @"Switch to right";
    }
    else {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.text = [NSString stringWithFormat:@"%d:%d", indexPath.section-1, indexPath.row];
    }
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        [self.viewDeckController toggleOpenView];
        return;
    }
    
    [self.viewDeckController closeLeftViewBouncing:^(IIViewDeckController *controller) {
        if ([controller.centerController isKindOfClass:[UINavigationController class]]) {
            UITableViewController* cc = (UITableViewController*)((UINavigationController*)controller.centerController).topViewController;
            cc.navigationItem.title = [tableView cellForRowAtIndexPath:indexPath].textLabel.text;
            if ([cc respondsToSelector:@selector(tableView)]) {
                [cc.tableView deselectRowAtIndexPath:[cc.tableView indexPathForSelectedRow] animated:NO];
            }
        }
        [NSThread sleepForTimeInterval:(300+arc4random()%700)/1000000.0]; // mimic delay... not really necessary
    }];
}


@end
