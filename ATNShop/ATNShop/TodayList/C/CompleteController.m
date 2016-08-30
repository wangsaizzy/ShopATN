//
//  CompleteController.m
//  @你
//
//  Created by 吴明飞 on 16/5/16.
//  Copyright © 2016年 王赛. All rights reserved.
//

#import "CompleteController.h"
#import "ListDetailController.h"
#import "CompleteViewCell.h"
#import "CompleteModel.h"

static NSInteger num = 1;

@interface CompleteController ()<UITableViewDataSource, UITableViewDelegate>

{
    UITableView *_tableView;
    NSMutableArray *_dataSource;
}

@end

@implementation CompleteController


- (void)viewDidLoad {
    [super viewDidLoad];
    _dataSource = [NSMutableArray arrayWithCapacity:8];
    [self setupViews];
    
    
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(requestData)];
    [_tableView.mj_header beginRefreshing];
    

    _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
}


- (void)setupViews {
    self.view.backgroundColor = RGB(238, 238, 238);
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kWight, kHeight - 118 * kHMulriple) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    //注册cell
    [_tableView registerClass:[CompleteViewCell class] forCellReuseIdentifier:@"CompleteViewCell"];
    
}

- (void)requestData {
    
    [self readData];
    
    if (_dataSource.count > 0) {
        [_tableView reloadData];
        [_tableView.mj_header endRefreshing];
        return;
    }

    [_dataSource removeAllObjects];
    

    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:@"SUCCESS" forKey:@"orderStatus"];
    [dict setObject:@"OFFLINE" forKey:@"orderType"];
    
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD showWithStatus:@"加载中..."];
   
    
    NSString *urlStr = [NSString stringWithFormat:@"/shop/order?page=%@", @(0)];
    
    [HttpHelper requestMethod:@"GET" urlString:urlStr parma:dict success:^(id json) {
        
        
        
        
        [SVProgressHUD dismiss];
        NSDictionary *dataDic = json[@"data"];
        NSArray *contentArr = dataDic[@"content"];
        for (NSDictionary *dic in contentArr) {
                    
        CompleteModel *model = [[CompleteModel alloc] initWithDic:dic];
                    
        [_dataSource addObject:model];
                }
        [_tableView reloadData];
                
        if (_dataSource.count < 7) {
                    
            _tableView.mj_footer.hidden = YES;
        }
                
        [self setupTableView];
        
            
        
    } failure:^(NSError *error) {
        
    }];
    
    [_tableView.mj_header endRefreshing];
    
    [self saveData];
}


- (void)loadMoreData {
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:@"SUCCESS" forKey:@"orderStatus"];
    [dict setObject:@"OFFLINE" forKey:@"orderType"];
    
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD showWithStatus:@"加载中..."];
    
    
    NSString *urlStr = [NSString stringWithFormat:@"/shop/order?page=%@", @(num)];
    
    [HttpHelper requestMethod:@"GET" urlString:urlStr parma:dict success:^(id json) {
        
        
        
        [SVProgressHUD dismiss];
        
        NSDictionary *dataDic = json[@"data"];
        NSArray *contentArr = dataDic[@"content"];
        
        if (contentArr.count == 0) {
            [_tableView.mj_footer endRefreshingWithNoMoreData];
            _tableView.mj_footer.hidden = YES;
        }
        for (NSDictionary *dic in contentArr) {
                
            CompleteModel *model = [[CompleteModel alloc] initWithDic:dic];
                
            [_dataSource addObject:model];
        }
        [_tableView reloadData];
            
            
        
    } failure:^(NSError *error) {
        
    }];
    
    num = num + 1;
    
    [_tableView.mj_footer endRefreshing];
    

}


- (void)setupTableView {
    
    if (_dataSource.count > 0) {
        
        _tableView.hidden = NO;
        
        
    } else if (_dataSource.count == 0) {
        
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

- (void)saveData {
    
    NSMutableArray *dataSource = [NSMutableArray array];
    for (CompleteModel *model in _dataSource) {
        [_dataSource addObject:model];
    }
    
    NSDictionary *dic = @{@"dataSource":dataSource};
    
    [ShopListCache setObjectOfDic:dic key:@"dataSource"];
}

- (void)readData {
    
    NSDictionary *dict = [ShopListCache selectCacheDicForKey:@"dataSourceArray"];
    if (dict == nil) {
        //没有缓存
        return;
    }
    NSMutableArray *dataSource = [NSMutableArray array];
    dataSource = [dict objectForKey:@"dataSource"];
    for (NSDictionary *dic in dataSource) {
        
        CompleteModel *model = [[CompleteModel alloc] initWithDic:dic];
        [_dataSource addObject:model];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 75 * kHMulriple;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    if (!cell) {
        cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    }
    
    CompleteViewCell *completeCell = [tableView dequeueReusableCellWithIdentifier:@"CompleteViewCell" forIndexPath:indexPath];
    CompleteModel *model = _dataSource[indexPath.row];
    completeCell.completeModel = model;
    completeCell.selectionStyle = UITableViewCellSelectionStyleNone;
    return completeCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CompleteModel *model = _dataSource[indexPath.row];
    ListDetailController *listVC = [[ListDetailController alloc] init];
    listVC.orderNo = model.orderNo;
    [self.navigationController pushViewController:listVC animated:YES];
    
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


- (void)dealloc {
    
    num = 1;
}

@end
