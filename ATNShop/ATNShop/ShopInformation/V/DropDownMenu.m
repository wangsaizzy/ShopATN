//
//  DropDownMenu.m
//  @你
//
//  Created by 吴明飞 on 16/5/18.
//  Copyright © 2016年 王赛. All rights reserved.
//


#import "DropDownMenu.h"
#import "CategoryNextModel.h"
@interface DropDownMenu ()

@property (nonatomic, assign) BOOL isShow;
@property (nonatomic, assign) CGPoint origin;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, strong) UIView *backGroundView;

@end

#define ScreenWidth      CGRectGetWidth([UIScreen mainScreen].applicationFrame)

@implementation DropDownMenu

- (instancetype)initWithOrigin:(CGPoint)origin andHeight:(CGFloat)height {
    CGSize screenSize = self.bounds.size;
    self = [self initWithFrame:CGRectMake(origin.x, origin.y, screenSize.width, 0)];
    if (self) {
        
        _origin = origin;
        _height = height;
        _isShow = NO;
        
        self.rightTableView = [[UITableView alloc] initWithFrame:CGRectMake(origin.x+ScreenWidth*0.7, self.frame.origin.y + self.frame.size.height, ScreenWidth*0.3, 0) style:UITableViewStylePlain];
        _rightTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _rightTableView.rowHeight = 38 * kHMulriple;
        _rightTableView.dataSource = self;
        _rightTableView.delegate = self;
        
        
        self.leftTableView = [[UITableView alloc] initWithFrame:CGRectMake(origin.x, self.frame.origin.y + self.frame.size.height, ScreenWidth * 0.7, 0) style:UITableViewStylePlain];
        _leftTableView.rowHeight = 38 * kHMulriple;
        _leftTableView.dataSource = self;
        _leftTableView.delegate = self;
        _leftTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _leftTableView.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.f];
        
        
        self.backgroundColor = [UIColor whiteColor];
        _backGroundView = [[UIView alloc] initWithFrame:CGRectMake(origin.x, origin.y, screenSize.width, screenSize.height)];
        _backGroundView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.0];
        _backGroundView.opaque = NO;
        UIGestureRecognizer *gesture = [[UIGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundTapped:)];
        [_backGroundView addGestureRecognizer:gesture];
        
        UIView *bottomShadow = [[UIView alloc] initWithFrame:CGRectMake(0, kHeight - 0.5, screenSize.width, 0.5)];
        bottomShadow.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:bottomShadow];
    }
    return self;
}

#pragma mark - gesture Action
- (void)menuTapped {
    
    if (!_isShow) {
        
        NSIndexPath *selectedIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [self.leftTableView selectRowAtIndexPath:selectedIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    }
    
    [self animationBackGroundView:self.backGroundView isShow:!_isShow complete:^{
       
        [self animateTableViewIsShow:!_isShow complete:^{
           
            [self tableView:self.leftTableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
            _isShow = !_isShow;
        }];
    }];
}

#pragma mark -animation method
- (void)animationBackGroundView:(UIView *)view isShow:(BOOL)isShow complete:(void(^)())complete {
    
    if (isShow) {
        
        [self.superview addSubview:view];
        [view.superview addSubview:self];
        
        [UIView animateWithDuration:0.2 animations:^{
           
            view.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.4];
        }];
    } else {
        
        [UIView animateWithDuration:0.2 animations:^{
           
            [view removeFromSuperview];
        }];
    }
    complete();
}

- (void)animateTableViewIsShow:(BOOL)isShow complete:(void(^)())complete {
    
    if (isShow) {
        
        _rightTableView.frame = CGRectMake(235, self.frame.origin.y, 100, 0);
        [self.superview addSubview:_rightTableView];
        _leftTableView.frame = CGRectMake(145, self.frame.origin.y, ScreenWidth * 0.3, 0);
        [self.superview addSubview:_leftTableView];
        
        _rightTableView.alpha = 1.0f;
        _leftTableView.alpha = 1.0f;
        [UIView animateWithDuration:0.2 animations:^{
            
            _rightTableView.frame = CGRectMake(235, self.frame.origin.y, 125, 200);
            _leftTableView.frame = CGRectMake(145, self.frame.origin.y, 90, 200);
            
            if (self.transformView) {
               
                self.transformView.transform = CGAffineTransformMakeRotation(M_PI);
            }
        } completion:^(BOOL finished) {
            
        }];
        
    } else {
        
        [UIView animateWithDuration:0.2 animations:^{
            
            _rightTableView.alpha = 0.0f;
            _leftTableView.alpha = 0.0f;
            if (self.transformView) {
                
                self.transformView.transform = CGAffineTransformMakeRotation(0);
            }
        } completion:^(BOOL finished) {
            
            [_rightTableView removeFromSuperview];
            [_leftTableView removeFromSuperview];
        }];
    }
    complete();
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSAssert(self.dataSource != nil, @"menu's dataSource shouldn't be nil");
    if ([self.dataSource respondsToSelector:@selector(menu:tableView:numberOfRowsInSection:)]) {
        
        return [self.dataSource menu:self tableView:tableView numberOfRowsInSection:section];
    } else {
        
        NSAssert(0 == 1, @"required method of dataSource protocol should be implemented");
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"DropDownMenuCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    NSAssert(self.dataSource != nil, @"menu's dataSource shouldn't be nil");
    
    if ([self.dataSource respondsToSelector:@selector(menu:tableView:titleForRowAtIndexPath:)]) {
        
        cell.textLabel.text = [self.dataSource menu:self tableView:tableView titleForRowAtIndexPath:indexPath];
    } else {
        
        NSAssert(0 == 1, @"required method of dataSource protocol should be implemented");
    }
    
    if (tableView == _rightTableView) {
        
        cell.backgroundColor = [UIColor whiteColor];
    } else {
        
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor whiteColor];
        cell.selectedBackgroundView = view;
        [cell setSelected:YES animated:YES];
        cell.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0f];
    }
    cell.textLabel.font = [UIFont systemFontOfSize:14.0 * kMulriple];
    
    return cell;
}

#pragma mark -UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.delegate || [self.delegate respondsToSelector:@selector(menu:tableView:didSelectRowAtIndexPath:)]) {
        
        if (tableView == _rightTableView) {
            
            [self animationBackGroundView:_backGroundView isShow:NO complete:^{
               
                [self animateTableViewIsShow:NO complete:^{
                   
                    _isShow = NO;
                }];
            }];
        }
        [self.delegate menu:self tableView:tableView didSelectRowAtIndexPath:indexPath];
    } else {
        
    }
}

@end

