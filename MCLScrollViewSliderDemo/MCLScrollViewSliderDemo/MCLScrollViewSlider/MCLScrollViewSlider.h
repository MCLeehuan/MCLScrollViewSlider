//
//  MCLScrollViewSlider.h
//  MCLScrollViewSlider
//
//  Created by MC Lee on 15/6/4.
//  Copyright (c) 2015年 MCLee. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^MCLClickedCallbackBlock)(NSInteger clickedIndex);

typedef enum {
    MCLScrollViewSliderPageContolAlimentRight,
    MCLScrollViewSliderPageContolAlimentCenter,
    MCLScrollViewSliderPageContolAlimentLeft
} MCLScrollViewSliderPageContolAliment;

/**
 *  @author MCLee
 *  @email  mcleehuan@gmail.com
 *  @github https://github.com/MCLeehuan/
 *  @note 待更新功能：1.pageControl显隐 2.是否自动轮播 3.轮播动画 4.加载网络图片的过滤动画 5.作为引导图使用
 *  @note 待完善的其他方面：1.发布全英文版 2.更专业的三方库 3.优化API 4.优化代码，枚举，私有方法规范等 5.设备适配 5.图片尺寸适配 6.内存优化 7.增加应用场景 8.优化库大小 9.单元测试
 */
@interface MCLScrollViewSlider : UIView

/**
 slider中label对象的text字符串组成的数组。不设置时，不显示label。
 **/
@property (nonatomic, strong) NSArray *labelTexts;

/**
 slider的自动滚动时间间隔，默认为1秒。
 **/
@property (nonatomic) CGFloat autoScrollTimeInterval;

/**
 slider子视图pageControl的位置，提供三个选项：左、中、右，默认居右。当有label时，无法设置此参数，强制选中右。
 **/
@property (nonatomic) MCLScrollViewSliderPageContolAliment pageControlAliment;

/**
pageControl未选中颜色，默认为UIPageControl的pageIndicatorTintColor属性默认值。
**/
@property (nonatomic, strong) UIColor *pageControlIndicatorTintColor;

/**
 pageControl选中颜色，默认为UIPageControl的currentPageIndicatorTintColor属性默认值。
 **/
@property (nonatomic, strong) UIColor *pageControlCurrentIndicatorTintColor;

/**
 label字体颜色，默认为白色。
 **/
@property (nonatomic, strong) UIColor *labelTextColor;

/**
 label背景颜色，默认为Red:0 green:0 blue:0 alpha:0.5。
 **/
@property (nonatomic, strong) UIColor *labelBackgroundColor;

/**
 label字体大小，默认为systemFontOfSize:14。
 **/
@property (nonatomic, strong) UIFont *labelTextFont;

/**
 label高度，默认为30。
 **/
@property (nonatomic) CGFloat labelHeight;

/**
 *  用本地图片初始化slider
 *
 *  @param frame  slider的frame
 *  @param images 由UIImage对象组成的数组
 *
 *  @return slider对象
 */
+ (instancetype)scrollViewSliderWithFrame:(CGRect)frame
                                   images:(NSArray *)images;

/**
 *  用网络图片初始化slider
 *
 *  @param frame  slider的frame
 *  @param imageURLs 由NSURL对象组成的数组
 *  @param placeholderImage UIImage占位符对象
 *
 *  @return slider对象
 */
+ (instancetype)scrollViewSliderWithFrame:(CGRect)frame
                                imageURLs:(NSArray *)imageURLs
                         placeholderImage:(UIImage *)placeholderImage;

/**
 *  点击任一图片的响应方法
 *
 *  @param block  用于回调的block。使用block时注意避免循环引用，将MCLScrollViewSlider对象转换成weak指针。
 *
 */
- (void)didSelectItemWithBlock:(MCLClickedCallbackBlock)block;

@end
