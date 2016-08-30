//
//  TimeTool.m
//  ATN
//
//  Created by 吴明飞 on 16/8/2.
//  Copyright © 2016年 王赛. All rights reserved.
//

#import "TimeTool.h"

#define AccountFile [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"time.data"]

@implementation TimeTool


+ (void)saveLoginDate:(NSDate *)loginDate {
    
    [NSKeyedArchiver archiveRootObject:loginDate toFile:AccountFile];
}

+ (NSDate *)unarchiveLoginDate {
    
    return [NSKeyedUnarchiver unarchiveObjectWithFile:AccountFile];
}

+ (void)clearTimeFile {
    
    NSFileManager *manager = [NSFileManager defaultManager];
    
    [manager removeItemAtPath:AccountFile error:nil];
}


//从文件解析对象的时候调用
-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        self.loginDate = [aDecoder decodeObjectForKey:@"loginDate"];
    }
    return self;
}
//将对象写入文件的时候调用
-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.loginDate forKey:@"loginDate"];
    
    
    
}

@end
