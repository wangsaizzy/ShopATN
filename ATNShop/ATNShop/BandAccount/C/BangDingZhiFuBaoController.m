//
//  BangDingZhiFuBaoController.m
//  @的你
//
//  Created by 吴明飞 on 16/3/25.
//  Copyright © 2016年 吴明飞. All rights reserved.
//
#define KMaxAccountLength 32
#define kMaxNameLength 4
#import "BangDingZhiFuBaoController.h"
#import "DrawMoneyController.h"
#import "BangDingZhiFuBaoView.h"
@interface BangDingZhiFuBaoController ()<UITextFieldDelegate>
@property (nonatomic, strong) BangDingZhiFuBaoView *bangDingView;
@end

@implementation BangDingZhiFuBaoController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    //设置导航控制器不隐藏
    self.navigationController.navigationBarHidden = NO;
    //关闭毛玻璃效果
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barTintColor = RGB(83, 83, 83);
    
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:20], NSForegroundColorAttributeName:[UIColor whiteColor]};
    self.navigationController.navigationBar.titleTextAttributes = dic;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //自定义视图
    [self setupViews];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(accountTFEditChanged:) name:@"UITextFieldTextDidChangeNotification" object:_bangDingView.accountNumberTF];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(nameTFEditChanged:) name:@"UITextFieldTextDidChangeNotification" object:_bangDingView.nameTF];
}

- (void)setupViews {
    self.bangDingView = [[BangDingZhiFuBaoView alloc] initWithFrame:self.view.bounds];
    self.bangDingView.backgroundColor = RGB(237, 237, 237);
    
    //添加点击事件
    [self.bangDingView.commitBtn addTarget:self action:@selector(commitBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    
    self.view = self.bangDingView;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:YES];
    NSString *accountNumberStr = self.bangDingView.accountNumberTF.text;
    //添加通知传值
    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:accountNumberStr forKey:@"ACCOUNTNUMBER"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"accountNumber" object:self userInfo:userInfo];
}

#pragma mark -提交按钮
- (void)commitBtnAction:(UIButton *)sender {

  
    
    if (self.bangDingView.accountNumberTF.text.length == 0) {
        
        ShowAlertView(@"请输入支付宝账号");
        return;
    }
    if (self.bangDingView.nameTF.text.length == 0) {
        
        ShowAlertView(@"请输入姓名");
        return;
    }
    
    
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    
    [dict setObject:@"ALI" forKey:@"type"];
    [dict setObject:_bangDingView.accountNumberTF.text forKey:@"accountNo"];
    [dict setObject:_bangDingView.nameTF.text forKey:@"userName"];
    
        WS(weakself);
    
    [SVProgressHUD showWithStatus:@"绑定中"];
    [HttpHelper requestMethod:@"POST" urlStr:KBindALIPay_url parma:dict success:^(id json) {
        
       [weakself.navigationController popViewControllerAnimated:YES];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ChangeAccountNoSuccess" object:nil];
        

       [SVProgressHUD showSuccessWithStatus:@"绑定成功"];
        [UserModel defaultModel].accountNo = _bangDingView.accountNumberTF.text;
                
        
    } failure:^(NSError *error) {if (error) {
        
        [SVProgressHUD showInfoWithStatus:@"绑定失败"];
    }

    }];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    NSString *accountStr = [_bangDingView.accountNumberTF.text stringByReplacingCharactersInRange:range withString:string];
    
    NSString *nameStr = [_bangDingView.nameTF.text stringByReplacingCharactersInRange:range withString:string];
    if (accountStr.length > KMaxAccountLength && range.length!=1){
        _bangDingView.accountNumberTF.text = [accountStr substringToIndex:KMaxAccountLength];
        
        return NO;
        
    }
    if (nameStr.length > kMaxNameLength && range.length != 1) {
        
        _bangDingView.nameTF.text = [nameStr substringToIndex:kMaxNameLength];
        return NO;
    }
    return YES;
}

- (void)nameTFEditChanged:(NSNotification *)obj{
    UITextField *textField = (UITextField *)obj.object;
    
    NSString *toBeString = _bangDingView.nameTF.text;
    NSString *lang = [[[UIApplication sharedApplication]textInputMode] primaryLanguage]; // 键盘输入模式
    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [textField markedTextRange];
        //获取高亮部分
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            if (toBeString.length > kMaxNameLength) {
                textField.text = [toBeString substringToIndex:kMaxNameLength];
            }
        }
        // 有高亮选择的字符串，则暂不对文字进行统计和限制
        else{
            
        }
    }
    // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
    else{
        if (toBeString.length > kMaxNameLength) {
            textField.text = [toBeString substringToIndex:kMaxNameLength];
        }
    }
}

- (void)accountTFEditChanged:(NSNotification *)obj{
    UITextField *textField = (UITextField *)obj.object;
    
    NSString *toBeString = _bangDingView.accountNumberTF.text;
    NSString *lang = [[[UIApplication sharedApplication]textInputMode] primaryLanguage]; // 键盘输入模式
    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [textField markedTextRange];
        //获取高亮部分
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            if (toBeString.length > KMaxAccountLength) {
                textField.text = [toBeString substringToIndex:KMaxAccountLength];
            }
        }
        // 有高亮选择的字符串，则暂不对文字进行统计和限制
        else{
            
        }
    }
    // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
    else{
        if (toBeString.length > KMaxAccountLength) {
            textField.text = [toBeString substringToIndex:KMaxAccountLength];
        }
    }
}


-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"UITextFieldTextDidChangeNotification"
                                                 object:_bangDingView.accountNumberTF];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"UITextFieldTextDidChangeNotification"
                                                 object:_bangDingView.nameTF];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.bangDingView.accountNumberTF resignFirstResponder];
    [self.bangDingView.nameTF resignFirstResponder];
    
}


@end
