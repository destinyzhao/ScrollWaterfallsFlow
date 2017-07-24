//
//  SISWaterfallsFlowLayout.h
//  ScrollWaterfallsFlow
//
//  Created by Destiny on 2017/7/22.
//  Copyright © 2017年 Destiny. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SISWaterfallsFlowRectModel.h"


typedef void(^ReloadBlock)(SISWaterfallsFlowRectModel *model);

@class SISWaterfallsFlowLayout;

@protocol WaterfallsFlowLayoutDataSource <NSObject>

@optional

//cell的列数
- (NSInteger)numberOfColumnsInFlowScrollView:(SISWaterfallsFlowLayout *)scrollView;

//设置每个cell的高度
- (CGFloat)flowScrollView:(SISWaterfallsFlowLayout *)scrollView heightAtIndex:(NSInteger)index;

@end

@interface SISWaterfallsFlowLayout : NSObject

@property (assign, nonatomic) CGFloat superViewWidth;
@property (strong, nonatomic) SISWaterfallsFlowRectModel *rectModel;
@property (strong, nonatomic) NSMutableArray *currLoadDataArray;
@property (assign, nonatomic) ReloadBlock block;
@property (assign, nonatomic) id<WaterfallsFlowLayoutDataSource> dataSource;

- (void)waterfallsFlowLayoutReload:(ReloadBlock)block;

@end
