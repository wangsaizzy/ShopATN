//
//  CityModel.m
//  ATNShopDemo
//
//  Created by 吴明飞 on 16/7/2.
//  Copyright © 2016年 吴明飞. All rights reserved.
//

#import "CityModel.h"

@implementation CityModel

- (instancetype)initWithName:(NSString *)name cityId:(NSString *)cityId longitude:(NSString *)longitude latitude:(NSString *)latitude updatetime:(NSString *)updatetime {
    
    self = [super init];
    if (self) {
        
        self.name = name;
        self.cityId = cityId;
        self.longitude = longitude;
        self.latitude = latitude;
        self.updatetime = updatetime;
    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

#pragma -mark将对象转化为NSData的方法
-(void)encodeWithCoder:(NSCoder *)aCoder {
    
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.cityId forKey:@"id"];
    [aCoder encodeObject:self.longitude forKey:@"longitude"];
    [aCoder encodeObject:self.latitude forKey:@"latitude"];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super init];
    if (self) {
        
        //解压过程
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.cityId = [aDecoder decodeObjectForKey:@"id"];
        self.longitude = [aDecoder decodeObjectForKey:@"longitude"];
        self.latitude = [aDecoder decodeObjectForKey:@"latitude"];
    }
    return self;
}

@end
