//
//  ShopListCache.h
//  ATNShopDemo
//
//  Created by 吴明飞 on 16/6/28.
//  Copyright © 2016年 吴明飞. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShopListCache : NSObject

//存数据 dic 字典数据 key 文件文字
+ (void)setObjectOfDic:(NSDictionary *)dic key:(NSString *)key;

//取数据
+ (NSDictionary *)selectCacheDicForKey:(NSString *)key;

//清除数据 清除成功后 回调block:completion
+ (void)clearCacheListData:(void(^)())completion;

//缓存大小
+ ( float )filePath;

@end
