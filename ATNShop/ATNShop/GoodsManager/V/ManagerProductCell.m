//
//  ManagerProductCell.m
//  @的你
//
//  Created by 吴明飞 on 16/3/31.
//  Copyright © 2016年 吴明飞. All rights reserved.
//

#import "ManagerProductCell.h"
#import "UIButton+Block.h"
#import "GoodsModel.h"




@interface ManagerProductCell ()
@property (nonatomic, copy) deleteCellBlock block;

@property (nonatomic, copy) editCellBlock editBlock;



@property (nonatomic, copy) StatusCellBlock statusBlock;


@property (nonatomic, assign) NSInteger cellIndex;

@property (nonatomic, assign) BOOL isSelected;
@end

@implementation ManagerProductCell




- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addSubview:self.productImage];
        [self addSubview:self.productNameLabel];
        [self addSubview:self.productPriceLabel];
        [self addSubview:self.editBtn];
        [self addSubview:self.deleteBtn];
        [self addSubview:self.productStatusBtn];
    
    }
    return self;
}

#pragma mark -懒加载
//商品图片
- (UIImageView *)productImage {
    if (!_productImage) {
        self.productImage = [[UIImageView alloc] initWithFrame:CGRectMake(20 * kMulriple, 10 * kHMulriple, 90 * kMulriple, 80 * kHMulriple)];
        
    }
    return _productImage;
}

//商品名称
- (UILabel *)productNameLabel {
    if (!_productNameLabel) {
        self.productNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(125 * kMulriple, 15 * kHMulriple, 220 * kMulriple, 25 * kHMulriple)];
        _productNameLabel.font = [UIFont systemFontOfSize:17 * kMulriple];
        _productNameLabel.textColor = RGB(111, 111, 111);
    }
    return _productNameLabel;
}

//商品价格
- (UILabel *)productPriceLabel {
    if (!_productPriceLabel) {
        self.productPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(125 * kMulriple, 50 * kHMulriple, 220 * kMulriple, 25 * kHMulriple)];
        _productPriceLabel.font = [UIFont systemFontOfSize:17 * kMulriple];
        _productPriceLabel.textColor = RGB(111, 111, 111);
    }
    return _productPriceLabel;
}

//编辑按钮
- (UIButton *)editBtn {
    if (!_editBtn) {
        self.editBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        _editBtn.frame = CGRectMake(325 * kMulriple, 45 * kHMulriple, 25 * kMulriple, 25 * kMulriple);
        [_editBtn setImage:[UIImage imageNamed:@"commitGoods"] forState:UIControlStateNormal];
    }
    return _editBtn;
}

//删除按钮
- (UIButton *)deleteBtn {
    if (!_deleteBtn) {
        self.deleteBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        _deleteBtn.frame = CGRectMake(185 * kMulriple, 95 * kHMulriple, 80 * kMulriple, 30 * kMulriple);
        [_deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
        _deleteBtn.titleLabel.font = [UIFont systemFontOfSize:17 * kMulriple];
        [_deleteBtn.layer setBorderWidth:1 * kMulriple];   //边框宽度
        [_deleteBtn.layer setBorderColor:RGB(237, 237, 237).CGColor];//边框颜色
        _deleteBtn.titleLabel.font = [UIFont systemFontOfSize:17 * kMulriple];
        [_deleteBtn setTitleColor:RGB(111, 111, 111) forState:UIControlStateNormal];

    }
    return _deleteBtn;
}

//产品状态按钮
- (UIButton *)productStatusBtn {
    
    if (!_productStatusBtn) {
        
        self.productStatusBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        _productStatusBtn.frame = CGRectMake(280 * kMulriple, 95 * kHMulriple, 80 * kMulriple, 30 * kMulriple);
    
    }
    return _productStatusBtn;
}

+ (id)creatCellWithTarget:(id)target index:(NSIndexPath *)index tableView:(UITableView *)tableView model:(GoodsModel *)model{
    static NSString *identifer = @"ManagerProductCell";
    
    ManagerProductCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
    
    if (!cell) {
        
        cell = [[ManagerProductCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifer];
    }
    
    
    cell.deleteBtn.tag = index.row;
    
    [cell.deleteBtn HandleClickEvent:UIControlEventTouchUpInside withClickBlick:^{
        
        if (cell.block) {
            cell.block(cell.deleteBtn.tag);
        }
    }];
    
    
    
    if (![model.img[@"portrait"] isEqual:[NSNull null]]) {
        
        NSString *portrait = model.img[@"portrait"][@"url"];
        NSURL *portraitUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", Service_Url,portrait]];
        [cell.productImage sd_setImageWithURL:portraitUrl placeholderImage:[UIImage imageNamed:@"list"] options:SDWebImageRefreshCached];
    }
    
    cell.editBtn.tag = index.row + 1000;
    
    [cell.editBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
       
        if (cell.editBlock) {
            cell.editBlock(cell.editBtn.tag);
        }
    }];
    cell.productNameLabel.text = model.name;
    cell.productPriceLabel.text = model.price;
    

    cell.productStatusBtn.tag = index.row + 5000;
    
    [cell.productStatusBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
        
        if (cell.statusBlock) {
            cell.statusBlock(cell.productStatusBtn.tag);
        }
    }];
    
    
    
    if (model.block == YES) {
        
        [cell.productStatusBtn setTitle:@"恢复售卖" forState:UIControlStateNormal];
        cell.productStatusBtn.backgroundColor = [UIColor redColor];
        cell.productStatusBtn.titleLabel.font = [UIFont systemFontOfSize:17 * kMulriple];
        [cell.productStatusBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    if (model.block == NO) {
        [cell.productStatusBtn.layer setBorderWidth:1 * kMulriple];   //边框宽度
        [cell.productStatusBtn.layer setBorderColor:RGB(237, 237, 237).CGColor];//边框颜色
        cell.productStatusBtn.titleLabel.font = [UIFont systemFontOfSize:17 * kMulriple];
        [cell.productStatusBtn setTitleColor:RGB(111, 111, 111) forState:UIControlStateNormal];
        [cell.productStatusBtn setTitle:@"缺货下架" forState:UIControlStateNormal];
        cell.productStatusBtn.backgroundColor = [UIColor whiteColor];
    }
    cell.backgroundColor = [UIColor whiteColor];
    cell.selectionStyle = UITableViewCellSeparatorStyleNone;
    return cell;
}



- (void)deleteCellWithIndex:(deleteCellBlock)deleteBlock{
    self.block = deleteBlock;
}

- (void)editCellWithIndex:(editCellBlock)editBlock {
    
    self.editBlock = editBlock;
}


- (void)statusCellWithIndex:(StatusCellBlock)statusBlock {
    
    self.statusBlock = statusBlock;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}




@end
