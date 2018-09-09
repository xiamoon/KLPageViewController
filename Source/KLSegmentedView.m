//
//  KLSegmentedView.m
//  KLPageViewController
//
//  Created by liqian on 2018/9/5.
//  Copyright © 2018年 liqian. All rights reserved.
//

#import "KLSegmentedView.h"

@interface KLSegmentedView () {
    CGFloat _containerWidth;
}
@property (nonatomic, strong) NSMutableArray *items;
@property (nonatomic, strong) UIView *selectedIndicator;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *containerView;

@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UIColor *normalTextColor;
@property (nonatomic, strong) UIColor *selectedTextColor;
@property (nonatomic, strong) UIFont *normalTextFont;
@property (nonatomic, strong) UIFont *selectedTextFont;
@end

@implementation KLSegmentedView

- (instancetype)initWithTitles:(NSArray<NSString *> *)titles frame:(CGRect)frame {
    self = [super init];
    if (self) {
        self.frame = frame;
        
        _currentIndex = -1;
        _items = @[].mutableCopy;
        _normalTextColor = KLColorHex(0xbfbfbf);
        _selectedTextColor = KLColorHex(0x444444);
        _normalTextFont = KLFontMedium(13);
        _selectedTextFont = KLFontMedium(13);
        
        _itemSpacing = 20.0;
        _marginLeft = 20.0;
        _marginRight = 20.0;
        
        CGFloat item_x = 0;
        
        UIFont *itemFont = _normalTextFont;
        
        UIView *containerView = [UIView new];
        _containerView = containerView;
        for (int i = 0; i < titles.count; i ++) {
            NSString *title = titles[i];
            CGFloat itemWidth = ceil([title boundingRectWithSize:CGSizeMake(self.width, self.height)
                                                         options:NSStringDrawingTruncatesLastVisibleLine
                                                      attributes:@{NSFontAttributeName:itemFont}
                                                         context:nil].size.width);
            
            UIButton *item = [UIButton buttonWithType:UIButtonTypeCustom];
            item.frame = CGRectMake(item_x, 0, itemWidth, self.height);
            [item setTitle:title forState:UIControlStateNormal];
            item.titleLabel.font = itemFont;
            [item setTitleColor:_normalTextColor forState:UIControlStateNormal];
            [item setTitleColor:_selectedTextColor forState:UIControlStateSelected];
            [item addTarget:self action:@selector(handleItemAction:) forControlEvents:UIControlEventTouchUpInside];
            [containerView addSubview:item];
            
            item_x += (itemWidth+_itemSpacing);
            
            [_items addObject:item];
        }
        
        CGFloat containerWidth = item_x-_itemSpacing;
        _containerWidth = containerWidth;
        
        UIScrollView *sc = [UIScrollView new];
        sc.showsHorizontalScrollIndicator = NO;
        sc.showsVerticalScrollIndicator = NO;
        [self addSubview:sc];
        _scrollView = sc;
        [sc mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsZero);
        }];
        
        [sc addSubview:containerView];
        CGFloat contentWidth = containerWidth + _marginLeft + _marginRight;
        if (contentWidth <= self.width) {
            [containerView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.bottom.offset(0);
                make.height.mas_equalTo(self.height);
                make.width.mas_equalTo(containerWidth);
                make.left.offset((self.width-containerWidth)*0.5);
                make.right.offset(-(self.width-containerWidth)*0.5);
            }];
        }else {
            [containerView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.bottom.offset(0);
                make.height.mas_equalTo(self.height);
                make.width.mas_equalTo(containerWidth);
                make.left.offset(self.marginLeft);
                make.right.offset(-self.marginRight);
            }];
        }
        
        _lineView = [UIView new];
        _lineView.backgroundColor = KLColorRGB(245, 246, 247);
        [self addSubview:_lineView];
        [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.offset(0.0);
            make.height.mas_equalTo(1.0);
        }];
        
        _selectedIndicator = [UIView new];
        _selectedIndicator.backgroundColor = KLColorHex(0xffa86a);
        _selectedIndicator.layer.cornerRadius = 3.0/2.0;
        [sc addSubview:_selectedIndicator];
        
        [sc layoutIfNeeded];
        
        [self selectedAtIndex:0];
    }
    return self;
}

