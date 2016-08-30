//
//  CaiWuDuiZhangController.m
//  ATN
//
//  Created by 吴明飞 on 16/4/27.
//  Copyright © 2016年 王赛. All rights reserved.
//

#import "CaiWuDuiZhangController.h"
#import "CaiWuDuiZhangCell.h"
#import "ListDetailController.h"
#import "CaiWuModel.h"

static NSInteger num = 1;

@interface CaiWuDuiZhangController ()<UITableViewDataSource, UITableViewDelegate>

{
    UITableView *_tableView;
    NSMutableArray *_dataSourceArray;
    
    NSMutableArray *_firstDataArr;
    NSMutableArray *_secondDataArr;
    NSMutableArray *_thirdDataArr;
    NSArray *_sortedMonthArr;
    
    NSDictionary *_dataDic;
    NSString *_currentMonthStr;
    NSString *_dataMonthStr;
}

@end

@implementation CaiWuDuiZhangController

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:YES];
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barTintColor = RGB(83, 83, 83);
    
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:20], NSForegroundColorAttributeName:[UIColor whiteColor]};
    self.navigationController.navigationBar.titleTextAttributes = dic;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataSourceArray = [NSMutableArray arrayWithCapacity:8];
    _firstDataArr = [NSMutableArray array];
    _secondDataArr = [NSMutableArray array];
    _thirdDataArr = [NSMutableArray array];
    [self customNaviBar];
    [self setupViews];
    
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(requestData)];
    [_tableView.mj_header beginRefreshing];
    
    
    
    _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
}

- (void)setupViews {
    
    self.title = @"财务对账";
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - 64 * kHMulriple) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView]
    ;
    
    //注册cell
    [_tableView registerClass:[CaiWuDuiZhangCell class] forCellReuseIdentifier:@"CaiWuDuiZhangCell"];
    
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


- (void)requestData {
    
    
    NSString *dateString = [self dateString];
    NSString *subString = [dateString substringWithRange:NSMakeRange(5, 2)];
    if ([subString integerValue] > 9) {
        
        _currentMonthStr = subString;
    } else {
        
        _currentMonthStr = [dateString substringWithRange:NSMakeRange(6, 1)];
    }
    
    
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:@"SUCCESS" forKey:@"orderStatus"];
    [dict setObject:@"OFFLINE" forKey:@"orderType"];

    
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD showWithStatus:@"加载中..."];
    
    
    WS(weakself);
     NSString *urlStr = [NSString stringWithFormat:@"/shop/order?page=%@", @(0)];
    
    [HttpHelper requestMethod:@"GET" urlString:urlStr parma:dict success:^(id json) {
        
        [SVProgressHUD dismiss];
        
        [weakself parseListDict:json subString:subString];
            
        
    } failure:^(NSError *error) {
        
    }];
   
    [_tableView.mj_header endRefreshing];
   
    
}

- (void)parseListDict:(NSDictionary *)dict subString:(NSString *)subString {
    NSInteger a = [_currentMonthStr integerValue];
   
    NSDictionary *dataDic = dict[@"data"];
    NSArray *contentArr = dataDic[@"content"];
    
    if (contentArr.count == 0) {
        
        _tableView.mj_footer.hidden = YES;
    }
    for (NSDictionary *dic in contentArr) {
        
        CaiWuModel *model = [[CaiWuModel alloc] initWithDic:dic];
        
        
        //获取时间戳
        NSTimeInterval _interval=[model.updatetime doubleValue] / 1000.0;
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:_interval];
        NSDateFormatter *objDateformat = [[NSDateFormatter alloc] init];
        [objDateformat setDateFormat:@"yyyy-MM-dd"];
        NSString *dateString = [objDateformat stringFromDate:date];
        NSString *monthString = [dateString substringWithRange:NSMakeRange(5, 2)];
        
        if ([monthString integerValue] > 9) {
            
            _dataMonthStr = subString;
        } else {
            
            _dataMonthStr = [dateString substringWithRange:NSMakeRange(6, 1)];
        }
        
        
        NSInteger b = [_dataMonthStr integerValue];
        
        if (a == b) {
            
            [_dataSourceArray addObject:model];
        } else if (b == a - 1) {
            
            [_firstDataArr addObject:model];
        } else if (b == a - 2) {
            
            [_secondDataArr addObject:model];
        } else if (b == a - 3) {
            
            [_thirdDataArr addObject:model];
        }
    }
        
    NSString *firstStr = [NSString stringWithFormat:@"%ld", a - 1];
    NSString *secondStr = [NSString stringWithFormat:@"%ld", a - 2];
    NSString *thirdStr = [NSString stringWithFormat:@"%ld", a - 3];
    
    
    
    if (_firstDataArr.count == 0 && _secondDataArr.count == 0 && _thirdDataArr.count == 0) {
        
        
        _dataDic = @{_currentMonthStr:_dataSourceArray};
    } else if (_firstDataArr && _secondDataArr.count == 0 && _thirdDataArr.count == 0) {
        
        _dataDic = @{_currentMonthStr:_dataSourceArray, firstStr:_firstDataArr};
    }
    else if (_firstDataArr && _secondDataArr && _thirdDataArr.count == 0) {
        
        _dataDic = @{_currentMonthStr:_dataSourceArray, firstStr:_firstDataArr, secondStr:_secondDataArr};
    } else if (_firstDataArr && _secondDataArr && _thirdDataArr) {
        
        _dataDic = @{_currentMonthStr:_dataSourceArray, firstStr:_firstDataArr, secondStr:_secondDataArr, thirdStr:_thirdDataArr};
    }
    
    
    //对数组进行降序排序
    NSSortDescriptor *sd1 = [NSSortDescriptor sortDescriptorWithKey:nil ascending:NO];
    _sortedMonthArr = [[_dataDic allKeys] sortedArrayUsingDescriptors:[NSArray arrayWithObjects:sd1, nil]];
    
    
    
    [_tableView reloadData];
    
    [self setupTableView];
    
}

