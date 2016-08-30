//
//  DrawModel.h
//  ATNShopDemo
//
//  Created by 吴明飞 on 16/7/11.
//  Copyright © 2016年 吴明飞. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DrawModel : NSObject
@property (nonatomic, copy) NSString *accountNo;
@property (nonatomic, strong) NSNumber *balance;
@property (nonatomic, strong) NSNumber *bankInfoId;
- (instancetype)initWithDic:(NSDictionary *)dic;
@end
