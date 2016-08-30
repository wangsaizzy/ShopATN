//
//  ShopCategoryController.h
//  ATNShopDemo
//
//  Created by 吴明飞 on 16/7/15.
//  Copyright © 2016年 吴明飞. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CategoryNextModel;



@interface ShopCategoryController : UIViewController
@property (nonatomic, copy) void(^ChangeCategory)(CategoryNextModel *);
@end
