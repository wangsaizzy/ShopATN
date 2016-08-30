//
//  ManagerModel.m
//  ATNShopDemo
//
//  Created by 吴明飞 on 16/7/11.
//  Copyright © 2016年 吴明飞. All rights reserved.
//

#import "ManagerModel.h"

@implementation ManagerModel
- (instancetype)initWithDic:(NSDictionary *)dic {
    
    self = [super init];
    if (self) {
        
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
    if ([key isEqualToString:@"img"]) {
        if (![value[@"portrait"] isEqual:[NSNull null]]) {
            
            self.portraitUrl = value[@"portrait"][@"url"];
        }
        if (![value[@"thumbnail"] isEqual:[NSNull null]]) {
            
           self.thumbnailUrl = value[@"thumbnail"][@"url"];
        }
        if (![value[@"banner"] isEqual:[NSNull null]]) {
            
            self.bannerUrl = value[@"banner"][@"url"];
        }
        
        self.album = value[@"album"];
    }
    
    if ([key isEqualToString:@"category"]) {
        
        self.categoryName = value[@"parentName"];
        self.categoryNextName = value[@"name"];
    }
}


////实现协议中的方法
//- (void)encodeWithCoder:(NSCoder *)aCoder{
//    [aCoder encodeObject:self.portraitUrl forKey:@"portraitUrl"];
//    [aCoder encodeObject:self.shopName forKey:@"shopName"];
//    [aCoder encodeObject:self.thumbnailUrl forKey:@"thumbnailUrl"];
//    [aCoder encodeObject:self.bannerUrl forKey:@"bannerUrl"];
//    [aCoder encodeObject:self.backRate forKey:@"backRate"];
//    [aCoder encodeObject:self.address forKey:@"address"];
//    [aCoder encodeObject:self.album forKey:@"album"];
//    aCoder encodeObject:<#(nullable id)#> forKey:<#(nonnull NSString *)#>
//}
//- (id)initWithCoder:(NSCoder *)aDecoder{
//    self = [super init];
//    if (self) {
//        self.name = [aDecoder decodeObjectForKey:@"name"];
//        self.gender = [aDecoder decodeObjectForKey:@"gender"];
//    }
//    return self;
//}

@end
