//
//  TodayListController.m
//  ATN
//
//  Created by 吴明飞 on 16/4/28.
//  Copyright © 2016年 王赛. All rights reserved.
//

#import "TodayListController.h"
#import "UntreatedController.h"
#import "BeingProcessedController.h"
#import "AfterApplicationController.h"
@interface TodayListController ()< UIScrollViewDelegate>

{
    NSMutableArray *_titleViewArr;
    NSMutableArray *_titleBtnArr;
    UIScrollView *_scrollView;
    UIPageControl *_pageControl;
}

@end

@implementation TodayListController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBarHidden = NO;
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barTintColor = RGB(83, 83, 83);
    
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:20], NSForegroundColorAttributeName:[UIColor whiteColor]};
    self.navigationController.navigationBar.titleTextAttributes = dic;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //最上端滑动视图
    [self setupscrollView];
    [self customNaviBar];
    //最上端滑动视图按钮
    [self titleScrollViewAddBtn];
    
}

- (void)customNaviBar {
    
    
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:20 * kMulriple], NSForegroundColorAttributeName:[UIColor whiteColor]};
    self.navigationController.navigationBar.titleTextAttributes = dic;
    self.navigationController.navigationBar.barTintColor = RGB(83, 83, 83);
}



#pragma mark -setupscrollView
- (void)setupscrollView {
    
    _scrollView  = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 54 * kHMulriple, kWight, kHeight)];
    [self.view addSubview:_scrollView];
    
    for (int i = 0; i < 3; i++) {
        
        if (i == 0) {

            UntreatedController *treateVC = [[UntreatedController alloc] init];
            treateVC.view.frame = CGRectMake(0, 0, kWight, kHeight);
            [_scrollView addSubview:treateVC.view];
            [self addChildViewController:treateVC];
        }
        
        if (i == 1) {
            
            BeingProcessedController *beVC = [[BeingProcessedController alloc] init];
            beVC.view.frame = CGRectMake(kWight, 0, kWight, kHeight);
            [_scrollView addSubview:beVC.view];
            [self addChildViewController:beVC];
        }
        
        if (i == 2) {
            
            AfterApplicationController *afterVC = [[AfterApplicationController alloc] init];
            afterVC.view.frame = CGRectMake(2 * kWight, 0, kWight, kHeight);
            [_scrollView addSubview:afterVC.view];
            [self addChildViewController:afterVC];
        }
        
    }
    
    _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 63 * kHMulriple, kWight, 2)];
    _pageControl.numberOfPages = 3;
    _pageControl.currentPage = 0;
    _scrollView.pagingEnabled = YES;
    _scrollView.contentSize = CGSizeMake(kWight * 3, kHeight);
    _scrollView.contentOffset = CGPointMake(0, 0);
    _scrollView.directionalLockEnabled = YES;
    _scrollView.bounces = NO;
    _scrollView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, kWight, 0);
    _scrollView.indicatorStyle = UIScrollViewIndicatorStyleBlack;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.delegate = self;
    
}


#pragma mark -titleScrollViewAddBtn
- (void)titleScrollViewAddBtn {
    _titleViewArr = [NSMutableArray arrayWithCapacity:6];
    _titleBtnArr = [NSMutableArray arrayWithCapacity:6];
    //2个内容切换的按钮所在的view
    UIView *btnView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWight, 54 * kHMulriple)];
    btnView.backgroundColor = RGB(238, 238, 238);
    
    NSArray *titleArr = @[@"未处理", @"处理中", @"售后申请"];
    for (int i = 0; i < 3; i++) {
        //按钮
        UIButton *titleBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        titleBtn.frame = CGRectMake(kWight / 3 * i, 0, kWight / 3, 64 * kHMulriple);
        [titleBtn setTitle:titleArr[i] forState:UIControlStateNormal];
        titleBtn.titleEdgeInsets = UIEdgeInsetsMake(-7 * kMulriple, 0, 7 * kMulriple, 0);
        titleBtn.tintColor = RGB(111, 111, 111);
        if (i == 0) {
            titleBtn.tintColor = RGB(237, 90, 87);
        }
        titleBtn.tag = i;
        [titleBtn addTarget:self action:@selector(titleBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        titleBtn.titleLabel.font = [UIFont systemFontOfSize:19];
        [btnView addSubview:titleBtn];
        
        //每个按钮对应的线
        UILabel *labelLine = [[UILabel alloc] initWithFrame:CGRectMake(kWight / 3 * i , 51 * kHMulriple, kWight / 3, 4)];
        labelLine.backgroundColor = RGB(237, 90, 87);
        if (i) {
            labelLine.hidden = YES;
        }
        [btnView addSubview:labelLine];
        [_titleViewArr addObject:labelLine];
        [_titleBtnArr addObject:titleBtn];
        
    }
    [self.view addSubview:btnView];
}

#pragma mark -切换按钮点击方法
- (void)titleBtnAction:(UIButton *)sender {
    UIButton *button;
    for (int i = 0; i < 3; i++) {
        
        UILabel *label = _titleViewArr[i];
        button = _titleBtnArr[i];
        if (sender.tag == i) {
            label.hidden = NO;
            button.tintColor = RGB(237, 90, 87);
        } else {
            label.hidden = YES;
            button.tintColor = RGB(111, 111, 111);
        }
        
    }
    
    if (sender.tag == 0) {
        [_scrollView setContentOffset:CGPointMake(0, 0) animated:NO];
    }
    if (sender.tag == 1) {
        [_scrollView setContentOffset:CGPointMake(kWight, 0) animated:NO];
    }
    if (sender.tag == 2) {
        
        [_scrollView setContentOffset:CGPointMake(kWight * 2, 0) animated:NO];
    }
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    UIButton *button;
    for (int i = 0; i < 3; i++) {
        UILabel *label = _titleViewArr[i];
        button = _titleBtnArr[i];
        if (scrollView.contentOffset.x == kWight * i) {
            label.hidden = NO;
            button.tintColor = RGB(237, 90, 87);
        } else {
            label.hidden = YES;
            button.tintColor = RGB(111, 111, 111);
        }
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end
