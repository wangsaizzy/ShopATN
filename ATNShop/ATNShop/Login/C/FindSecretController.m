//
//  FindSecretController.m
//  ATNShopDemo
//
//  Created by 吴明飞 on 16/7/23.
//  Copyright © 2016年 吴明飞. All rights reserved.
//

#define kMaxTestLength 6
#define KMaxPhoneLength 11
#define KMaxSecretLength 20
#import "FindSecretController.h"
#import "AlertSecretCodeView.h"
@interface FindSecretController ()<UIGestureRecognizerDelegate>

{
    AlertSecretCodeView *_testView;
}


@end

@implementation FindSecretController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.translucent = NO;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"修改密码";
    [self customNaviBar];
    [self setupViews];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(phoneTFEditChanged:) name:@"UITextFieldTextDidChangeNotification" object:_testView.phoneNumberTF];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(testTFEditChanged:) name:@"UITextFieldTextDidChangeNotification" object:_testView.bringTestNumberTF];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(secretTFEditChanged:) name:@"UITextFieldTextDidChangeNotification" object:_testView.SecretNumberTF];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(resetTFEditChanged:) name:@"UITextFieldTextDidChangeNotification" object:_testView.reSetSecretNumberTF];
}

- (void)customNaviBar {
    
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"arrowImage"] style:UIBarButtonItemStylePlain target:self action:@selector(handleBack:)];
    self.navigationItem.leftBarButtonItem = left;
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:20 * kMulriple], NSForegroundColorAttributeName:[UIColor whiteColor]};
    self.navigationController.navigationBar.titleTextAttributes = dic;
    self.navigationController.navigationBar.barTintColor = RGB(83, 83, 83);
}

- (void)handleBack:(UIBarButtonItem *)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)endEditing
{
    [self.view endEditing:YES];
    
}

- (void)setupViews {
    _testView = [[AlertSecretCodeView alloc] initWithFrame:self.view.bounds];
    self.view = _testView;
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer.delegate = self;
    //将触摸事件添加到当前view
    [self.view addGestureRecognizer:tapGestureRecognizer];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(endEditing)];
    tap.delegate = self;
    [self.view addGestureRecognizer:tap];
    
    [_testView.acquireTestBtn addTarget:self action:@selector(acquireTestBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [_testView.commitBtn addTarget:self action:@selector(commitBtnAction:) forControlEvents:UIControlEventTouchUpInside];
}


#pragma mark -获取验证码
- (void)acquireTestBtnAction:(UIButton *)sender {
    
    if (_testView.phoneNumberTF.text.length == 0) {
        ShowAlertView(@"请输入手机号");
        return;
    }
    
    BOOL isRight = [self isMobileNumber:_testView.phoneNumberTF.text];
    if (!isRight) {
        
        ShowAlertView(@"账号格式不正确，请重新输入");
        return;
    }
    
    [SVProgressHUD setMinimumDismissTimeInterval:1];
    
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    
    [SVProgressHUD show];
    WS(weakself);
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:_testView.phoneNumberTF.text forKey:@"phone"];
    
    
    [HttpHelper requestMethod:@"GET" urlString:KRecoverPasswordCode_url parma:dict success:^(id json) {
        
        [weakself countDown];
        [SVProgressHUD showSuccessWithStatus:@"获取验证码成功"];
        
    } failure:^(NSError *error) {
        
        [SVProgressHUD showInfoWithStatus:@"获取验证码失败"];
    }];
    
}

#pragma mark -提交
- (void)commitBtnAction:(UIButton *)sender {
    
    if (_testView.phoneNumberTF.text.length == 0) {
        
        ShowAlertView(@"请输入手机号");
        return;
    }
    
    BOOL isRight = [self isMobileNumber:_testView.phoneNumberTF.text];
    if (!isRight) {
        
        ShowAlertView(@"账号格式不正确，请重新输入");
        return;
    }
    
    
    
    if (_testView.bringTestNumberTF.text.length == 0) {
        
        ShowAlertView(@"请输入验证码");
        return;
    }
    
    if (_testView.SecretNumberTF.text.length < 6) {
        
        ShowAlertView(@"新密码长度不能少于6个字符");
        return;
    }
    
    if (_testView.reSetSecretNumberTF.text.length < 6) {
        
        ShowAlertView(@"确认密码长度不能少于6个字符");
        return;
    }
    
    if (![_testView.SecretNumberTF.text isEqualToString:_testView.reSetSecretNumberTF.text]) {
        ShowAlertView(@"确认密码和新密码不一致");
        return;
    }

    
    [SVProgressHUD setMinimumDismissTimeInterval:1];
    
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    
    [SVProgressHUD show];
    WS(weakself);
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:_testView.phoneNumberTF.text forKey:@"phone"];
    [dict setObject:_testView.reSetSecretNumberTF.text forKey:@"password"];
    [dict setObject:_testView.bringTestNumberTF.text forKey:@"captcha"];
    
    
    [SVProgressHUD show];
    dispatch_queue_t queue1 = dispatch_get_main_queue();
    [HttpHelper requestMethod:@"PATCH" urlString:KRecoverPassword_url parma:dict success:^(id json) {
        [SVProgressHUD showSuccessWithStatus:@"修改成功"];
        dispatch_sync(queue1, ^{
            
            [weakself.navigationController popToRootViewControllerAnimated:YES];
            
        });
        
        
        
    } failure:^(NSError *error) {
        
        [SVProgressHUD showInfoWithStatus:@"修改失败"];
    }];
    
}

