//
//  UpLoadImageHelper.m
//  ATN
//
//  Created by 吴明飞 on 16/6/14.
//  Copyright © 2016年 王赛. All rights reserved.
//

#import "UpLoadImageHelper.h"

@implementation UpLoadImageHelper
+ (instancetype)sharedInstance{
    static UpLoadImageHelper *sharedInstance=nil;
    static dispatch_once_t  onceToken;
    dispatch_once(&onceToken,^{
        sharedInstance=[[UpLoadImageHelper alloc]init];
    });
    return sharedInstance;
}

@end
