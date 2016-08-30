//
//  BingDingNumberController.m
//  @的你
//
//  Created by 吴明飞 on 16/3/25.
//  Copyright © 2016年 吴明飞. All rights reserved.
//

#import "BingDingNumberController.h"
#import "BingDingBankCardController.h"
#import "BangDingZhiFuBaoController.h"
@interface BingDingNumberController ()

@end

@implementation BingDingNumberController

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:YES];
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barTintColor = RGB(83, 83, 83);
    
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:20], NSForegroundColorAttributeName:[UIColor whiteColor]};
    self.navigationController.navigationBar.titleTextAttributes = dic;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self customNaviBar];
    self.title = @"绑定提现账号";
    self.themeColor = RGB(239, 143, 49);
    self.leftMenuTitle = @"绑定支付宝账号";
    self.rightMenuTitle = @"绑定银行卡账号";
    self.leftViewController = [BangDingZhiFuBaoController new];
    self.rightViewController = [BingDingBankCardController new];
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
