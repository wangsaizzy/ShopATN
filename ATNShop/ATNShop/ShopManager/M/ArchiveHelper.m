//
//  ArchiveHelper.m
//  ATNShopDemo
//
//  Created by 吴明飞 on 16/8/1.
//  Copyright © 2016年 吴明飞. All rights reserved.
//

#import "ArchiveHelper.h"
#import "UserModel.h"
@implementation ArchiveHelper
//+ (void)archiveUserModel:(UserModel *)model {
//    
//    //将per转化为NSData对象
//    NSMutableData *data = [NSMutableData data];
//    //创建归档对象 工具
//    NSKeyedArchiver *archive = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
//   
//    
//    [archive encodeObject:model forKey:@"userModel"];
//    //结束归档
//    [archive finishEncoding];
//    
//    //写入文件
//    BOOL isSuccess = [data writeToFile:[self filePath] atomically:YES];
//    
//    if (isSuccess == YES) {
//        
//        [SVProgressHUD showSuccessWithStatus:@"写入成功"];
//        
//    } else {
//        
//        
//    }
//    
//}
//
//+ (NSString *)filePath{
//   NSString *path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
//    
//    NSString *newPath = [path stringByAppendingPathComponent:@"userModel.data"];
//    //创建数据库文件管理对象
//    NSFileManager *fileManager = [NSFileManager defaultManager];
//    //判断文件夹是否存在 不存在则创建
//    if ([fileManager fileExistsAtPath:newPath] == NO) {
//        [fileManager createDirectoryAtPath:newPath withIntermediateDirectories:YES attributes:nil error:nil];
//    }
//
//    
//    return newPath;
//    
//}
//
//+ (UserModel *)unarchiveUserModel {
//    
//    NSData *data = [NSData dataWithContentsOfFile:[self filePath]];
//    //1.创建反归档对象 工具
//    NSKeyedUnarchiver *unArchive = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
//    //2.反归档
//    UserModel *model = [unArchive decodeObjectForKey:@"userModel"];
//    
//    
//    //3.结束反归档
//    [unArchive finishDecoding];
//    
//    return model;
//}
//
//+ (NSString *)unarchiveToken {
//
//    return [self unarchiveUserModel].token;
//}
//
//+ (NSNumber *)unarchiveShopId {
//    
//    return [self unarchiveUserModel].shopId;
//}
//
//+ (NSString *)unarchiveShopName {
//    
//    return [self unarchiveUserModel].shopName;
//}
//
//+ (NSString *)unarchiveportraitUrl {
//    
//    return [self unarchiveUserModel].portraitUrl;
//}
//
//+ (BOOL)unarchiveIsAppLogin {
//    
//    return [self unarchiveUserModel].isAppLogin;
//}
//
//+ (void)clearUserModelData {
//    
//    //移除缓存数据的文件夹 创建一个新的空文件夹
//    NSFileManager *manager = [NSFileManager defaultManager];
//    //获取缓存文件夹的路径
//    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
//    
//    NSString *newPath = [documentsPath stringByAppendingPathComponent:@"userModel.data"];
//    //移除文件夹
//    [manager removeItemAtPath:newPath error:nil];
//    
//    //创建一个新的文件夹
//    [manager createDirectoryAtPath:newPath withIntermediateDirectories:YES attributes:nil error:nil];
//
//}
@end
