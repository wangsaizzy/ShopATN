//
//  TodayIncomeModel.h
//  ATNShop
//
//  Created by 王赛 on 16/10/10.
//  Copyright © 2016年 王赛. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TodayIncomeModel : NSObject

@property (nonatomic, copy) NSString *createtime;
/**
 *  收入
 */
@property (nonatomic, copy) NSString *income;//收入
/**
 *  头像
 */
@property (nonatomic, copy) NSString *userPortrait;

- (instancetype) initWithDic:(NSDictionary *)dic;


@end
