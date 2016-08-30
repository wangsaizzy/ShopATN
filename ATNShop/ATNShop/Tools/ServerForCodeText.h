//
//  ServerForCodeText.h
//  TestCodeJM
//
//  Created by szalarm on 16/2/29.
//  Copyright © 2016年 szalarm. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 加解密服务类,依赖
<GTMBase64.h>
 
 */
@interface ServerForCodeText : NSObject
#pragma mark public
//base64
+(NSString *) EncodeWithBase64:(NSString *) pRawStr;
+(NSString *) DecodeWithBase64:(NSString *) pBase64Str;

@end
