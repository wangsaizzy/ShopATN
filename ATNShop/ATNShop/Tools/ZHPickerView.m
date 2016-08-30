//
//  ZHPickerView.m
//  @的你
//
//  Created by 吴明飞 on 16/3/31.
//  Copyright © 2016年 吴明飞. All rights reserved.
//
#define ZHToobarHeight 40
#import "ZHPickerView.h"

@interface ZHPickerView ()<UIPickerViewDataSource, UIPickerViewDelegate>
@property (nonatomic, copy) NSString *plistName;
@property (nonatomic, strong) NSArray *plistArray;
@property (nonatomic, assign) BOOL isLevelString;
@property (nonatomic, assign) BOOL isLevelArray;
@property (nonatomic, assign) BOOL isLevelDic;
@property (nonatomic, strong) NSDictionary *levelTwoDic;
@property (nonatomic, strong) UIToolbar *toolBar;
@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic, strong) UIDatePicker *datePicker;
@property (nonatomic, assign) NSDate *defaultDate;
@property (nonatomic, assign) BOOL isHaveNavController;
@property (nonatomic, assign) NSInteger pickerViewHeight;
@property (nonatomic, copy) NSString *resultString;
@property (nonatomic, strong) NSMutableArray *componentArray;
@property (nonatomic, strong) NSMutableArray *dicKeyArray;
@property (nonatomic, copy) NSMutableArray *state;
@property (nonatomic, copy) NSMutableArray *city;
@property (nonatomic, strong) UIView *backGround;
@end

@implementation ZHPickerView
- (NSArray *)plistArray {
    if (!_plistArray) {
        _plistArray = [[NSArray alloc] init];
    }
    return _plistArray;
}

- (NSArray *)componentArray {
    if (!_componentArray) {
        _componentArray = [[NSMutableArray alloc] init];
    }
    return _componentArray;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpToolBar];
        
    }
    return self;
}

- (instancetype)initPickerViewWithPlistName:(NSString *)plistName isHaveNavController:(BOOL)isHaveNavController {
    self = [super init];
    if (self) {
        _plistName = plistName;
        self.plistArray = [self getPlistArrayByPlistName:plistName];
        [self setUpPickerView];
        [self setFrameWith:isHaveNavController];
        [self createBackGroundView];
    }
    return self;
}

- (instancetype)initPickerViewWithArray:(NSArray *)array isHaveNavController:(BOOL)isHaveNavController {
    self = [super init];
    if (self) {
        self.plistArray = array;
        [self setArrayClass:array];
        [self setUpPickerView];
        [self setFrameWith:isHaveNavController];
        [self createBackGroundView];
    }
    return self;
}

- (instancetype)initDatePickerViewWithdate:(NSDate *)defaultDate datePickerMode:(UIDatePickerMode)datePickerMode isHaveNavController:(BOOL)isHaveNavController {
    self = [super init];
    if (self) {
        _defaultDate = defaultDate;
        [self setUpDatePickerWithDatePickerMode:(UIDatePickerMode)datePickerMode];
        [self setFrameWith:isHaveNavController];
        [self createBackGroundView];
    }
    return self;
}

- (NSArray *)getPlistArrayByPlistName:(NSString *)plistName {
    NSString *path = [[NSBundle mainBundle] pathForResource:plistName ofType:@"plist"];
    NSArray *array = [[NSArray alloc] initWithContentsOfFile:path];
    [self setArrayClass:array];
    return array;
}

- (void)setArrayClass:(NSArray *)array {
    _dicKeyArray = [[NSMutableArray alloc] init];
    for (id levelTwo in array) {
        if ([levelTwo isKindOfClass:[NSArray class]]) {
            _isLevelArray = YES;
            _isLevelDic = NO;
            _isLevelString = NO;
        } else if ([levelTwo isKindOfClass:[NSString class]]) {
            _isLevelString = YES;
            _isLevelDic = NO;
            _isLevelArray = NO;
        } else if ([levelTwo isKindOfClass:[NSDictionary class]]) {
            _isLevelDic = YES;
            _isLevelArray = NO;
            _isLevelString = NO;
            _levelTwoDic = levelTwo;
            [_dicKeyArray addObject:[_levelTwoDic allKeys]];
        }
    }
}

