//
//  ShareView.m
//  AiyoyouDemo
//
//  Created by aiyoyou on 16/7/1.
//  Copyright © 2016年 aiyoyou. All rights reserved.
//

#import "ZCSudokuView.h"
#import "ZCSudokuCell.h"

#define kSelfW          self.frame.size.width
#define kSelfH          self.frame.size.height
#define kpageControlH   (13*_scale)

@interface ZCSudokuView()<UIScrollViewDelegate>
{
    CGFloat         _cellW;//cell宽度
    CGFloat         _cellH;//cell高度
    
    NSInteger       _pageSizeAmount;//总页数
}
@property (nonatomic,assign) CGFloat         scale;//屏幕比例
@property (nonatomic,strong) UIScrollView   *scrollView;
@property (nonatomic,strong) UIPageControl  *pageControl;

@end

@implementation ZCSudokuView


#pragma mark - action
//最主要的执行函数
- (void)configShareView {
    [self removeAllSubViews];
    
    //cell总个数获取
    if ([self.delegate respondsToSelector:@selector(numberOfCellInSudokuView)]) {
        _number = [self.delegate numberOfCellInSudokuView];
    }
    if (_number==0)return;
    
    //列数获取
    if ([self.delegate respondsToSelector:@selector(numberOfColumnInSudokuView)]) {
        _columnAmount = [self.delegate numberOfColumnInSudokuView];
    }
    //行数获取
    if ([self.delegate respondsToSelector:@selector(numberOfRowInSudokuView)]) {
        _rowAmount = [self.delegate numberOfRowInSudokuView];
    }
    
    /** -------------------------------- 一切从这里开始👇 -------------------------------- */
    if (_columnAmount==0 && _rowAmount==0) {
        _columnAmount = 4;//如果行和列都等于0，列默认4.
    }
    
    //根据数据源总数（_number）确定行和列
    _columnAmount = (_columnAmount==0)?ceilf(_number/(CGFloat)_rowAmount):_columnAmount;
    _rowAmount = (_rowAmount==0)?ceilf(_number/(CGFloat)_columnAmount):_rowAmount;
    
    //计算页数
    _pageSizeAmount = ceilf(_number/(CGFloat)(_columnAmount*_rowAmount));
    
    //设置scrollView的内容大小
    self.scrollView.contentSize = CGSizeMake(kSelfW*_pageSizeAmount,kSelfH);
    
    if (_pageSizeAmount>1) {
        [self addSubview:self.pageControl];
        _pageControl.frame = CGRectMake(0,kSelfH-kpageControlH,kSelfW,kpageControlH);
        _pageControl.currentPage = 0;
        _pageControl.numberOfPages = _pageSizeAmount;
        _cellH = (kSelfH-kpageControlH)/_rowAmount;
    }else {
        [_pageControl removeFromSuperview];
        _cellH = kSelfH/_rowAmount;
    }
    _cellW = kSelfW/_columnAmount;
    
    //cell渲染
    for (int pageSize=0; pageSize<_pageSizeAmount; pageSize++ ) {
        for (int row=0;row<_rowAmount;row++) {
            for (int column=0;column<_columnAmount;column++) {
                NSInteger index = pageSize*_columnAmount*_rowAmount+_columnAmount*row+column;
                if (index>_number-1)break;
                if ([self.delegate respondsToSelector:@selector(sudokuView:cellForRowAtIndex:)]) {
                    ZCSudokuCell *cell = [self.delegate sudokuView:self cellForRowAtIndex:index];
                    if (!cell)continue;
                    
                    cell.tag = index;
                    //cell控件渲染。
                    CGFloat cellX = pageSize*kSelfW+column*_cellW;
                    CGFloat cellY = row*_cellH;
                    cell.frame = CGRectMake(cellX,cellY,_cellW,_cellH);
                    [_scrollView addSubview:cell];
                    //cell点击事件
                    [cell addTarget:self action:@selector(cellClickUpInside:) forControlEvents:UIControlEventTouchUpInside];
                    
                }
            }
        }
    }
    
    //画线条
    if (_isDrawLine) {
        [self drawLine];
    }
    
}

#pragma mark -scrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    int page = floor((scrollView.contentOffset.x-kSelfW/2)/kSelfW)+1;
    self.pageControl.currentPage = page;
    
}

//给九宫格划线
- (void)drawLine {
    
    //横向line
    for (int i=0;i<_rowAmount+1;i++ ) {
        UIView *line = [self line];
        line.frame = CGRectMake(0,i*(kSelfH/_rowAmount),kSelfW*_pageSizeAmount,0.5);
        [_scrollView addSubview:line];
    }
    
    //纵向line
    for (int j=0;j<_columnAmount*_pageSizeAmount-1;j++) {
        UIView *line = [self line];
        line.frame = CGRectMake((j+1)*_cellW,0,0.5,kSelfH);
        [_scrollView addSubview:line];
    }
    
}
//cell的点击事件
- (void)cellClickUpInside:(ZCSudokuCell *)cell {
    if ([self.delegate respondsToSelector:@selector(sudokuView:didSelectAtIndex:)]) {
        [self.delegate sudokuView:self didSelectAtIndex:cell.tag];
    }
    if ([self.delegate respondsToSelector:@selector(sudokuCell:didSelectAtIndex:)]) {
        [self.delegate sudokuCell:cell didSelectAtIndex:cell.tag];
    }
}
//移除所有子控件
- (void)removeAllSubViews {
    for (UIView *view in [_scrollView subviews]) {
        [view removeFromSuperview];
    }
}
//显示控件
- (void)showWithView:(UIView *)view {
    if (!view)return;
    [self scale];
    [view addSubview:self];
    [self configShareView];
}
//刷新控件
- (void)reloadData {
    [self scale];
    [self configShareView];
}


#pragma mark - init

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]init];
        _scrollView.backgroundColor = [UIColor clearColor];
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.pagingEnabled = YES;
        _scrollView.delegate = self;
        _scrollView.frame = self.bounds;
        //        _scrollView.bounces = NO;//关闭拖拽弹动效果
        [self addSubview:_scrollView];
    }
    return _scrollView;
}
//线条初始化
- (UIView *)line {
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = [UIColor colorWithRed:207/255.0 green:210/255.0 blue:213/255.0 alpha:0.7];
    return line;
}
//初始化翻页控件
- (UIPageControl *)pageControl {
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc]init];
        _pageControl.backgroundColor = [UIColor clearColor];
        _pageControl.currentPageIndicatorTintColor = [UIColor colorWithRed:0/255.0 green:162/255.0 blue:255/255.0 alpha:1];
        _pageControl.pageIndicatorTintColor = [UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:1];
        //_pageControl.pageIndicatorTintColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"blue_circle_icon"]];
        [_pageControl setUserInteractionEnabled:NO];
    }
    return _pageControl;
}

- (CGFloat)scale {
    if (_scale == 0) {
        _scale = ([UIScreen mainScreen].bounds.size.height>480?[UIScreen mainScreen].bounds.size.height/667.0:0.851574);
    }
    return _scale;
}

@end
