//
//  UpLoadImageHelper.h
//  ATN
//
//  Created by 吴明飞 on 16/6/14.
//  Copyright © 2016年 王赛. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UpLoadImageHelper : NSObject
@property (copy, nonatomic) void (^singleSuccessBlock)(id success);
@property (copy, nonatomic)  void (^singleFailureBlock)(NSError *);

+ (instancetype)sharedInstance;
@end
