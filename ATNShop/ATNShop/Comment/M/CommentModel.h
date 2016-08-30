//
//  CommentModel.h
//  ATNShopDemo
//
//  Created by 吴明飞 on 16/6/24.
//  Copyright © 2016年 吴明飞. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommentModel : NSObject
@property (nonatomic, strong) NSArray *img;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, strong) NSNumber *star;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *userPortrait;

- (instancetype)initWithDic:(NSDictionary *)dic;
@end
