//
//  DropDownMenu.h
//  @你
//
//  Created by 吴明飞 on 16/5/18.
//  Copyright © 2016年 王赛. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DropDownMenu;
@class CategoryNextModel;
@protocol DropDownMenuDataSource <NSObject>

@required
- (NSInteger)menu:(DropDownMenu *)menu tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;

- (NSString *)menu:(DropDownMenu *)menu tableView:(UITableView *)tableView titleForRowAtIndexPath:(NSIndexPath *)indexPath;


@end

@protocol DropDownMenuDelegate <NSObject>

@optional
- (void)menu:(DropDownMenu *)menu tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface DropDownMenu : UIView<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *rightTableView;
@property (nonatomic, strong) UITableView *leftTableView;
@property (nonatomic, strong) UIView *transformView;

//设置代理
@property (nonatomic, assign) id<DropDownMenuDataSource>dataSource;
@property (nonatomic, assign) id<DropDownMenuDelegate>delegate;

- (instancetype)initWithOrigin:(CGPoint)origin andHeight:(CGFloat)height;

- (void)menuTapped;

@end
