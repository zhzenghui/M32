//
//  RegistionViewController.m
//  M32
//
//  Created by i-Bejoy on 13-11-26.
//  Copyright (c) 2013年 zeng hui. All rights reserved.
//

#import "RegistionViewController.h"

@interface RegistionViewController ()
{
    UITextField *phoneTextField;

    UITextField *confirmCodeTextField;

    
    UITextField *userNameTextField;
    UITextField *passwordTextField;
    UITextField *confirmPasswordTextField;

    
    
    UILabel *phone;

    
    UIView *checkCodeView;
    
    UIView *registView;
}
@end

@implementation RegistionViewController

- (void) popViewController
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)backGetCode
{

}

- (void)checkButton:(UIButton *)button
{
    
    
    if (button.highlighted) {
        button.highlighted = NO;
    }
    else {
        button.highlighted = YES;
    }
}

- (void)openAgree
{
    
}

- (void)openCheckView
{
    checkCodeView.frame = CGRectMake(0, 0, screenWidth, screenHeight);

}

- (void)getCode
{

    if (phoneTextField.text.length == 0) {
        [[Message share] messageAlert:@"请请填写手机号码！"];
        return;
    }
    
    phone.text = phoneTextField.text;
    
    
    NSString *url = [NSString stringWithFormat:@"%@/user/sendMobileCode/%@/", KHomeUrl, phoneTextField.text];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dict = responseObject;
        if ([[dict objectForKey:@"result"] intValue] == 1 ) {
            [self openCheckView];
            
        }
        else {
            [[Message share] messageAlert:[dict objectForKey:@"message"]];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog( @"%@", error);
        [[Message share] messageAlert:@"网络错误"];

    }];
    
    
}

- (void)getUser
{
    
    NSString *url = [NSString stringWithFormat:@"%@/user/getUserByMobile/%@/", KHomeUrl, phoneTextField.text];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dict = [responseObject objectForKey:@"user"];
        
        if ( [responseObject objectForKey:@"user"] != [NSNull null] ) {
            NSDictionary *dict = [responseObject objectForKey:@"user"];

            
//            SharedAppUser.ID =  [[dict objectForKey:@"id"] intValue];
//            SharedAppUser.name = [dict objectForKey:@"nickName"];

            if (!_isRegistion) {
                
                userNameTextField.text = [dict objectForKey:@"nickName"];
                [userNameTextField setEnabled:NO];
            }
        }

        registView.frame = CGRectMake(0, 0, screenWidth, screenHeight);

        
        NSLog( @"%@", dict);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog( @"%@", error);
        
    }];
    
    
}

- (void)submintCode
{
    
    NSString *url = [NSString stringWithFormat:@"%@/user/verfiyMobileCode/%@/%@/", KHomeUrl, phoneTextField.text, confirmCodeTextField.text];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dict = responseObject;
        
        if ([[dict objectForKey:@"result"] intValue] == 1 ) {

            [[Message share] messageAlert:@"验证码验证成功"];
            
            [self getUser];
        }
        else {
            [[Message share] messageAlert:@"验证码无效！"];
        }


        NSLog( @"%@", dict);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog( @"%@", error);
        [[Message share] messageAlert:@"验证码无效！"];

    }];
    

}

