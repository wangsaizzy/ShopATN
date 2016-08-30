//
//  IsAppLoginTool.m
//  ATN
//
//  Created by 吴明飞 on 16/8/2.
//  Copyright © 2016年 王赛. All rights reserved.
//

#import "IsAppLoginTool.h"

#define AccountFile [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"isAppLogin.data"]
@implementation IsAppLoginTool

+ (void)saveIsAppLogin:(BOOL)isAppLogin {
    
    
    NSString *login = [NSString stringWithFormat:@"%d", isAppLogin];
    [NSKeyedArchiver archiveRootObject:login toFile:AccountFile];
}

+ (BOOL)unarchiveIsAppLogin {
    
    NSString *isAppLogin = [NSKeyedUnarchiver unarchiveObjectWithFile:AccountFile];
    
    return [isAppLogin boolValue];
}

+ (void)clearIsAppLogin {
    
    NSFileManager *manager = [NSFileManager defaultManager];
    
    [manager removeItemAtPath:AccountFile error:nil];
}

//从文件解析对象的时候调用
-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        
        self.isAppLogin = [aDecoder decodeBoolForKey:@"isAppLogin"];
        
        
        
    }
    return self;
}
//将对象写入文件的时候调用
-(void)encodeWithCoder:(NSCoder *)aCoder
{
    
    [aCoder encodeBool:self.isAppLogin forKey:@"isAppLogin"];
    
    
}

@end
