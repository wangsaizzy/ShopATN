//
//  CompleteModel.h
//  ATNShopDemo
//
//  Created by 吴明飞 on 16/6/28.
//  Copyright © 2016年 吴明飞. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CompleteModel : NSObject
@property (nonatomic, copy) NSString *portrait;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *orderNo;
@property (nonatomic, strong) NSNumber *amount;
@property (nonatomic, strong) NSNumber *id;
@property (nonatomic, copy) NSString *orderType;
@property (nonatomic, copy) NSString *updatetime;
@property (nonatomic, copy) NSString *userPortrait;
- (instancetype)initWithDic:(NSDictionary *)dic;
@end
