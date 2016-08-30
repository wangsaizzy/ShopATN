//
//  HttpHelper.m
//  @的你
//
//  Created by 吴明飞 on 16/4/23.
//  Copyright © 2016年 吴明飞. All rights reserved.
//

#import "HttpHelper.h"
#import "AFNetworking.h"
#import "UpLoadImageHelper.h"
@implementation HttpHelper

//普通POST请求
+ (void)post:(NSString *)URL param:(NSDictionary *)param finishBlock:(void (^) (NSURLResponse *response, NSData *data, NSError *connectionError)) block {
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@", Service_Url, URL];
    NSString *urlStr = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    //把传进来的URL字符串变为URL地址
    NSURL *url = [NSURL URLWithString:urlStr];
    
    //请求初始化
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:10];
    
    //解析请求参数，用NSDictionary来存参数，通过自定义的函数把它解析成post格式的字符串
    NSString *parseParam = [self setDictionaryToString:param];
    
    NSData *postData = [parseParam dataUsingEncoding:NSUTF8StringEncoding];
    
    
    //设置请求体
    [request setHTTPBody:postData];
    
    //设置请求方法
    [request setHTTPMethod:@"POST"];
    
    
    
    //创建一个新的队列
    NSOperationQueue *queue = [NSOperationQueue new];
    
    //发送异步请求，请求完以后返回的数据，通过completionHandler参数来调用
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:block];
}




//字典转字符串
+ (NSString *)setDictionaryToString:(NSDictionary *)dic {
    
    NSString *keyValueFormat;
    NSMutableString *result = [NSMutableString new];
    //实例化一个key枚举器用来存放dictionary的key
    NSEnumerator *keyEnum = [dic keyEnumerator];
    id key;
    while (key = [keyEnum nextObject]) {
        keyValueFormat = [NSString stringWithFormat:@"%@=%@&",key,[dic valueForKey:key]];
        [result appendString:keyValueFormat];
    }
    return result;
}

//AFN数据请求
+ (void)requestUrl:(NSString *)url success:(void (^)(id))success failure:(void (^)(NSError *))failure {
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@", Service_Url, url];
    NSString *newStr = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURL *URL = [NSURL URLWithString:newStr];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:20];
    
    NSString *token = [NSString stringWithFormat:@"%@", [AccountTool unarchiveToken]];
    
    [request setValue:token forHTTPHeaderField:@"Authorization"];
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        
            
            if (!error) {
                
                NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)response;
                if ([httpResponse respondsToSelector:@selector(allHeaderFields)]) {
                    
                    // 取得http状态码
                    
                    NSInteger code = [httpResponse statusCode];
                    
                    if (code == 200) {
                        
                        
                        if ([responseObject isKindOfClass:[NSDictionary class]]) {
                            
                            
                            NSString *message = responseObject[@"message"];
                            if ([message isEqualToString:@"成功"]) {
                                
                                if (![responseObject isEqual:[NSNull null]]) {
                                    
                                    success(responseObject);
                                } else {
                                    
                                    [SVProgressHUD showInfoWithStatus:@"暂无数据"];
                                }
                                
                                
                            } else {
                                
                                [SVProgressHUD showInfoWithStatus:message];
                            }
                            
                        }
                        
                        
                        
                        
                    } else if (code == 400 || code == 401 || code == 403) {
                        
                        [SVProgressHUD showInfoWithStatus:@"请求不合法"];
                        
                    } else if (code == 404) {
                        
                        [SVProgressHUD showInfoWithStatus:@"未知异常"];
                    } else if (code == 500 || code == 505) {
                        
                        [SVProgressHUD showInfoWithStatus:@"服务器异常"];
                    }
                }
                
            }  else {
                
                failure(error);
            }

        
    }];
    [dataTask resume];
}

