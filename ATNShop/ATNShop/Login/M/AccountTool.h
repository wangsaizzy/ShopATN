//
//  AccountTool.h
//  ATNShopDemo
//
//  Created by 吴明飞 on 16/8/1.
//  Copyright © 2016年 吴明飞. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Account;
@interface AccountTool : NSObject




//需要存储的账号信息
+(void)saveAccount:(Account *)account;
//返回要存储的账号信息

+ (void)clearAccount;

+ (NSString *)unarchiveToken;

+ (NSString *)unarchiveShopId;

@end
