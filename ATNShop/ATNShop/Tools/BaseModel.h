//
//  BaseModel.h
//  ATN
//
//  Created by 吴明飞 on 16/4/29.
//  Copyright © 2016年 王赛. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface BaseModel : JSONModel

@property (nonatomic, assign) NSInteger status;

@property (nonatomic, copy) NSString * info;

@property (nonatomic, strong) NSArray *data;

@property (nonatomic, assign) NSInteger isUser;

@end
