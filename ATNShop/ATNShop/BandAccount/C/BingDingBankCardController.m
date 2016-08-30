//
//  BingDingBankCardController.m
//  @的你
//
//  Created by 吴明飞 on 16/3/25.
//  Copyright © 2016年 吴明飞. All rights reserved.
//
#define KMaxCardLength 19
#import "BingDingBankCardController.h"
#import "BangDingBankCardView.h"
@interface BingDingBankCardController ()<UITextFieldDelegate>
@property (nonatomic, strong) BangDingBankCardView *cardView;
@end

@implementation BingDingBankCardController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupViews];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cardTFEditChanged:) name:@"UITextFieldTextDidChangeNotification" object:_cardView.bankNumberTF];
}

- (void)setupViews {
    self.cardView = [[BangDingBankCardView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.cardView];
    
    [_cardView.commitBtn addTarget:self action:@selector(commitBtnAction:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)commitBtnAction:(UIButton *)sender {
    
    if (self.cardView.bankTF.text.length == 0) {
        
        ShowAlertView(@"请输入银行");
        return;
    }
    if (self.cardView.openBankTF.text.length == 0) {
        
        ShowAlertView(@"请输入开户行");
        return;
    }
    
    if (self.cardView.bankNumberTF.text.length == 0) {
        
        ShowAlertView(@"请输入银行卡号");
        return;
    }
    
    BOOL isRight = [self validateBankCardNumber:self.cardView.bankNumberTF.text];
    if (!isRight) {
        
        ShowAlertView(@"卡号错误，请重新输入卡号");
        return;
    }
    
    if (self.cardView.nameTF.text.length == 0) {
        
        ShowAlertView(@"请输入姓名");
        return;
    }
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    
    [dict setObject:@"BANK" forKey:@"type"];
    [dict setObject:_cardView.bankNumberTF.text forKey:@"accountNo"];
    [dict setObject:_cardView.bankTF.text forKey:@"bankName"];
    [dict setObject:_cardView.openBankTF.text forKey:@"depositBank"];
    [dict setObject:_cardView.nameTF.text forKey:@"userName"];
    
    WS(weakself);
    
    [SVProgressHUD showWithStatus:@"提交中"];
     
   
    [HttpHelper requestMethod:@"POST" urlStr:KBankCard_url parma:dict success:^(id json) {
       
           [SVProgressHUD showSuccessWithStatus:@"绑定成功"];
            [UserModel defaultModel].accountNo = _cardView.bankNumberTF.text;
            [weakself.navigationController popViewControllerAnimated:YES];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ChangeAccountNoSuccess" object:nil];
        
    } failure:^(NSError *error) {
        if (error) {
            
            [SVProgressHUD showInfoWithStatus:@"绑定失败"];
        }
        
    }];
    
}

//银行卡
- (BOOL) validateBankCardNumber: (NSString *)bankCardNumber
{
    BOOL flag;
    if (bankCardNumber.length <= 0) {
        flag = NO;
        return flag;
    }
    NSString *regex2 = @"^([0-9]{16}|[0-9]{19})$";
    NSPredicate *bankCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    return [bankCardPredicate evaluateWithObject:bankCardNumber];
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    NSString *cardStr = [_cardView.bankNumberTF.text stringByReplacingCharactersInRange:range withString:string];
    
    
    if (cardStr.length > KMaxCardLength && range.length!=1){
        _cardView.bankNumberTF.text = [cardStr substringToIndex:KMaxCardLength];
        
        return NO;
        
    }
   
    return YES;
}

- (void)cardTFEditChanged:(NSNotification *)obj{
    UITextField *textField = (UITextField *)obj.object;
    
    NSString *toBeString = _cardView.bankNumberTF.text;
    NSString *lang = [[[UIApplication sharedApplication]textInputMode] primaryLanguage]; // 键盘输入模式
    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [textField markedTextRange];
        //获取高亮部分
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            if (toBeString.length > KMaxCardLength) {
                textField.text = [toBeString substringToIndex:KMaxCardLength];
            }
        }
        // 有高亮选择的字符串，则暂不对文字进行统计和限制
        else{
            
        }
    }
    // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
    else{
        if (toBeString.length > KMaxCardLength) {
            textField.text = [toBeString substringToIndex:KMaxCardLength];
        }
    }
}


-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"UITextFieldTextDidChangeNotification"
                                                 object:_cardView.bankNumberTF];
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.cardView.bankNumberTF resignFirstResponder];
    [self.cardView.bankTF resignFirstResponder];
    [self.cardView.nameTF resignFirstResponder];
    [self.cardView.openBankTF resignFirstResponder];
}


@end
