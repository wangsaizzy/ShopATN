//
//  UserCommentController.m
//  @的你
//
//  Created by 吴明飞 on 16/3/31.
//  Copyright © 2016年 吴明飞. All rights reserved.
//

#import "UserCommentController.h"
#import "UserCommentCell.h"
#import "CommentModel.h"
#import "CommentCell.h"

static NSInteger num = 1;

@interface UserCommentController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSourceArr;

@property (nonatomic, assign) NSInteger index;
@end

@implementation UserCommentController

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
   
    self.dataSourceArr = [NSMutableArray arrayWithCapacity:6];
    [self customNaviBar];

    [self setupViews];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(requestData)];
    [self.tableView.mj_header beginRefreshing];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
}

- (void)customNaviBar {
    
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"arrowImage"] style:UIBarButtonItemStylePlain target:self action:@selector(handleBack:)];
    self.navigationItem.leftBarButtonItem = left;
    
}

- (void)handleBack:(UIBarButtonItem *)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)setupViews {
    self.view.backgroundColor = RGB(238, 238, 238);
    self.title = @"用户评价";
   
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, kHeight - 64 * kHMulriple) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    
    [self.tableView registerClass:[UserCommentCell class] forCellReuseIdentifier:@"UserCommentCell"];
    [self.tableView registerClass:[CommentCell class] forCellReuseIdentifier:@"CommentCell"];
        
}


//GET异步请求
- (void)requestData {
    
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD showWithStatus:@"加载中..."];
    NSString *urlStr = [NSString stringWithFormat:@"/user/shop/%@/vote?page=%@", [AccountTool unarchiveShopId], @(0)];
    
    
    
    [HttpHelper requestUrl:urlStr success:^(id json) {
               
        [SVProgressHUD dismiss];
        
        
        NSDictionary *dataDic = json[@"data"];
        NSArray *contentArr = dataDic[@"content"];
        for (NSDictionary *dic in contentArr) {
                    
            CommentModel *model = [[CommentModel alloc] initWithDic:dic];
            [self.dataSourceArr addObject:model];
            
        }
        
        
        [self.tableView reloadData];

        if (self.dataSourceArr.count < 5) {
            
            _tableView.mj_footer.hidden = YES;
        }
        
        [self setupTableView];
        
    } failure:^(NSError *error) {
        
    }];

    [_tableView.mj_header endRefreshing];
    
    
}

- (void)loadMoreData {
    
     NSString *urlStr = [NSString stringWithFormat:@"/user/shop/%@/vote?page=%@", [AccountTool unarchiveShopId], @(num)];
    
    [HttpHelper requestUrl:urlStr success:^(id json) {
        
        [SVProgressHUD dismiss];
        
        
        NSDictionary *dataDic = json[@"data"];
        NSArray *contentArr = dataDic[@"content"];
        
        if (contentArr.count == 0) {
            
            _tableView.mj_footer.hidden = YES;
        }
        
        
        
        for (NSDictionary *dic in contentArr) {
            
            CommentModel *model = [[CommentModel alloc] initWithDic:dic];
            [self.dataSourceArr addObject:model];
            
        }
        
        [self.tableView reloadData];
        
    
    } failure:^(NSError *error) {
        
    }];
    
    num = num + 1;
    [self.tableView.mj_footer endRefreshing];

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
    
}

#pragma mark -UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    
    return self.dataSourceArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"cell";
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    if (!cell) {
        cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    }

    CommentModel *model = self.dataSourceArr[indexPath.row];
    
    
    if (model.img.count == 0) {
        
        CommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommentCell" forIndexPath:indexPath];
        if (!cell) {
            
            cell = [[CommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CommentCell"];
        }
        cell.commentModel = model;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.selectionStyle = UITableViewCellSeparatorStyleNone;
        return cell;

    } else {
        
        UserCommentCell *userCell = [tableView dequeueReusableCellWithIdentifier:@"UserCommentCell" forIndexPath:indexPath];
        if (!userCell) {
            
            userCell = [[UserCommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UserCommentCell"];
        }
        for (UIView *subView in userCell.contentView.subviews)
        {
            [subView removeFromSuperview];
        }
        userCell.commentModel = model;
        
        userCell.selectionStyle = UITableViewCellSeparatorStyleNone;
        return userCell;
    }
    
    return cell;
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CommentModel *model = self.dataSourceArr[indexPath.row];
    if (model.img.count == 0) {
        
        return [CommentCell heightForRowWithModel:model];
    } else {
        
        return [UserCommentCell heightForRowWithCommentModel:model];
    }
    
    
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
