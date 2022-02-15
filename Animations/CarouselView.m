//
//  CarouselView.m
//  Animations
//
//  Created by 朱晓峰 on 2022/2/14.
//  Copyright © 2022 JM. All rights reserved.
//

#import "CarouselView.h"

@interface CarouselView()
<
UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout
>

@property (nonatomic, strong) UICollectionView *collectionView;
/// 缓存的视图
@property (nonatomic, strong) NSMutableDictionary<NSString *,UIView *> *cells;

@property (nonatomic, assign) CarouselViewScrollDirection scrollDirection;
@end

@implementation CarouselView

- (instancetype)initWithFrame:(CGRect)frame scrollDirection:(CarouselViewScrollDirection)scrollDirection {
    if (self = [super initWithFrame:frame]) {
        [self setupData];
        _scrollDirection = scrollDirection;
        [self setupSubViews];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupData];
        [self setupSubViews];
    }
    return self;
}

/// 初始化子视图
- (void)setupSubViews {
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = (int)_scrollDirection;
    _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
    [self addSubview:_collectionView];
    
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    
    _collectionView.pagingEnabled = YES;
    if (@available(iOS 13.0, *)) {
        _collectionView.automaticallyAdjustsScrollIndicatorInsets = NO;
    } else {
        // Fallback on earlier versions
    }
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    _collectionView.scrollEnabled = _scrollEnable;
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.showsHorizontalScrollIndicator = NO;
}

/// 默认值
- (void)setupData {
    _scrollEnable = YES;
    _circleEnable = YES;
    _scrollDirection = CarouselViewScrollDirectionHorizontal;
    _currentIndex = 0;
    
    _cells = [NSMutableDictionary dictionary];
}

- (void)setScrollEnable:(BOOL)scrollEnable {
    _scrollEnable = scrollEnable;
    _collectionView.scrollEnabled = scrollEnable;
}


/// 刷新列表
- (void)reloadData {
    [_cells removeAllObjects];
    
    [_collectionView reloadData];
    [self scrollToPage:0 animation:NO];
}

- (void)scrollToPage:(NSUInteger)index animation:(BOOL)animation {
    NSInteger section = _circleEnable ? 1 : 0;
    UICollectionViewScrollPosition positon;
    if (_scrollDirection == CarouselViewScrollDirectionVertical) {
        positon = UICollectionViewScrollPositionTop;
    } else {
        positon = UICollectionViewScrollPositionLeft;
    }
    [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:section] atScrollPosition:positon animated:animation];
}
#pragma mark delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.delegate && [self.delegate respondsToSelector:@selector(numberOfItemsInCarouselView:)]) {
        return [self.delegate numberOfItemsInCarouselView:self];
    }
    return 0;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return _circleEnable ? 3 : 1;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.delegate && [self.delegate respondsToSelector:@selector(carouselView:didSelectItemAtIndex:)]) {
        [self.delegate carouselView:self didSelectItemAtIndex:indexPath.row];
    }
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    NSString *key = [NSString stringWithFormat:@"%ld",indexPath.row];
    
    UIView *view;
    if (self.cells[key]) {
        view = self.cells[key];
    } else {
        if (self.delegate && [self.delegate respondsToSelector:@selector(carouselView:cellForItemAtIndex:)]) {
            view = [self.delegate carouselView:self cellForItemAtIndex:indexPath.row];
        }
        self.cells[key] = view;
    }
    
    [cell.contentView addSubview:view];
    view.frame = cell.contentView.bounds;
    cell.backgroundColor = self.backgroundColor;
    return cell;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (_circleEnable) {
        NSIndexPath *indexPath;
        if (_scrollDirection == CarouselViewScrollDirectionHorizontal) {
            indexPath = [_collectionView indexPathForItemAtPoint:CGPointMake(scrollView.contentOffset.x + 10, scrollView.contentOffset.y)];
        } else {
            indexPath = [_collectionView indexPathForItemAtPoint:CGPointMake(scrollView.contentOffset.x, scrollView.contentOffset.y + 10)];
        }
        if (indexPath.section != 1) {
            [self scrollToPage:indexPath.row animation:NO];
        }
    }
}
- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    NSIndexPath *index = [_collectionView indexPathForItemAtPoint:CGPointMake(collectionView.contentOffset.x + 10, collectionView.contentOffset.y)];
    if (_currentIndex != index.row) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(carouselView:didChangedCurrentIndex:)]) {
            
            [self.delegate carouselView:self didChangedCurrentIndex:index.row];
        }
        _currentIndex = index.row;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return collectionView.frame.size;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}
@end
