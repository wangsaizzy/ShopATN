//
//  LoginAndRegistViewController.m
//  @的你
//
//  Created by 吴明飞 on 16/3/14.
//  Copyright © 2016年 吴明飞. All rights reserved.
//
#define KMaxSecretLength 20
#define kMaxLength 11
#import "LoginAndRegistViewController.h"
#import "ShopManagerController.h"
#import "FindSecretController.h"
#import "AppDelegate.h"
#import "LoginView.h"
#import "LoginModel.h"
#import "UserModel.h"
#import "HttpHelper.h"
#import "Account.h"
#import "AccountTool.h"

@interface LoginAndRegistViewController ()<UITextFieldDelegate>
@property (nonatomic, strong) LoginView *loginView;
@end

@implementation LoginAndRegistViewController

- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBarHidden = YES;

    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", Service_Url,  [UserModel defaultModel].portraitUrl]];
    [_loginView.customerPhotoImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"headImage"] options:SDWebImageRefreshCached];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupViews];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"登录";
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(accountTFEditChanged:) name:@"UITextFieldTextDidChangeNotification" object:_loginView.accountNumberTF];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(secretTFEditChanged:) name:@"UITextFieldTextDidChangeNotification" object:_loginView.secretNumberTF];
}

#pragma mark -SetupViews
- (void)setupViews {
    
    if (_isFromHomeView) {
        [self addNavigationBackButton];
    }
    
    self.loginView = [[LoginView alloc] initWithFrame:self.view.bounds];
    self.view = _loginView;
    
    self.loginView.accountNumberTF.text = [UserModel defaultModel].accountNumber;
    self.loginView.secretNumberTF.text = [UserModel defaultModel].password;
    
    [_loginView.loginBtn addTarget:self action:@selector(loginBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [_loginView.forgetSecretBtn addTarget:self action:@selector(forgetSecretBtnAction:) forControlEvents:UIControlEventTouchUpInside];
}

// 返回按钮
- (void)addNavigationBackButton
{
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setFrame:CGRectMake(0, 0, 44, 44)];
    [backBtn addTarget:self action:@selector(selectBackBtnAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *img = [[UIImageView alloc]init];
    [img setFrame:CGRectMake(0, 15, 10, 15)];
    [img setImage:[UIImage imageNamed:@"backImage"]];
    
    [backBtn addSubview:img];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
}

// 点击返回
- (void)selectBackBtnAction
{
    if ([self.navigationController popViewControllerAnimated:YES]==nil)
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}


#pragma mark -forgetSecretBtnAction:
- (void)forgetSecretBtnAction:(UIButton *)sender {
    
    FindSecretController *testVC = [[FindSecretController alloc] init];
    [self.navigationController pushViewController:testVC animated:YES];
}



- (void)loginBtnAction:(UIButton *)sender {
    
    
    [SVProgressHUD setMinimumDismissTimeInterval:1];

    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    
    if (_loginView.accountNumberTF.text.length == 0) {
        ShowAlertView(@"请输入账号");
        return;
    }
    
    BOOL isRight = [self isMobileNumber:_loginView.accountNumberTF.text];
    if (!isRight) {
        
        ShowAlertView(@"账号格式不正确，请重新输入");
        return;
    }
    
    if (_loginView.secretNumberTF.text.length == 0) {
        ShowAlertView(@"请输入密码");
        return;
    }
    
    if (_loginView.secretNumberTF.text.length < 6) {
        
        ShowAlertView(@"密码有误，请重新输入");
        return;
    }
    WS(weakself);
    
    [TimeTool saveLoginDate:[NSDate date]];
    
        
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:_loginView.accountNumberTF.text forKey:@"phone"];
    [dict setObject:_loginView.secretNumberTF.text forKey:@"password"];
    [dict setObject:@"IOS" forKey:@"deviceType"];
    
    [HttpHelper post:KLogin_url param:dict finishBlock:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (!connectionError) {
            
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)response;
            if ([httpResponse respondsToSelector:@selector(allHeaderFields)]) {
                
                // 取得http状态码
                
                NSInteger code = [httpResponse statusCode];
                
                if (code == 200) {
                    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                    if ([dict isKindOfClass:[NSDictionary class]]) {
                        
                        
                        NSString *message = dict[@"message"];
                        if ([message isEqualToString:@"成功"]) {
                            
                            [weakself parseDict:dict];
                            [SVProgressHUD dismiss];
                        } else {
                            
                            [SVProgressHUD showInfoWithStatus:message];
                        }
                        
                    }
                    
                    
                    
                } else if (code == 400 || code == 401 || code == 403) {
                    
                    [SVProgressHUD showInfoWithStatus:@"请求不合法"];
                    
                } else if (code == 404) {
                    
                    [SVProgressHUD showInfoWithStatus:@"未知异常"];
                } else if (code == 500 || code == 505) {
                    
                    [SVProgressHUD showInfoWithStatus:@"服务器异常"];
                }

            }
            
        } else {
            
            [SVProgressHUD showInfoWithStatus:@"登录失败"];
        }
    }];
    
}

