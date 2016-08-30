//
//  NSString+size.h


//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (size)


//根据文字显示的区域以及大小，计算最终显示所需要的空间
-(CGSize)sizeWithFont:(UIFont *)font Size:(CGSize)size;

@end
