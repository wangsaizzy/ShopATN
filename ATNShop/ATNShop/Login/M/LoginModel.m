//
//  LoginModel.m
//  ATN
//
//  Created by 吴明飞 on 16/4/29.
//  Copyright © 2016年 王赛. All rights reserved.
//

#import "LoginModel.h"

@implementation LoginModel

- (instancetype)initWithDic:(NSDictionary *)dic {
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
    if ([key isEqualToString:@"data"]) {
        
        self.token = value[@"token"];
        
    }
    
    if ([key isEqualToString:@"data"]) {
        self.userShopId = value[@"user"][@"id"];
        
        self.shopId = value[@"shop"][@"id"];
    }
}

@end
