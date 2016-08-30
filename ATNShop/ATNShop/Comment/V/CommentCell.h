//
//  CommentCell.h
//  ATNShopDemo
//
//  Created by 吴明飞 on 16/7/28.
//  Copyright © 2016年 吴明飞. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CommentModel;
@interface CommentCell : UITableViewCell
@property (nonatomic, strong) UIImageView *userImage;
@property (nonatomic, strong) UILabel *userNameLabel;
@property (nonatomic, strong) UILabel *standardLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *contentLabel;

@property (nonatomic, strong) CommentModel *commentModel;
@property (nonatomic, strong) UILabel *typeLabel;
+ (CGFloat)heightForRowWithModel:(CommentModel *)model;
+ (CGFloat)heightForContentText:(NSString *)text;

@end
