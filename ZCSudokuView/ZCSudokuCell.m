//
//  ShareCell.m
//  AiyoyouDemo
//
//  Created by aiyoyou on 16/7/1.
//  Copyright © 2016年 aiyoyou. All rights reserved.
//

#import "ZCSudokuCell.h"

#define kSelfW          self.frame.size.width
#define kSelfH          self.frame.size.height

@interface ZCSudokuCell()
{
    CGFloat         _scale;
}
@property (nonatomic,copy) void(^MyBlock)(CGSize imageViewSize);
@end

@implementation ZCSudokuCell
@synthesize imageView   = _imageView;
@synthesize titleLabel  = _titleLabel;

//cell初始化
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        _scale = ([UIScreen mainScreen].bounds.size.height>480?[UIScreen mainScreen].bounds.size.height/667.0:0.851574);
    }
    return self;
}

//重写cell的frame的setter方法,子控件的位置信息只有在父容器frame确定之后才能被确定。
- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    [self configControlFrame];
}
/*
 cell子控件frame设置。这里的_imageView不能使用self.imageView。因为点语法会调用getter方法，本身不需
 要实例化的控件会被实例化，这样我们没有用到的控件也实例化了，所以getter懒加载方式加载控件是要放在需要时例化控件才能继续
 操作的步骤上。
 */
- (void)configControlFrame {
    
    //imageView位置
    if (_imageView) {
        _imageView.frame = CGRectMake(0,
                                      0,
                                      self.imageViewSize.width,
                                      self.imageViewSize.height);
        CGFloat imageCenterX = self.imageEdgeInsets.left-self.imageEdgeInsets.right+kSelfW/2.0;
        CGFloat imageCenterY = self.imageEdgeInsets.top-self.imageEdgeInsets.bottom+(_titleLabel?kSelfH*2/5.0:kSelfH/2.0);
        _imageView.center = CGPointMake(imageCenterX,imageCenterY);
        if (_MyBlock) {
            _MyBlock(_imageViewSize);
        }
    }
    
    
    //titleLabel位置
    if (_titleLabel) {
        _titleLabel.frame = CGRectMake(0,
                                       0,
                                       self.titleLabelSize.width,
                                       self.titleLabelSize.height);
        CGFloat titleCenterX = self.titleEdgeInsets.left+self.titleEdgeInsets.right+kSelfW/2.0;
        CGFloat titleCenterY = self.titleEdgeInsets.top+self.titleEdgeInsets.bottom+(_imageView?kSelfH*4/5.0:kSelfH/2.0);
        _titleLabel.center = CGPointMake(titleCenterX,titleCenterY);
    }
}

//图片控件
- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc]init];
        _imageView.contentMode = UIViewContentModeScaleToFill;
        _imageView.backgroundColor = [UIColor clearColor];
        _imageView.clipsToBounds = YES;
        _imageView.layer.cornerRadius = 3;
        [self addSubview:_imageView];
    }
    return _imageView;
}

//文字控件
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.font = [UIFont systemFontOfSize:15*_scale];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_titleLabel];
    }
    return _titleLabel;
}


//修改ImageView和titleLabel的默认大小（imageView的宽高为self高度的2/5 ,titleLabel的高度为self高度的1/5）;
- (CGSize)imageViewSize {
    _imageViewSize = CGSizeEqualToSize(_imageViewSize,CGSizeZero)?CGSizeMake(kSelfH*2/5.0,kSelfH*2/5.0):_imageViewSize;
    return _imageViewSize;
}

- (CGSize)titleLabelSize {
    _titleLabelSize = CGSizeEqualToSize(_titleLabelSize,CGSizeZero)?CGSizeMake(kSelfW,kSelfH/5.0):_titleLabelSize;
    return _titleLabelSize;
}

- (void)imageViewcornerRadius:(void (^)(CGSize))blockImageView {
    _MyBlock = blockImageView;
}

@end
