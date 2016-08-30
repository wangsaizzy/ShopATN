//
//  UserCommentCell.h
//  @的你
//
//  Created by 吴明飞 on 16/3/31.
//  Copyright © 2016年 吴明飞. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CommentModel;
@interface UserCommentCell : UITableViewCell

//用来传递点击了 第几个button
@property (nonatomic, copy) void (^ClickIndex)(NSInteger);

@property (nonatomic, strong) UIImageView *userImage;
@property (nonatomic, strong) UILabel *userNameLabel;
@property (nonatomic, strong) UILabel *standardLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *contentLabel;

@property (nonatomic, strong) CommentModel *commentModel;
@property (nonatomic, strong) UILabel *typeLabel;
+ (CGFloat)heightForRowWithCommentModel:(CommentModel *)commentModel;
+ (CGFloat)heightForContentText:(NSString *)text;
@end
