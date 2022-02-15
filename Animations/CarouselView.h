//
//  CarouselView.h
//  Animations
//
//  Created by 朱晓峰 on 2022/2/14.
//  Copyright © 2022 JM. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, CarouselViewScrollDirection) {
    CarouselViewScrollDirectionVertical,
    CarouselViewScrollDirectionHorizontal
};

@class CarouselView;
@protocol CarouselViewDelegate <NSObject>

@required

- (NSInteger)numberOfItemsInCarouselView:(CarouselView *)carouselView;

/// 展示的视图，只调用一次
- (__kindof UIView *)carouselView:(CarouselView *)carouselView cellForItemAtIndex:(NSInteger)index;

/// 当前展示的index发生变化
- (void)carouselView:(CarouselView *)carouselView didChangedCurrentIndex:(NSInteger)index;

@optional
/// 相应点击事件
- (void)carouselView:(CarouselView *)carouselView didSelectItemAtIndex:(NSInteger)index;

@end

@interface CarouselView : UIView

- (instancetype)initWithFrame:(CGRect)frame scrollDirection:(CarouselViewScrollDirection)scrollDirection;

@property (nonatomic, weak) id<CarouselViewDelegate> delegate;

/// 当前展示的位置
@property (nonatomic, assign, readonly) NSUInteger currentIndex;
/// YES：允许滑动,默认YES
@property (nonatomic, assign) BOOL scrollEnable;
/// 允许轮播
@property (nonatomic, assign) BOOL circleEnable;

- (void)reloadData;

- (void)scrollToPage:(NSUInteger)index animation:(BOOL)animation;

@end

NS_ASSUME_NONNULL_END
