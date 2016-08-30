//
//  UIButton+Block.m
//  ATNShopDemo
//
//  Created by 吴明飞 on 16/6/25.
//  Copyright © 2016年 吴明飞. All rights reserved.
//

#import "UIButton+Block.h"
#import <objc/runtime.h>

static char *overViewKey;


@implementation UIButton (Block)

-(void)HandleClickEvent:(UIControlEvents)aEvent withClickBlick:(ActionBlock)buttonClickEvent
{
    objc_setAssociatedObject(self, &overViewKey, buttonClickEvent, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self addTarget:self action:@selector(buttonClick) forControlEvents:aEvent];
}

-(void)buttonClick
{
    ActionBlock blockClick = objc_getAssociatedObject(self, &overViewKey);
    if (blockClick != nil)
    {
        blockClick();
    }
}


@end
