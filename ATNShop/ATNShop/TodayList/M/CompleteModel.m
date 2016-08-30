//
//  CompleteModel.m
//  ATNShopDemo
//
//  Created by 吴明飞 on 16/6/28.
//  Copyright © 2016年 吴明飞. All rights reserved.
//

#import "CompleteModel.h"

@implementation CompleteModel
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
