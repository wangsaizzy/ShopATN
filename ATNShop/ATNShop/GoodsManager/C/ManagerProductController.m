//
//  ManagerProductController.m
//  @的你
//
//  Created by 吴明飞 on 16/3/31.
//  Copyright © 2016年 吴明飞. All rights reserved.
//

#import "ManagerProductController.h"
#import "ManagerTableView.h"
#import "AddGoodsController.h"
#import "ManagerProductCell.h"
#import "GoodsModel.h"


static NSInteger num = 1;

@interface ManagerProductController ()

@property (nonatomic, strong) ManagerTableView *tableView;

//**数据源数组*/
@property (nonatomic, copy) NSMutableArray *dataArray;
/**模型数组*/
@property (nonatomic, copy) NSMutableArray *modelArray;

@property (nonatomic, strong) UIImageView *backImage;
@property (nonatomic, strong) UILabel *textLabel;
@end

@implementation ManagerProductController

{
    BOOL _isResume;//恢复售卖
    BOOL _isOutOfStock;//缺货下架
}

- (UIImageView *)backImage {
    
    if (!_backImage) {
        
        self.backImage = [[UIImageView alloc] initWithFrame:CGRectMake(98 * kMulriple, 184 * kHMulriple, 180 * kMulriple, 180 * kHMulriple)];
        _backImage.image = [UIImage imageNamed:@"nosource"];
        _backImage.alpha = 0.5;
        [self.view addSubview:self.backImage];
    }
    return _backImage;
}

- (UILabel *)textLabel {
    
    if (!_textLabel) {
        
        self.textLabel = [[UILabel alloc] initWithFrame:CGRectMake(210 * kMulriple, 280 * kHMulriple, 90 * kMulriple, 25 * kHMulriple)];
        _textLabel.text = @"暂无数据";
        _textLabel.textColor = RGB(111, 111, 111);
        _textLabel.font = KFont;
        
        [self.view addSubview:self.textLabel];
    }
    return _textLabel;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    self.navigationController.navigationBarHidden = YES;
    self.navigationController.navigationBar.tintColor = [UIColor darkGrayColor];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:20], NSForegroundColorAttributeName:RGB(94, 94, 94)};
    self.navigationController.navigationBar.titleTextAttributes = dic;
    num = 1;
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self customNaviBar];
    
    
    //自定义试图用
    [self setupViews];
    //请求数据
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(requestModelData)];
    [self.tableView.mj_header beginRefreshing];
    
    
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestModelData) name:@"AddGoodsSuccess" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestModelData) name:@"AlertGoodsSuccess" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestModelData) name:@"DeleteGoodsSuccess" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestModelData) name:@"ResumeGoodsSuccess" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestModelData) name:@"StockGoodsSuccess" object:nil];
}



- (void)setupViews {
    self.view.backgroundColor = RGB(238, 238, 238);
    
    self.tableView = [[ManagerTableView alloc] initWithFrame:CGRectMake(0, 64 * kHMulriple, self.view.bounds.size.width, self.view.bounds.size.height - 64 * kHMulriple) style:UITableViewStylePlain];
    
    self.tableView.cellHeight = 140 * kHMulriple;
    self.tableView.pagingEnabled = NO;
    [self.view addSubview:self.tableView];
}

- (void)requestModelData {
    
    num = 1;
    
    WS(weakself);
    [self.modelArray removeAllObjects];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD showWithStatus:@"加载中..."];
    
    NSString *urlStr = [NSString stringWithFormat:@"/shop/product?page=%@", @(0)];
    
    [HttpHelper requestUrl:urlStr success:^(id json) {
        [SVProgressHUD dismiss];
        NSMutableArray *array = [NSMutableArray array];
        NSDictionary *dataDic = json[@"data"];
        NSArray *contentArr = dataDic[@"content"];
        for (NSDictionary *dic in contentArr) {
            GoodsModel *model = [[GoodsModel alloc] initWithDic:dic];
            [array addObject:model];
        }
        [weakself.modelArray addObjectsFromArray:array];
        
        [weakself LoadDataWithArray:weakself.modelArray];
        

        if (array.count < 5) {
            
            _tableView.mj_footer.hidden = YES;
        }

        
        if (array.count > 0) {
            
            _tableView.hidden = NO;
            [_textLabel removeFromSuperview];
            [_backImage removeFromSuperview];

        } else if (array.count == 0) {
            
            self.view.backgroundColor = RGB(200, 200, 200);
            [self.view addSubview:self.backImage];
            [self.view addSubview:self.textLabel];
            _tableView.hidden = YES;
        }


    } failure:^(NSError *error) {
        
    }];
    

    [self.tableView.mj_header endRefreshing];
}