+ (void)requestMethod:(NSString *)method urlString:(NSString *)urlString parma:(NSDictionary *)param success:(void (^)(id))success failure:(void (^)(NSError *))failure {
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@", Service_Url, urlString];
    NSString *newStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [SVProgressHUD setMinimumDismissTimeInterval:1];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    
    NSString *token = [NSString stringWithFormat:@"%@", [AccountTool unarchiveToken]];
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:method URLString:newStr parameters:param error:nil];
    
    [request setValue:token forHTTPHeaderField:@"Authorization"];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            
            failure(error);
        } else {
            
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)response;
            if ([httpResponse respondsToSelector:@selector(allHeaderFields)]) {
                
                // 取得http状态码
                
                NSInteger code = [httpResponse statusCode];
                
                if (code == 200) {
                    
                    if ([responseObject isKindOfClass:[NSDictionary class]]) {
                        
                        [SVProgressHUD dismiss];
                        NSString *message = responseObject[@"message"];
                        if ([message isEqualToString:@"成功"]) {
                            
                            success(responseObject);
                        } else {
                            
                            [SVProgressHUD showInfoWithStatus:message];
                        }
                        
                    }
                    
                } else if (code == 400 || code == 401 || code == 403) {
                    
                    [SVProgressHUD showInfoWithStatus:@"请求不合法"];
                    
                } else if (code == 404) {
                    
                    [SVProgressHUD showInfoWithStatus:@"未知异常"];
                } else if (code == 500 || code == 505) {
                    
                    [SVProgressHUD showInfoWithStatus:@"服务器异常"];
                }
            }

        }
    }];
    [dataTask resume];
//    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
//    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
//            
//            if (!connectionError) {
//    
//                NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)response;
//                if ([httpResponse respondsToSelector:@selector(allHeaderFields)]) {
//    
//                    // 取得http状态码
//                    
//                    NSInteger code = [httpResponse statusCode];
//    
//                    if (code == 200) {
//    
//                        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
//                        if ([dict isKindOfClass:[NSDictionary class]]) {
//    
//                            [SVProgressHUD dismiss];
//                            NSString *message = dict[@"message"];
//                            if ([message isEqualToString:@"成功"]) {
//    
//                                success(dict);
//                            } else {
//    
//                                [SVProgressHUD showInfoWithStatus:message];
//                            }
//    
//                        }
//    
//                    } else if (code == 400 || code == 401 || code == 403) {
//    
//                        [SVProgressHUD showInfoWithStatus:@"请求不合法"];
//    
//                    } else if (code == 404) {
//    
//                        [SVProgressHUD showInfoWithStatus:@"未知异常"];
//                    } else if (code == 500 || code == 505) {
//    
//                        [SVProgressHUD showInfoWithStatus:@"服务器异常"];
//                    }
//                }
//    
//            } else {
//                
//                failure(connectionError);
//            }
//        }];
    
   

}

+ (void)requestMethod:(NSString *)method urlStr:(NSString *)urlStr parma:(NSDictionary *)param success:(void (^)(id))success failure:(void (^)(NSError *))failure {

    NSString *urlString = [NSString stringWithFormat:@"%@%@", Service_Url, urlStr];
    NSString *newStr = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
     [SVProgressHUD setMinimumDismissTimeInterval:1];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    
    NSString *token = [NSString stringWithFormat:@"%@", [AccountTool unarchiveToken]];

    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:method URLString:newStr parameters:param constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
    } error:nil];
    
    [request setValue:token forHTTPHeaderField:@"Authorization"];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    NSURLSessionUploadTask *uploadTask;
    uploadTask = [manager
                  uploadTaskWithStreamedRequest:request
                  progress:^(NSProgress * _Nonnull uploadProgress) {
                     
                  }
                  completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
                      
                      
                      
                      if (!error) {
                          
                          NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)response;
                          if ([httpResponse respondsToSelector:@selector(allHeaderFields)]) {
                              
                              // 取得http状态码
                              
                              NSInteger code = [httpResponse statusCode];
                              
                              if (code == 200) {
                                  if ([responseObject isKindOfClass:[NSDictionary class]]) {
                                      
                                      NSString *message = responseObject[@"message"];
                                      if ([message isEqualToString:@"成功"]) {
                                          
                                          success(responseObject);
                                      } else {
                                          
                                          [SVProgressHUD showInfoWithStatus:message];
                                      }
                                      
                                  }
                                  
                              } else if (code == 400 || code == 401 || code == 403) {
                                  
                                  [SVProgressHUD showInfoWithStatus:@"请求不合法"];
                                  
                              } else if (code == 404) {
                                  
                                  [SVProgressHUD showInfoWithStatus:@"未知异常"];
                              } else if (code == 500 || code == 505) {
                                  
                                  [SVProgressHUD showInfoWithStatus:@"服务器异常"];
                              }
                          }
                          
                      } else {
                          
                          failure(error);
                      }

                  }];
    
    [uploadTask resume];
    

   
    
}
                            


