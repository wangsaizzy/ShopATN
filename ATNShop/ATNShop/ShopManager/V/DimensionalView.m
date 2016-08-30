//
//  DimensionalView.m
//  ATNShopDemo
//
//  Created by 吴明飞 on 16/6/27.
//  Copyright © 2016年 吴明飞. All rights reserved.
//

#import "DimensionalView.h"

@implementation DimensionalView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        [self addSubview:self.scanImageView];
        [self addSubview:self.shopNameLabel];
        [self addSubview:self.saveBtn];
        [self addSubview:self.deleteBtn];
        [self addSubview:self.pictureImage];
        
    }
    return self;
}



- (UIImageView *)scanImageView {
    
    if (!_scanImageView) {
        
        self.scanImageView = [[UIImageView alloc] initWithFrame:CGRectMake(50 * kMulriple, 30 * kHMulriple, 155 * kMulriple, 155 * kHMulriple)];
    }
    return _scanImageView;
}

- (UILabel *)shopNameLabel {
    
    if (!_shopNameLabel) {
        
        self.shopNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(50 * kMulriple, 205 * kHMulriple, 155 * kMulriple, 30 * kHMulriple)];
        _shopNameLabel.font = [UIFont systemFontOfSize:17 * kMulriple];
    }
    return _shopNameLabel;
}

- (UIButton *)saveBtn {
    
    if (!_saveBtn) {
        
        self.saveBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        self.saveBtn.frame = CGRectMake(50 * kMulriple, 255 * kHMulriple, 70 * kMulriple, 30 * kHMulriple);
        [self.saveBtn setTitle:@"保存" forState:UIControlStateNormal];
        _saveBtn.titleLabel.font = [UIFont systemFontOfSize:17 * kMulriple];
        self.saveBtn.backgroundColor = RGB(238, 238, 238);
        [self.saveBtn setTitleColor:RGB(111, 111, 111) forState:UIControlStateNormal];
    }
    return _saveBtn;
}

- (UIButton *)deleteBtn {
    
    if (!_deleteBtn) {
        
        self.deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.deleteBtn.frame = CGRectMake(215 * kMulriple, 0, 40 * kMulriple, 40 * kHMulriple);
        [self.deleteBtn setImage:[UIImage imageNamed:@"delete"] forState:UIControlStateNormal];
    }
    return _deleteBtn;
}



- (UIImageView *)pictureImage {
    
    if (!_pictureImage) {
        
        self.pictureImage = [[UIImageView alloc] initWithFrame:CGRectMake(135 * kMulriple, 255 * kHMulriple, 100 * kMulriple, 30 * kHMulriple)];
        self.pictureImage.image = [UIImage imageNamed:@"AITNI"];
    }
    return _pictureImage;
}

@end