#pragma mark-判断是否为手机号
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


#pragma mark -UITextfieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    NSString *phoneStr = [_testView.phoneNumberTF.text stringByReplacingCharactersInRange:range withString:string];
    
    NSString *testStr = [_testView.bringTestNumberTF.text stringByReplacingCharactersInRange:range withString:string];
    
    NSString *secretStr = [_testView.SecretNumberTF.text stringByReplacingCharactersInRange:range withString:string];
    
    NSString *resetStr = [_testView.reSetSecretNumberTF.text stringByReplacingCharactersInRange:range withString:string];
    if (phoneStr.length > KMaxPhoneLength && range.length!=1){
        _testView.phoneNumberTF.text = [phoneStr substringToIndex:KMaxPhoneLength];
        
        return NO;
        
    }
    if (testStr.length > kMaxTestLength && range.length != 1) {
        
        _testView.bringTestNumberTF.text = [testStr substringToIndex:kMaxTestLength];
        return NO;
    }
    
    if (secretStr.length > KMaxSecretLength && range.length!=1){
        _testView.SecretNumberTF.text = [secretStr substringToIndex:KMaxSecretLength];
        
        return NO;
        
    }
    if (resetStr.length > KMaxSecretLength && range.length != 1) {
        
        _testView.reSetSecretNumberTF.text = [resetStr substringToIndex:KMaxSecretLength];
        return NO;
    }
    
    
    return YES;
}

- (void)phoneTFEditChanged:(NSNotification *)obj{
    UITextField *textField = (UITextField *)obj.object;
    
    NSString *toBeString = _testView.phoneNumberTF.text;
    NSString *lang = [[[UIApplication sharedApplication]textInputMode] primaryLanguage]; // 键盘输入模式
    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [textField markedTextRange];
        //获取高亮部分
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            if (toBeString.length > KMaxPhoneLength) {
                textField.text = [toBeString substringToIndex:KMaxPhoneLength];
            }
        }
        // 有高亮选择的字符串，则暂不对文字进行统计和限制
        else{
            
        }
    }
    // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
    else{
        if (toBeString.length > KMaxPhoneLength) {
            textField.text = [toBeString substringToIndex:KMaxPhoneLength];
        }
    }
}

- (void)testTFEditChanged:(NSNotification *)obj{
    UITextField *textField = (UITextField *)obj.object;
    
    NSString *toBeString = _testView.bringTestNumberTF.text;
    NSString *lang = [[[UIApplication sharedApplication]textInputMode] primaryLanguage]; // 键盘输入模式
    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [textField markedTextRange];
        //获取高亮部分
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            if (toBeString.length > kMaxTestLength) {
                textField.text = [toBeString substringToIndex:kMaxTestLength];
            }
        }
        // 有高亮选择的字符串，则暂不对文字进行统计和限制
        else{
            
        }
    }
    // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
    else{
        if (toBeString.length > kMaxTestLength) {
            textField.text = [toBeString substringToIndex:kMaxTestLength];
        }
    }
}

- (void)secretTFEditChanged:(NSNotification *)obj{
    UITextField *textField = (UITextField *)obj.object;
    
    NSString *toBeString = _testView.SecretNumberTF.text;
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

- (void)resetTFEditChanged:(NSNotification *)obj{
    UITextField *textField = (UITextField *)obj.object;
    
    NSString *toBeString = _testView.reSetSecretNumberTF.text;
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


-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"UITextFieldTextDidChangeNotification"
                                                 object:_testView.phoneNumberTF];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"UITextFieldTextDidChangeNotification"
                                                 object:_testView.bringTestNumberTF];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"UITextFieldTextDidChangeNotification"
                                                 object:_testView.SecretNumberTF];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"UITextFieldTextDidChangeNotification"
                                                 object:_testView.reSetSecretNumberTF];
}


#pragma mark - 验证码倒计时
- (void)countDown {
    
    __block int timeout = 60;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), 1.0 * NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(_timer, ^{
        if (timeout <= 0) {
            //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据需要自己设置
                _testView.acquireTestBtn.enabled = YES;
                NSString *downStr = [NSString stringWithFormat:@"%@", @"获取验证码"];
                [_testView.acquireTestBtn setTitle:downStr forState:UIControlStateNormal];
                [_testView.acquireTestBtn.titleLabel setFont:[UIFont systemFontOfSize:17 * kMulriple]];
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据需要自己设置
                _testView.acquireTestBtn.enabled = NO;
                NSString *downStr = [NSString stringWithFormat:@"%d%@",timeout, @"s后再次获取"];
                [_testView.acquireTestBtn setTitle:downStr forState:UIControlStateNormal];
                [_testView.acquireTestBtn.titleLabel setFont:[UIFont systemFontOfSize:13 * kMulriple]];
                timeout--;
            });
        }
        
    });
    dispatch_resume(_timer);
}

//关闭键盘
-(void)keyboardHide:(UITapGestureRecognizer *)tap{
    
    [_testView.phoneNumberTF resignFirstResponder];
    [_testView.bringTestNumberTF resignFirstResponder];
    [_testView.SecretNumberTF resignFirstResponder];
    [_testView.reSetSecretNumberTF resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
