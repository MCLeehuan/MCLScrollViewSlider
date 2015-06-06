//
//  MCLCollectionViewCell.m
//  MCLScrollViewSlider
//
//  Created by MC Lee on 15/6/4.
//  Copyright (c) 2015年 MCLee. All rights reserved.
//

#import "MCLCollectionViewCell.h"

@interface MCLCollectionViewCell ()

@property (nonatomic, weak) UILabel *label;

@end

@implementation MCLCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupImageView];
        [self setupLabel];
    }
    
    return self;
}

- (void)setupImageView {
    UIImageView *imageView = [[UIImageView alloc] init];
    self.imageView = imageView;
    self.imageView.frame = self.bounds;
    [self addSubview:self.imageView];
}

- (void)setupLabel {
    UILabel *label = [[UILabel alloc] init];
    self.label = label;
    //label默认隐藏
    self.label.hidden = YES;
    [self addSubview:self.label];
}

//重写setter方法：不要调用self.labelText，会造成死循环；可在此方法里为label设置值，方便在cell initWithFrame之后修改。
- (void)setLabelText:(NSString *)labelText {
    _labelText = [labelText copy];
    self.label.text = [NSString stringWithFormat:@"    %@", _labelText];
    
    //如果label.text被设置，则显示label。
    self.label.hidden = NO;
}

- (void)setLabelTextColor:(UIColor *)labelTextColor {
    _labelTextColor = labelTextColor;
    self.label.textColor = _labelTextColor;
}

- (void)setLabelBackgroundColor:(UIColor *)labelBackgroundColor {
    _labelBackgroundColor = labelBackgroundColor;
    self.label.backgroundColor =  _labelBackgroundColor;
}

- (void)setLabelTextFont:(UIFont *)labelTextFont {
    _labelTextFont = labelTextFont;
    self.label.font = _labelTextFont;
}

- (void)setLabelHeight:(CGFloat)labelHeight {
    _labelHeight = labelHeight;
    CGFloat labelWidth = self.frame.size.width;
    CGFloat labelY = self.frame.size.height - _labelHeight;
    self.label.frame = CGRectMake(0, labelY, labelWidth, _labelHeight);
}

@end
