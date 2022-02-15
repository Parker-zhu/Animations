//
//  CarouselViewController.m
//  Animations
//
//  Created by 朱晓峰 on 2022/2/14.
//  Copyright © 2022 YouXianMing. All rights reserved.
//

#import "CarouselViewController.h"
#import "UIView+SetRect.h"
#import "DeviceInfo.h"
#import "CarouselView.h"
#import "UIFont+Fonts.h"

@interface CarouselViewController ()<CarouselViewDelegate>

@end

@implementation CarouselViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    {
        CarouselView *view = [[CarouselView alloc] initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, 200)];
        view.delegate = self;
        [view reloadData];
        [self.view addSubview:view];
    }
    
    {
        CarouselView *view = [[CarouselView alloc] initWithFrame:CGRectMake(0, 400, self.view.frame.size.width, 200) scrollDirection:CarouselViewScrollDirectionVertical];
        view.delegate = self;
        [view reloadData];
        [self.view addSubview:view];
    }
}

- (void)makeViewsConfig:(NSMutableDictionary<NSString *,ControllerBaseViewConfig *> *)viewsConfig {
    
    if (DeviceInfo.isFringeScreen == YES) {
        
        CGFloat realHeight = 64 + DeviceInfo.fringeScreenTopSafeHeight;
        
        ControllerBaseViewConfig *titleViewConfig = viewsConfig[titleViewId];
        ControllerBaseViewConfig *contentViewConfig = viewsConfig[contentViewId];
        
        titleViewConfig.frame   = CGRectMake(0, 0, Width, realHeight);
        contentViewConfig.frame = CGRectMake(0, realHeight, Width, Height - realHeight);
    }
}

- (void)setupSubViews {
    
    // Title label.
    UILabel *titleLabel      = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, Width, 64.f)];
    titleLabel.font          = [UIFont HeitiSCWithFontSize:20.f];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor     = [UIColor colorWithRed:0.329  green:0.329  blue:0.329 alpha:1];
    titleLabel.text          = self.title;
    titleLabel.bottom        = self.titleView.height;
    [self.titleView addSubview:titleLabel];
    
    // Line.
    UIView *line         = [[UIView alloc] initWithFrame:CGRectMake(0, self.titleView.height - 0.5, self.view.width, 0.5)];
    line.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.25f];
    [self.titleView addSubview:line];
    
    // Back button.
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 64)];
    backButton.center    = CGPointMake(20, titleLabel.centerY);
    [backButton setImage:[UIImage imageNamed:@"backIcon"]             forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"backIcon_highlighted"] forState:UIControlStateHighlighted];
    [backButton addTarget:self action:@selector(popSelf) forControlEvents:UIControlEventTouchUpInside];
    [backButton.imageView setContentMode:UIViewContentModeCenter];
    [self.titleView addSubview:backButton];
}

- (void)popSelf {
    
    [self popViewControllerAnimated:YES];
}
#pragma mark delegate
- (__kindof UIView *)carouselView:(CarouselView *)carouselView cellForItemAtIndex:(NSInteger)index {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor colorWithRed:(random()%255)/255.0 green:(random()%255)/255.0 blue:(random()%255)/255.0 alpha:1];
    return view;
}
- (NSInteger)numberOfItemsInCarouselView:(CarouselView *)carouselView {
    return 3;
}

- (void)carouselView:(CarouselView *)carouselView didChangedCurrentIndex:(NSInteger)index {
    
}
- (void)carouselView:(CarouselView *)carouselView didSelectItemAtIndex:(NSInteger)index {
    
}
@end