- (void)setUpPickerView {
    UIPickerView *pickerView = [[UIPickerView alloc] init];
    pickerView.backgroundColor = [UIColor lightGrayColor];
    _pickerView = pickerView;
    pickerView.delegate = self;
    pickerView.dataSource = self;
    pickerView.frame = CGRectMake(0, ZHToobarHeight, kWight, pickerView.frame.size.height);
    _pickerViewHeight = pickerView.frame.size.height;
    [self addSubview:pickerView];
}

- (void)setUpDatePickerWithDatePickerMode:(UIDatePickerMode)datePickerMode {
    UIDatePicker *datePicker = [[UIDatePicker alloc] init];
    datePicker.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    datePicker.backgroundColor = [UIColor whiteColor];
    if (_defaultDate) {
        [datePicker setDate:_defaultDate];
    }
    _datePicker = datePicker;
    datePicker.frame = CGRectMake(0, ZHToobarHeight, datePicker.frame.size.width, datePicker.frame.size.height);
    _pickerViewHeight = datePicker.frame.size.height;
    [self addSubview:datePicker];
}

- (void)setFrameWith:(BOOL)isHaveController {
    CGFloat toolViewX = 0;
    CGFloat toolViewH = _pickerViewHeight + ZHToobarHeight;
    CGFloat toolViewY;
    if (isHaveController) {
        toolViewY = kHeight - toolViewH - 50 * kHMulriple;
    } else {
        toolViewY = kHeight - toolViewH;
    }
    CGFloat toolViewW = kWight;
    self.frame = CGRectMake(toolViewX, toolViewY, toolViewW, toolViewH);
}

- (void)setUpToolBar {
    //自定义toolBar
    _toolBar = [self setToolBarStyle];
    [self setToolBarWithPickerViewFrame];
    [self addSubview:_toolBar];
}

- (UIToolbar *)setToolBarStyle {
    UIToolbar *toolBar = [[UIToolbar alloc] init];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] init];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(remove)];
    UIBarButtonItem *centerSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(doneClick)];
    
    toolBar.items = @[item, leftItem, centerSpace, right, item];
    return toolBar;
}

- (void)setToolBarWithPickerViewFrame {
    _toolBar.frame = CGRectMake(0, 0, kWight, ZHToobarHeight);
    _toolBar.backgroundColor = [UIColor whiteColor];
}

- (void)createBackGroundView {
    _backGround = [[UIView alloc] init];
    _backGround.frame = CGRectMake(0, 0, kWight, kHeight);
    _backGround.backgroundColor = RGBA(0, 0, 0, 0.7);
    
    
    //单击
    UITapGestureRecognizer *singleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(remove)];
    [_backGround addGestureRecognizer:singleRecognizer];
}

#pragma mark -数据源方法
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    NSInteger component;
    if (_isLevelArray) {
        component = _plistArray.count;
    } else if (_isLevelString) {
        component = 1;
    } else if (_isLevelDic) {
        component = [_levelTwoDic allKeys].count * 2;
    }
    return component;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    NSArray *rowArray = [[NSArray alloc] init];
    if (_isLevelArray) {
        rowArray = _plistArray[component];
    } else if (_isLevelString) {
        rowArray = _plistArray;
    } else if (_isLevelDic) {
        NSInteger pIndex = [pickerView selectedRowInComponent:0];
        NSDictionary *dic = _plistArray[pIndex];
        for (id dicValue in [dic allValues]) {
            if ([dicValue isKindOfClass:[NSArray class]]) {
                if (component % 2 == 1) {
                    rowArray = dicValue;
                } else {
                    rowArray = _plistArray;
                }
            }
        }
    }
    return rowArray.count;
}

