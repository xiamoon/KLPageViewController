//
//  KLSegmentedView.h
//  KLPageViewController
//
//  Created by liqian on 2018/9/5.
//  Copyright © 2018年 liqian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KLPublicMicros.h"
#import "UIView+KLKit.h"
#import <Masonry/Masonry.h>

@class KLSegmentedView;
@protocol KLSegmentedViewDelegate <NSObject>
- (void)klSegmentedView:(UIView *)view didSelectedItemAtIndex:(NSInteger)index;
@end

// 如果你想自定义KLSegmentedView，你只需要实现这个协议即可。
@protocol KLSegmentedViewProtocol <NSObject>
@required
@property (nonatomic, weak) id <KLSegmentedViewDelegate> delegate;
- (void)selectedItemAtIndex:(NSInteger)index;
@end


@interface KLSegmentedView : UIView <KLSegmentedViewProtocol>

// Defult 0.0。此设置是为了扩大每个item的占位显示区域。注意：和fixedItemWidth不可同时设置。如果同时设置只取extraItemWidth的值。
@property (nonatomic, assign) CGFloat extraItemWidth;

// Defult 0.0。此设置是为了统一所有item的宽度。注意：和extraItemWidth不可同时设置。如果同时设置只取extraItemWidth的值。
@property (nonatomic, assign) CGFloat fixedItemWidth;

@property (nonatomic, assign) CGFloat itemSpacing; // Defult 20.0
@property (nonatomic, assign) CGFloat marginLeft; // Defult 20.0
@property (nonatomic, assign) CGFloat marginRight; // Defult 20.0

@property (nonatomic, weak) id <KLSegmentedViewDelegate> delegate;


- (instancetype)initWithTitles:(NSArray<NSString *> *)titles frame:(CGRect)frame;

- (void)setNeedsShowShadowImage:(BOOL)show;
- (void)setItemTextColor:(UIColor *)color forState:(UIControlState)state;
- (void)setItemTextFont:(UIFont *)font forState:(UIControlState)state;
- (void)setIndicatorWidth:(CGFloat)width;

@end
