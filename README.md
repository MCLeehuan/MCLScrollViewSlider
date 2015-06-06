# MCLScrollViewSlider
MCLScrollViewSlider is a delightful autoscrollview library for iOS.It's built on top of the UICollectionView.

Choose MCLScrollViewSlider for your next project, or migrate over your existing projects—you'll be happy you did!

#### Screenshot
![Alt text](http://a.hiphotos.baidu.com/image/pic/item/c2cec3fdfc0392459e43548f8294a4c27c1e25bf.jpg)

## How To Get Started 

*	Download MCLScrollViewSlider and try out the included iPhone example apps
*	Read the "Getting Started" guide
*	Check out the documentation for a comprehensive look at all of the APIs available in MCLScrollViewSlider

## Communication

*	If you found a bug, and can provide steps to reliably reproduce it, open an issue.
*	If you want to contribute, submit a pull request.

## Installation with CocoaPods

CocoaPods is a dependency manager for Objective-C, which automates and simplifies the process of using 3rd-party libraries like MCLScrollViewSlider in your projects. 

### Podfile
> platform :ios, '7.0'

>pod "MCLScrollViewSlider"


	
## Architecture

###MCLScrollViewSlider
*	MCLScrollViewSlider

### MCLCollectionViewCell
*	MCLCollectionViewCell

### MCLImageCache
*	NSData+MCLDataCache

## Usage
### Local Images
>		MCLScrollViewSlider *scrollView = [MCLScrollViewSlider 		scrollViewSliderWithFrame:CGRectMake(0, 60, w, 180)
		images:images];
		[self.view addSubview:scrollView];

### Web Images
>		MCLScrollViewSlider *scrollView = [MCLScrollViewSlider 		scrollViewSliderWithFrame:CGRectMake(0, 280, w, 180)
		imageURLs:imagesURL
		placeholderImage:[UIImage imageNamed:@"placeholder"]];
		[self.view addSubview:scrollView];

		
### More Options Above Usage
##### Add labels
>		NSArray *labelTexts = @[@"1", @"2"];
>		scrollView.labelTexts = labelTexts;

##### Change autoScrollTimeInterval(Default value is 1.0 s)
>		scrollView.autoScrollTimeInterval = 2.0;
                                              
##### Add didSelectItemWithBlock
>		[scrollView didSelectItemWithBlock:^(NSInteger clickedIndex) {
        		NSLog(@"%d",(int)clickedIndex); }];
                 
##### Change pageControlAliment(Default value is MCLScrollViewSliderPageContolAlimentRight)
>		scrollView.pageControlAliment = MCLScrollViewSliderPageContolAlimentCenter; (or MCLScrollViewSliderPageContolAlimentLeft)

##### Change pageControlIndicatorTintColor
>		scrollView.pageControlIndicatorTintColor = [UIColor redColor];

##### Change pageControlCurrentIndicatorTintColor
>		scrollView.pageControlCurrentIndicatorTintColor = [UIColor redColor];

##### Change labelTextColor
>		scrollView.labelTextColor = [UIColor redColor];

##### Change labelBackgroundColor
>		scrollView.labelBackgroundColor = [UIColor redColor];

##### Change labelTextFont
>		scrollView.labelTextFont = [UIFont systemFontOfSize:14];

##### Change labelHeight
>		scrollView.labelHeight = 40;

## Contact
Email: mcleehuan@gmail.com

## Maintainers
MCLee

## License
MCLScrollViewSlider is available under the MIT license. See the LICENSE file for more info.

