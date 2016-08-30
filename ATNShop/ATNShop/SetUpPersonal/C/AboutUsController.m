//
//  AboutUsController.m
//  ATNShopDemo
//
//  Created by 吴明飞 on 16/7/8.
//  Copyright © 2016年 吴明飞. All rights reserved.
//

#import "AboutUsController.h"

@interface AboutUsController ()

@end

@implementation AboutUsController

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
}

- (void)customNaviBar {
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"arrowImage"] style:UIBarButtonItemStylePlain target:self action:@selector(handleBack:)];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    self.navigationItem.leftBarButtonItem = left;
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:20 * kMulriple], NSForegroundColorAttributeName:[UIColor whiteColor]};
    self.navigationController.navigationBar.titleTextAttributes = dic;
    self.navigationController.navigationBar.barTintColor = RGB(83, 83, 83);
}

- (void)handleBack:(UIBarButtonItem *)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setupViews {
    
    self.title = @"关于我们";
    self.view.backgroundColor = RGB(238, 238, 238);
    UIView *imageView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWight, 240 * kHMulriple)];
    
    UIImageView *logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(100 * kMulriple, 30 * kHMulriple, 125 * kMulriple, 160 * kHMulriple)];
    logoImageView.image = [UIImage imageNamed:@"aboutus"];
    
    logoImageView.centerX = imageView.width / 2;
    [imageView addSubview:logoImageView];
    [self.view addSubview:imageView];
    
    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(20 * kMulriple, 270 * kHMulriple, 335 * kMulriple, 80)];
    textLabel.text = @"艾特你是一个互联网逆向消费平台，我们的理念是让消费者日常花出去的钱再进行收益，花钱就等于在赚钱。我们涵盖线上电商购物出行旅游机票等，线下吃喝玩乐消费。";
    textLabel.textColor = RGB(111, 111, 111);
    textLabel.numberOfLines = 0;
    textLabel.font = [UIFont systemFontOfSize:17 * kMulriple];
    CGSize size = CGSizeMake(335, 666);
    CGSize requiredSize = CGSizeZero;
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:17 * kMulriple]};
    requiredSize = [textLabel.text boundingRectWithSize:size options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:dic context:nil].size;
    textLabel.frame = CGRectMake(20 * kMulriple, 270 * kHMulriple, 335 * kMulriple, requiredSize.height);
    
    [self.view addSubview:textLabel];
    
    UILabel *commitLabel = [[UILabel alloc] initWithFrame:CGRectMake(80 * kMulriple, 320 * kHMulriple + requiredSize.height, 215 * kMulriple, 30 * kHMulriple)];
    commitLabel.text = @"吃喝玩乐 @ 你消费我补贴";
    commitLabel.textColor = RGB(111, 111, 111);
    commitLabel.font = [UIFont systemFontOfSize:17 * kMulriple];
    commitLabel.centerX = self.view.width / 2;
    [self.view addSubview:commitLabel];
    
    UILabel *bottomLabel = [[UILabel alloc] initWithFrame:CGRectMake(90 * kMulriple, 545 * kHMulriple, 195 * kMulriple , 20 * kHMulriple)];
    bottomLabel.textColor = RGB(111, 111, 111);
    bottomLabel.font = [UIFont systemFontOfSize:13 * kMulriple];
    bottomLabel.text = @"copyright * 2015-2016";
    bottomLabel.textAlignment = NSTextAlignmentCenter;
    bottomLabel.centerX = self.view.width / 2;
    
    UILabel *bottomLabelOne = [[UILabel alloc] initWithFrame:CGRectMake(70 * kMulriple, 570 * kHMulriple, 235 * kMulriple , 20 * kHMulriple)];
    bottomLabelOne.textColor = RGB(111, 111, 111);
    bottomLabelOne.font = [UIFont systemFontOfSize:14 * kMulriple];
    bottomLabelOne.text = @"北京改变未来国际投资管理有限公司";
    bottomLabelOne.textAlignment = NSTextAlignmentCenter;
    bottomLabelOne.centerX = self.view.width / 2;
    
    [self.view addSubview:bottomLabelOne];
    [self.view addSubview:bottomLabel];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}


@end