//上传头像
+ (void)uploadFileWithMethod:(NSString *)method
                         URL:(NSString *)urlPath
                        name:(NSString *)name
                    fileName:(NSString *)fileName
                       param:(NSDictionary *)param
                       image:(UIImage *)image
                     success:(void (^)(id))success
                     failure:(void (^)(NSError *))failure
                    progress:(void (^)(long long, long long))progress {
    if (!image) {
        //执行失败操作代码块
        if (failure) {
            NSError *error = [[NSError alloc] initWithDomain:@"请选择图片上传，图片不能不空" code:0 userInfo:nil];
            failure(error);
        }
        return;
    }
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@", Service_Url, urlPath];
    NSString *urlStr = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *token = [NSString stringWithFormat:@"%@", [AccountTool unarchiveToken]];
    
    AFHTTPRequestSerializer *serializer = [AFHTTPRequestSerializer serializer];
     [SVProgressHUD setMinimumDismissTimeInterval:1];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD showWithStatus:@"加载中..."];

    NSMutableURLRequest *request = [serializer multipartFormRequestWithMethod:method URLString:urlStr parameters:param constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        NSData *imageData = UIImageJPEGRepresentation(image, 0.3);
        [formData appendPartWithFileData:imageData name:name fileName:fileName mimeType:@"image/jpg"];
        
    } error:nil];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    [request setValue:token forHTTPHeaderField:@"Authorization"];
    
    NSURLSessionUploadTask *uploadTask = [manager uploadTaskWithStreamedRequest:request progress:^(NSProgress *uploadProgress) {
        
        
        
    } completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
       
        if (!error) {
            
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)response;
            if ([httpResponse respondsToSelector:@selector(allHeaderFields)]) {
                
                // 取得http状态码
                
                NSInteger code = [httpResponse statusCode];
                
                if (code == 200) {
                    if ([responseObject isKindOfClass:[NSDictionary class]]) {
                        
                        NSString *message = responseObject[@"message"];
                        if ([message isEqualToString:@"成功"]) {
                            
                            success(responseObject);
                        } else {
                            
                            [SVProgressHUD showInfoWithStatus:message];
                        }
                        
                    }

                } else if (code == 400 || code == 401 || code == 403) {
                    
                    [SVProgressHUD showInfoWithStatus:@"请求不合法"];
                    
                } else if (code == 404) {
                    
                    [SVProgressHUD showInfoWithStatus:@"未知异常"];
                } else if (code == 500 || code == 505) {
                    
                    [SVProgressHUD showInfoWithStatus:@"服务器异常"];
                }
            }

        } else {
            
            failure(error);
        }

    }];
    [uploadTask resume];
}

/**
 *  上传图片接口
 *
 */
