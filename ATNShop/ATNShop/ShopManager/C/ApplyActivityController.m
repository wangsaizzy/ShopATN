//
//  ApplyActivityController.m
//  ATNShopDemo
//
//  Created by 吴明飞 on 16/7/7.
//  Copyright © 2016年 吴明飞. All rights reserved.
//
#define kMaxLength 6
#import "ApplyActivityController.h"
#import "ApplyActivityView.h"
#import "DropDownMenuView.h"
@interface ApplyActivityController ()<UITextFieldDelegate>

@property (nonatomic, strong) ApplyActivityView *applyView;

@end

@implementation ApplyActivityController
{
    
    DropDownMenuView *_menuView;
    
    UIView *_darkView;
    
    NSArray *_timeArr;
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    self.navigationController.navigationBar.translucent = NO;
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
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFiledEditChanged:) name:@"UITextFieldTextDidChangeNotification" object:_applyView.rateTF];
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


- (void)setupViews {
    self.title = @"申请活动";
    self.applyView = [[ApplyActivityView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.applyView];
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapGesture)];
    singleTap.numberOfTapsRequired = 1;
    [self.darkView addGestureRecognizer:singleTap];
    _timeArr = @[@"一天", @"三天", @"一周", @"两周", @"三周", @"一个月"];
    
    [_applyView.chooseTimeBtn addTarget:self action:@selector(chooseTimeBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [_applyView.commitBtn addTarget:self action:@selector(commitBtnAction:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)handleSingleTapGesture{
    [_darkView removeFromSuperview];
    [_menuView removeFromSuperview];
}

- (void)chooseTimeBtnAction:(UIButton *)sender {
    
    [UIView animateWithDuration:0.3 animations:^{
        
        [_applyView addSubview:_darkView];
        _menuView = [[DropDownMenuView alloc] initWithFrame:CGRectMake(150 * kMulriple, 119 * kHMulriple, 210 * kMulriple, 260 * kHMulriple)];
        
        _menuView.layer.cornerRadius = 10 * kMulriple;
        _menuView.layer.masksToBounds = YES;
        [_applyView addSubview:_menuView];
        _menuView.dataSource = _timeArr;
    }];
    
    
    __weak typeof(self)weakSelf = self;
    [_menuView setFinishBlock:^(NSString *title){
        weakSelf.applyView.timeLabel.text = title;
        [weakSelf handleSingleTapGesture];
    }];

}

- (UIView *)darkView{
    if (!_darkView) {
        _darkView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, kHeight)];
        _darkView.backgroundColor = [UIColor colorWithWhite:.7 alpha:.3];
        _darkView.userInteractionEnabled = YES;
    }
    return _darkView;
}


- (void)commitBtnAction:(UIButton *)sender {
    
    if (_applyView.rateTF.text.length == 0) {
        ShowAlertView(@"请输入折扣");
        return;
    }
    if (_applyView.timeLabel.text.length == 0) {
        ShowAlertView(@"请选择时间");
        return;
    }
    
    
   
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:_applyView.rateTF.text forKey:@"backRate"];
    [dict setObject:_applyView.timeLabel.text forKey:@"cycle"];
    WS(weakself);
    
    [HttpHelper requestMethod:@"POST" urlStr:KActivity_apply_url parma:dict success:^(id json) {
        
            
            [SVProgressHUD showSuccessWithStatus:@"申请成功"];
            [weakself.navigationController popToRootViewControllerAnimated:YES];
        

    
    } failure:^(NSError *error) {
        
    }];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    if ([self isViewLoaded] && !self.view.window) {
        self.view = nil;
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    
    if (toBeString.length > kMaxLength && range.length!=1){
        textField.text = [toBeString substringToIndex:kMaxLength];
        
        return NO;
    
    }
    return YES;
}

-(void)textFiledEditChanged:(NSNotification *)obj{
    UITextField *textField = (UITextField *)obj.object;
    
    NSString *toBeString = textField.text;
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
                                                 object:_applyView.rateTF];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.applyView.rateTF resignFirstResponder];
    
}
@end
