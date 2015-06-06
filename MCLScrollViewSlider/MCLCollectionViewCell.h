//
//  MCLCollectionViewCell.h
//  MCLScrollViewSlider
//
//  Created by MC Lee on 15/6/4.
//  Copyright (c) 2015年 MCLee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MCLCollectionViewCell : UICollectionViewCell

@property (nonatomic, weak) UIImageView *imageView;

@property (nonatomic, copy) NSString *labelText;
@property (nonatomic, strong) UIColor *labelTextColor;
@property (nonatomic, strong) UIColor *labelBackgroundColor;
@property (nonatomic, strong) UIFont *labelTextFont;
@property (nonatomic) CGFloat labelHeight;
@property (nonatomic) BOOL hasConfigured;

@end
