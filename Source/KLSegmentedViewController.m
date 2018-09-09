//
//  KLSegmentedViewController.m
//  KLPageViewController
//
//  Created by liqian on 2018/9/5.
//  Copyright © 2018年 liqian. All rights reserved.
//

#import "KLSegmentedViewController.h"

@interface KLSegmentedViewController ()<UIPageViewControllerDelegate,
UIPageViewControllerDataSource, UIScrollViewDelegate, KLSegmentedViewDelegate>

@property (nonatomic, strong) NSArray<UIViewController *> *viewControllers;
@property (nonatomic, strong) UIView<KLSegmentedViewProtocol> *segmentedView;
@property (nonatomic, assign) BOOL needAutoAddSegmentedView;

@property (nonatomic, assign) NSInteger previousIndex;
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, strong) UIScrollView *internalScrollView;
@property (nonatomic, strong) UIPageViewController *pageController;
@property (nonatomic, strong) UIViewController *pendingViewController;
@property (nonatomic, assign) KLSegmentedViewPosition position;
@end

@implementation KLSegmentedViewController

- (instancetype)initWithViewControllers:(NSArray<UIViewController *> *)viewControllers {
    return [self initWithViewControllers:viewControllers segmentedView:nil needAutoAddSegmentedView:NO segmentedViewPosition:KLSegmentedViewPositionTop];
}


- (instancetype)initWithViewControllers:(NSArray<UIViewController *> *)viewControllers
                          segmentedView:(nullable UIView<KLSegmentedViewProtocol> *)segmentedView
                  segmentedViewPosition:(KLSegmentedViewPosition)position {
    return [self initWithViewControllers:viewControllers segmentedView:segmentedView needAutoAddSegmentedView:YES segmentedViewPosition:position];
}


- (instancetype)initWithViewControllers:(NSArray<UIViewController *> *)viewControllers
                          segmentedView:(nullable UIView<KLSegmentedViewProtocol> *)segmentedView
               needAutoAddSegmentedView:(BOOL)needAutoAddSegmentedView
                  segmentedViewPosition:(KLSegmentedViewPosition)position {
    NSAssert(viewControllers&&viewControllers.count, @"viewControllers 不能为空");
    self = [super init];
    if (!self) return nil;
    _previousIndex = -1;
    _currentIndex = -1;
    _viewControllers = viewControllers;
    _segmentedView = segmentedView;
    if (_segmentedView) {
        _segmentedView.delegate = self;
    }
    _needAutoAddSegmentedView = needAutoAddSegmentedView;
    _position = position;
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (_segmentedView && _needAutoAddSegmentedView) {
        [self.view addSubview:_segmentedView];
    }
    
    [self addChildViewController:self.pageController];
    [self.view addSubview:self.pageController.view];
    [self.pageController didMoveToParentViewController:self];
    self.internalScrollView.delegate = self;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    CGFloat segHeight = 0.0;
    
    if (_segmentedView && _needAutoAddSegmentedView) {
        segHeight = _segmentedView.height;
        switch (_position) {
            case KLSegmentedViewPositionBottom: {
                [_pageController.view mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.right.top.offset(0);
                    make.bottom.mas_equalTo(self.segmentedView.mas_top);
                }];
                [_segmentedView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.bottom.offset(0);
                    make.width.mas_equalTo(self.segmentedView.width);
                    make.height.mas_equalTo(self.segmentedView.height);
                    make.top.mas_equalTo(self.pageController.view.mas_bottom);
                }];
            } break;
                
//            case KLSegmentedViewPositionLeft: {
//                [_pageController.view mas_makeConstraints:^(MASConstraintMaker *make) {
//                    make.left.right.top.offset(0);
//                    make.bottom.mas_equalTo(self.segmentedView.mas_top);
//                }];
//                [_segmentedView mas_makeConstraints:^(MASConstraintMaker *make) {
//                    make.left.bottom.offset(0);
//                    make.width.mas_equalTo(self.segmentedView.width);
//                    make.height.mas_equalTo(self.segmentedView.height);
//                    make.top.mas_equalTo(self.pageController.view.mas_bottom);
//                }];
//            } break;
                
//            case KLSegmentedViewPositionRight: {
//                [_pageController.view mas_makeConstraints:^(MASConstraintMaker *make) {
//                    make.left.right.top.offset(0);
//                    make.bottom.mas_equalTo(self.segmentedView.mas_top);
//                }];
//                [_segmentedView mas_makeConstraints:^(MASConstraintMaker *make) {
//                    make.left.bottom.offset(0);
//                    make.width.mas_equalTo(self.segmentedView.width);
//                    make.height.mas_equalTo(self.segmentedView.height);
//                    make.top.mas_equalTo(self.pageController.view.mas_bottom);
//                }];
//            } break;
                
            default: {
                [_segmentedView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.top.offset(0);
                    make.width.mas_equalTo(self.segmentedView.width);
                    make.height.mas_equalTo(self.segmentedView.height);
                    make.bottom.mas_equalTo(self.pageController.view.mas_top);
                }];
                [_pageController.view mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.right.bottom.offset(0);
                    make.top.mas_equalTo(self.segmentedView.mas_bottom);
                }];
            } break;
        }
    }else {
        [_pageController.view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsZero);
        }];
    }
}

