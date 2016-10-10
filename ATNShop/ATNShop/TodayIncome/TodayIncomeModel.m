//
//  TodayIncomeModel.m
//  ATNShop
//
//  Created by 王赛 on 16/10/10.
//  Copyright © 2016年 王赛. All rights reserved.
//

#import "TodayIncomeModel.h"

@implementation TodayIncomeModel

- (instancetype ) initWithDic:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dic];
        
    }
    return self;
    
}

-(void) setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

@end
