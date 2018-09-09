# KLPageViewController

这个组件用于快速创建一个pageVIewController。

#### 一、特性
1. 快速创建。只需要把包含子控制器的数组传过去即可。
```
- (instancetype)initWithViewControllers:(NSArray<UIViewController *> *)viewControllers
```
2. 可以可选的指定一个SegmentedView，并指定其放置位置。
```
- (instancetype)initWithViewControllers:(NSArray<UIViewController *> *)viewControllers
segmentedView:(nullable UIView<KLSegmentedViewProtocol> *)segmentedView
segmentedViewPosition:(KLSegmentedViewPosition)position;
```
3. SegmentedView可定制化，只需遵循一个协议即可。
```
// 如果你想自定义KLSegmentedView，你只需要实现这个协议即可。
@protocol KLSegmentedViewProtocol <NSObject>
@required
@property (nonatomic, weak) id <KLSegmentedViewDelegate> delegate;
- (void)selectedItemAtIndex:(NSInteger)index;
@end
```

#### 二、用法
```
NSArray *vcs = @[vc1, vc2, vc3, vc4, vc5, vc6];
NSArray *titles = @[@"按钮1", @"按钮2", @"按钮3", @"按钮4", @"按钮5", @"按钮6"];

KLSegmentedView *segView = [[KLSegmentedView alloc] initWithTitles:titles frame:CGRectMake(0, 0, KLScreenWidth, 44.0)];
//    segView.itemSpacing = 10.0;
//    segView.marginLeft = 20.0;
//    segView.marginRight = 50.0;
segView.extraItemWidth = 20.0;
//    segView.fixedItemWidth = 100.0;
//    [segView setItemTextFont:KLFontMedium(17) forState:UIControlStateNormal];

KLSegmentedViewController *segVc = [[KLSegmentedViewController alloc] initWithViewControllers:vcs segmentedView:segView segmentedViewPosition:KLSegmentedViewPositionTop];

[self addChildViewController:segVc];
[self.view addSubview:segVc.view];
[segVc didMoveToParentViewController:self];
[segVc.view mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.right.bottom.offset(0);
    make.top.mas_equalTo(self.mas_topLayoutGuideBottom);
}];
```
