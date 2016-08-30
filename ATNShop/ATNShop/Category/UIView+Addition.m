//
//  UIView+Addition.m
//  @的你
//
//  Created by 吴明飞 on 16/3/15.
//  Copyright © 2016年 吴明飞. All rights reserved.
//

#import "UIView+Addition.h"

@implementation UIView (Addition)


- (CGFloat)centerX {
    return self.center.x;
}



- (void)setCenterX:(CGFloat)centerX {
    self.center = CGPointMake(centerX, self.center.y);
}


- (CGFloat)centerY {
    return self.center.y;
}



- (void)setCenterY:(CGFloat)centerY {
    self.center = CGPointMake(self.center.x, centerY);
}


- (CGFloat)width {
    return self.frame.size.width;
}



- (void)setWidth:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}



- (CGFloat)height {
    return self.frame.size.height;
}



- (void)setHeight:(CGFloat)height {
    if(height == self.height){
        return;
    }
    
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}
@end
