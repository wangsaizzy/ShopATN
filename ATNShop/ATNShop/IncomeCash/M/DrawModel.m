//
//  DrawModel.m
//  ATNShopDemo
//
//  Created by 吴明飞 on 16/7/11.
//  Copyright © 2016年 吴明飞. All rights reserved.
//

#import "DrawModel.h"

@implementation DrawModel
- (instancetype)initWithDic:(NSDictionary *)dic {
    
    self = [super init];
    if (self) {
        if (![dic isEqual:[NSNull null]]) {
             [self setValuesForKeysWithDictionary:dic];
        }
       
    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
    if ([key isEqualToString:@"id"]) {
        
        self.bankInfoId = value;
    }
}

@end
