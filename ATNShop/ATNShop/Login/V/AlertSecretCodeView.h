//
//  AlertSecretCodeView.h
//  ATN
//
//  Created by 吴明飞 on 16/6/3.
//  Copyright © 2016年 王赛. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AlertSecretCodeView : UIView
@property (nonatomic, strong) UITextField *phoneNumberTF;
@property (nonatomic, strong) UITextField *bringTestNumberTF;
@property (nonatomic, strong) UITextField *reSetSecretNumberTF;
@property (nonatomic, strong) UITextField *SecretNumberTF;
@property (nonatomic, strong) UIButton *acquireTestBtn;

@property (nonatomic, strong) UIButton *commitBtn;
@end
