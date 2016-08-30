//
//  LoginView.h
//  @的你
//
//  Created by 吴明飞 on 16/3/14.
//  Copyright © 2016年 吴明飞. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginView : UIView
@property (nonatomic, strong) UIImageView *customerPhotoImageView;//头像
@property (nonatomic, strong) UITextField *accountNumberTF;//账号输入框
@property (nonatomic, strong) UITextField *secretNumberTF;//密码输入框
@property (nonatomic, strong) UIButton *forgetSecretBtn;//忘记密码按钮
@property (nonatomic, strong) UIButton *loginBtn;//商家登录按钮
@end
