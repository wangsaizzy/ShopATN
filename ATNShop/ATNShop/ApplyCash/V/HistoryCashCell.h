//
//  HistoryCashCell.h
//  ATN
//
//  Created by 吴明飞 on 16/4/28.
//  Copyright © 2016年 王赛. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HistoryCashModel;
@interface HistoryCashCell : UITableViewCell

@property (nonatomic, strong) UILabel *cashLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *statusLabel;
@property (nonatomic, strong) HistoryCashModel *model;
@end
