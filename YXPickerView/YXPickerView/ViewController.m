//
//  ViewController.m
//  YXPickerView
//
//  Created by bai on 16/9/12.
//  Copyright © 2016年 bai. All rights reserved.
//

#import "ViewController.h"
#import "YXPickerView.h"

@interface ViewController ()< YXPickerViewDelegate>

@property (nonatomic, strong) NSArray *province;
@property (nonatomic, strong) NSArray *city;
@property (nonatomic, strong) YXPickerView *pickerView;
@property (nonatomic, strong) NSArray *shCounty;
@property (nonatomic, strong) NSArray *gzCounty;
@property (nonatomic, strong) NSArray *szCounty;
@property (nonatomic, strong) NSArray *bjCounty;
@property (nonatomic, strong) NSMutableArray *titleArrayM;

@end

@implementation ViewController

- (NSMutableArray *)titleArrayM
{
    if (!_titleArrayM) {
        _titleArrayM = [NSMutableArray array];
    }
    return _titleArrayM;
}

- (NSArray *)province
{
    if (!_province) {
        _province = @[@"上海", @"广州", @"深圳", @"北京"];
    }
    return _province;
}

- (NSArray *)city
{
    if (!_city) {
        _city = @[@"城市1",@"城市2",@"城市3",@"城市4",@"城市5",@"城市6"];
    }
    return _city;
}

- (NSArray *)shCounty
{
    if (!_shCounty) {
        _shCounty = @[@"上海1", @"上海2", @"上海3", @"上海4"];
    }
    return _shCounty;
}

- (NSArray *)gzCounty
{
    if (!_gzCounty) {
        _gzCounty = @[@"广州1", @"广州2"];
    }
    return _gzCounty;
}

- (NSArray *)szCounty
{
    if (!_szCounty) {
        _szCounty = @[@"深圳1", @"深圳2", @"深圳3"];
    }
    return _szCounty;
}

- (NSArray *)bjCounty
{
    if (!_bjCounty) {
        _bjCounty = @[@"北京1", @"北京2", @"北京3", @"北京4", @"北京5"];
    }
    return _bjCounty;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self setupUI];
}

- (void)setupUI
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(0, 50, 50, 30);
    [button setTitle:@"show" forState:UIControlStateNormal];
    [self.view addSubview:button];
    [button addTarget:self action:@selector(showButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    NSArray *dataArray = @[self.province,self.city, self.shCounty, self.gzCounty];
    
    // 把需要显示的数据放入一个数组
    YXPickerView *pickView = [[YXPickerView alloc] initWithDataArray: dataArray];
    pickView.delegate = self;
    pickView.backgroundColor = [UIColor orangeColor]; // 注意: 这是修改蒙版颜色！
    pickView.toolBarTextColor = [UIColor redColor];
    pickView.pickerViewBackColor = [UIColor blueColor];
    self.pickerView = pickView;
    
    CGFloat width = self.view.bounds.size.width/dataArray.count;
    for (int i = 0; i<dataArray.count; i++) {
        UILabel *label = [UILabel new];
        label.frame = CGRectMake(i*width, 100, self.view.bounds.size.width/dataArray.count, 30);
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor orangeColor];
        [self.titleArrayM addObject:label];
        [self.view addSubview:label];
    }
    
}

- (void)showButtonClicked
{
    [self.pickerView show];
}

// 代理方法返回选中的数据
- (void)YXPickerViewDidEnsureButton:(YXPickerView *)pickerView withResultArray:(NSMutableArray *)resultArray
{
    NSLog(@"%@",resultArray);
    for (int i = 0; i<resultArray.count; i++) {
        UILabel *label = self.titleArrayM[i];
        label.text = resultArray[i];
    }
    
}

@end