#pragma mark - Public Interface.
- (void)setCurrentSelectedIndex:(NSInteger)index animated:(BOOL)animated {
    if (index < 0 || index >= _viewControllers.count) {
        return;
    }
    
    if (animated) {
        UIPageViewControllerNavigationDirection direction = UIPageViewControllerNavigationDirectionForward;
        if (index <= _currentIndex) {
            direction = UIPageViewControllerNavigationDirectionReverse;
        }
        __weak typeof(self) weakSelf = self;
        [_pageController setViewControllers:@[_viewControllers[index]] direction:direction animated:YES completion:^(BOOL finished) {
            // 注；animated为NO时，不会进入此代码
            if (finished) {
                [weakSelf _handleNotificationWithIndex:index];
                [weakSelf.segmentedView selectedItemAtIndex:index];
                weakSelf.currentIndex = index;
            }
        }];
    }else {
        [_pageController setViewControllers:@[_viewControllers[index]] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
        [self _handleNotificationWithIndex:index];
        [self.segmentedView selectedItemAtIndex:index];
        self.currentIndex = index;
    }
}

- (void)setScrollEnabled:(BOOL)enabled {
    self.internalScrollView.scrollEnabled = enabled;
}

#pragma mark - KLSegmentedViewDelegate
- (void)klSegmentedView:(UIView *)view didSelectedItemAtIndex:(NSInteger)index {
    [self setCurrentSelectedIndex:index animated:YES];
}

#pragma mark - UIPageViewControllerDataSource / UIPageViewControllerDelegate.
- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    if (_currentIndex == 0) {
        return nil;
    }
    return _viewControllers[_currentIndex-1];
}

- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    if (_currentIndex == _viewControllers.count-1) {
        return nil;
    }
    return _viewControllers[_currentIndex+1];
}

- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray<UIViewController *> *)pendingViewControllers {
    _pendingViewController = pendingViewControllers.firstObject;
}

// pageViewController用手势滚动结束时调用，处理segmentedView的选择状态
- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed {
    if (completed) {
        NSInteger index = [_viewControllers indexOfObject:_pendingViewController];
        [self _handleNotificationWithIndex:index];
        [_segmentedView selectedItemAtIndex:index];
        _currentIndex = index;
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    NSLog(@"---> %@", NSStringFromCGPoint(scrollView.contentOffset));
    
//    CGFloat progress = (scrollView.contentOffset.x/scrollView.width) - 1.0;
//    NSLog(@"---> %.2f", progress);
    
}

#pragma mark - Private.
// handle Notify.
- (void)_handleNotificationWithIndex:(NSInteger)toIndex {
    if (toIndex >= _viewControllers.count) {
        return;
    }
    UIViewController *presentingVc;
    if (_currentIndex >= 0) {
        presentingVc = _viewControllers[_currentIndex];
    }
    UIViewController *presentedVc = _viewControllers[toIndex];
    
    if ([presentingVc conformsToProtocol:@protocol(KLSegmentedViewControllerNotify)]) {
        UIViewController<KLSegmentedViewControllerNotify> *vc = (UIViewController<KLSegmentedViewControllerNotify> *)presentingVc;
        [vc viewControllerIsVisible:NO index:_currentIndex];
    }
    if ([presentedVc conformsToProtocol:@protocol(KLSegmentedViewControllerNotify)]) {
        UIViewController<KLSegmentedViewControllerNotify> *vc = (UIViewController<KLSegmentedViewControllerNotify> *)presentedVc;
        [vc viewControllerIsVisible:YES index:toIndex];
    }
    
    if ([_delegate respondsToSelector:@selector(viewController:didScrollToControllerAtIndex:)]) {
        [_delegate viewController:self didScrollToControllerAtIndex:toIndex];
    }
}


#pragma mark - Getters.
- (UIPageViewController *)pageController {
    if (!_pageController) {
        _pageController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
        _pageController.delegate = self;
        _pageController.dataSource = self;
        
        [self setCurrentSelectedIndex:0 animated:NO];
    }
    return _pageController;
}

- (UIScrollView *)internalScrollView {
    if (!_internalScrollView) {
        UIScrollView *scrollView;
        for(id subview in self.pageController.view.subviews){
            if([subview isKindOfClass:UIScrollView.class]){
                scrollView = subview;
                break;
            }
        }
        _internalScrollView = scrollView;
    }
    return _internalScrollView;
}

- (void)dealloc {
    NSLog(@"KLSegmentedViewController dealloced.");
}

@end
