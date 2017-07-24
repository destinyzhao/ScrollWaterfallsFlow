# ScrollWaterfallsFlow
ScollView 瀑布流

结合TMMuiLazyScrollView实现ScrollView瀑布流

使用方法
~~~ 
SISWaterfallsFlowLayout *layout = [SISWaterfallsFlowLayout new];
    layout.dataSource = self;
    layout.superViewWidth =  self.view.frame.size.width;
    layout.currLoadDataArray = self.currLoadDataArray;
    [layout waterfallsFlowLayoutReload:^(SISWaterfallsFlowRectModel *model) {
        _rectArray = model.rectArray;
        self.scrollview.contentSize = CGSizeMake(self.view.frame.size.width, model.contentSizeHeight);
}];
   
 实现委托
- (NSInteger)numberOfColumnsInFlowScrollView:(SISWaterfallsFlowLayout *)scrollView
{
    return 2;
}

- (CGFloat)flowScrollView:(SISWaterfallsFlowLayout *)scrollView heightAtIndex:(NSInteger)index {
    return arc4random()%100+80;
}
