//
//  NewsCell.h
//  ATNShopDemo
//
//  Created by 吴明飞 on 16/7/12.
//  Copyright © 2016年 吴明飞. All rights reserved.
//

#import <UIKit/UIKit.h>
@class NewsModel;
@interface NewsCell : UITableViewCell
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UIImageView *backImageView;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) NewsModel *model;
+ (CGFloat)heightForRowWithModel:(NewsModel *)model;
@end
