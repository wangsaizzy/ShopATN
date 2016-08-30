//
//  SearchResultView.m
//  ATNShopDemo
//
//  Created by 吴明飞 on 16/7/10.
//  Copyright © 2016年 吴明飞. All rights reserved.
//

#import "SearchResultView.h"
#import "AroundInformationCell.h"
#import "POIAnnotation.h"
@interface SearchResultView()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong)UITableView *tableView;

@end

@implementation SearchResultView

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
    [self.topView addSubview:self.tableView];
    
    //
    [_tableView registerClass:[AroundInformationCell class] forCellReuseIdentifier:@"AroundInformationCell"];
}

- (void)removeViewFromSuperView{
    [self.topView removeFromSuperview];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 75 * kHMulriple;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AroundInformationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AroundInformationCell" forIndexPath:indexPath];
    if (!cell) {
        
        cell = [[AroundInformationCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"AroundInformationCell"];
    }
    
    POIAnnotation *annotation = _dataSource[indexPath.row];
    NSString *titleStr = [annotation title];
    NSString *subtitleStr = [annotation subtitle];
    cell.titleLabel.text = titleStr;
    cell.subtitleLabel.text = subtitleStr;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    self.finishBlock(self.dataSource[indexPath.row]);
}

@end
