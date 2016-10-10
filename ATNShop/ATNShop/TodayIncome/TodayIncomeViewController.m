//
//  TodayIncomeViewController.m
//  ATNShop
//
//  Created by 王赛 on 16/10/10.
//  Copyright © 2016年 王赛. All rights reserved.
//

#import "TodayIncomeViewController.h"
#import "TodayIncomeCell.h"
#import "TodayIncomeModel.h"

@interface TodayIncomeViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic ,strong) UITableView *tableView;
@property (nonatomic ,strong) NSMutableArray *orderListArray;

@end

@implementation TodayIncomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.orderListArray = [NSMutableArray arrayWithCapacity:8];
    
    
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBarHidden = NO;
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barTintColor = RGB(83, 83, 83);
    
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:20], NSForegroundColorAttributeName:[UIColor whiteColor]};
    self.navigationController.navigationBar.titleTextAttributes = dic;
    
    [self customNaviBar];
    [self setupViews];
    [self requestData];
}

- (void)customNaviBar {
    
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:20 * kMulriple], NSForegroundColorAttributeName:[UIColor whiteColor]};
    self.navigationController.navigationBar.titleTextAttributes = dic;
    self.navigationController.navigationBar.barTintColor = RGB(83, 83, 83);
    
    /**
     改变nav push 到下一级颜色
     */
    //    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    //    backItem.title = @"XX";
    //    self.navigationItem.backBarButtonItem = backItem;
//    [self.navigationController.navigationBar setTintColor:[UIColor darkGrayColor]];
    
}

- (void)setupViews {
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0 , 0, kWight , kHeight) style:UITableViewStyleGrouped];
    //设置数据源和代理
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    _tableView.separatorStyle = NO;//隐藏分割线
    [self.view addSubview:_tableView];
    
    
    //注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"TodayIncomeCell" bundle:nil] forCellReuseIdentifier:@"TodayIncomeCell.h"];
}

- (void)requestData {
  /*
    [_orderListArray removeAllObjects];
    
    NSString *dateString = [self currentDateStr];
    
    NSString *subString = [dateString substringWithRange:NSMakeRange(8, 2)];
    
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD showWithStatus:@"加载中"];
    WS(weakself);
    
    NSString *urlStr = [NSString stringWithFormat:@"/user/appointment?page=%@", @(0)];
    
    [HttpHelper requestUrl:urlStr success:^(id json) {
        
        [SVProgressHUD dismiss];
        [weakself parseListDict:json subString:subString];
        
    } failure:^(NSError *error) {
        
    }];
   */ 
}

- (NSString *)currentDateStr {
    
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

- (void)parseListDict:(NSDictionary *)dict subString:(NSString *)subString {
    
    
    NSDictionary *dataDic = dict[@"data"];
    NSArray *contentArr = dataDic[@"content"];
   
    for (NSDictionary *dic in contentArr) {
        
        TodayIncomeModel *model = [[TodayIncomeModel alloc] initWithDic:dic];
        
        
        
        
        //获取时间戳
        NSTimeInterval _interval=[model.createtime doubleValue] / 1000.0;
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:_interval];
        NSDateFormatter *objDateformat = [[NSDateFormatter alloc] init];
        [objDateformat setDateFormat:@"yyyy-MM-dd"];
        NSString *dateString = [objDateformat stringFromDate:date];
        
        
        NSString *dayString = [dateString substringWithRange:NSMakeRange(8, 2)];
        
        if ([dayString isEqualToString:subString]) {
            
            [_orderListArray addObject:model];
        }
    }
    
    [_tableView reloadData];
    
    if (_orderListArray.count == 0) {
        
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



#pragma mark ---- tableView datasource

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    
    
    
    return 0.000001f;  // 设置为0.0001  是为了不悬浮
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.orderListArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TodayIncomeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TodayIncomeCell"];
    
    /**
     *   配置Cell
     */
    TodayIncomeModel *model = self.orderListArray[indexPath.row];
    
    cell.incomemodel = model;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

#pragma mark --行高
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.00001f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90 *kHMulriple;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    
    
    
    UIView* footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWight   , 70.0)];
    
    UILabel *la = [[UILabel alloc ]init ];
    la.frame = CGRectMake(0, 0*kMulriple, kWight- 0 , 60);
    la.text = @"----没有更多记录了----";
    la.textColor = [UIColor lightGrayColor];
    la.font = [UIFont systemFontOfSize:15.f*kMulriple];
    la.backgroundColor  = [UIColor whiteColor];
    la.textAlignment = NSTextAlignmentCenter;
    
    
    la.layer.cornerRadius = 10.f*kMulriple;
    la.layer.masksToBounds = YES;
    
    [footerView addSubview:la];
    
    return footerView;
    
}




#pragma mark --选中行
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
