//
//  ManagerModel.h
//  ATNShopDemo
//
//  Created by 吴明飞 on 16/7/11.
//  Copyright © 2016年 吴明飞. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ManagerModel : NSObject
@property (nonatomic, copy) NSString *portraitUrl;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *thumbnailUrl;
@property (nonatomic, copy) NSString *bannerUrl;
@property (nonatomic, strong) NSNumber *backRate;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, strong) NSNumber *longitude;
@property (nonatomic, strong) NSNumber *latitude;
@property (nonatomic, strong) NSArray *album;
@property (nonatomic, copy) NSString *areaName;
@property (nonatomic, copy) NSString *categoryName;
@property (nonatomic, copy) NSString *categoryNextName;
@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, strong) NSNumber *sumTodayInmoney;
@property (nonatomic, strong) NSNumber *countTodayOrders;

- (instancetype)initWithDic:(NSDictionary *)dic;
@end
