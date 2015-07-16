//
//  MCLScrollViewSlider.m
//  MCLScrollViewSlider
//
//  Created by MC Lee on 15/6/4.
//  Copyright (c) 2015年 MCLee. All rights reserved.
//

#import "MCLScrollViewSlider.h"
#import "MCLCollectionViewCell.h"
#import "NSData+MCLDataCache.h"

NSString * const cellIdentifier = @"cellIdentifier";

@interface MCLScrollViewSlider () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, weak) UICollectionView *mainView;
@property (nonatomic, weak) UICollectionViewFlowLayout *flowLayout;
@property (nonatomic, weak) UIPageControl *pageControl;
@property (nonatomic, strong) NSMutableArray *images;
@property (nonatomic, strong) UIImage *placeholderImage;
@property (nonatomic, strong) NSArray *imageURLs;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic) NSInteger cellCount;
@property (nonatomic, strong) MCLClickedCallbackBlock callbackBlock;

@end

@implementation MCLScrollViewSlider

+ (instancetype)scrollViewSliderWithFrame:(CGRect)frame images:(NSArray *)images {
    MCLScrollViewSlider *scrollViewSlider = [[self alloc] initWithFrame:frame];
    scrollViewSlider.images = [NSMutableArray arrayWithArray:images];
    return scrollViewSlider;
}

+ (instancetype)scrollViewSliderWithFrame:(CGRect)frame imageURLs:(NSArray *)imageURLs placeholderImage:(UIImage *)placeholderImage{
    MCLScrollViewSlider *scrollViewSlider = [[self alloc] initWithFrame:frame];
    scrollViewSlider.imageURLs = [NSMutableArray arrayWithArray:imageURLs];
    scrollViewSlider.placeholderImage = placeholderImage;
    return scrollViewSlider;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initialization];
        [self setupMainView];
    }
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    //当回滚到offset=0时，scrollTo中部。
    if (self.mainView.contentOffset.x == 0 &&  self.cellCount) {
        [self.mainView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.cellCount * 0.5 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    }
    
    if (self.labelTexts.count) {
        self.pageControlAliment = MCLScrollViewSliderPageContolAlimentRight;
    }
}

//解决当父View释放时，当前视图因为被Timer强引用而不能释放的问题
- (void)willMoveToSuperview:(UIView *)newSuperview {
    if (!newSuperview) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

// 默认设置
- (void)initialization {
    _autoScrollTimeInterval = 1.0;
    _labelTextColor = [UIColor whiteColor];
    _labelBackgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    _labelTextFont= [UIFont systemFontOfSize:14];
    _labelHeight = 30;
    self.backgroundColor = [UIColor lightGrayColor];
}

// 设置显示图片的collectionView
- (void)setupMainView {
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = self.frame.size;
    flowLayout.minimumLineSpacing = 0;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.flowLayout = flowLayout;
    
    UICollectionView *mainView = [[UICollectionView alloc] initWithFrame:self.frame collectionViewLayout:self.flowLayout];
    mainView.backgroundColor = [UIColor clearColor];
    mainView.pagingEnabled = YES;
    mainView.showsHorizontalScrollIndicator = NO;
    mainView.showsVerticalScrollIndicator = NO;
    [mainView registerClass:[MCLCollectionViewCell class] forCellWithReuseIdentifier:cellIdentifier];
    mainView.dataSource = self;
    mainView.delegate = self;
    self.mainView = mainView;
    self.mainView.frame = self.bounds;
    [self addSubview:self.mainView];
}

- (void)setImages:(NSMutableArray *)images {
    _images = images;
    self.cellCount = self.images.count * 100;
    
    if (_images.count != 1 && _images.count != 0) {
        [self setupTimer]; //第一次setupTimer
    } else {
        self.mainView.scrollEnabled = NO;
    }
    
    [self setupPageControl]; //必须在images确定了之后调用
    [self.mainView reloadData];
}

- (void)setImageURLs:(NSArray *)imageURLs {
    _imageURLs = imageURLs;
    
    NSMutableArray *images = [NSMutableArray arrayWithCapacity:_imageURLs.count];
    for (int i = 0; i < _imageURLs.count; i++) {
        UIImage *image = [[UIImage alloc] init];
        [images addObject:image];
    }
    self.images = images; //images是最终承载数组
    [self loadImageWithImageURLs:_imageURLs];
}

- (void)loadImageWithImageURLs:(NSArray *)imageURLs {
    for (int i = 0; i < imageURLs.count; i++) {
        [self loadImageAtIndex:i];
    }
}

- (void)loadImageAtIndex:(NSInteger)index {
    NSURL *url = self.imageURLs[index];
    
    // 如果有缓存，直接加载缓存
    NSData *data = [NSData getDataCacheWithIdentifier:url.absoluteString];
    if (data) {
        [self.images setObject:[UIImage imageWithData:data] atIndexedSubscript:index];
    } else {
        
        // 网络加载图片并缓存图片
        [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:url]
                                           queue:[[NSOperationQueue alloc] init]
                               completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError){
                                   if (!connectionError) {
                                       UIImage *image = [UIImage imageWithData:data];
                                       if (!image) return; // 防止错误数据导致崩溃
                                       [self.images setObject:image atIndexedSubscript:index];
                                       dispatch_async(dispatch_get_main_queue(), ^{
                                           if (index == 0) {
                                               [self.mainView reloadData];
                                           }
                                       });
                                       [data saveDataCacheWithIdentifier:url.absoluteString];
                                   } else { // 加载数据失败
                                       static int repeat = 0;
                                       dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                           if (repeat > 10) return;
                                           [self loadImageAtIndex:index];
                                           repeat++;
                                       });
                                       
                                   }
                               }
         
         ];
    }
}

