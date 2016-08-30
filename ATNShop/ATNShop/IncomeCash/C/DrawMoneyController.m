//
//  DrawMoneyController.m
//  @的你
//
//  Created by 吴明飞 on 16/3/28.
//  Copyright © 2016年 吴明飞. All rights reserved.
//

#import "DrawMoneyController.h"
#import "ApplyCashController.h"
#import "BingDingNumberController.h"
#import "HistoryCashController.h"
#import "DrawMoneyView.h"
#import "DrawModel.h"
@interface DrawMoneyController ()
@property (nonatomic, strong) DrawMoneyView *drawView;
@property (nonatomic, strong) NSString *accountNumberString;
@property (nonatomic, strong) NSNumber *balanceString;
@property (nonatomic, strong) NSMutableArray *dataSourceArr;
@property (nonatomic, strong) NSMutableArray *dataBalanceArr;
@property (nonatomic, strong) NSNumber *bankInfoId;
@end

@implementation DrawMoneyController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barTintColor = RGB(83, 83, 83);
    
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:20], NSForegroundColorAttributeName:[UIColor whiteColor]};
    self.navigationController.navigationBar.titleTextAttributes = dic;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    [self viewDidLoad];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self customNaviBar];
    [self requestData];
    
   
    [self setupViews];
    
    
    [self requestBalanceData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestData) name:@"ChangeAccountNoSuccess" object:nil];
    
    
}

- (void)customNaviBar {
    self.title = @"收入提现";
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
    
    self.dataSourceArr = [NSMutableArray arrayWithCapacity:6];
    self.dataBalanceArr = [NSMutableArray arrayWithCapacity:8];
    self.drawView = [[DrawMoneyView alloc] initWithFrame:self.view.bounds];
    self.view = self.drawView;

    
    if ([UserModel defaultModel].accountNo.length == 0) {
        [_drawView.bingdingBtn setTitle:@"请绑定提现账号" forState:UIControlStateNormal];
        [_drawView.bingdingBtn setTitleColor:RGB(247, 139, 139) forState:UIControlStateNormal];
        _drawView.bingdingBtn.titleLabel.font = KFont;
        
        [_drawView.directApplyFirstImage removeFromSuperview];
        [_drawView.directHistorySecondImage removeFromSuperview];
        
    } else {
        [_drawView.bingdingBtn removeFromSuperview];
        [_drawView.directFirstImage removeFromSuperview];
        _drawView.bangDingLabel.text = [UserModel defaultModel].accountNo;
        _drawView.bangDingLabel.textColor = RGB(111, 111, 111);
        _drawView.bangDingLabel.textAlignment = NSTextAlignmentRight;
        [_drawView.applyCashBtn addSubview:_drawView.directApplyFirstImage];
        [_drawView.historyCashBtn addSubview:_drawView.directHistorySecondImage];
        
    }

    //绑定账号按钮
    [_drawView.accountBtn addTarget:self action:@selector(accountBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [_drawView.bingdingBtn addTarget:self action:@selector(bingdingBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    //申请提现按钮
    [_drawView.applyCashBtn addTarget:self action:@selector(applyCashBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    //历史提现按钮
    [_drawView.historyCashBtn addTarget:self action:@selector(historyCashBtnAction:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)requestBalanceData {
   
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD showWithStatus:@"加载中..."];
    [HttpHelper requestUrl:KBanlance_url success:^(id json) {
        [SVProgressHUD dismiss];
        NSDictionary *accountDic = json[@"data"][@"account"];
        DrawModel *model = [[DrawModel alloc] initWithDic:accountDic];
        NSNumber *balance = model.balance;
            
        if ([balance floatValue] > 0) {
            float money = [balance floatValue];
            _drawView.cashLabel.text = [NSString stringWithFormat:@"￥%.2f", money];
                
        } else {
                
            _drawView.cashLabel.text = @"￥0.00";
        }
        self.balanceString = balance;
        
    } failure:^(NSError *error) {
        
    }];
   
}

- (void)requestData {
    
    [HttpHelper requestUrl:KAccountNo_url success:^(id json) {
        
        
        NSDictionary *dataDic = json[@"data"];
        DrawModel *model = [[DrawModel alloc] initWithDic:dataDic];
        [UserModel defaultModel].accountNo = model.accountNo;
        self.bankInfoId = model.bankInfoId;
        
        
        
    } failure:^(NSError *error) {
        
        
    }];
    
    
}



#pragma mark -绑定提现账号按钮点击事件
- (void)accountBtnAction:(UIButton *)sender {
    
    if ([UserModel defaultModel].accountNo.length == 0) {
        BingDingNumberController *numberVC = [BingDingNumberController new];
        
        [self.navigationController pushViewController:numberVC animated:YES];
        
    } else  {
        
        
    }
}

#pragma mark -申请提现按钮点击事件
- (void)applyCashBtnAction:(UIButton *)sender {
    
    if ([UserModel defaultModel].accountNo.length == 0) {
        return;
    } else  {
        ApplyCashController *applyVC = [[ApplyCashController alloc] init];
        applyVC.applyAccount = [UserModel defaultModel].accountNo;
        applyVC.balance = self.balanceString;
        applyVC.bankInfoId = self.bankInfoId;
        [self.navigationController pushViewController:applyVC animated:YES];
    }
   
}

#pragma mark -历史提现按钮点击事件
- (void)historyCashBtnAction:(UIButton *)sender {
    
    if ([UserModel defaultModel].accountNo.length == 0) {
        return;
    } else  {
     
        HistoryCashController *cashVC = [[HistoryCashController alloc] init];
        [self.navigationController pushViewController:cashVC animated:YES];
    }
    
}

- (void)bingdingBtnAction:(UIButton *)sender {
    
    if ([UserModel defaultModel].accountNo.length == 0) {
        
        BingDingNumberController *numberVC = [BingDingNumberController new];
        [self.navigationController pushViewController:numberVC animated:YES];
    } else {
        
        return;
    }
}

//通知的方法
- (void)notificationAction:(NSNotification *)sender {
    self.accountNumberString = [sender.userInfo objectForKey:@"ACCOUNTNUMBER"];
}

//移除通知
- (void)dealloc {

    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"ChangeAccountNoSuccess" object:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
