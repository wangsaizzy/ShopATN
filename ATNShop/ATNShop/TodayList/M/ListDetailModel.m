//
//  ListDetailModel.m
//  ATNShopDemo
//
//  Created by 吴明飞 on 16/6/30.
//  Copyright © 2016年 吴明飞. All rights reserved.
//

#import "ListDetailModel.h"

@implementation ListDetailModel

- (instancetype)initWithDic:(NSDictionary *)dic {
    
    self = [super init];
    if (self) {
        
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
    if ([key isEqualToString:@"order"]) {
        
        self.updatetime = value[@"updatetime"];
        self.amount = value[@"amount"];
        self.payType = value[@"payType"];
        self.backAmount = value[@"backAmount"];
        self.orderNo = value[@"orderNo"];
    }
    
    if ([key isEqualToString:@"user"]) {
        
        self.phone = value[@"phone"];
        self.name = value[@"name"];
        self.portrait = value[@"portrait"];
    }
}

@end
