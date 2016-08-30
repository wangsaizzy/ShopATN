//
//  SubscribeModel.m
//  ATNShopDemo
//
//  Created by 吴明飞 on 16/7/8.
//  Copyright © 2016年 吴明飞. All rights reserved.
//

#import "SubscribeModel.h"

@implementation SubscribeModel
- (instancetype)initWithDic:(NSDictionary *)dic {
    self = [super init];
    if (self) {
        
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

@end
