//
//  RightViewController.m
//  ViewDeckExample
//


#import "RightViewController.h"
#import "IIViewDeckController.h"
#import "ZHNavigationViewController.h"

#import "LoginViewController.h"
#import "CommentViewController.h"
#import "FavViewController.h"

@interface RightViewController ()
{
    UIButton *newsButton;
    UIButton *lawButton;
    UIButton *dailyButton;
    
    UIButton *dengchuButton;
    
    UILabel *userName ;
}
@property (nonatomic, retain) NSMutableArray* logs;

@end


@implementation RightViewController



- (void)openCenterViewController:(UIButton *) button
{
    
    for (int i = 100; i< 104; i++) {
        UIButton *button = (UIButton *) [self.view viewWithTag:i];
        button.selected = NO;
        
    }
    
    button.selected = YES;
    switch (button.tag) {
        case 100:
        {
            
            if (SharedAppUser.ID != 0)
            {
                [[Message share] messageAlert:@"您已经登录，如果要登出，点击登出按钮，再进行该操作"];
                return;
            }
            LoginViewController  * vc = [[LoginViewController alloc] init];
                
            [self.navigationController pushViewController:vc animated:YES];
                
            break;
        }
        case 101:
        {
            
            FavViewController  * vc = [[FavViewController alloc] init];
            
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case 102:
        {
            CommentViewController  * vc = [[CommentViewController alloc] init];
            
            [self.navigationController pushViewController:vc animated:YES];
            
            break;
        }
        case 103:
        {
            CommentViewController  * vc = [[CommentViewController alloc] init];
            
            [self.navigationController pushViewController:vc animated:YES];
            
            break;
        }
        default:
            break;
    }
}


- (void)loginOut
{
    userName.text = @"登陆账号";
    lawButton.alpha = 0;
    dailyButton.alpha = 0;
    dengchuButton.alpha = 0;
    
    SharedAppUser.ID = 0;
    SharedAppUser.name = @"";

}

- (void )alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != 0) {
        [self loginOut];
    }

}

- (void)loginOut:(UIButton *)button
{
    [[Message share] messageAlert:@"确定要登出账号吗？" delegate:self];
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
    
    UIImageView *bgImgeView = [[UIImageView alloc] initWithFrame:NavitionRectMake(0, 20, 320, 568)];
    bgImgeView.image = [UIImage imageNamed:@"bg"];
    
    [self.view addSubview:bgImgeView];
    
    
    
    
    
    if (iOS7) {
        
        UIImageView *statuebar_gb_ImageView = [[UIImageView alloc] init];
        statuebar_gb_ImageView.image = [UIImage imageNamed:@"statuebar_bg.jpg"];
        statuebar_gb_ImageView.frame = NavitionRectMake(0, 0, 320, 20);
        
        [self.view addSubview:statuebar_gb_ImageView];
    }
    
    UIImageView *backgroundImageView = [[UIImageView alloc] init];
    backgroundImageView.image = [UIImage imageNamed:@"right_menu_bg"];
    backgroundImageView.frame = NavitionRectMake(320-110, 20, 110, 548);
    
    [self.view addSubview:backgroundImageView];
    
    
    
    
    newsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [newsButton setBackgroundImage:[UIImage imageNamed:@"right_user_login_0"] forState:UIControlStateNormal];
//    [newsButton setBackgroundImage:[UIImage imageNamed:@"right_user_login_1"] forState:UIControlStateSelected];
//    newsButton.selected = YES;
    newsButton.frame = RectMake(320-110, 0, 110, 76);
    newsButton.tag = 100;

    [newsButton addTarget:self action:@selector(openCenterViewController:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:newsButton];
    
    userName = [[UILabel alloc] initWithFrame:CGRectMake(0, 45, 110, 23)];
    [userName setFont:[UIFont systemFontOfSize:16]];
    userName.textColor = [UIColor whiteColor];
    
    userName.textAlignment = NSTextAlignmentCenter;
    userName.text = @"登陆账号";
    [newsButton addSubview:userName];
    

    
    
    lawButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [lawButton setBackgroundImage:[UIImage imageNamed:@"right_fav_button_1"] forState:UIControlStateNormal];
    [lawButton setBackgroundImage:[UIImage imageNamed:@"right_fav_button_0"] forState:UIControlStateSelected];
    lawButton.alpha = 0;
    lawButton.frame = RectMake(320-110, 153-77, 110, 76);
    lawButton.tag = 101;
    [lawButton addTarget:self action:@selector(openCenterViewController:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:lawButton];
    
    
    
    dailyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [dailyButton setBackgroundImage:[UIImage imageNamed:@"right_comment_button_0"] forState:UIControlStateNormal];
    [dailyButton setBackgroundImage:[UIImage imageNamed:@"right_comment_button_1"] forState:UIControlStateSelected];
    dailyButton.alpha = 0;
    dailyButton.frame = RectMake(320-110, 230-77, 110, 76);
    dailyButton.tag = 102;
    [dailyButton addTarget:self action:@selector(openCenterViewController:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:dailyButton];
    
    
    dengchuButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [dengchuButton setBackgroundImage:[UIImage imageNamed:@"logout@2x"] forState:UIControlStateNormal];
    dengchuButton.alpha = 0;
    dengchuButton.frame = RectMake(320-110, 230, 110, 51/2);
    dengchuButton.tag = 102;
    [dengchuButton addTarget:self action:@selector(loginOut:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:dengchuButton];
    
    
    
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    

    
   



}




- (void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:YES];
    
    
    if (SharedAppUser.ID != 0) {
        
        userName.text = SharedAppUser.name;
        lawButton.alpha = 1;
        dailyButton.alpha = 1;
        dengchuButton.alpha = 1;
    }
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    
}



@end