- (void)loadMoreData {
    
    NSString *dateString = [self dateString];
    
    NSString *subString = [dateString substringWithRange:NSMakeRange(5, 2)];
    if ([subString integerValue] > 9) {
        
        _currentMonthStr = subString;
    } else {
        
        _currentMonthStr = [dateString substringWithRange:NSMakeRange(6, 1)];
    }
    
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    
    [dict setObject:@"SUCCESS" forKey:@"orderStatus"];
    [dict setObject:@"OFFLINE" forKey:@"orderType"];
    
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD showWithStatus:@"加载中"];
    
    WS(weakself);
    
    
    NSString *urlStr = [NSString stringWithFormat:@"/shop/order?page=%@", @(num)];
    
    
    [HttpHelper requestMethod:@"GET" urlString:urlStr parma:dict success:^(id json) {
        
        
        [SVProgressHUD dismiss];
        
        [weakself parseListDict:json subString:subString];
            
        
    } failure:^(NSError *error) {
        
        
    }];
    
     [_tableView.mj_footer endRefreshing];
    num = num + 1;
    
   

}



- (NSString *)dateString {
    
    NSTimeZone *gmt = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier: NSCalendarIdentifierGregorian];
    [calendar setTimeZone:gmt];
    NSDate *date = [NSDate date];
    NSDateComponents *components = [calendar components:NSUIntegerMax fromDate:date];
    components.day-=1;
    [components setHour: 0];
    
    [components setMinute:0];
    
    [components setSecond: 0];
    
    NSDate *startDate = [calendar dateFromComponents:components];
    NSDate *endDate = [calendar dateByAddingUnit:NSCalendarUnitDay value:1 toDate:startDate options:0];
    NSDateFormatter *objDateformat = [[NSDateFormatter alloc] init];
    [objDateformat setDateFormat:@"yyyy-MM-dd HH:mm"];
    
    NSString *dateString = [objDateformat stringFromDate:endDate];
    
    return dateString;

}


- (void)setupTableView {
    
    if (_dataSourceArray.count > 0 || _firstDataArr.count > 0 || _secondDataArr.count > 0 || _thirdDataArr.count > 0) {
        
        _tableView.hidden = NO;
        
        
    } else {
        
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
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
   
    return _dataDic.count;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40 * kHMulriple;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSString *key = _sortedMonthArr[section];
    return [_dataDic[key] count];
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

    
    CaiWuDuiZhangCell *caicell = [tableView dequeueReusableCellWithIdentifier:@"CaiWuDuiZhangCell" forIndexPath:indexPath];
    
    NSString *key = _sortedMonthArr[indexPath.section];
    
    NSArray *group = _dataDic[key];
    
    CaiWuModel *model = group[indexPath.row];
    caicell.model = model;
    caicell.selectionStyle = UITableViewCellSelectionStyleNone;
     
    return caicell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *key = _sortedMonthArr[indexPath.section];
    NSArray *group = _dataDic[key];
    CaiWuModel *model = group[indexPath.row];
    ListDetailController *listVC = [[ListDetailController alloc] init];
    listVC.orderNo = model.orderNo;
    [self.navigationController pushViewController:listVC animated:YES];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView* customView = [[UIView alloc] initWithFrame:CGRectMake(0, 0.0, kWight, 30.0*kMulriple)];
    
    customView.backgroundColor = RGB(238, 238, 238);
    
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(15*kMulriple, 10*kMulriple, 80*kMulriple, 20*kMulriple)];
    switch (section) {
        case 0:
        {
            lab.frame = CGRectMake(15*kMulriple, 20*kMulriple, 80*kMulriple, 10*kMulriple);
            lab.text = @"本月";
        }
            break;
            
        case 1:
        {
            lab.text = [NSString stringWithFormat:@"%@月", _sortedMonthArr[section]];
        }
            break;
        case 2:
        {
            lab.text = [NSString stringWithFormat:@"%@月", _sortedMonthArr[section]];
        }
            break;
        case 3:
        {
            lab.text = [NSString stringWithFormat:@"%@月", _sortedMonthArr[section]];
        }
            break;
            
        default:
            break;
    }
    lab.textColor = RGB(111, 111, 111);
    lab.font = [UIFont fontWithName:@"STHeiciSC-Light" size:7*kMulriple];
    
    
    [customView addSubview:lab];
    return customView;
}



- (void)dealloc {
    
    _dataSourceArray = nil;
    _firstDataArr = nil;
    _secondDataArr = nil;
    _thirdDataArr = nil;
    num = 1;
}


@end
