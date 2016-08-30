//
//  ShopCategoryController.m
//  ATNShopDemo
//
//  Created by 吴明飞 on 16/7/15.
//  Copyright © 2016年 吴明飞. All rights reserved.
//

#import "ShopCategoryController.h"
#import "CategoryModel.h"
#import "CategoryNextModel.h"
@interface ShopCategoryController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

//分类数据源
@property (nonatomic, strong) NSMutableArray *categoryDataArr;

//分类Id
@property (nonatomic, strong) NSMutableArray *categoryIdArr;

//二级分类数据源
@property (nonatomic, strong) NSMutableArray *categorySourceArr;

@property (nonatomic, assign) NSInteger index;

@property (nonatomic, strong) NSMutableArray *categoryBtnArr;
//记录 选中的button
@property (nonatomic, strong) UIButton *selectBtn;

@property (nonatomic, assign) BOOL isClick;
@property (nonatomic, assign) CGFloat btnHeight;

@property (nonatomic, assign) CGFloat lineHeight;
@end

@implementation ShopCategoryController
- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:YES];
    self.navigationController.navigationBarHidden = YES;
    
}



- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.categoryDataArr = [NSMutableArray arrayWithCapacity:6];
    self.categorySourceArr = [NSMutableArray arrayWithCapacity:6];
    self.categoryBtnArr = [NSMutableArray arrayWithCapacity:6];
    self.categoryIdArr = [NSMutableArray arrayWithCapacity:6];
    [self customNaviBar];
    
    [self requestData];
    
    [self setupViews];
}

- (void)setupViews {
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(80 * kMulriple, 64 * kHMulriple, 295 * kMulriple, self.view.bounds.size.height) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    _tableView.backgroundColor = RGB(238, 238, 238);
    [self.view addSubview:self.tableView];
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
    textLabel.text = @"店铺分类";
    textLabel.textColor = [UIColor whiteColor];
    textLabel.font = [UIFont systemFontOfSize:20 * kMulriple];
    textLabel.centerX = naviView.width / 2;
    
    [naviView addSubview:textLabel];

    [self.view addSubview:naviView];

}

- (void)backBtnAction:(UIButton *)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)requestData {
       [HttpHelper requestUrl:KFirstCategory_url success:^(id json) {
        
           
           NSArray *contentArr = json[@"data"];
           for (NSDictionary *dic in contentArr) {
               
                CategoryModel *model = [[CategoryModel alloc] initWithDic:dic];
                [self.categoryIdArr addObject:model.id];
                [self setCategoryBtnWithTitle:model.name];
            }
            NSArray *catetoryIdArr = self.categoryIdArr;
            if (catetoryIdArr) {
                
                [self requestCategoryDataCategoryId:catetoryIdArr[0]];
            }

           
    } failure:^(NSError *error) {
        
    }];

   
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)setCategoryBtnWithTitle:(NSString *)title {
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 80 * kMulriple, self.view.bounds.size.height)];
    scrollView.backgroundColor = [UIColor whiteColor];
    UIButton *categoryBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    

    //frame
    categoryBtn.frame = CGRectMake(0, self.btnHeight + 64 * kHMulriple, 80 * kMulriple, 44 * kHMulriple);
    //title
    [categoryBtn setTitle:title forState:UIControlStateNormal];
    //font
    categoryBtn.titleLabel.font = [UIFont systemFontOfSize:17 * kHMulriple];
    //titleColor
    [categoryBtn setTitleColor:RGB(111, 111, 111) forState:UIControlStateNormal];
    //选中状态的字体颜色
    //[categoryBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateSelected];
    [categoryBtn setBackgroundColor:[UIColor whiteColor]];
    //点击事件
    [categoryBtn addTarget:self action:@selector(categoryBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UILabel *labelLine = [[UILabel alloc] initWithFrame:CGRectMake(0, 43.5 * kHMulriple, 80 * kMulriple, 0.5 * kHMulriple)];
    labelLine.backgroundColor = RGB(150, 150, 150);
    self.btnHeight += 44 * kHMulriple;
    [categoryBtn addSubview:labelLine];
    [self.view addSubview:categoryBtn];
    [self.categoryBtnArr addObject:categoryBtn];
    //设置默认选中为第一个
    self.selectBtn = self.categoryBtnArr[0];
    //[self.selectBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [self.selectBtn setBackgroundColor:RGB(238, 238, 238)];
    
}

- (void)categoryBtnAction:(UIButton *)sender {
    NSInteger indexOfBtn = [self.categoryBtnArr indexOfObject:sender];
    [self.selectBtn setTitleColor:RGB(111, 111, 111) forState:UIControlStateNormal];
    [self.selectBtn setBackgroundColor:[UIColor whiteColor]];
    //设置选中button
    self.selectBtn = sender;
    [self.selectBtn setTitleColor:RGB(111, 111, 111) forState:UIControlStateNormal];
    
    self.selectBtn.backgroundColor = RGB(238, 238, 238);
    self.index = indexOfBtn;
    [self requestCategoryDataCategoryId:self.categoryIdArr[indexOfBtn]];
}

- (void)requestCategoryDataCategoryId:(NSNumber *)categoryId {
    [self.categorySourceArr removeAllObjects];
    
    NSString *urlString = [NSString stringWithFormat:@"/user/shopcategory/%@", categoryId];
    
   
    [HttpHelper requestUrl:urlString success:^(id json) {
        
        
                NSArray *contentArr = json[@"data"];
                
                for (NSDictionary *dic in contentArr) {
                    
                    CategoryNextModel *model = [[CategoryNextModel alloc] initWithDic:dic];
                    
                    [self.categorySourceArr addObject:model];
                    
                }
               [self.tableView reloadData];
        
    } failure:^(NSError *error) {
        
    }];
    
}



- (void)setSelectBtn:(UIButton *)selectBtn {
    
    
    if (_selectBtn != selectBtn) {
        _selectBtn = selectBtn;
    }
    
}

#pragma mark -UITableViewDataSource & UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.categorySourceArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    if (!cell) {
        cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    }
    CategoryNextModel *model = self.categorySourceArr[indexPath.row];
    cell.textLabel.text = model.name;
    cell.textLabel.font = [UIFont systemFontOfSize:17 * kMulriple];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.textColor = RGB(111, 111, 111);
    cell.backgroundColor = RGB(238, 238, 238);
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CategoryNextModel *model = self.categorySourceArr[indexPath.row];
    self.ChangeCategory(model);
    [self.navigationController popViewControllerAnimated:YES];
}
@end
