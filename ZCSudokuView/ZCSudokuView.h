//
//  ShareView.h
//  AiyoyouDemo
//
//  Created by aiyoyou on on 16/7/1.
//  Copyright © 2016年 aiyoyou. All rights reserved.
//

/**
 *  调用示例
 *
- (ZCSudokuView *)sudokuView {
    if (!_sudokuView) {
        _sudokuView = [[ZCSudokuView alloc] init];
        _sudokuView.backgroundColor = [UIColor whiteColor];
        _sudokuView.columnAmount = 4;
        _sudokuView.rowAmount = 2;
        _sudokuView.number = 12;
        _sudokuView.delegate = self;
        //        _sudokuView.isDrawLine = YES;
        _sudokuView.frame = CGRectMake(0,
                                       32,
                                       ([UIScreen mainScreen].bounds.size.width),
                                       150);
        [_sudokuView showWithView:self.view];
    }
    return _sudokuView;
}


#pragma mark - ShareViewDelegate

- (ZCSudokuCell *)sudokuView:(ZCSudokuView *)sudokuView cellForRowAtIndex:(NSInteger)index {
    NSLog(@"%ld",(long)index);
    ZCSudokuCell *cell = [[ZCSudokuCell alloc]init];
    cell.imageView.image = [UIImage imageNamed:@"key"];
    cell.titleLabel.text = @"微博";
    //    cell.imageEdgeInsets = UIEdgeInsetsMake(0,0, 0,0);
    //    cell.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    //    cell.imageViewSize = CGSizeMake(20,20);
    //    __weak typeof (ZCSudokuCell *)weakCell = cell;
    //    [cell imageViewcornerRadius:^(CGSize imageViewSize) {
    //        weakCell.imageView.layer.cornerRadius = imageViewSize.width/2.0;
    //    }];
    return cell;
}
 
 - (void)sudokuView:(ZCSudokuView *)sudokuView didSelectAtIndex:(NSInteger)index {
    NSLog(@"%ld",(long)index);
}
 */


#import <UIKit/UIKit.h>
@class ZCSudokuCell;
@class ZCSudokuView;

@protocol ZCSudokuViewDelegate <NSObject>
@required
- (ZCSudokuCell *)sudokuView:(ZCSudokuView *)sudokuView cellForRowAtIndex:(NSInteger)index;

@optional
- (NSInteger )numberOfColumnInSudokuView;//纵列列数
- (NSInteger )numberOfRowInSudokuView;//行数
- (NSInteger )numberOfCellInSudokuView;//数据源个数
- (void)sudokuView:(ZCSudokuView *)sudokuView didSelectAtIndex:(NSInteger)index;//九宫格点击事件代理
- (void)sudokuCell:(ZCSudokuCell *)cell didSelectAtIndex:(NSInteger)index;//九宫格点击事件代理

@end

@interface ZCSudokuView : UIView

@property (nonatomic,assign) NSInteger                  columnAmount;//纵列列数（也可以选择代理形式设置列数）
@property (nonatomic,assign) NSInteger                  rowAmount;//行数（也可以选择代理形式设置行数）
@property (nonatomic,assign) NSInteger                  number;//数据源个数（也可以选择代理形式设置数据源个数）

@property (nonatomic,assign) id<ZCSudokuViewDelegate>   delegate;
@property (nonatomic,assign) BOOL                       isDrawLine;//Defaul is no.（默认不画分割线）

- (void)showWithView:(UIView *)view;//将九宫格显示在view上
- (void)reloadData;//刷新九宫格

@end
