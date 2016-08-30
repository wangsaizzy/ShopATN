//
//  TimeTool.h
//  ATN
//
//  Created by 吴明飞 on 16/8/2.
//  Copyright © 2016年 王赛. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TimeTool : NSObject
@property (nonatomic, strong) NSDate *loginDate;
+ (void)saveLoginDate:(NSDate *)loginDate;

+ (NSDate *)unarchiveLoginDate;

+ (void)clearTimeFile;
@end
