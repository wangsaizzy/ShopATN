//
//  UserModel.m
//  @的你
//
//  Created by 吴明飞 on 16/4/5.
//  Copyright © 2016年 吴明飞. All rights reserved.
//

#import "UserModel.h"

NSString *const k_UserDefaults_user = @"k_UserDefaults_user";

@implementation UserModel
static UserModel *singletonModel = nil;
+ (UserModel *)defaultModel {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        singletonModel = [[UserModel alloc] init];
    });
    return singletonModel;
}




////*************************用户信息****************************

- (void)setAccountNumber:(NSString *)accountNumber {
    
    [[NSUserDefaults standardUserDefaults] setObject:accountNumber forKey:@"accountNumber"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)accountNumber {
    
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"accountNumber"];
}

- (void)setPassword:(NSString *)password {
    [[NSUserDefaults standardUserDefaults] setObject:password forKey:@"password"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)password {
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"password"];
}
- (void)setShopName:(NSString *)shopName {
    
    [[NSUserDefaults standardUserDefaults] setObject:shopName forKey:@"shopName"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)shopName {
    
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"shopName"];
}


- (void)setLongitude:(NSNumber *)longitude {
    
    [[NSUserDefaults standardUserDefaults] setObject:longitude forKey:@"longitude"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSNumber *)longitude {
    
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"longitude"];
}

- (void)setLatitude:(NSNumber *)latitude {
    
    [[NSUserDefaults standardUserDefaults] setObject:latitude forKey:@"latitude"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSNumber *)latitude {
    
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"latitude"];
}

- (void)setPortraitUrl:(NSString *)portraitUrl {
    
    [[NSUserDefaults standardUserDefaults] setObject:portraitUrl forKey:@"portraitUrl"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)portraitUrl {
    
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"portraitUrl"];
}







- (void)setAccountNo:(NSString *)accountNo {
    
    [[NSUserDefaults standardUserDefaults] setObject:accountNo forKey:@"accountNo"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)accountNo {
    
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"accountNo"];
}


- (void)clearUserModel {
   
    // 先将其转化为字典，然后用forin遍历删除即可
    NSUserDefaults *defatluts = [NSUserDefaults standardUserDefaults];
    NSDictionary *dictionary = [defatluts dictionaryRepresentation];
    for(NSString *key in [dictionary allKeys]){
        [defatluts removeObjectForKey:key];
        [defatluts synchronize];
    }

}

////实现协议中的方法
//- (void)encodeWithCoder:(NSCoder *)aCoder{
//    [aCoder encodeObject:self.token forKey:@"token"];
//    [aCoder encodeObject:self.shopId forKey:@"shopId"];
//    [aCoder encodeObject:self.accountNumber forKey:@"accountNumber"];
//    [aCoder encodeObject:self.password forKey:@"password"];
//    [aCoder encodeObject:self.shopName forKey:@"shopName"];
//    [aCoder encodeObject:self.portraitUrl forKey:@"portraitUrl"];
//    
//    
//}
//- (id)initWithCoder:(NSCoder *)aDecoder{
//    self = [super init];
//    if (self) {
//        self.token = [aDecoder decodeObjectForKey:@"token"];
//        self.shopId = [aDecoder decodeObjectForKey:@"shopId"];
//        self.shopName = [aDecoder decodeObjectForKey:@"shopName"];
//        self.accountNumber = [aDecoder decodeObjectForKey:@"accountNumber"];
//        self.password = [aDecoder decodeObjectForKey:@"password"];
//        self.portraitUrl = [aDecoder decodeObjectForKey:@"portraitUrl"];
//        
//    }
//    return self;
//}



@end
