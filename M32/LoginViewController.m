//
//  LoginViewController.m
//  M32
//
//  Created by i-Bejoy on 13-11-24.
//  Copyright (c) 2013年 zeng hui. All rights reserved.
//

#import "LoginViewController.h"
#import "IIViewDeckController.h"
#import "NewsViewController.h"
#import "ZHNavigationViewController.h"
#import "RegistionViewController.h"

@interface LoginViewController ()
{
    UITextField *nameTextField;
    UITextField *passwordTextField;
}
@end

@implementation LoginViewController


- (void)popViewController
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}


- (void)getUser
{
    
    NSString *url = [NSString stringWithFormat:@"%@/user/getUserByMobile/%@/", KHomeUrl, nameTextField.text];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dict = [responseObject objectForKey:@"user"];
        
        if (dict != nil ) {
            
            
            SharedAppUser.ID =  [[dict objectForKey:@"id"] intValue];
            SharedAppUser.name = [dict objectForKey:@"nickName"];

            
        }
        [self.navigationController popViewControllerAnimated:YES];

        
        
        NSLog( @"%@", dict);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog( @"%@", error);
        
    }];
    
    
}
- (void)login
{
    

    NSString *url = [NSString stringWithFormat:@"%@user/login", KHomeUrl];
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *para = @{@"username": nameTextField.text,
                           @"password": passwordTextField.text
                           };
    
    
    [manager POST:url parameters:para success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"fasong: %@", responseObject);
        
        NSDictionary *dict = responseObject;
        NSLog(@"%@", dict);
        if ([[dict objectForKey:@"result"] intValue] == 1 ) {
            [[Message share] messageAlert:@"登陆成功"];
            
            SharedAppUser.ID =  [[dict objectForKey:@"userId"] intValue];
//            SharedAppUser.name = nameTextField.text;
//            
//
            
//           [KNSUserDefaults setObject:nil forKey:@"fav"];

            
            
            [self getUser];

            
            

        }
        else {
            SharedAppUser.ID = 0;
            [[Message share] messageAlert:[dict objectForKey:@"message"]];
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [[Message share] messageAlert:@"服务器错误"];

    }];
    
    
}

- (void)wangJiPassword:(UIButton *)button
{
    
}

- (void)registion:(UIButton *)button
{
    RegistionViewController *registionView = [[RegistionViewController alloc] init];

    if (button.tag == 100) {
        registionView.isRegistion = YES;
    }
    else {
        registionView.isRegistion = NO;
    }
    
    [self.navigationController pushViewController:registionView animated:YES];
}

- (void)setNavigationBarView
{
    
    
    UIView  *navigationBarView = [[UIView alloc] init];
    if (iOS7) {
        navigationBarView.frame = CGRectMake(0, 20, 640, 44);
    }
    else {
        navigationBarView.frame = CGRectMake(0, 0, 640, 44);
    }
    
    
    NSString *navImageName = [NSString string];
    if (iOS7) {
        navImageName = @"user_login_navitionbar_bg";
    }else {
        navImageName = @"user_login_navitionbar_bg";
    }
    
    
    UIImage *img = [UIImage imageNamed:navImageName] ;
    navigationBarView.backgroundColor = [UIColor colorWithPatternImage:img];
    
    
    
    
    
    UIButton *leftBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [leftBarButton addTarget:self action:@selector(popViewController) forControlEvents:UIControlEventTouchUpInside];
    [leftBarButton setImage:[UIImage imageNamed:@"news_conent_arrowup"] forState:UIControlStateNormal];
    leftBarButton.frame = NavitionRectMake(0, 0, 81/2, 44);
    [navigationBarView addSubview:leftBarButton];

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

- (void)viewDidLoad
{
    [super viewDidLoad];

    if (iOS7) {
        
        UIImageView *statuebar_gb_ImageView = [[UIImageView alloc] init];
        statuebar_gb_ImageView.image = [UIImage imageNamed:@"statuebar_bg.jpg"];
        statuebar_gb_ImageView.frame = NavitionRectMake(0, 0, 320, 20);
        
        [self.view addSubview:statuebar_gb_ImageView];
    }
    

    [self setNavigationBarView];
    
    
    UIImageView *gb_ImageView = [[UIImageView alloc] init];
    gb_ImageView.image = [UIImage imageNamed:@"user_login_bg"];
    gb_ImageView.frame = RectMake2x(31, 194, 579, 196);
    
    [self.baseView addSubview:gb_ImageView];
    
    
    nameTextField = [[UITextField alloc] init];
    nameTextField.frame = RectMake2x(118, 200, 400, 88);
    nameTextField.placeholder = @"请填写手机号";
    nameTextField.keyboardType = UIKeyboardTypePhonePad;

    [self.baseView addSubview:nameTextField];


    passwordTextField = [[UITextField alloc] init];
    passwordTextField.frame = RectMake2x(118, 300, 400, 88);
    passwordTextField.secureTextEntry = YES;
    passwordTextField.placeholder = @"请填写密码";
    
    [self.baseView addSubview:passwordTextField];


    
//    UILabel *userName = [[UILabel alloc] initWithFrame:CGRectMake(0, 45, 110, 23)];
//    [userName setFont:[UIFont systemFontOfSize:16]];
//    userName.textColor = [UIColor whiteColor];
//    
//    userName.textAlignment = NSTextAlignmentCenter;
//    userName.text = @"忘记密码";
//    [newsButton addSubview:userName];
    
    
    UIButton *wangJiPasswordButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [wangJiPasswordButton setTitle:@"忘记密码" forState:UIControlStateNormal];
    wangJiPasswordButton.tag = 1022;
    [wangJiPasswordButton addTarget:self action:@selector(registion:) forControlEvents:UIControlEventTouchUpInside];
    wangJiPasswordButton.frame = RectMake2x(442, 300, 150, 88);
    
    [self.baseView  addSubview:wangJiPasswordButton];
    

    
    UIButton *registrationButton = [UIButton buttonWithType:UIButtonTypeCustom];
    registrationButton.tag = 100;
    [registrationButton addTarget:self action:@selector(registion:) forControlEvents:UIControlEventTouchUpInside];
    [registrationButton setImage:[UIImage imageNamed:@"user_singup_button"] forState:UIControlStateNormal];
    registrationButton.frame = RectMake2x(31, 440, 280, 94);
    
    [self.baseView  addSubview:registrationButton];

    
    UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [loginButton addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
    [loginButton setImage:[UIImage imageNamed:@"user_login_button"] forState:UIControlStateNormal];
    loginButton.frame = RectMake2x(330, 440, 280, 94);
    
    [self.baseView  addSubview:loginButton];

    

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    
    if (SharedAppUser.ID != 0 ) {
        
        
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
