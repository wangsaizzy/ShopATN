//
//  CategoryModel.m
//  ATNShopDemo
//
//  Created by 吴明飞 on 16/7/13.
//  Copyright © 2016年 吴明飞. All rights reserved.
//

#import "CategoryModel.h"

@implementation CategoryModel
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
