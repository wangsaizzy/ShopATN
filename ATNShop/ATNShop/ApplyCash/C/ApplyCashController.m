//
//  ApplyCashController.m
//  ATNShopDemo
//
//  Created by 吴明飞 on 16/7/18.
//  Copyright © 2016年 吴明飞. All rights reserved.
//
#define kMaxTestLength 6
#define KMaxSecretLength 20

#import "ApplyCashController.h"

#import "ApplyCashView.h"

@interface ApplyCashController ()<UIGestureRecognizerDelegate, UITextFieldDelegate>
@property (nonatomic, strong) ApplyCashView *applyView;

@end

@implementation ApplyCashController

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:YES];
    self.navigationController.navigationBarHidden = NO;
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barTintColor = RGB(83, 83, 83);
    
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:20], NSForegroundColorAttributeName:[UIColor whiteColor]};
    self.navigationController.navigationBar.titleTextAttributes = dic;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self customNaviBar];
    [self setupViews];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(secretTFEditChanged:) name:@"UITextFieldTextDidChangeNotification" object:_applyView.secretTF];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(testTFEditChanged:) name:@"UITextFieldTextDidChangeNotification" object:_applyView.testTF];
}

- (void)customNaviBar {
    
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"arrowImage"] style:UIBarButtonItemStylePlain target:self action:@selector(handleBack:)];
    self.navigationItem.leftBarButtonItem = left;
}

- (void)handleBack:(UIBarButtonItem *)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)setupViews {
    self.title = @"申请提现";
    
    self.view.backgroundColor = RGB(238, 238, 238);
    self.applyView = [[ApplyCashView alloc] initWithFrame:self.view.bounds];
    self.view = self.applyView;
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer.delegate = self;
    //将触摸事件添加到当前view
    [self.view addGestureRecognizer:tapGestureRecognizer];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(endEditing)];
    tap.delegate = self;
    [self.view addGestureRecognizer:tap];
    
    if (self.balance) {
        float money = [self.balance floatValue];
        _applyView.cashLabel.text = [NSString stringWithFormat:@"￥%.2f", money];
        _applyView.accountLabel.text = self.applyAccount;
    } else {
        
        _applyView.cashLabel.text = @"￥0.00";
        _applyView.accountLabel.text = self.applyAccount;
    }
    
    
    [_applyView.acquireBtn addTarget:self action:@selector(acquireBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [_applyView.applyCashBtn addTarget:self action:@selector(applyCashBtnAction:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)endEditing
{
    [self.view endEditing:YES];
    
}


- (void)acquireBtnAction:(UIButton *)sender {
    [SVProgressHUD setMinimumDismissTimeInterval:1];
    
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    
    WS(weakself);
    [SVProgressHUD show];
    [HttpHelper requestMethod:@"GET" urlString:KCashCaptcha_url parma:nil success:^(id json) {
        
       
        [weakself countDown];
        [SVProgressHUD showSuccessWithStatus:@"获取验证码成功"];
        
        
    } failure:^(NSError *error) {
        
        
    }];
    
}


- (void)applyCashBtnAction:(UIButton *)sender {
    
    if ([self.balance floatValue] == 0) {
        
        ShowAlertView(@"可用余额为0，无法提现");
        return;
    }
    
    if ((_applyView.cashTF.text.length == 0) || ([_applyView.cashTF.text floatValue] == 0))
    {
        
        ShowAlertView(@"请输入提现金额");
        return;
        
    }
    if ([_applyView.cashTF.text integerValue] < 10) {
        
        ShowAlertView(@"提现金额不得低于10元");
        return;
    }
    
    if ([_applyView.cashTF.text floatValue] > [self.balance floatValue]) {
        
        ShowAlertView(@"申请金额不可大于可提金额");
        return;
    }
    
    
    
    if (_applyView.secretTF.text.length == 0) {
        
        ShowAlertView(@"登录密码不能为空");
        return;
    }
    
    if (_applyView.secretTF.text.length < 6) {
        
        ShowAlertView(@"密码长度不能小于6位");
        return;
    }
    
    if (_applyView.secretTF.text.length > 20) {
        
        ShowAlertView(@"密码长度不能多于20位");
        return;
    }

    
    if (_applyView.testTF.text.length == 0) {
        
        ShowAlertView(@"验证码不能为空");
        return;
    }
    
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    
    [dict setObject:_applyView.cashTF.text forKey:@"amount"];
    [dict setObject:_applyView.secretTF.text forKey:@"password"];
    [dict setObject:self.bankInfoId forKey:@"bankInfoId"];
    [dict setObject:_applyView.testTF.text forKey:@"captcha"];
    
    
    WS(weakself);
    [HttpHelper requestMethod:@"POST" urlStr:KApplyCash_url parma:dict success:^(id json) {
        
        [SVProgressHUD showSuccessWithStatus:@"提现成功"];
        [weakself.navigationController popViewControllerAnimated:YES];
        
    } failure:^(NSError *error) {
        
        [SVProgressHUD showInfoWithStatus:@"提现失败"];
    }];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    NSString *secretStr = [self.applyView.secretTF.text stringByReplacingCharactersInRange:range withString:string];
    
    NSString *testStr = [self.applyView.testTF.text stringByReplacingCharactersInRange:range withString:string];
    if (secretStr.length > KMaxSecretLength && range.length!=1){
        self.applyView.secretTF.text = [secretStr substringToIndex:KMaxSecretLength];
        
        return NO;
        
    }
    if (testStr.length > kMaxTestLength && range.length != 1) {
        
        self.applyView.testTF.text = [secretStr substringToIndex:kMaxTestLength];
        return NO;
    }
    return YES;
}

- (void)secretTFEditChanged:(NSNotification *)obj{
    UITextField *textField = (UITextField *)obj.object;
    
    NSString *toBeString = self.applyView.secretTF.text;
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

- (void)testTFEditChanged:(NSNotification *)obj{
    UITextField *textField = (UITextField *)obj.object;
    
    NSString *toBeString = self.applyView.testTF.text;
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


-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"UITextFieldTextDidChangeNotification"
                                                 object:_applyView.secretTF];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"UITextFieldTextDidChangeNotification"
                                                 object:_applyView.testTF];
}



- (void)countDown {
    WS(weakself);
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
                weakself.applyView.acquireBtn.enabled = YES;
                NSString *downStr = [NSString stringWithFormat:@"%@", @"获取验证码"];
                [weakself.applyView.acquireBtn setTitle:downStr forState:UIControlStateNormal];
                [weakself.applyView.acquireBtn.titleLabel setFont:[UIFont systemFontOfSize:17 * kMulriple]];
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据需要自己设置
                weakself.applyView.acquireBtn.enabled = NO;
                NSString *downStr = [NSString stringWithFormat:@"%d%@",timeout, @"s后再次获取"];
                [weakself.applyView.acquireBtn setTitle:downStr forState:UIControlStateNormal];
                [weakself.applyView.acquireBtn.titleLabel setFont:[UIFont systemFontOfSize:13 * kMulriple]];
                timeout--;
            });
        }
        
    });
    dispatch_resume(_timer);
}

-(void)keyboardHide:(UITapGestureRecognizer *)tap{
    [self.applyView.cashTF resignFirstResponder];
    [self.applyView.secretTF resignFirstResponder];
    [self.applyView.testTF resignFirstResponder];
    
}

//DropDownMenu *menu = (DropDownMenu *)[self.view viewWithTag:1001];

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
