//
//  UserCommentCell.m
//  @的你
//
//  Created by 吴明飞 on 16/3/31.
//  Copyright © 2016年 吴明飞. All rights reserved.
//

#import "UserCommentCell.h"
#import "CommentModel.h"
#import "FYPhotoBrowser.h"
#import "UIImageView+WebCache.h"
#import "FYImageView.h"

@interface UserCommentCell()

@property (nonatomic, strong) NSMutableArray *imageArr;

@end

@implementation UserCommentCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addSubview:self.userImage];
        [self addSubview:self.userNameLabel];
        [self addSubview:self.standardLabel];
        [self addSubview:self.timeLabel];
        [self addSubview:self.contentLabel];
        [self addSubview:self.typeLabel];
    
    }
    return self;
}



#pragma mark -懒加载
//用户头像
- (UIImageView *)userImage {
    if (!_userImage) {
        self.userImage = [[UIImageView alloc] initWithFrame:CGRectMake(20 * kMulriple, 10 * kHMulriple, 50 * kMulriple, 50 * kHMulriple)];
        self.userImage.layer.cornerRadius = 25 * kMulriple;
        self.userImage.layer.masksToBounds = YES;
        
    }
    return _userImage;
}

//用户名
- (UILabel *)userNameLabel {
    if (!_userNameLabel) {
        self.userNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(80 * kMulriple, 10 * kHMulriple, 100 * kMulriple, 20 * kHMulriple)];
        _userNameLabel.font = [UIFont systemFontOfSize:16 * kMulriple];
        _userNameLabel.textColor = RGB(111, 111, 111);
    }
    return _userNameLabel;
}

- (UILabel *)typeLabel {
    
    if (!_typeLabel) {
        
        self.typeLabel = [[UILabel alloc] initWithFrame:CGRectMake(80 * kMulriple, 35 * kHMulriple, 100 * kMulriple, 25 * kHMulriple)];
        self.typeLabel.text = @"线下交易";
        _typeLabel.font = [UIFont systemFontOfSize:16 * kMulriple];
        _typeLabel.textColor = RGB(111, 111, 111);
        
    }
    return _typeLabel;
}


//产品规格
-standardLabel {
    if (!_standardLabel) {
        self.standardLabel = [[UILabel alloc] initWithFrame:CGRectMake(70 * kMulriple, 32 * kHMulriple, 80 * kMulriple, 18 * kHMulriple)];
        _standardLabel.font = [UIFont systemFontOfSize:17 * kMulriple];
        _standardLabel.textColor = RGB(111, 111, 111);
    }
    return _standardLabel;
}

//时间
- (UILabel *)timeLabel {
    if (!_timeLabel) {
        self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(295 * kMulriple, 10 * kHMulriple, 40 * kMulriple, 20 * kHMulriple)];
        _timeLabel.font = [UIFont systemFontOfSize:17 * kMulriple];
        _timeLabel.textColor = RGB(111, 111, 111);
    }
    return _timeLabel;
}

//评论内容
- (UILabel *)contentLabel {
    if (!_contentLabel) {
        self.contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(20 * kMulriple, 70 * kHMulriple, 335 * kMulriple, 45)];
        self.contentLabel.textColor =RGB(111, 111, 111);
        self.contentLabel.font = [UIFont systemFontOfSize:14 * kMulriple];
        self.contentLabel.numberOfLines = 0;
        self.contentLabel.lineBreakMode = NSLineBreakByWordWrapping;
    }
    return _contentLabel;
}