+(void)uploadFile:(NSData *)fileData name:(NSString *)name fileName:(NSString *)fileName mimeType:(NSString *)mimeType Success:(void (^)(id success))sucess fail:(void (^)(NSError *))fail  {
    
    NSString *urlString = [NSString stringWithFormat:@"%@/shop/shop/%@/album", Service_Url, [AccountTool unarchiveShopId]];
    
    NSString *urlStr = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    AFHTTPRequestSerializer *serializer = [AFHTTPRequestSerializer serializer];
    
    [SVProgressHUD show];
    NSMutableURLRequest *request = [serializer multipartFormRequestWithMethod:@"PUT" URLString:urlStr parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        if (fileData!=nil) {
            [formData appendPartWithFileData:fileData name:name fileName:fileName mimeType:mimeType];
        }
    } error:nil];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSString *value = [NSString stringWithFormat:@"%@", [AccountTool unarchiveToken]];
    [request setValue:value forHTTPHeaderField:@"Authorization"];
    
    NSURLSessionUploadTask *uploadTask = [manager uploadTaskWithStreamedRequest:request progress:^(NSProgress *uploadProgress) {
        
    } completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (!error) {
            [SVProgressHUD dismiss];
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)response;
            if ([httpResponse respondsToSelector:@selector(allHeaderFields)]) {
                
                // 取得http状态码
                NSLog(@"%ld",[httpResponse statusCode]);
                NSInteger code = [httpResponse statusCode];
                
                if (code == 200) {
                    
                    if ([responseObject isKindOfClass:[NSDictionary class]]) {
                        
                        NSString *message = responseObject[@"message"];
                        if ([message isEqualToString:@"成功"]) {
                            [SVProgressHUD showSuccessWithStatus:@"上传成功"];
                           
                            sucess(responseObject);
                            NSLog(@"======%@", responseObject);

                        } else {
                            
                            [SVProgressHUD showInfoWithStatus:message];
                        }
                        
                    }


                } else if (code == 400 || code == 401 || code == 403) {
                    
                    [SVProgressHUD showInfoWithStatus:@"请求不合法"];
                    
                } else if (code == 404) {
                    
                    [SVProgressHUD showInfoWithStatus:@"未知异常"];
                } else if (code == 500 || code == 505) {
                    
                    [SVProgressHUD showInfoWithStatus:@"服务器出错"];
                }
            } else {
                fail(error);
            }

        }
    }];
    [uploadTask resume];
    
}


/**
 *  上传多张图片接口
 *
 *  @param array      数据
 */
+(void)uploadManyFile:(NSArray *)array Success:(void (^)(NSArray *success))sucess fail:(void (^)(NSError *))fail {
    NSMutableArray *arrayUrl=[[NSMutableArray alloc]init];
    NSString *miniType=@"image/jpg";
    __block NSUInteger currentIndex=0;
    UpLoadImageHelper *uploadHelper=[UpLoadImageHelper sharedInstance];
    __weak UpLoadImageHelper *weakhelper=uploadHelper;
    weakhelper.singleFailureBlock=^(NSError *error){
        
        [SVProgressHUD showInfoWithStatus:@"服务器出错"];
    };
    weakhelper.singleSuccessBlock=^(id success){
        
                
                //这里返回的数据需要解析哈一般的data里面的数据
                NSDictionary *dicdata=(NSDictionary *)success;
        
                NSArray *temparray=dicdata[@"data"][@"img"][@"album"];
                [arrayUrl addObject:temparray[0]];
                currentIndex++;
                if ([array count]==[arrayUrl count]) {
                    sucess(arrayUrl);
                    return ;
                }else{
                    UIImage *imageone=array[currentIndex];
                    NSData *imageData= UIImageJPEGRepresentation(imageone, 0.3);
                    NSString *imagename=[NSString stringWithFormat:@"image"];
                    NSString *filename=[NSString stringWithFormat:@"image%ld.jpg",currentIndex];
                    
                    [HttpHelper uploadFile:imageData name:imagename fileName:filename mimeType:miniType Success:weakhelper.singleSuccessBlock fail:weakhelper.singleFailureBlock];
                }
        
    };
    if (array.count == 0) {
        ShowAlertView(@"请选择图片");
        return;
    }
    
    UIImage *imageone=array[0];
    NSData *dataObj = UIImageJPEGRepresentation(imageone, 0.3);
    
    [HttpHelper uploadFile:dataObj name:@"image" fileName:@"image.jpg" mimeType:miniType Success:weakhelper.singleSuccessBlock fail:weakhelper.singleFailureBlock];
    
    
}




@end
