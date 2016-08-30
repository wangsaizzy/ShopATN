//
//  SearchResultView.h
//  ATNShopDemo
//
//  Created by 吴明飞 on 16/7/10.
//  Copyright © 2016年 吴明飞. All rights reserved.
//

#import <UIKit/UIKit.h>
@class POIAnnotation;
typedef void(^selectBlock)(POIAnnotation *annotation);

@interface SearchResultView : UIView
@property (nonatomic, strong)UIView *topView;
@property (nonatomic, strong)NSArray *dataSource;
@property (nonatomic, strong)POIAnnotation *annotation;
@property (nonatomic, copy)selectBlock finishBlock;
@end
