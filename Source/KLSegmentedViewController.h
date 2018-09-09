//
//  KLSegmentedViewController.h
//  KLPageViewController
//
//  Created by liqian on 2018/9/5.
//  Copyright © 2018年 liqian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KLSegmentedView.h"

// Notify.
// 在viewControllers中的控制器里面遵循此协议，就可以在页面出现和消失的时候收到通知。
@protocol KLSegmentedViewControllerNotify <NSObject>
- (void)viewControllerIsVisible:(BOOL)visible index:(NSInteger)index;
@end

typedef NS_ENUM(NSInteger, KLSegmentedViewPosition) {
    KLSegmentedViewPositionTop = 0,
    KLSegmentedViewPositionBottom,
//    KLSegmentedViewPositionLeft, // 后续支持
//    KLSegmentedViewPositionRight, // 后续支持
};


@class KLSegmentedViewController;
@protocol kLSegmentedViewControllerDelegate <NSObject>
@optional
- (void)viewController:(KLSegmentedViewController *)vc
      didScrollToControllerAtIndex:(NSInteger)index;
@end


@interface KLSegmentedViewController : UIViewController
@property (nonatomic, weak) id<kLSegmentedViewControllerDelegate> delegate;
@property (nonatomic, assign, readonly) NSInteger currentIndex;
@property (nonatomic, strong, readonly) NSArray<UIViewController *> *viewControllers;


- (instancetype)initWithViewControllers:(NSArray<UIViewController *> *)viewControllers;


- (instancetype)initWithViewControllers:(NSArray<UIViewController *> *)viewControllers
                          segmentedView:(nullable UIView<KLSegmentedViewProtocol> *)segmentedView
                  segmentedViewPosition:(KLSegmentedViewPosition)position;

/**
 创建一个PageViewController，可以选择性的加入segmentedView.
 
 @param viewControllers 子控制器集合
 @param segmentedView 分段视图
 @param needAutoAddSegmentedView 是否把segmentedView加入到当前PageViewController的视图层次中去
 @param position segmentedView在segmentedView视图层次中的位置，目前只支持上面和下面
 @return pageViewController
 */
- (instancetype)initWithViewControllers:(NSArray<UIViewController *> *)viewControllers
                          segmentedView:(nullable UIView<KLSegmentedViewProtocol> *)segmentedView
               needAutoAddSegmentedView:(BOOL)needAutoAddSegmentedView
                  segmentedViewPosition:(KLSegmentedViewPosition)position;


- (void)setCurrentSelectedIndex:(NSInteger)index animated:(BOOL)animated;
- (void)setScrollEnabled:(BOOL)enabled;

@end
