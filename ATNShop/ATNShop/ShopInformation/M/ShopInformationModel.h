//
//  ShopInformationModel.h
//  ATN
//
//  Created by 吴明飞 on 16/5/27.
//  Copyright © 2016年 王赛. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShopInformationModel : NSObject
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSNumber *latitude;
@property (nonatomic, copy) NSNumber *longitude;
@property (nonatomic, strong) NSNumber *areaId;
@property (nonatomic, copy) NSString *phone;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *subscribeAble;
@property (nonatomic, copy) NSNumber *backRate;
@property (nonatomic, strong) NSNumber *categoryId;
@property (nonatomic, strong) NSArray *albumArr;
@property (nonatomic, copy) NSString *protraitUrl;
@property (nonatomic, copy) NSString *thumbnailUrl;
@property (nonatomic, copy) NSString *bannerUrl;
@property (nonatomic, copy) NSString *categoryName;
@property (nonatomic, copy) NSString *categoryNextName;
- (instancetype)initWithDic:(NSDictionary *)dic;
@end