- (void)loadMoreData {
    
    WS(weakself);
    
    NSString *urlStr = [NSString stringWithFormat:@"/shop/product?page=%@", @(num)];
    
    [HttpHelper requestUrl:urlStr success:^(id json) {
        [SVProgressHUD dismiss];
        
        NSMutableArray *array = [NSMutableArray array];
        NSDictionary *dataDic = json[@"data"];
        NSArray *contentArr = dataDic[@"content"];
        
        if (contentArr.count == 0) {
            
            _tableView.mj_footer.hidden = YES;
        } else {
            
            for (NSDictionary *dic in contentArr) {
                GoodsModel *model = [[GoodsModel alloc] initWithDic:dic];
                [array addObject:model];
            }
            [weakself.modelArray addObjectsFromArray:array];
            [weakself LoadDataWithArray:weakself.modelArray];

        }
        
    } failure:^(NSError *error) {
        
    }];
    
    [self.tableView.mj_footer endRefreshing];
    
    num = num + 1;
}


#pragma mark -- 刷新事件
- (void)LoadDataWithArray:(NSArray *)array{
    
    WS(weakself);
    
    
    
    [self.dataArray removeAllObjects];
    
    for (int i = 0; i < array.count; i++) {
        
        
        NSIndexPath *index = [NSIndexPath indexPathForRow:i inSection:0];
        ManagerProductCell *cell = [ManagerProductCell creatCellWithTarget:self index:index tableView:self.tableView model:array[i]];
        
        // 将创建好的 cell 加入数组
        [self.dataArray addObject:cell];
        
        [self editCellTouchEventArray:array cell:cell];
        [self statusCellTouchEventArray:array cell:cell];
        
        
        // cell 上的删除点击事件
        [cell deleteCellWithIndex:^(NSInteger index) {
            GoodsModel *model = array[index];
            NSString *urlString = [NSString stringWithFormat:@"/shop/product/%@", model.id];
            
            [SVProgressHUD showWithStatus:@"删除中..."];
            [HttpHelper requestMethod:@"DELETE" urlString:urlString parma:nil success:^(id json) {
                [SVProgressHUD showSuccessWithStatus:@"删除成功"];
                
                    [weakself.dataArray removeObjectAtIndex:index];
                    [weakself.modelArray removeObjectAtIndex:index];
                    
                    // 刷新数据
                    [weakself LoadDataWithArray:weakself.modelArray];
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"DeleteGoodsSuccess" object:nil];
                

            } failure:^(NSError *error) {
                
            }];
            
    }];
        

    }
    
    [self.tableView setUpTheDataSourceWithArray:self.dataArray];

}


- (void)editCellTouchEventArray:(NSArray *)array cell:(ManagerProductCell *)cell {
    
    [cell editCellWithIndex:^(NSInteger index) {
        
        AddGoodsController *goodsVC = [[AddGoodsController alloc] init];
        goodsVC.model = array[index - 1000];
        [self.navigationController pushViewController:goodsVC animated:YES];
    }];
}

