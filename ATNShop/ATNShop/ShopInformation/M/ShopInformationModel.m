//
//  ShopInformationModel.m
//  ATN
//
//  Created by 吴明飞 on 16/5/27.
//  Copyright © 2016年 王赛. All rights reserved.
//

#import "ShopInformationModel.h"

@implementation ShopInformationModel
- (instancetype)initWithDic:(NSDictionary *)dic {
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}


- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
   
    if ([key isEqualToString:@"data"]) {
        self.albumArr = value[@"img"][@"album"];
        self.protraitUrl = value[@"img"][@"portrait"][@"url"];
        self.thumbnailUrl = value[@"img"][@"thumbnail"][@"url"];
        self.bannerUrl = value[@"img"][@"banner"][@"url"];
    }
    
    if ([key isEqualToString:@"data"]) {
        
        self.name = value[@"name"];
        
        self.areaId = value[@"areaId"];
        
        self.categoryId = value[@"category"][@"id"];
        
        self.categoryName = value[@"category"][@"parentName"];
        
        self.categoryNextName = value[@"category"][@"name"];
        
        self.type = value[@"type"];
        
        self.status = value[@"status"];
        
        self.latitude = value[@"latitude"];
        
        self.longitude = value[@"longitude"];
        
        self.phone = value[@"phone"];
        
        self.address = value[@"address"];
        
        self.subscribeAble = value[@"subscribeAble"];
        
        self.backRate = value[@"backRate"];
        
        
        
    }
    
}

@end
