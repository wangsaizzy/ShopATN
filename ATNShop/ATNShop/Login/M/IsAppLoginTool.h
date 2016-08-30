//
//  IsAppLoginTool.h
//  ATN
//
//  Created by 吴明飞 on 16/8/2.
//  Copyright © 2016年 王赛. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IsAppLoginTool : NSObject

@property (nonatomic, assign) BOOL isAppLogin;//用户token

//需要存储的账号信息
+(void)saveIsAppLogin:(BOOL)isAppLogin;
//返回要存储的账号信息

+ (void)clearIsAppLogin;

+ (BOOL)unarchiveIsAppLogin;
@end
