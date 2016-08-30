//
//  AddGoodsController.h
//  ATN
//
//  Created by 吴明飞 on 16/5/7.
//  Copyright © 2016年 王赛. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GoodsModel;
@interface AddGoodsController : UIViewController

@property (nonatomic, strong) GoodsModel *model;

@property (nonatomic, assign) BOOL isSubmit;
@end
