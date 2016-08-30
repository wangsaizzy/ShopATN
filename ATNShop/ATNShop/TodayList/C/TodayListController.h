//
//  TodayListController.h
//  ATN
//
//  Created by 吴明飞 on 16/4/28.
//  Copyright © 2016年 王赛. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TodayListController : UIViewController

@property (nonatomic, strong) UIScrollView *mainScrollView;

@property (nonatomic, assign) NSInteger indexOfBtn;

@property (nonatomic, assign) BOOL isPush;


@end
