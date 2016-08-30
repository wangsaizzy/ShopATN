//
//  ListDetailModel.h
//  ATNShopDemo
//
//  Created by 吴明飞 on 16/6/30.
//  Copyright © 2016年 吴明飞. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ListDetailModel : NSObject
@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSString *portrait;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *updatetime;
@property (nonatomic, strong) NSNumber *amount;
@property (nonatomic, strong) NSNumber *backAmount;
@property (nonatomic, copy) NSString *payType;
@property (nonatomic, copy) NSString *orderNo;
- (instancetype)initWithDic:(NSDictionary *)dic;
@end