- (void)statusCellTouchEventArray:(NSArray *)array cell:(ManagerProductCell *)cell {
    
    [SVProgressHUD setMinimumDismissTimeInterval:1];
    
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
        [cell statusCellWithIndex:^(NSInteger index) {
       
        GoodsModel *model = array[index - 5000];
        if ([cell.productStatusBtn.titleLabel.text isEqualToString:@"恢复售卖"]) {
            
            NSString *urlString = [NSString stringWithFormat:@"/shop/product/%@/publish", model.id];
           
            
            
            [HttpHelper requestMethod:@"PATCH" urlStr:urlString parma:nil success:^(id json) {
                
            
                [[NSNotificationCenter defaultCenter] postNotificationName:@"ResumeGoodsSuccess" object:nil];
                        
                [SVProgressHUD showSuccessWithStatus:@"发布成功"];
                
                [cell.productStatusBtn.layer setBorderWidth:1 * kMulriple];   //边框宽度
                [cell.productStatusBtn.layer setBorderColor:RGB(237, 237, 237).CGColor];//边框颜色
                cell.productStatusBtn.titleLabel.font = [UIFont systemFontOfSize:17 * kMulriple];
                [cell.productStatusBtn setTitleColor:RGB(111, 111, 111) forState:UIControlStateNormal];
                [cell.productStatusBtn setTitle:@"缺货下架" forState:UIControlStateNormal];
                cell.productStatusBtn.backgroundColor = [UIColor whiteColor];
                
               
            } failure:^(NSError *error) {
                
                if (error) {
                    
                  [SVProgressHUD showInfoWithStatus:@"发布失败"];
                }

            }];

        }
        
        if ([cell.productStatusBtn.titleLabel.text isEqualToString:@"缺货下架"]) {
            
            NSString *urlString = [NSString stringWithFormat:@"/shop/product/%@/unpublish", model.id];
            
            
            [HttpHelper requestMethod:@"PATCH" urlStr:urlString parma:nil success:^(id json) {
            
                        
                [SVProgressHUD showSuccessWithStatus:@"下架成功"];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"StockGoodsSuccess" object:nil];
                          
                    [cell.productStatusBtn setTitle:@"恢复售卖" forState:UIControlStateNormal];
                    cell.productStatusBtn.backgroundColor = [UIColor redColor];
                    cell.productStatusBtn.titleLabel.font = [UIFont systemFontOfSize:17 * kMulriple];
                    [cell.productStatusBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                
                        
                
            } failure:^(NSError *error) {
                
                if (error) {
                    
                    [SVProgressHUD showInfoWithStatus:@"下架失败"];
                }

            }];

        }
    }];
}


#pragma mark -- lazy load
- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
- (NSMutableArray *)modelArray
{
    if (!_modelArray) {
        _modelArray = [NSMutableArray array];
    }
    return _modelArray;
}


//添加商品按钮方法
- (void)addBtnAction:(UIButton *)sender {
    
    AddGoodsController *goodsVC = [[AddGoodsController alloc] init];
    goodsVC.isSubmit = YES;
    [self.navigationController pushViewController:goodsVC animated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)dealloc {
    num = 1;
    _modelArray = nil;
    _dataArray = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"AddGoodsSuccess" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"AlertGoodsSuccess" object:nil];
     [[NSNotificationCenter defaultCenter] removeObserver:self name:@"DeleteGoodsSuccess" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"ResumeGoodsSuccess" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"StockGoodsSuccess" object:nil];
}

- (void)customNaviBar {
    //自定义导航栏
    UIView *naviView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWight, 64 * kHMulriple)];
    naviView.backgroundColor = RGB(83, 83, 83);
    
    //返回按钮
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 25 * kHMulriple, 80 * kMulriple, 30 * kHMulriple);
    
    [backBtn addTarget:self action:@selector(backBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *arrowImage = [[UIImageView alloc] initWithFrame:CGRectMake(15 * kMulriple, 2.5 * kHMulriple, 15 * kMulriple, 25 * kHMulriple)];
    arrowImage.image = [UIImage imageNamed:@"arrowImage"];
    [backBtn addSubview:arrowImage];

    [naviView addSubview:backBtn];
    
    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(137 * kMulriple, 20 * kHMulriple, 100 * kMulriple, 40 * kHMulriple)];
    textLabel.text = @"商品管理";
    textLabel.textColor = [UIColor whiteColor];
    textLabel.font = [UIFont systemFontOfSize:20 * kMulriple];
    textLabel.centerX = naviView.width / 2;
    
    [naviView addSubview:textLabel];
    
    //搜索按钮
    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    addBtn.frame = CGRectMake(330 * kMulriple, 25 * kHMulriple, 40 * kMulriple, 30 * kMulriple);
    [addBtn setTitle:@"添加" forState:UIControlStateNormal];
    [addBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    addBtn.titleLabel.font = [UIFont systemFontOfSize:17 * kMulriple];
    [addBtn addTarget:self action:@selector(addBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [naviView addSubview:addBtn];
    
    [self.view addSubview:naviView];
    
    
}


- (void)backBtnAction:(UIButton *)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}


@end