- (void)setCommentModel:(CommentModel *)commentModel {
    
    if (_commentModel != commentModel) {
        
        _commentModel = commentModel;
    }
    
    self.userNameLabel.text = commentModel.userName;
    self.contentLabel.text = commentModel.content;

    self.contentLabel.frame = CGRectMake(20 * kMulriple, 80 * kHMulriple, 335 * kMulriple, [[self class] heightForContentText:self.contentLabel.text]);

    [self.userImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", Service_Url, commentModel.userPortrait]] placeholderImage:[UIImage imageNamed:@"userImage"]];
    
    self.imageArr = [NSMutableArray array];
    if (commentModel.img.count >0) {
        
        for (NSDictionary *dic in commentModel.img) {
            NSString *url = nil;
            
            url = [NSString stringWithFormat:@"%@%@", Service_Url, dic[@"url"]];
            [_imageArr addObject:url];
        }
        
        for (int i = 0; i < commentModel.img.count; i++) {
            
            FYImageView *im =[[FYImageView alloc]initWithFrame:CGRectMake(i * 80 * kMulriple + 20 * kMulriple, [UserCommentCell heightForContentText:commentModel.content] + 90 * kHMulriple, 70 * kMulriple, 70 * kHMulriple)];
            [im addTarget:self action:@selector(cellClick:)];
            //im.contentMode = UIViewContentModeScaleAspectFit;
            [im  sd_setImageWithURL:[NSURL URLWithString:_imageArr[i]] placeholderImage:[UIImage imageNamed:@"list"]];
            im.tag = i ;
            [self.contentView addSubview:im];
            
        }
        
        
        
    } else if (commentModel.img.count == 0) {
        
        //[self.im removeFromSuperview];
    }

        
    
    
    //通用-评价_小
    
    NSInteger starCount = [commentModel.star integerValue];
    switch (starCount) {
        case 1:{
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(260 * kMulriple, 10 * kHMulriple, 15 * kMulriple, 15 * kHMulriple)];
            imageView.image = [UIImage imageNamed:@"super"];
            [self addSubview:imageView];
        }
            break;
        case 2:{
            for (int i = 0; i < 2; i++) {
                
                UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(260 * kMulriple + i * 15 * kMulriple, 10 * kHMulriple, 15 * kMulriple, 15 * kHMulriple)];
                imageView.image = [UIImage imageNamed:@"super"];
                [self addSubview:imageView];
            }
            
        }
            break;
            
        case 3:{
            for (int i = 0; i < 3; i++) {
                
                UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(260 * kMulriple + i * 15 * kMulriple, 10 * kHMulriple, 15 * kMulriple, 15 * kHMulriple)];
                imageView.image = [UIImage imageNamed:@"super"];
                [self addSubview:imageView];
            }
            
        }
            break;
            
        case 4:{
            for (int i = 0; i < 4; i++) {
                
                UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(260 * kMulriple + i * 15 * kMulriple, 10 * kHMulriple, 15 * kMulriple, 15 * kHMulriple)];
                imageView.image = [UIImage imageNamed:@"super"];
                [self addSubview:imageView];
            }
            
        }
            break;
            
        case 5:{
            for (int i = 0; i < 5; i++) {
                
                UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(260 * kMulriple + i * 15 * kMulriple, 10 * kHMulriple, 15 * kMulriple, 15 * kHMulriple)];
                imageView.image = [UIImage imageNamed:@"super"];
                [self addSubview:imageView];
            }
            
        }
            break;
            
        default:
            break;
    }
}

-(void)cellClick:(UITapGestureRecognizer *)tap
{
    NSInteger index = tap.view.tag ;
    NSArray *dataArr = _imageArr;
    FYPhotoBrowser *photoWeb = [[FYPhotoBrowser alloc]initWithImageUrlString:dataArr atIndex:index FromView:self];
    photoWeb.isFromNet = YES;
    [photoWeb showWithView:tap.view];
    
}


//提供外部接口 动态返回cell的高度
+ (CGFloat)heightForRowWithCommentModel:(CommentModel *)commentModel{
    

    return [self heightForContentText:commentModel.content] + 175 * kHMulriple;
  
   
}

//动态计算文本的高度
+ (CGFloat)heightForContentText:(NSString *)text{
    //文本渲染时需要一个矩形的大小 第一个参数:size 在限定的范围(宽高区域内) size(控件的宽度, 尽量大的高度值)
    //attributes属性:设置的字体大小要和控件(contentLabel)的字体大小匹配一致 避免出现计算偏差
    
    CGSize boudingSize = CGSizeMake(335, 300);
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:14]};
    return [text boundingRectWithSize:boudingSize options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attributes context:nil].size.height;
}



@end