- (void)handleItemAction:(UIButton *)button {
    NSInteger index = [_items indexOfObject:button];
    if ([_delegate respondsToSelector:@selector(klSegmentedView:didSelectedItemAtIndex:)]) {
        [_delegate klSegmentedView:self didSelectedItemAtIndex:index];
    }
}

- (void)selectedAtIndex:(NSInteger)index {
    if (index < 0 || index >= _items.count) return;
    if (index == _currentIndex) return;
    
    [_items enumerateObjectsUsingBlock:^(UIButton *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.selected = NO;
    }];
    
    UIButton *button = _items[index];
    button.selected = YES;
    
    [_selectedIndicator mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(16, 3.0));
        make.centerX.mas_equalTo(button.mas_centerX);
        make.bottom.mas_equalTo(self.mas_bottom).offset(-3);
    }];
    [UIView animateWithDuration:0.25 animations:^{
        [self.scrollView layoutIfNeeded];
    }];
    
    NSInteger previousIndex = index-1;
    NSInteger currentIndex = index;
    NSInteger nextIndex = index+1;

    UIButton *previousItem = nil;
    if (previousIndex >= 0) {
        previousItem = _items[previousIndex];
    }
    UIButton *currentItem = _items[currentIndex];
    UIButton *nextItem = nil;
    if (nextIndex <= _items.count-1) {
        nextItem = _items[nextIndex];
    }

    CGFloat visibleLeft = 0.0;
    CGFloat visibleWidth = 0.0;

    visibleLeft = previousItem.left+_marginLeft;
    visibleWidth = (previousItem.width+currentItem.width+nextItem.width) + 2*_itemSpacing;
    if (!previousItem) {
        visibleWidth -= _itemSpacing;
    }else if (previousItem == _items.firstObject) {
        visibleLeft = 0.0;
        visibleWidth += _marginLeft;
    }else {
        visibleLeft -= _itemSpacing*0.5;
        visibleWidth += _itemSpacing*0.5;
    }
    if (!nextItem) {
        visibleWidth -= _itemSpacing;
    }else if (nextItem == _items.lastObject) {
        visibleWidth += _marginRight;
    }else {
        visibleWidth += _itemSpacing*0.5;
    }
    [_scrollView scrollRectToVisible:CGRectMake(visibleLeft, 0, visibleWidth, self.height) animated:YES];

    _currentIndex = index;
}

- (void)setNeedsShowShadowImage:(BOOL)show {
    _lineView.hidden = !show;
}

- (void)setItemTextColor:(UIColor *)color
                forState:(UIControlState)state {
    for (UIButton *item in _items) {
        [item setTitleColor:_normalTextColor forState:state];
    }
    if (state == UIControlStateNormal) {
        _normalTextColor = color;
    }else if (state == UIControlStateSelected) {
        _selectedTextColor = color;
    }
}

- (void)setItemTextFont:(UIFont *)font forState:(UIControlState)state {
    CGFloat containerWidth = 0.0;
    CGFloat item_x = 0.0;
    for (UIButton *item in _items) {
        item.titleLabel.font = font;
        NSString *title = [item titleForState:UIControlStateNormal];
        CGFloat itemWidth = ceil([title boundingRectWithSize:CGSizeMake(self.width, self.height)
                                                     options:NSStringDrawingTruncatesLastVisibleLine
                                                  attributes:@{NSFontAttributeName:font}
                                                     context:nil].size.width);
        
        CGFloat newItemWidth = itemWidth + _extraItemWidth;
        item.left = item_x;
        item.width = newItemWidth;
        
        containerWidth += (newItemWidth+_itemSpacing);
        item_x += (newItemWidth+_itemSpacing);
    }
    
    containerWidth -= _itemSpacing;
    _containerWidth = containerWidth;
    [self _updateContainerViewConstraints];
    
    
    if (state == UIControlStateNormal) {
        _normalTextFont = font;
    }else if (state == UIControlStateSelected) {
        _selectedTextFont = font;
    }
}

