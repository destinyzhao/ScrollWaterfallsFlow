//
//  SISWaterfallsFlowLayout.m
//  ScrollWaterfallsFlow
//
//  Created by Destiny on 2017/7/22.
//  Copyright © 2017年 Destiny. All rights reserved.
//

#import "SISWaterfallsFlowLayout.h"

const CGFloat FlowLayoutDefaultHeight = 120;
const CGFloat FlowLayoutDefaultColumn = 3;

@interface SISWaterfallsFlowLayout ()

@property (strong, nonatomic) NSMutableArray *rectArray;
/** 所有列最大Y值的数组 */
@property (strong, nonatomic) NSMutableArray *maxYColumns;
/** 最小Y值cell的列数(最短的一列) */
@property (assign, nonatomic) NSInteger minCellColumn;

@end

@implementation SISWaterfallsFlowLayout

- (NSMutableArray *)rectArray
{
    if (!_rectArray) {
        _rectArray = [NSMutableArray array];
    }
    return _rectArray;
}

- (NSMutableArray *)maxYColumns
{
    if (!_maxYColumns) {
        _maxYColumns = [NSMutableArray array];
    }
    return _maxYColumns;
}

- (SISWaterfallsFlowRectModel *)rectModel
{
    if (!_rectModel) {
        _rectModel = [SISWaterfallsFlowRectModel new];
    }
    return _rectModel;
}

- (void)waterfallsFlowLayoutReload:(ReloadBlock)block
{
    self.block = block;
    
    CGFloat rowMargin = 5;
    CGFloat columnMargin = 5;
    CGFloat leftMargin = 5;
    CGFloat topMargin = 5;
    CGFloat bottomMargin = 5;
    
    /** cell的总数 */
    NSInteger numberOfCells = self.currLoadDataArray.count;
    /** 列数 */
    NSInteger numberOfColumns = [self numberOfColumns];
    /** cell的宽度 */
    CGFloat cellWidth = (self.superViewWidth-(numberOfColumns + 1)*columnMargin)/numberOfColumns;
    
    /** 所有列最大Y值的数组 */
    //NSMutableArray *maxYColumns = [NSMutableArray new];
    
    for (int i = 0; i < numberOfColumns; i++) {
        [self.maxYColumns addObject:[NSNumber numberWithFloat:0.0]];
    }
    
    // 计算所有cell的frame
    for (int i = 0; i < numberOfCells; i++) {
        /** 最小Y值cell的列数(最短的一列) */
        //NSInteger minCellColumn = 0;
        
        //存放所有列中最小的Y值
        CGFloat minYCell = [_maxYColumns[_minCellColumn] floatValue];
        
        //求出最短一列的Y值
        for (int j = 0; j < numberOfColumns; j++) {
            if ([self.maxYColumns[j] floatValue] < minYCell) {
                _minCellColumn = j;
                minYCell = [self.maxYColumns[j] floatValue];
            }
        }
        
        // cell的高度
        CGFloat cellHeight = [self heightAtIndex:i];
        
        // cell的位置
        CGFloat cellX = leftMargin + _minCellColumn * (cellWidth + columnMargin);
        CGFloat cellY = 0;
        
        if (minYCell == 0.0) { // 首行
            cellY = topMargin;
        }else {
            cellY = minYCell + rowMargin;
        }
        
        // 添加frame到数组中
        CGRect cellFrame = CGRectMake(cellX, cellY, cellWidth, cellHeight);
        self.maxYColumns[_minCellColumn] = [NSNumber numberWithFloat:CGRectGetMaxY(cellFrame)];
        
        [self.rectArray addObject:[NSValue valueWithCGRect:cellFrame]];
        
        //获取整个瀑布流的高度
        CGFloat contentHeight = [self.maxYColumns[0] floatValue];
        
        for (int i = 0; i < numberOfColumns; i++) {
            if ([self.maxYColumns[i] floatValue] > contentHeight) {
                contentHeight = [self.maxYColumns[i] floatValue];
            }
        }
        
        contentHeight += bottomMargin;
        
        self.rectModel.contentSizeHeight = contentHeight;
    }
    self.rectModel.rectArray = self.rectArray;
    
    if (self.block) {
        self.block(self.rectModel);
    }
}

- (CGFloat)heightAtIndex:(NSInteger)index {
    if ([self.dataSource respondsToSelector:@selector(flowScrollView:heightAtIndex:)]) {
        return [self.dataSource flowScrollView:self heightAtIndex:index];
    }
    
    return FlowLayoutDefaultHeight;
}

- (NSInteger)numberOfColumns {
    if ([self.dataSource respondsToSelector:@selector(numberOfColumnsInFlowScrollView:)]) {
        return [self.dataSource numberOfColumnsInFlowScrollView:self];
    }
    
    return FlowLayoutDefaultColumn;
}


@end
