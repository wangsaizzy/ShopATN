//
//  ManagerTableView.m
//  ATNShopDemo
//
//  Created by 吴明飞 on 16/6/25.
//  Copyright © 2016年 吴明飞. All rights reserved.
//

#import "ManagerTableView.h"
#import "ManagerProductCell.h"
@interface ManagerTableView () <UITableViewDataSource,UITableViewDelegate>
/**数据源 数组*/
@property(nonatomic,strong)NSMutableArray *dataArray;

/**将这个 block 定义属性*/
@property (nonatomic, copy) handleCellBlock clickBlock;
@end



@implementation ManagerTableView

- (void)setUpTheDataSourceWithArray:(NSMutableArray *)dataArray {
    
    // 加载数据时 增加分割线 刷新数据
    _dataArray = dataArray;
    
    if (_dataArray.count) {
        
    }

    //设置状态栏返回顶部
    [self setScrollsToTop:YES];
    
    [self registerClass:[ManagerProductCell class] forCellReuseIdentifier:@"ManagerProductCell"];
    
    [self reloadData];
}

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.delegate = self;
        self.dataSource = self;
        
        //self.separatorStyle = UITableViewCellSeparatorStyleNone;
        // 设置去除tableview的底端横线
        //self.tableFooterView = [UIView new];
    }
    
   
    
    return self;
}

#pragma mark -- tableView # delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.dataArray[indexPath.row];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return _cellHeight;
}

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
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
