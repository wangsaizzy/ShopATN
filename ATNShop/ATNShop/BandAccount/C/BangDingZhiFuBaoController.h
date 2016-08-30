//
//  BangDingZhiFuBaoController.h
//  @的你
//
//  Created by 吴明飞 on 16/3/25.
//  Copyright © 2016年 吴明飞. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AccountNumberProtocol <NSObject>

- (void)accountNumber:(NSString *)accountNum;

@end

@interface BangDingZhiFuBaoController : UIViewController
@property (nonatomic, copy) void(^accountNumber)(NSString *);

@property (nonatomic, assign) id<AccountNumberProtocol>delegate;
@end
