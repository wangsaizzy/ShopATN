//
//  DropDownMenuView.m
//  ATNShopDemo
//
//  Created by 吴明飞 on 16/7/2.
//  Copyright © 2016年 吴明飞. All rights reserved.
//

#import "DropDownMenuView.h"

@interface DropDownMenuView()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong)UITableView *tableView;

@end
@implementation DropDownMenuView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self createView];
    }
    return self;
}

- (void)createView{
    self.topView = [[UIView alloc] initWithFrame:self.bounds];
    [self addSubview:self.topView];
    
    self.tableView = [[UITableView alloc] initWithFrame:self.topView.bounds style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.allowsSelection = YES;
    [self.topView addSubview:self.tableView];
}

- (void)removeViewFromSuperView{
    [self.topView removeFromSuperview];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.textLabel.text = self.dataSource[indexPath.row];
    
    cell.textLabel.textColor = [UIColor blackColor];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    self.finishBlock(self.dataSource[indexPath.row]);
    
}


@end
