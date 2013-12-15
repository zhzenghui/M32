//
//  LeftViewController.m
//  ViewDeckExample
//


#import "LeftViewController.h"
#import "IIViewDeckController.h"

#import "ZHNavigationViewController.h"

#import "NewsViewController.h"
#import "LawViewController.h"
#import "DailyViewController.h"
#import "AboutViewController.h"

@implementation LeftViewController

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
            [self.viewDeckController closeLeftViewBouncing:^(IIViewDeckController *controller) {
                self.viewDeckController.leftController = SharedAppDelegate.leftController;
                
                NewsViewController  * newsController = [[NewsViewController alloc] init];
                ZHNavigationViewController *navVC = [[ZHNavigationViewController alloc] initWithRootViewController:newsController];

                self.viewDeckController.centerController = navVC;
                

            }];
            break;
        }
        case 101:
        {
            
            [self.viewDeckController closeLeftViewBouncing:^(IIViewDeckController *controller) {
                self.viewDeckController.leftController = SharedAppDelegate.leftController;
                
                LawViewController  * lawController = [[LawViewController alloc] init];
                ZHNavigationViewController *navVC = [[ZHNavigationViewController alloc] initWithRootViewController:lawController];

                self.viewDeckController.centerController = navVC;
                
                
            }];
            break;
        }
        case 102:
        {
            [self.viewDeckController closeLeftViewBouncing:^(IIViewDeckController *controller) {
                self.viewDeckController.leftController = SharedAppDelegate.leftController;
                
                DailyViewController  * dailyController = [[DailyViewController alloc] init];
                ZHNavigationViewController *navVC = [[ZHNavigationViewController alloc] initWithRootViewController:dailyController];

                self.viewDeckController.centerController = navVC;
            }];
            break;
        }
        case 103:
        {

                AboutViewController  * dailyController = [[AboutViewController alloc] init];
                [self presentViewController:dailyController animated:YES completion:^{
                }];

            break;
        }
        default:
            break;
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

#pragma mark - View lifecycle
- (void)loadView
{
    [super loadView];
    
    if (iOS7) {
        
        UIImageView *statuebar_gb_ImageView = [[UIImageView alloc] init];
        statuebar_gb_ImageView.image = [UIImage imageNamed:@"statuebar_bg.jpg"];
        statuebar_gb_ImageView.frame = NavitionRectMake(0, 0, 320, 20);
        
        [self.view addSubview:statuebar_gb_ImageView];
    }
    

    UIImageView *bgImgeView = [[UIImageView alloc] initWithFrame:NavitionRectMake(0, 20, 320, 568)];
    bgImgeView.image = [UIImage imageNamed:@"bg"];

    [self.view addSubview:bgImgeView];
    
    
    UIImageView *backgroundImageView = [[UIImageView alloc] init];
    backgroundImageView.image = [UIImage imageNamed:@"0-底@2x"];
    backgroundImageView.frame = NavitionRectMake(0, 20, 110, 548);

    [self.view addSubview:backgroundImageView];
    

    
    
    UIButton *newsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [newsButton setBackgroundImage:[UIImage imageNamed:@"leftmenu-news-1"] forState:UIControlStateNormal];
    [newsButton setBackgroundImage:[UIImage imageNamed:@"leftmenu-news-0"] forState:UIControlStateSelected];
    newsButton.selected = YES;
    newsButton.frame = RectMake(0, 77, 110, 76);
    newsButton.tag = 100;
    [newsButton addTarget:self action:@selector(openCenterViewController:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:newsButton];
    

    UIButton *lawButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [lawButton setBackgroundImage:[UIImage imageNamed:@"leftmenu-law-1"] forState:UIControlStateNormal];
    [lawButton setBackgroundImage:[UIImage imageNamed:@"leftmenu-law-0"] forState:UIControlStateSelected];

    lawButton.frame = RectMake(0, 153, 110, 76);
    lawButton.tag = 101;
    [lawButton addTarget:self action:@selector(openCenterViewController:) forControlEvents:UIControlEventTouchUpInside];

    [self.view addSubview:lawButton];
    

    
    
    UIButton *dailyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [dailyButton setBackgroundImage:[UIImage imageNamed:@"leftmenu-daliy-1"] forState:UIControlStateNormal];
    [dailyButton setBackgroundImage:[UIImage imageNamed:@"leftmenu-daliy-0"] forState:UIControlStateSelected];

    dailyButton.frame = RectMake(0, 230, 110, 76);
    dailyButton.tag = 102;
    [dailyButton addTarget:self action:@selector(openCenterViewController:) forControlEvents:UIControlEventTouchUpInside];

    [self.view addSubview:dailyButton];

    
    
    UIButton *aboutButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [aboutButton setBackgroundImage:[UIImage imageNamed:@"leftmenu-our-1"] forState:UIControlStateNormal];
    [aboutButton setBackgroundImage:[UIImage imageNamed:@"leftmenu-our-0"] forState:UIControlStateSelected];
    
    aboutButton.frame = RectMake(0, 230+76, 110, 76);
    aboutButton.tag = 103;
    [aboutButton addTarget:self action:@selector(openCenterViewController:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:aboutButton];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (iOS7) {

    } else {
    
        
    }
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];

    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


@end
