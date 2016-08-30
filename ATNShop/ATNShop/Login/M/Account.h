//
//  Account.h
//  ATNShopDemo
//
//  Created by 吴明飞 on 16/8/1.
//  Copyright © 2016年 吴明飞. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Account : NSObject
@property (nonatomic, copy) NSString *token;//用户token
@property (nonatomic, copy) NSString *shopId;//用户Id


- (instancetype)initWithDic:(NSDictionary *)dic;
@end
