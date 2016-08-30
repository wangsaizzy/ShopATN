//
//  SubscribeModel.h
//  ATNShopDemo
//
//  Created by 吴明飞 on 16/7/8.
//  Copyright © 2016年 吴明飞. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SubscribeModel : NSObject
@property (nonatomic, copy) NSString *userPortrait;
@property (nonatomic, strong) NSString *createtime;
@property (nonatomic, copy) NSString *userName;
- (instancetype)initWithDic:(NSDictionary *)dic;
@end
