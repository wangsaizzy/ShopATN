//
//  HistoryCashModel.h
//  ATNShopDemo
//
//  Created by 吴明飞 on 16/6/29.
//  Copyright © 2016年 吴明飞. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HistoryCashModel : NSObject
@property (nonatomic, strong) NSNumber *amount;
@property (nonatomic, copy) NSString *createtime;
@property (nonatomic, copy) NSString *status;

- (instancetype)initWithDic:(NSDictionary *)dic;
@end
