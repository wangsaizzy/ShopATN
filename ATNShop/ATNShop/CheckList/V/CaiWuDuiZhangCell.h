//
//  CaiWuDuiZhangCell.h
//  ATN
//
//  Created by 吴明飞 on 16/4/27.
//  Copyright © 2016年 王赛. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CaiWuModel;
@interface CaiWuDuiZhangCell : UITableViewCell

@property (nonatomic, strong) UILabel *dayLabel;//日期
@property (nonatomic, strong) UILabel *weekLabel;//周几
@property (nonatomic, strong) UIImageView *posterImageView;//图片
@property (nonatomic, strong) UILabel *priceLabel;//价格
@property (nonatomic, strong) UILabel *typeLabel;//名称
@property (nonatomic, strong) CaiWuModel *model;
@end