- (void)setupPageControl {
    if (self.pageControl) [self.pageControl removeFromSuperview]; //重新加载数据时调整
    
    UIPageControl *pageControl = [[UIPageControl alloc] init];
    pageControl.numberOfPages = self.images.count;
    pageControl.pageIndicatorTintColor = self.pageControlIndicatorTintColor;
    self.pageControl = pageControl;
    self.pageControlAliment = MCLScrollViewSliderPageContolAlimentRight;
    [self addSubview:self.pageControl];
}

- (void)setPageControlAliment:(MCLScrollViewSliderPageContolAliment)pageControlAliment {
    _pageControlAliment = pageControlAliment;
    CGSize size = [self.pageControl sizeForNumberOfPages:self.images.count];
    CGFloat height = size.height - 5;
    CGFloat x = (self.frame.size.width - size.width) * 0.5; //居中
    switch (_pageControlAliment) {
        case MCLScrollViewSliderPageContolAlimentCenter:
            break;
        case MCLScrollViewSliderPageContolAlimentRight:
            x = self.frame.size.width - size.width - 10;
            break;
        case MCLScrollViewSliderPageContolAlimentLeft:
            x = 10;
            break;
    }
    
    CGFloat y = self.frame.size.height - height;
    self.pageControl.frame = CGRectMake(x, y, size.width, height);
}

- (void)setPageControlIndicatorTintColor:(UIColor *)pageControlIndicatorTintColor {
    _pageControlIndicatorTintColor = pageControlIndicatorTintColor;
    self.pageControl.pageIndicatorTintColor = _pageControlIndicatorTintColor;
}

- (void)setPageControlCurrentIndicatorTintColor:(UIColor *)pageControlCurrentIndicatorTintColor {
    _pageControlCurrentIndicatorTintColor = pageControlCurrentIndicatorTintColor;
    self.pageControl.currentPageIndicatorTintColor = _pageControlCurrentIndicatorTintColor;
}

- (void)setAutoScrollTimeInterval:(CGFloat)autoScrollTimeInterval {
    _autoScrollTimeInterval = autoScrollTimeInterval;
    
    [self.timer invalidate];
    self.timer = nil;
    [self setupTimer];
}

- (void)setupTimer {
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:self.autoScrollTimeInterval target:self selector:@selector(automaticScroll) userInfo:nil repeats:YES];
    self.timer = timer;
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)automaticScroll {
    if (0 == self.cellCount) return;
    int currentIndex = self.mainView.contentOffset.x / self.flowLayout.itemSize.width;
    int targetIndex = currentIndex + 1;
    if (targetIndex == self.cellCount) {
        targetIndex = self.cellCount * 0.5;
        [self.mainView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:targetIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO]; // 回滚到中部
    }
    [self.mainView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:targetIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
}


#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.cellCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MCLCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    long itemIndex = indexPath.item % self.images.count;
    UIImage *image = self.images[itemIndex];
    if (image.size.width == 0 && self.placeholderImage) {
        image = self.placeholderImage;
    }
    cell.imageView.image = image;
    if (self.labelTexts.count) {
        cell.labelText = self.labelTexts[itemIndex];
    }

    if (!cell.hasConfigured) {
        cell.labelBackgroundColor = self.labelBackgroundColor;
        cell.labelTextColor = self.labelTextColor;
        cell.labelTextFont = self.labelTextFont;
        cell.labelHeight = self.labelHeight;
        cell.hasConfigured = YES;
    }
    
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.callbackBlock) {
        self.callbackBlock(indexPath.item % self.images.count);
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    int itemIndex = (scrollView.contentOffset.x + self.mainView.frame.size.width * 0.5) / self.mainView.frame.size.width;
    int indexOnPageControl = itemIndex % self.images.count;
    self.pageControl.currentPage = indexOnPageControl;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.timer invalidate];
    self.timer = nil;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self setupTimer];
}

#pragma mark - set block
- (void)didSelectItemWithBlock:(MCLClickedCallbackBlock)block {
    self.callbackBlock = block;
}

@end
