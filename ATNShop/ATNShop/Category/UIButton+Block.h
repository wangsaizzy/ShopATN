//
//  UIButton+Block.h
//  ATNShopDemo
//
//  Created by 吴明飞 on 16/6/25.
//  Copyright © 2016年 吴明飞. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void (^ActionBlock)();

@interface UIButton (Block)

- (void)HandleClickEvent:(UIControlEvents)aEvent withClickBlick:(ActionBlock)buttonClickEvent;

@end
