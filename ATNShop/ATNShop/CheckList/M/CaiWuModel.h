//
//  CaiWuModel.h
//  ATNShopDemo
//
//  Created by 吴明飞 on 16/6/30.
//  Copyright © 2016年 吴明飞. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CaiWuModel : NSObject
@property (nonatomic, copy) NSString *updatetime;
@property (nonatomic, copy) NSString *userPortrait;
@property (nonatomic, strong) NSNumber *amount;
@property (nonatomic, copy) NSString *orderNo;
@property (nonatomic, strong) NSNumber *backAmount;
@property (nonatomic, copy) NSString *payType;
- (instancetype)initWithDic:(NSDictionary *)dic;
@end
