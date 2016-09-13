//
//  YXPickerView.m
//  YXPickerView
//
//  Created by bai on 16/9/12.
//  Copyright © 2016年 bai. All rights reserved.
//

#import "YXPickerView.h"

#define KYXScreenBounds [UIScreen mainScreen].bounds // 屏幕Bounds

@interface YXPickerView ()<UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, weak) UIView *toolBar;  // 工具条
@property (nonatomic, weak) UIPickerView *pickerView; // pickerView
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *resultArray;  // 返回数据

@end

@implementation YXPickerView

static CGFloat KYXToobarHeight = 40; // 工具条高度
static CGFloat KAnimationTime = 0.3; // 弹入弹出动画时长
static CGFloat KComponentRowHeight = 40; // 每行高度

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (NSMutableArray *)resultArray
{
    if (!_resultArray) {
        _resultArray = [NSMutableArray array];
    }
    return _resultArray;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
//        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        self.frame = CGRectMake(0, 0, KYXScreenBounds.size.width, KYXScreenBounds.size.height);
        [self setupPickerView];
        [self setupToolBar];
    }
    return self;
}

- (instancetype)initWithDataArray:(NSArray *)dataArray
{
    if (self = [super init]) {
//        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.1];
        self.frame = CGRectMake(0, 0, KYXScreenBounds.size.width, KYXScreenBounds.size.height);
        [self setupPickerView];
        [self setupToolBar];
        self.dataArray = [dataArray mutableCopy];
        for (int i = 0; i<dataArray.count; i++) {
            [self.resultArray addObject:dataArray[i][0]];
        }
    }
    return self;
}

- (void)setupToolBar
{
    UIView *toolBar = [[UIView alloc] init];
    self.toolBar = toolBar;
    self.toolBar.frame = CGRectMake(0, KYXScreenBounds.size.height, KYXScreenBounds.size.width, KYXToobarHeight);
    toolBar.backgroundColor = [UIColor whiteColor];
    // 取消按钮
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.frame = CGRectMake(20, 5, 50, 30);
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(cancelButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.toolBar addSubview:cancelButton];
    // 确定按钮
    UIButton *ensureButton = [UIButton buttonWithType:UIButtonTypeCustom];
    ensureButton.frame = CGRectMake(KYXScreenBounds.size.width - 70, 5, 50, 30);
    [ensureButton setTitle:@"确定" forState:UIControlStateNormal];
    [ensureButton addTarget:self action:@selector(ensureButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [ensureButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.toolBar addSubview:ensureButton];
    [self addSubview:_toolBar];
}

- (void)setupPickerView
{
    UIPickerView *pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, KYXScreenBounds.size.height, KYXScreenBounds.size.width, 216)];
    pickerView.delegate = self;
    pickerView.dataSource = self;
    self.pickerView = pickerView;
    [self addSubview:pickerView];
}

- (void)show
{
    [UIView animateWithDuration:KAnimationTime animations:^{
        self.toolBar.frame = CGRectMake(0, KYXScreenBounds.size.height-_pickerView.frame.size.height, KYXScreenBounds.size.width, KYXToobarHeight);
        self.pickerView.frame = CGRectMake(0, KYXScreenBounds.size.height-_pickerView.frame.size.height, KYXScreenBounds.size.width, _pickerView.frame.size.height);
    }];
    [[UIApplication sharedApplication].keyWindow addSubview:self];
}

- (void)hide
{
    [UIView animateWithDuration:KAnimationTime animations:^{
        self.toolBar.frame = CGRectMake(0, KYXScreenBounds.size.height, KYXScreenBounds.size.width, KYXToobarHeight);
        self.pickerView.frame = CGRectMake(0, KYXScreenBounds.size.height, KYXScreenBounds.size.width, _pickerView.frame.size.height);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        
    }];
}

- (void)ensureButtonClicked
{
    [self hide];
    if ([self.delegate respondsToSelector:@selector(YXPickerViewDidEnsureButton:withResultArray:)]) {
        [self.delegate YXPickerViewDidEnsureButton:self withResultArray:self.resultArray];
    }
}

- (void)cancelButtonClicked
{
    [self hide];
}

#pragma mark piackView 数据源方法
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return self.dataArray.count;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    NSArray *rowArray=[[NSArray alloc] init];
    for (int i = 0; i<self.dataArray.count; i++) {
        if (component == i) {
            rowArray = self.dataArray[i];
            return rowArray.count;
        }
    }
    
    return 1;
}

#pragma mark UIPickerView 代理方法
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    NSArray *rowArray=[[NSArray alloc] init];
    for (int i = 0; i<self.dataArray.count; i++) {
        if (component == i) {
            rowArray = self.dataArray[i];
            return rowArray[row];
        }
    }
    return nil;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return KComponentRowHeight;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (self.resultArray.count == 0) {
        NSLog(@"数据有问题");
        return;
    }else{
        self.resultArray[component] = self.dataArray[component][row];
//        [self.resultArray replaceObjectAtIndex:component withObject:self.dataArray[component][row]];
    }
}

#pragma mark 控件基本元素设置

/**
 *  设置PickView的颜色
 */
- (void)setPickerViewBackColor:(UIColor *)pickerViewBackColor
{
    _pickerViewBackColor = pickerViewBackColor;
    self.pickerView.backgroundColor = pickerViewBackColor;
}

/**
 *  设置toobar的文字颜色
 */
- (void)setToolBarTextColor:(UIColor *)toolBarTextColor
{
    _toolBarTextColor = toolBarTextColor;
    for (UIView *subview in self.toolBar.subviews) {
        if ([subview isKindOfClass:[UIButton class]]) {
            UIButton *button = (UIButton *)subview;
            [button setTitleColor:toolBarTextColor forState:UIControlStateNormal];
        }
    }
}

/**
 *  设置toobar的背景颜色
 */
- (void)setToolBarBackgroundColor:(UIColor *)toolBarBackgroundColor
{
    _toolBarBackgroundColor = toolBarBackgroundColor;
    self.toolBar.backgroundColor = toolBarBackgroundColor;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self hide];
}

- (void)dealloc
{
    NSLog(@"释放了");
}



@end
