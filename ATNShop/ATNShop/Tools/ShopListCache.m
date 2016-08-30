//
//  ShopListCache.m
//  ATNShopDemo
//
//  Created by 吴明飞 on 16/6/28.
//  Copyright © 2016年 吴明飞. All rights reserved.
//

#import "ShopListCache.h"

@implementation ShopListCache

+ (void)setObjectOfDic:(NSDictionary *)dic key:(NSString *)key {
    //缓存文件夹的路径
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    //拼接上数据文件的路径
    NSString *newPath = [path stringByAppendingPathComponent:@"com.shopLoad.listDataCache"];
    //创建数据库文件管理对象
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //判断文件夹是否存在 不存在则创建
    if ([fileManager fileExistsAtPath:newPath] == NO) {
        [fileManager createDirectoryAtPath:newPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    //缓存文件的路径
    NSString *cacheFilePath = [newPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist", key]];
    
    //直接写入文件
    BOOL isSuccess = [dic writeToFile:cacheFilePath atomically:NO];
    if (isSuccess == YES) {
        
    } else {
        
    }
    
}

+ (NSDictionary *)selectCacheDicForKey:(NSString *)key {
    //获取缓存文件夹的路径
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    //拼接上数据文件夹的路径
    NSString *filePath = [path stringByAppendingPathComponent:@"com.shopLoad.listDataCache"];
    //缓存文件的路径
    NSString *cacheFilePath = [filePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist", key]];
    //取得 缓存数据
    NSDictionary *cacheDic = [NSDictionary dictionaryWithContentsOfFile:cacheFilePath];
    
    return cacheDic;
}

+ (void)clearCacheListData:(void (^)())completion {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //清除缓存
        //移除缓存数据的文件夹 创建一个新的空文件夹
        NSFileManager *manager = [NSFileManager defaultManager];
        //获取缓存文件夹的路径
        NSString *path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
        //拼接上数据文件夹的路径
        NSString *filePath = [path stringByAppendingPathComponent:@"com.shopLoad.listDataCache"];
        //移除文件夹
        [manager removeItemAtPath:filePath error:nil];
        
        //创建一个新的文件夹
        [manager createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:nil];
        if (completion) {
            //回调主线程
            dispatch_async(dispatch_get_main_queue(), ^{
                //调用blcok
                completion();
            });
        }
    });
}

// 显示缓存大小
+ ( float )filePath
{
    NSString * cachPath = [ NSSearchPathForDirectoriesInDomains ( NSCachesDirectory , NSUserDomainMask , YES ) firstObject];
    NSString *newPath = [cachPath stringByAppendingPathComponent:@"com.shopLoad.listDataCache"];
    
    return [self folderSizeAtPath :newPath];
    
}
//1:首先我们计算一下 单个文件的大小

+ ( long long ) fileSizeAtPath:( NSString *) filePath{
    
    NSFileManager * manager = [ NSFileManager defaultManager ];
    
    if ([manager fileExistsAtPath :filePath]){
        
        return [[manager attributesOfItemAtPath :filePath error : nil ] fileSize ];
    }
    
    return 0 ;
    
}
//2:遍历文件夹获得文件夹大小，返回多少 M（提示：你可以在工程界设置（)m）

+ ( float ) folderSizeAtPath:( NSString *) folderPath{
    
    NSFileManager * manager = [ NSFileManager defaultManager ];
    
    if (![manager fileExistsAtPath :folderPath]) return 0 ;
    
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath :folderPath] objectEnumerator ];
    
    NSString * fileName;
    
    long long folderSize = 0 ;
    
    while ((fileName = [childFilesEnumerator nextObject ]) != nil ){
        
        NSString * fileAbsolutePath = [folderPath stringByAppendingPathComponent :fileName];
        
        folderSize += [ self fileSizeAtPath :fileAbsolutePath];
        
    }
    
    return folderSize/( 1024.0 * 1024.0 );
    
}

@end
