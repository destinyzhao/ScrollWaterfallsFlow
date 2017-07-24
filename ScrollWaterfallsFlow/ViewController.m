//
//  ViewController.m
//  ScrollWaterfallsFlow
//
//  Created by Destiny on 2017/7/22.
//  Copyright © 2017年 Destiny. All rights reserved.
//

#import "ViewController.h"
#import "TMMuiLazyScrollView.h"
#import "SISWaterfallsFlowLayout.h"
#import "SISWaterfallsFlowRectModel.h"
#import "TestModel.h"

@interface LazyScrollViewCustomView : UILabel

@end

@implementation LazyScrollViewCustomView

@end

@interface ViewController ()<TMMuiLazyScrollViewDataSource,WaterfallsFlowLayoutDataSource>

@property (strong, nonatomic) NSMutableArray *rectArray;
@property (strong, nonatomic) TMMuiLazyScrollView *scrollview;
@property (strong, nonatomic) SISWaterfallsFlowLayout *layout;
@property (strong, nonatomic) NSMutableArray *dataArray;
@property (strong, nonatomic) NSMutableArray *currLoadDataArray;


@end

@implementation ViewController

- (TMMuiLazyScrollView *)scrollview
{
    if (!_scrollview) {
        _scrollview = [[TMMuiLazyScrollView alloc]init];
        _scrollview.frame = self.view.bounds;
        _scrollview.dataSource = self;
    }
    return _scrollview;
}

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (NSMutableArray *)currLoadDataArray
{
    if (!_currLoadDataArray) {
        _currLoadDataArray = [NSMutableArray array];
    }
    return _currLoadDataArray;
}

#pragma mark -- 右导航按钮
-(UIBarButtonItem *)rightBarButton
{
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setFrame: CGRectMake(0, 0, 50, 40)];
    [rightBtn setTitle:@"更多" forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [rightBtn.titleLabel setFont:[UIFont systemFontOfSize:12.f]];
    [rightBtn addTarget:self action:@selector(reload:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    
    return rightButtonItem;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.navigationItem.rightBarButtonItem = [self rightBarButton];
    
    for (int i = 0; i < 10; i++) {
        TestModel *model = [TestModel new];
        model.title = [NSString stringWithFormat:@"测试商品名称:%d",i];
        model.color = [UIColor grayColor];
        [self.dataArray addObject:model];
        [self.currLoadDataArray addObject:model];
    }
    
    [self.view addSubview:self.scrollview];
    
    //Here is frame array for test.
    //LazyScrollView must know every rect before rending.
    _rectArray  = [[NSMutableArray alloc] init];
    
    SISWaterfallsFlowLayout *layout = [SISWaterfallsFlowLayout new];
    layout.dataSource = self;
    layout.superViewWidth =  self.view.frame.size.width;
    layout.currLoadDataArray = self.currLoadDataArray;
    [layout waterfallsFlowLayoutReload:^(SISWaterfallsFlowRectModel *model) {
        _rectArray = model.rectArray;
        self.scrollview.contentSize = CGSizeMake(self.view.frame.size.width, model.contentSizeHeight);
    }];
    
    _layout = layout;
  
    //STEP 3 reload LazyScrollView
    [_scrollview reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)reload:(UIButton *)sender
{
    [self.currLoadDataArray removeAllObjects];
    
    for (int i = 0; i < 10; i++) {
        TestModel *model = [TestModel new];
        model.title = [NSString stringWithFormat:@"测试商品名称:%d",i];
        model.color = [self randomColor];
        [self.dataArray addObject:model];
        [self.currLoadDataArray addObject:model];
    }
    _layout.currLoadDataArray = self.currLoadDataArray;
    [_layout waterfallsFlowLayoutReload:^(SISWaterfallsFlowRectModel *model) {
        _rectArray = model.rectArray;
        self.scrollview.contentSize = CGSizeMake(self.view.frame.size.width, model.contentSizeHeight);
    }];
    [_scrollview reloadData];
    
}

//STEP 2 implement datasource delegate.
- (NSUInteger)numberOfItemInScrollView:(TMMuiLazyScrollView *)scrollView
{
    return _rectArray.count;
}

- (TMMuiRectModel *)scrollView:(TMMuiLazyScrollView *)scrollView rectModelAtIndex:(NSUInteger)index
{
    CGRect rect = [(NSValue *)[_rectArray objectAtIndex:index]CGRectValue];
    TMMuiRectModel *rectModel = [[TMMuiRectModel alloc]init];
    rectModel.absoluteRect = rect;
    rectModel.muiID = [NSString stringWithFormat:@"%ld",index];
    return rectModel;
}

- (UIView *)scrollView:(TMMuiLazyScrollView *)scrollView itemByMuiID:(NSString *)muiID
{
    //Find view that is reuseable first.
    LazyScrollViewCustomView *label = (LazyScrollViewCustomView *)[scrollView dequeueReusableItemWithIdentifier:@"testView"];
    NSInteger index = [muiID integerValue];
    if (!label)
    {
        label = [[LazyScrollViewCustomView alloc]initWithFrame:[(NSValue *)[_rectArray objectAtIndex:index]CGRectValue]];
        label.textAlignment = NSTextAlignmentCenter;
        label.reuseIdentifier = @"testView";
    }
    label.frame = [(NSValue *)[_rectArray objectAtIndex:index]CGRectValue];
    TestModel *model = self.dataArray[index];
    label.text = model.title;
    label.backgroundColor = model.color;
    [scrollView addSubview:label];
    label.userInteractionEnabled = YES;
    [label addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(click:)]];
    return label;
}

#pragma mark - Private

- (UIColor *) randomColor
{
    CGFloat hue = ( arc4random() % 256 / 256.0 ); //0.0 to 1.0
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5; // 0.5 to 1.0,away from white
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5; //0.5 to 1.0,away from black
    return [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
    
}

- (void)click:(UIGestureRecognizer *)recognizer
{
    LazyScrollViewCustomView *label = (LazyScrollViewCustomView *)recognizer.view;
    
    NSLog(@"Click - %@",label.muiID);
}

- (NSInteger)numberOfColumnsInFlowScrollView:(SISWaterfallsFlowLayout *)scrollView
{
    return 2;
}

- (CGFloat)flowScrollView:(SISWaterfallsFlowLayout *)scrollView heightAtIndex:(NSInteger)index {
    return arc4random()%100+80;
}


@end
