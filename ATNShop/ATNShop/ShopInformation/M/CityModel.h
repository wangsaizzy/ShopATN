//
//  CityModel.h
//  ATNShopDemo
//
//  Created by 吴明飞 on 16/7/2.
//  Copyright © 2016年 吴明飞. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CityModel : NSObject
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *cityId;
@property (nonatomic, copy) NSString *longitude;
@property (nonatomic, copy) NSString *latitude;
@property (nonatomic, copy) NSString *updatetime;
- (instancetype)initWithName:(NSString *)name
                      cityId:(NSString *)cityId
                   longitude:(NSString *)longitude
                    latitude:(NSString *)latitude
                  updatetime:(NSString *)updatetime;

@end
