//
//  ShareCell.h
//  AiyoyouDemo
//
//  Created by aiyoyou on 16/7/1.
//  Copyright © 2016年 aiyoyou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZCSudokuCell : UIButton

@property (nonatomic,strong) UIImageView             *imageView;//图片
@property (nonatomic,strong) UILabel                 *titleLabel;//标题

@property (nonatomic,assign) CGSize                 imageViewSize;//自定义imageView的大小
@property (nonatomic,assign) CGSize                 titleLabelSize;//自定义titleLabel的大小

//获取imageView的大小（如果自定义了imageView的大小则不需要调用这个block来获取imageView的大小）
- (void)imageViewcornerRadius:(void(^)(CGSize imageViewSize)) blockImageView;


@end