#pragma mark -UIPickerViewDelegate
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    NSString *rowTitle = nil;
    if (_isLevelArray) {
        rowTitle = _plistArray[component][row];
    } else if (_isLevelString) {
        rowTitle = _plistArray[row];
    } else if (_isLevelDic) {
        NSInteger pIndex = [pickerView selectedRowInComponent:0];
        NSDictionary *dic = _plistArray[pIndex];
        if (component % 2 == 0) {
            rowTitle = _dicKeyArray[row][component];
        }
        for (id dicValue in [dic allValues]) {
            if ([dicValue isKindOfClass:[NSArray class]] && component % 2 == 1) {
                NSArray *arr = dicValue;
                if (arr.count > row) {
                    rowTitle = dicValue[row];
                }
            }
        }
    }
    return rowTitle;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    _selectIndex = row;
    if (_isLevelDic && component % 2 == 0) {
        [pickerView reloadComponent:1];
        [pickerView selectRow:0 inComponent:1 animated:YES];
    }
    if (_isLevelString) {
        _resultString = _plistArray[row];
    } else if (_isLevelArray) {
        _resultString = @"";
        if (![self.componentArray containsObject:@(component)]) {
            [self.componentArray addObject:@(component)];
        }
        for (int i = 0; i < _plistArray.count; i++) {
            if ([self.componentArray containsObject:@(i)]) {
                NSInteger cIndex = [pickerView selectedRowInComponent:i];
                _resultString = [NSString stringWithFormat:@"%@%@", _resultString, _plistArray[i][cIndex]];
            } else {
                _resultString = [NSString stringWithFormat:@"%@%@", _resultString, _plistArray[i][0]];
            }
        }
    } else if (_isLevelDic) {
        if (component == 0) {
            _state = _dicKeyArray[row][0];
        } else {
            NSInteger cIndex = [pickerView selectedRowInComponent:0];
            NSDictionary *dicValueDic = _plistArray[cIndex];
            NSArray *dicValueArray = [dicValueDic allValues][0];
            if (dicValueArray.count > row) {
                _city = dicValueArray[row];
            }
        }
    }
}

//移除
- (void)remove {
    [UIView animateWithDuration:0.2 animations:^{
        _backGround.alpha = 0;
        CGRect frame = self.frame;
        frame.origin.y = kHeight;
        self.frame = frame;
    } completion:^(BOOL finished) {
        [_backGround removeFromSuperview];
        [self removeFromSuperview];
    }];
}


//展示
- (void)show {
    CGFloat _y = self.frame.origin.y;
    CGRect frame = self.frame;
    frame.origin.y = kHeight;
    self.frame = frame;
    
    _backGround.alpha = 0;
    [[UIApplication sharedApplication].keyWindow addSubview:_backGround];
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
    [UIView animateWithDuration:0.2 animations:^{
        _backGround.alpha = 1;
        CGRect frame = self.frame;
        frame.origin.y = _y;
        self.frame = frame;
    }];
}

- (void)doneClick {
    if (_pickerView) {
        if (_resultString) {
            
        } else {
            if (_isLevelString) {
                _resultString = [NSString stringWithFormat:@"%@", _plistArray[0]];
            } else if (_isLevelArray) {
                _resultString = @"";
                for (int i = 0; i < _plistArray.count; i++) {
                    _resultString = [NSString stringWithFormat:@"%@%@", _resultString, _plistArray[i][0]];
                }
            } else if (_isLevelDic) {
                if (_state == nil) {
                    _state = _dicKeyArray[0][0];
                    NSDictionary *dicValueDic = _plistArray[0];
                    _city = [dicValueDic allValues][0][0];
                }
                if (_city == nil) {
                    NSInteger cIndex = [_pickerView selectedRowInComponent:0];
                    NSDictionary *dicValueDic = _plistArray[cIndex];
                    _city = [dicValueDic allValues][0][0];
                }
                _resultString = [NSString stringWithFormat:@"%@%@", _state, _city];
            }
        }
    } else if (_datePicker) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        if (_datePicker.datePickerMode == UIDatePickerModeTime) {
            [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        } else if (_datePicker.datePickerMode == UIDatePickerModeTime) {
            [dateFormatter setDateFormat:@"HH:mm"];
        }
        _resultString = [dateFormatter stringFromDate:_datePicker.date];
    }
    if ([self.delegate respondsToSelector:@selector(toolBarDonBtnHaveClick:resultsString:)]) {
        [self.delegate toolBarDonBtnHaveClick:self resultsString:_resultString];
    }
    [self remove];
}

//设置pickerView的颜色
- (void)setPickerViewColor:(UIColor *)color {
    _pickerView.backgroundColor = color;
}

/**
 *  设置toobar的文字颜色
 */
- (void)setTintColor:(UIColor *)color {
    _toolBar.tintColor = color;
}

/**
 *  设置toobar的背景颜色
 */
- (void)setToolBarTintColor:(UIColor *)color {
    _toolBar.barTintColor = color;
}

@end
