//
//  NewsModel.m
//  ATNShopDemo
//
//  Created by 吴明飞 on 16/7/12.
//  Copyright © 2016年 吴明飞. All rights reserved.
//

#import "NewsModel.h"

@implementation NewsModel
- (instancetype)initWithNewsId:(NSString *)newsId content:(NSString *)content createtime:(NSString *)createtime {
    
    self = [super init];
    if (self) {
        
        self.id = newsId;
        self.content = content;
        self.createtime = createtime;
    }
    return self;
}
@end
