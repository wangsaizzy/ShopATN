//
//  UserModel.h
//  @的你
//
//  Created by 吴明飞 on 16/4/5.
//  Copyright © 2016年 吴明飞. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LoginModel.h"

@interface UserModel : NSObject
@property (nonatomic, strong) LoginModel *user;

@property (nonatomic, copy) NSString *token;

@property (nonatomic, strong) NSNumber *shopId;
@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSString *accountNumber;
@property (nonatomic, copy) NSString *password;//密码

@property (nonatomic, copy) NSString *shopName;//商户名称

@property (nonatomic, copy) NSString *portraitUrl;

@property (nonatomic, copy) NSString *accountNo;

@property (nonatomic, assign) BOOL isAppLogin;

@property (nonatomic, strong) NSDate *loginTime;

@property (nonatomic, strong) NSNumber *longitude;
@property (nonatomic, strong) NSNumber *latitude;


//单例模式
+ (UserModel *)defaultModel;

- (void)clearUserModel;
@end
