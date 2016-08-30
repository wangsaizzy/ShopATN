//
//  Account.m
//  ATNShopDemo
//
//  Created by 吴明飞 on 16/8/1.
//  Copyright © 2016年 吴明飞. All rights reserved.
//

#import "Account.h"

@implementation Account
- (instancetype)initWithDic:(NSDictionary *)dic {
    
    self = [super init];
    if (self) {
        
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
    if ([key isEqualToString:@"shop"]) {
        
        self.shopId = value[@"id"];
    }
}

//从文件解析对象的时候调用
-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        self.shopId = [aDecoder decodeObjectForKey:@"shopId"];
        self.token = [aDecoder decodeObjectForKey:@"token"];
        
        
        
    }
    return self;
}
//将对象写入文件的时候调用
-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.shopId forKey:@"shopId"];
    [aCoder encodeObject:self.token forKey:@"token"];
   
    
}

@end
