//
//  ManagerProductCell.h
//  @的你
//
//  Created by 吴明飞 on 16/3/31.
//  Copyright © 2016年 吴明飞. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GoodsModel;


typedef NS_ENUM(NSInteger, IsChangeGoodsStates) {
    resumeState,//发布商品
    stockState//商品下架
};

typedef void(^deleteCellBlock)(NSInteger index);
typedef void(^editCellBlock)(NSInteger index);

typedef void(^StatusCellBlock)(NSInteger index);


@interface ManagerProductCell : UITableViewCell
@property (nonatomic, strong) UIImageView *productImage;
@property (nonatomic, strong) UILabel *productNameLabel;
@property (nonatomic, strong) UILabel *productPriceLabel;
@property (nonatomic, strong) UIButton *editBtn;
@property (nonatomic, strong) UIButton *deleteBtn;
@property (nonatomic, strong) UIButton *productResumeBtn;
@property (nonatomic, strong) UIButton *productStockBtn;

@property (nonatomic, strong) UIButton *productStatusBtn;
@property (nonatomic, strong) NSMutableArray *categoryBtnArr;

@property (nonatomic, assign) IsChangeGoodsStates goodsStatus;

+ (id)creatCellWithTarget:(id)target index:(NSIndexPath *)index tableView:(UITableView *)tableView model:(GoodsModel *)model;

- (void)deleteCellWithIndex:(deleteCellBlock)deleteBlock;

- (void)editCellWithIndex:(editCellBlock)editBlock;



- (void)statusCellWithIndex:(StatusCellBlock)statusBlock;
@end
