//
//  YXPickerView.h
//  YXPickerView
//
//  Created by bai on 16/9/12.
//  Copyright © 2016年 bai. All rights reserved.
//

/**
 * 使用注意:
 * 1.在初始化的时候把需要的显示的数据放入一个数组即可
 * 2.使用yxpickerView.backgroundColor修改的是蒙版颜色
 *
 */
#import <UIKit/UIKit.h>
@class YXPickerView;
@protocol YXPickerViewDelegate <NSObject>

@optional
- (void)YXPickerViewDidEnsureButton:(YXPickerView *)pickerView withResultArray:(NSMutableArray *)resultArray;

@end

@interface YXPickerView : UIView

@property (nonatomic, weak) id<YXPickerViewDelegate> delegate;
@property (nonatomic, strong) UIColor *pickerViewBackColor; // 设置PickView的颜色
@property (nonatomic, strong) UIColor *toolBarTextColor; // 设置toobar的文字颜色
@property (nonatomic, strong) UIColor *toolBarBackgroundColor; // 设置toobar的背景颜色
/**
 *  初始化
 *
 *  @param dataArray 传一个数据数组
 */
- (instancetype)initWithDataArray:(NSArray *)dataArray;
/**
 *  显示控件
 */
- (void)show;
/**
 *  隐藏控件
 */
- (void)hide;


@end
