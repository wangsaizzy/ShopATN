//
//  ZHPickerView.h
//  @的你
//
//  Created by 吴明飞 on 16/3/31.
//  Copyright © 2016年 吴明飞. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZHPickerView;
@protocol ZHPickerViewDelegate <NSObject>

- (void)toolBarDonBtnHaveClick:(ZHPickerView *)pickView resultsString:(NSString *)resultString;

@end
@interface ZHPickerView : UIView

@property (nonatomic, assign) id<ZHPickerViewDelegate>delegate;
@property (nonatomic, assign, readonly) NSInteger selectIndex;
/**
 *  通过plistName添加一个pickView
 *
 *  @param plistName          plist文件的名字
 
 *  @param isHaveNavControler 是否在NavControler之内
 *
 *  @return 带有toolbar的pickview
 */

- (instancetype)initPickerViewWithPlistName:(NSString *)plistName isHaveNavController:(BOOL)isHaveNavController;
/**
 *  通过plistName添加一个pickView
 *
 *  @param array              需要显示的数组
 *  @param isHaveNavControler 是否在NavControler之内
 *
 *  @return 带有toolbar的pickview
 */
- (instancetype)initPickerViewWithArray:(NSArray *)array isHaveNavController:(BOOL)isHaveNavController;

/**
 *  通过时间创建一个DatePicker
 *
 *  @param date               默认选中时间
 *  @param isHaveNavControler是否在NavControler之内
 *
 *  @return 带有toolbar的datePicker
 */

- (instancetype)initDatePickerViewWithdate:(NSDate *)defaultDate datePickerMode:(UIDatePickerMode)datePickerMode isHaveNavController:(BOOL)isHaveNavController;
/**
 *   移除本控件
 */
- (void)remove;

/**
 *   显示本控件
 */
- (void)show;

/**
 *   设置PickerView的颜色
 */
- (void)setPickerViewColor:(UIColor *)color;

/**
 *   设置toolBar的文字颜色
 */
- (void)setTintColor:(UIColor *)color;

/**
 *   设置toolBar的背景色
 */
- (void)setToolBarTintColor:(UIColor *)color;

@end
