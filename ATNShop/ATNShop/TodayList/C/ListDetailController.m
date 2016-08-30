//
//  ListDetailController.m
//  ATN
//
//  Created by 吴明飞 on 16/4/27.
//  Copyright © 2016年 王赛. All rights reserved.
//

#import "ListDetailController.h"
#import "ListDetailView.h"
#import "ListDetailModel.h"
@interface ListDetailController ()
{
    ListDetailView *_listView;
}
@end

@implementation ListDetailController

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:YES];
    self.navigationController.navigationBarHidden = NO;
    self.tabBarController.tabBar.hidden = YES;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self customNaviBar];
    [self setupViews];
    [self requestData];
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
    self.title = @"订单详情";
    _listView = [[ListDetailView alloc] initWithFrame:self.view.bounds];
    self.view = _listView;
    
}

- (void)requestData {
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    NSString *urlString =[NSString stringWithFormat:@"/shop/order/%@", self.orderNo];
    [SVProgressHUD showWithStatus:@"加载中..."];
    
    [HttpHelper requestUrl:urlString success:^(id json) {
        [SVProgressHUD dismiss];
    
        
        NSDictionary *dataDic = json[@"data"];
        ListDetailModel *model = [[ListDetailModel alloc] initWithDic:dataDic];
        [_listView.headImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", Service_Url, model.portrait]] placeholderImage:[UIImage imageNamed:@"userImage"]];
        _listView.nameLabel.text = model.name;
        _listView.phoneLabel.text = model.phone;
        _listView.priceLabel.text = [NSString stringWithFormat:@"￥%@", model.amount];
                
                
        
            float cash = [model.amount floatValue] - [model.backAmount floatValue];
            _listView.totalLabel.text = [NSString stringWithFormat:@"合计: ￥%@(实入￥ %.2f)", model.amount, cash];
        
                
        NSTimeInterval _interval=[model.updatetime doubleValue] / 1000.0;
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:_interval];
        NSDateFormatter *objDateformat = [[NSDateFormatter alloc] init];
        [objDateformat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *dateString = [objDateformat stringFromDate:date];
        _listView.timeLabel.text = dateString;
        _listView.listNumLabel.text = model.orderNo;
        _listView.consumeLabel.text = @"线下消费";
                
    } failure:^(NSError *error) {
        
    }];

}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
