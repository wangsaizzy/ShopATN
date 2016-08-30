//
//  AccountTool.m
//  ATNShopDemo
//
//  Created by 吴明飞 on 16/8/1.
//  Copyright © 2016年 吴明飞. All rights reserved.
//

#import "AccountTool.h"
#import "Account.h"
#define AccountFile [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"account.data"]


@implementation AccountTool
+(void)saveAccount:(Account *)account
{
    [NSKeyedArchiver archiveRootObject:account toFile:AccountFile];
}
+(Account *)account
{
    //取出账号
    Account *account = [NSKeyedUnarchiver unarchiveObjectWithFile:AccountFile];
    return account;
}

+ (NSString *)unarchiveToken {
    
    return [self account].token;
}

+ (NSString *)unarchiveShopId {
    
    return [self account].shopId;
}

+ (void)clearAccount {
    
   NSFileManager *manager = [NSFileManager defaultManager];
    
    [manager removeItemAtPath:AccountFile error:nil];
}

@end
