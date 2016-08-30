//
//  PlaceholderTextView.h
//  ATNShopDemo
//
//  Created by 吴明飞 on 16/6/28.
//  Copyright © 2016年 吴明飞. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlaceholderTextView : UITextView

@property (nonatomic, strong) UILabel * placeHolderLabel;

@property (nonatomic, copy) NSString * placeholder;

@property (nonatomic, strong) UIColor * placeholderColor;

- (void)textChanged:(NSNotification * )notification;

@end