- (void)setIndicatorWidth:(CGFloat)width {
    _selectedIndicator.width = width;
}


- (void)setExtraItemWidth:(CGFloat)extraItemWidth {
    _extraItemWidth = extraItemWidth;
    if (_fixedItemWidth != 0) {
        NSAssert(NO, @"不能同时设置 'extraItemWidth' 和 'fixedItemWidth' 的值。");
        return;
    }
    
    CGFloat containerWidth = 0.0;
    CGFloat item_x = 0.0;
    for (UIButton *item in _items) {
        CGFloat newItemWidth = item.width + extraItemWidth;

        item.left = item_x;
        item.width = newItemWidth;

        containerWidth += (newItemWidth+_itemSpacing);
        item_x += (newItemWidth+_itemSpacing);
    }
    
    containerWidth -= _itemSpacing;
    _containerWidth = containerWidth;
    [self _updateContainerViewConstraints];
}

- (void)setFixedItemWidth:(CGFloat)fixedItemWidth {
    _fixedItemWidth = fixedItemWidth;
    if (_extraItemWidth != 0) {
        NSAssert(NO, @"不能同时设置 'fixedItemWidth' 和 'extraItemWidth' 的值。");
        return;
    }
    
    CGFloat containerWidth = 0.0;
    CGFloat item_x = 0.0;
    for (UIButton *item in _items) {
        CGFloat newItemWidth = fixedItemWidth;
        
        item.left = item_x;
        item.width = newItemWidth;
        
        containerWidth += (newItemWidth+_itemSpacing);
        item_x += (newItemWidth+_itemSpacing);
    }
    
    containerWidth -= _itemSpacing;
    _containerWidth = containerWidth;
    [self _updateContainerViewConstraints];
}


- (void)setMarginLeft:(CGFloat)marginLeft {
    _marginLeft = marginLeft;
    [self _updateContainerViewConstraints];
}

- (void)setMarginRight:(CGFloat)marginRight {
    _marginRight = marginRight;
    [self _updateContainerViewConstraints];
}

- (void)setItemSpacing:(CGFloat)itemSpacing {
    _itemSpacing = itemSpacing;
    
    CGFloat containerWidth = 0.0;
    CGFloat item_x = 0.0;
    for (UIButton *item in _items) {
        item.left = item_x;
        
        containerWidth += (item.width+itemSpacing);
        item_x += (item.width+itemSpacing);
    }

    containerWidth -= itemSpacing;
    _containerWidth = containerWidth;
    [self _updateContainerViewConstraints];
}

#pragma mark - KLSegmentedViewProtocol
- (void)selectedItemAtIndex:(NSInteger)index {
    [self selectedAtIndex:index];
}

#pragma mark - Private.
- (void)_updateContainerViewConstraints {
    CGFloat contentWidth = _containerWidth + _marginLeft + _marginRight;
    if (contentWidth <= self.width) {
        [_containerView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.offset(0);
            make.height.mas_equalTo(self.height);
            make.width.mas_equalTo(self->_containerWidth);
            make.left.offset((self.width-self->_containerWidth)*0.5);
            make.right.offset(-(self.width-self->_containerWidth)*0.5);
        }];
    }else {
        [_containerView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.offset(0);
            make.height.mas_equalTo(self.height);
            make.width.mas_equalTo(self->_containerWidth);
            make.left.offset(self.marginLeft);
            make.right.offset(-self.marginRight);
        }];
    }
}


- (void)dealloc {
    
}

@end
