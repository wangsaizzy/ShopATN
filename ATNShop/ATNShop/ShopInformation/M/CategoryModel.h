//
//  CategoryModel.h
//  ATNShopDemo
//
//  Created by 吴明飞 on 16/7/13.
//  Copyright © 2016年 吴明飞. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CategoryModel : NSObject
@property (nonatomic, strong) NSNumber *id;
@property (nonatomic, copy) NSString *name;
- (instancetype)initWithDic:(NSDictionary *)dic;

@end
