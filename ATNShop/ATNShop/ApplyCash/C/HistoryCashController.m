//
//  HistoryCashController.m
//  ATN
//
//  Created by 吴明飞 on 16/4/28.
//  Copyright © 2016年 王赛. All rights reserved.
//

#import "HistoryCashController.h"
#import "HistoryCashCell.h"
#import "HistoryCashModel.h"

static NSInteger num = 1;

@interface HistoryCashController ()<UITableViewDataSource, UITableViewDelegate>

{
    UITableView *_tableView;
    NSMutableArray *_dataSourceArr;
}

@end

@implementation HistoryCashController

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
    _dataSourceArr = [NSMutableArray arrayWithCapacity:8];
    [self customNaviBar];
    [self setupViews];
    
    
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(requestData)];
    [_tableView.mj_header beginRefreshing];
    
    _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    
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
    
    self.title = @"历史提现";
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kWight, kHeight - 64 * kHMulriple) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    //注册cell
    [_tableView registerClass:[HistoryCashCell class] forCellReuseIdentifier:@"HistoryCashCell"];
    
}

- (void)requestData {
    
    [_dataSourceArr removeAllObjects];
    
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD showWithStatus:@"加载中..."];

    NSString *urlStr = [NSString stringWithFormat:@"/shop/cash?page=%@", @(0)];
    
    [HttpHelper requestUrl:urlStr success:^(id json) {
      
        [SVProgressHUD dismiss];
        NSDictionary *dataDic = json[@"data"];
        NSArray *contentArr = dataDic[@"content"];
        for (NSDictionary *dic in contentArr) {
                    
            HistoryCashModel *model = [[HistoryCashModel alloc] initWithDic:dic];
            [_dataSourceArr addObject:model];
        }
        [_tableView reloadData];

        if (_dataSourceArr.count < 7) {
            
            _tableView.mj_footer.hidden = YES;
        }
        [self setupTableView];
        
    } failure:^(NSError *error) {
        
    }];
    
    [_tableView.mj_header endRefreshing];
}

- (void)loadMoreData {
    
    NSString *urlStr = [NSString stringWithFormat:@"/shop/cash?page=%@", @(num)];
    
    [HttpHelper requestUrl:urlStr success:^(id json) {
        
        [SVProgressHUD dismiss];
        NSDictionary *dataDic = json[@"data"];
        NSArray *contentArr = dataDic[@"content"];
        
        if (contentArr.count == 0) {
            
            _tableView.mj_footer.hidden = YES;
        }
        for (NSDictionary *dic in contentArr) {
            
            HistoryCashModel *model = [[HistoryCashModel alloc] initWithDic:dic];
            [_dataSourceArr addObject:model];
        }
        [_tableView reloadData];
        
        
        
    } failure:^(NSError *error) {
        
    }];

    num = num + 1;
    
    [_tableView.mj_footer endRefreshing];
    
    
}

- (void)setupTableView {
    
    if (_dataSourceArr.count > 0) {
        
        _tableView.hidden = NO;
        
        
    } else if (_dataSourceArr.count == 0) {
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(98 * kMulriple, 184 * kHMulriple, 180 * kMulriple, 180 * kHMulriple)];
        imageView.image = [UIImage imageNamed:@"nosource"];
        imageView.alpha = 0.5;
        [self.view addSubview:imageView];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(210 * kMulriple, 280 * kHMulriple, 90 * kMulriple, 25 * kHMulriple)];
        label.text = @"暂无数据";
        label.textColor = RGB(111, 111, 111);
        label.font = KFont;
        
        [self.view addSubview:label];
        self.view.backgroundColor = RGB(200, 200, 200);
        
        _tableView.hidden = YES;
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSourceArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 90 * kHMulriple;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HistoryCashCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HistoryCashCell" forIndexPath:indexPath];
    HistoryCashModel *model = _dataSourceArr[indexPath.row];
    cell.model = model;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    
    return 0.001f;  // 设置为0.0001  是为了不悬浮
    
}



- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView* footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWight, 60.0)];
    
    UILabel *la = [[UILabel alloc ]init ];
    la.frame = CGRectMake(20 * kMulriple, 40*kHMulriple, kWight- 40 * kMulriple, 20 * kHMulriple);
    la.text = @"----没有更多记录了----";
    
    la.textColor = [UIColor lightGrayColor];
    la.font = [UIFont systemFontOfSize:15.f*kMulriple];
    la.textAlignment = NSTextAlignmentCenter;
    [footerView addSubview:la];
    
    return footerView;
    
}


@end
