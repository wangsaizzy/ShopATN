//
//  ManagerTableView.h
//  ATNShopDemo
//
//  Created by 吴明飞 on 16/6/25.
//  Copyright © 2016年 吴明飞. All rights reserved.
//

#import <UIKit/UIKit.h>

// 这个 block 用于回调当前点击 cell 的行数
typedef void(^handleCellBlock)(NSIndexPath *index);

@interface ManagerTableView : UITableView


/**
 *   设置数据源 (要求数组里必须是装着 cell)
 *
 *  @param dataArray
 */
- (void)setUpTheDataSourceWithArray:(NSMutableArray<UITableViewCell *> *)dataArray;

/**cell 行高*/
@property (nonatomic, assign) CGFloat cellHeight;

@end