- (void)parseDict:(NSDictionary *)dict {
    
    

    NSDictionary *dataDic = dict[@"data"];
    
    Account *account = [[Account alloc] initWithDic:dataDic];
    
    [AccountTool saveAccount:account];
    
    [UserModel defaultModel].accountNumber = _loginView.accountNumberTF.text;
            
    [UserModel defaultModel].password = _loginView.secretNumberTF.text;
    
    //[UserModel defaultModel].isAppLogin = YES;
    
    [IsAppLoginTool saveIsAppLogin:YES];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"LoginShopSuccess" object:nil];
    
    [SVProgressHUD showSuccessWithStatus:@"登陆成功"];
}

- (BOOL)isMobileNumber:(NSString *)mobileNum
{

    BOOL flag;
    if (mobileNum.length <= 0) {
        flag = NO;
        return flag;
    }

    NSString *regex = @"^((13[0-9])|(147)|(15[^4,\\D])|(18[0,5-9]))\\d{8}$";
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    BOOL isMatch = [pred evaluateWithObject:mobileNum];
    return isMatch;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    NSString *secretStr = [_loginView.secretNumberTF.text stringByReplacingCharactersInRange:range withString:string];
    
    NSString *phoneStr = [_loginView.accountNumberTF.text stringByReplacingCharactersInRange:range withString:string];
    if (secretStr.length > KMaxSecretLength && range.length!=1){
        _loginView.secretNumberTF.text = [secretStr substringToIndex:KMaxSecretLength];
        
        return NO;
        
    }
    if (phoneStr.length > kMaxLength && range.length != 1) {
        
        _loginView.accountNumberTF.text = [phoneStr substringToIndex:kMaxLength];
        return NO;
    }
    return YES;
}

- (void)secretTFEditChanged:(NSNotification *)obj{
    UITextField *textField = (UITextField *)obj.object;
    
    NSString *toBeString = _loginView.secretNumberTF.text;
    NSString *lang = [[[UIApplication sharedApplication]textInputMode] primaryLanguage]; // 键盘输入模式
    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [textField markedTextRange];
        //获取高亮部分
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            if (toBeString.length > KMaxSecretLength) {
                textField.text = [toBeString substringToIndex:KMaxSecretLength];
            }
        }
        // 有高亮选择的字符串，则暂不对文字进行统计和限制
        else{
            
        }
    }
    // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
    else{
        if (toBeString.length > KMaxSecretLength) {
            textField.text = [toBeString substringToIndex:KMaxSecretLength];
        }
    }
}

- (void)accountTFEditChanged:(NSNotification *)obj{
    UITextField *textField = (UITextField *)obj.object;
    
    NSString *toBeString = _loginView.accountNumberTF.text;
    NSString *lang = [[[UIApplication sharedApplication]textInputMode] primaryLanguage]; // 键盘输入模式
    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [textField markedTextRange];
        //获取高亮部分
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            if (toBeString.length > kMaxLength) {
                textField.text = [toBeString substringToIndex:kMaxLength];
            }
        }
        // 有高亮选择的字符串，则暂不对文字进行统计和限制
        else{
            
        }
    }
    // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
    else{
        if (toBeString.length > kMaxLength) {
            textField.text = [toBeString substringToIndex:kMaxLength];
        }
    }
}


-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"UITextFieldTextDidChangeNotification"
                                                 object:_loginView.accountNumberTF];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"UITextFieldTextDidChangeNotification"
                                                 object:_loginView.secretNumberTF];
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
   
    [self.loginView.accountNumberTF resignFirstResponder];
    [self.loginView.secretNumberTF resignFirstResponder];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
