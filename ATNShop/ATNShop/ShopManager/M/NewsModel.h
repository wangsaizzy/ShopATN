//
//  NewsModel.h
//  ATNShopDemo
//
//  Created by 吴明飞 on 16/7/12.
//  Copyright © 2016年 吴明飞. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewsModel : NSObject
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *createtime;
- (instancetype)initWithNewsId:(NSString *)newsId
                      content:(NSString *)content
                  createtime:(NSString *)createtime;
@end
