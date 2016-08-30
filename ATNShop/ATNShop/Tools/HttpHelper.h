//
//  HttpHelper.h
//  @的你
//
//  Created by 吴明飞 on 16/4/23.
//  Copyright © 2016年 吴明飞. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface HttpHelper : NSObject


//普通POST请求
+ (void)post:(NSString *)URL param:(NSDictionary *)param finishBlock:(void (^) (NSURLResponse *response, NSData *data, NSError *connectionError)) block;





//AFN数据请求
+ (void)requestUrl:(NSString *)url
           success:(void (^)(id json))success
           failure:(void (^) (NSError *error)) failure;



//带参数GET请求
+ (void)requestMethod:(NSString *)method
               urlString:(NSString *)urlString
                parma:(NSDictionary *)param
              success:(void (^)(id json))success
              failure:(void (^) (NSError *error)) failure;


//AFN请求
+ (void)requestMethod:(NSString *)method
               urlStr:(NSString *)urlStr
                parma:(NSDictionary *)param
              success:(void (^)(id json))success
              failure:(void (^) (NSError *error)) failure;




//上传图片
+ (void)uploadFileWithMethod:(NSString *)method
                         URL:(NSString *)urlPath
                        name:(NSString *)name
                    fileName:(NSString *)fileName
                       param:(NSDictionary *)param
                       image:(UIImage *)image
                     success:(void (^) (id json))success
                     failure:(void (^) (NSError *error)) failure
                    progress:(void (^) (long long totalBytesWritten, long long totalBytesExpectedToWrite))progress;



/**
 *  上传文件接口
 *
 *  @param fileData      数据
 *  @param name          名称
 *  @param fileName      文件名称
 *  @param mimeType      文件类型
 */
+(void)uploadFile:(NSData *)fileData name:(NSString *)name fileName:(NSString *)fileName mimeType:(NSString *)mimeType Success:(void (^)(id sucess))sucess fail:(void (^)(NSError *))fail ;

/**
 *  上传多张图片接口
 *
 *  @param array      数据
 */
+(void)uploadManyFile:(NSArray *)array   Success:(void (^)(NSArray *success))sucess fail:(void (^)(NSError *))fail ;

@end
