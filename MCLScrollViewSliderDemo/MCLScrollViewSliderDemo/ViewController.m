//
//  ViewController.m
//  MCLScrollViewSliderDemo
//
//  Created by MC Lee on 15/6/6.
//  Copyright (c) 2015年 GoldenVision. All rights reserved.
//

#import "ViewController.h"
#import "MCLScrollViewSlider.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    NSArray *images = @[[UIImage imageNamed:@"image_1.jpg"],
                        [UIImage imageNamed:@"image_2.jpg"],
                        [UIImage imageNamed:@"image_3.jpg"],
                        [UIImage imageNamed:@"image_4.jpg"]
                        ];
    
    NSArray *labelTests = @[@"NO.1 view's label",
                        @"NO.2 view's label",
                        @"NO.3 view's label",
                        @"NO.4 view's label"
                        ];
    
    // 加载本地图片
    MCLScrollViewSlider *localScrollView = [MCLScrollViewSlider scrollViewSliderWithFrame:CGRectMake(0, 50, self.view.bounds.size.width, 200)
                                                                                   images:images];
    localScrollView.labelTexts = labelTests;
    localScrollView.pageControlCurrentIndicatorTintColor = [UIColor redColor];
    [self.view addSubview:localScrollView];
    
    
    NSArray *imageURLs = @[
                           [NSURL URLWithString:@"http://e.hiphotos.baidu.com/image/pic/item/267f9e2f07082838bbd29a1cba99a9014d08f1df.jpg"],
                           [NSURL URLWithString:@"http://h.hiphotos.baidu.com/image/pic/item/9a504fc2d56285359235e92f92ef76c6a6ef63e2.jpg"],
                           [NSURL URLWithString:@"http://b.hiphotos.baidu.com/image/pic/item/f703738da9773912126cd560fa198618367ae26d.jpg"]
                           ];
    // 加载网络图片
        MCLScrollViewSlider *webScrollView = [MCLScrollViewSlider scrollViewSliderWithFrame:CGRectMake(0, 300, self.view.bounds.size.width, 200)
                                                                                     imageURLs:imageURLs
                                                                              placeholderImage:[UIImage imageNamed:@"placeholder"]];
        webScrollView.pageControlAliment = MCLScrollViewSliderPageContolAlimentCenter;
        webScrollView.autoScrollTimeInterval = 2.0;
        webScrollView.pageControlIndicatorTintColor = [UIColor yellowColor];
        [self.view addSubview:webScrollView];
        [webScrollView didSelectItemWithBlock:^(NSInteger clickedIndex) {
            NSLog(@"%d",(int)clickedIndex);
        }];

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
