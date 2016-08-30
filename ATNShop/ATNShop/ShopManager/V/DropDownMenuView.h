//
//  DropDownMenuView.h
//  ATNShopDemo
//
//  Created by 吴明飞 on 16/7/2.
//  Copyright © 2016年 吴明飞. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^selectBlock)(NSString *title);

@interface DropDownMenuView : UIView
@property (nonatomic, strong)UIView *topView;
@property (nonatomic, strong)NSArray *dataSource;
@property (nonatomic, copy) NSString *textTitle;
@property (nonatomic, copy)selectBlock finishBlock;
@end