- (void)submintUser
{
    if (! [passwordTextField.text isEqualToString:confirmPasswordTextField.text]) {
        
        [[Message share] messageAlert:@"请检查密码是否一致"];

        return;
    }
    
    NSString *url = [NSString stringWithFormat:@"%@user/register", KHomeUrl];
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *para = @{@"nickName": userNameTextField.text,
                           @"password": passwordTextField.text,
                           @"mobile": phoneTextField.text,
                           @"code": confirmCodeTextField.text,
                           };
    
    
    [manager POST:url parameters:para success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"fasong: %@", responseObject);
        
        NSDictionary *dict = responseObject;
        NSLog(@"%@", dict);
        if ([[dict objectForKey:@"result"] intValue] == 1 ) {
            [[Message share] messageAlert:@"注册成功"];
            
            [self popViewController];

        }
        else {
            [[Message share] messageAlert:@"注册失败"];
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
}

- (void)retUserPassword
{
    if (! [passwordTextField.text isEqualToString:confirmPasswordTextField.text]) {
        
        [[Message share] messageAlert:@"请检查密码是否一致"];
        
        return;
    }
    
    NSString *url = [NSString stringWithFormat:@"%@user/retrievePwd", KHomeUrl];
    

    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *para = @{@"password": passwordTextField.text,
                           @"mobile": phoneTextField.text,
                           @"code": confirmCodeTextField.text,
                           };
    
    
    [manager POST:url parameters:para success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"fasong: %@", responseObject);
        
        NSDictionary *dict = responseObject;
        NSLog(@"%@", dict);
        if ([[dict objectForKey:@"result"] intValue] == 1 ) {
            [[Message share] messageAlert:@"修改密码成功"];
                        
            [self popViewController];
            
        }
        else {
            [[Message share] messageAlert:@"修改密码失败"];
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
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
    
    
    UIImageView *gb_ImageView = [[UIImageView alloc] init];
    gb_ImageView.image = [UIImage imageNamed:@"user_login_phone_tf_bg"];
    gb_ImageView.frame = RectMake2x(29, 198, 583, 108);
    
    [self.baseView addSubview:gb_ImageView];
    
    
    phoneTextField = [[UITextField alloc] init];
    phoneTextField.delegate = self;
    phoneTextField.keyboardType = UIKeyboardTypeNumberPad;
    phoneTextField.frame = RectMake2x(40, 206, 400, 88);
    phoneTextField.placeholder = @"请输入手机号";
    
    [self.baseView addSubview:phoneTextField];
    
    
    
    
    
    UIButton *getCodeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [getCodeButton addTarget:self action:@selector(getCode) forControlEvents:UIControlEventTouchUpInside];
    [getCodeButton setImage:[UIImage imageNamed:@"user_registion_getcode_button"] forState:UIControlStateNormal];
    getCodeButton.frame = RectMake2x(31, 343, 583, 108);
    
    [self.baseView  addSubview:getCodeButton];
    
    
//    ----------------------------------------------------------------
    
    
    checkCodeView = [[UIView alloc] initWithFrame:CGRectMake(screenWidth, 0, screenWidth, screenHeight)];
    checkCodeView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"user_bg"]];


    
    UIImageView *bg_ImageView = [[UIImageView alloc] init];
    bg_ImageView.image = [UIImage imageNamed:@"user_registion_checkphone_bg"];
    bg_ImageView.frame = RectMake2x(29, 172, 584, 304);
    
    [checkCodeView addSubview:bg_ImageView];
    
    
    
    phone =  [[UILabel alloc]initWithFrame:RectMake2x(300, 175, 280, 38)];
    phone.text = phoneTextField.text;
    
    [checkCodeView  addSubview:phone];
    
    confirmCodeTextField = [[UITextField alloc] init];
    confirmCodeTextField.delegate = self;
    confirmCodeTextField.keyboardType = UIKeyboardTypeNumberPad;

    confirmCodeTextField.frame = RectMake2x(40, 380, 300, 88);
    confirmCodeTextField.placeholder = @"请输入验证码";
    
    [checkCodeView addSubview:confirmCodeTextField];
    
    
    
    UIButton *submitCodeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [submitCodeButton addTarget:self action:@selector(submintCode) forControlEvents:UIControlEventTouchUpInside];
    [submitCodeButton setImage:[UIImage imageNamed:@"user_registion_submit_phone"] forState:UIControlStateNormal];
    submitCodeButton.frame = RectMake2x(30, 513, 583, 108);
    
    [checkCodeView  addSubview:submitCodeButton];
    
    
//    UILabel *notifiLabel = [[UILabel alloc] initWithFrame:RectMake2x(209, 643, 221, 33)];
//    notifiLabel.text = @"11秒后重新发送";
//    [checkCodeView addSubview:notifiLabel];
    
    
    
    [self.baseView addSubview:checkCodeView];
  
    
//    ----------------------------------------------------------------

    
    
    registView = [[UIView alloc] initWithFrame:CGRectMake(screenWidth, 0, screenWidth, screenHeight)];
    registView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"user_bg"]];
    

    UIImageView *regist_bg_ImageView = [[UIImageView alloc] init];
    regist_bg_ImageView.image = [UIImage imageNamed:@"user_registion_text"];
    regist_bg_ImageView.frame = RectMake2x(29, 194, 584, 304);
    
    [registView addSubview:regist_bg_ImageView];
    
    
   
    
    
    userNameTextField = [[UITextField alloc] init];
    userNameTextField.delegate = self;
    userNameTextField.frame = RectMake2x(118, 200, 400, 88);
    userNameTextField.placeholder = @"请输入用户名";
    
    [registView addSubview:userNameTextField];
    
    passwordTextField = [[UITextField alloc] init];
    passwordTextField.delegate = self;
    passwordTextField.frame = RectMake2x(118, 300, 400, 88);
    passwordTextField.placeholder = @"请输入密码";
    passwordTextField.secureTextEntry = YES;
    
    [registView addSubview:passwordTextField];
    
    confirmPasswordTextField = [[UITextField alloc] init];
    confirmPasswordTextField.delegate = self;
    confirmPasswordTextField.secureTextEntry = YES;
    confirmPasswordTextField.frame = RectMake2x(118, 400, 400, 88);
    confirmPasswordTextField.placeholder = @"请输入确定密码";
    
    [registView addSubview:confirmPasswordTextField];
    
    
    
    
    [self.baseView addSubview:registView];

    
    
    [self setNavigationBarView];

    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    
    UIButton *submitUserButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    if (_isRegistion) {
        [submitUserButton addTarget:self action:@selector(submintUser) forControlEvents:UIControlEventTouchUpInside];
    }
    else {
        [submitUserButton addTarget:self action:@selector(retUserPassword) forControlEvents:UIControlEventTouchUpInside];
    }
    
    [submitUserButton setImage:[UIImage imageNamed:@"user_singup_button_0"] forState:UIControlStateNormal];
    submitUserButton.frame = RectMake2x(67, 514, 508, 98);
    
    [registView  addSubview:submitUserButton];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return NO;
}

@end
