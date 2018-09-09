//
//  ViewController.m
//  KLPageViewController
//
//  Created by liqian on 2018/9/4.
//  Copyright © 2018年 liqian. All rights reserved.
//

#import "ViewController.h"
#import "KLSegmentedViewController.h"
#import <Masonry/Masonry.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"标题";
    
    UIViewController *vc1 = [UIViewController new];
    vc1.view.backgroundColor = [UIColor whiteColor];
    
    UIViewController *vc2 = [UIViewController new];
    vc2.view.backgroundColor = [UIColor orangeColor];
    
    UIViewController *vc3 = [UIViewController new];
    vc3.view.backgroundColor = [UIColor yellowColor];
    
    UIViewController *vc4 = [UIViewController new];
    vc4.view.backgroundColor = [UIColor grayColor];
    
    UIViewController *vc5 = [UIViewController new];
    vc5.view.backgroundColor = [UIColor cyanColor];
    
    UIViewController *vc6 = [UIViewController new];
    vc6.view.backgroundColor = [UIColor purpleColor];
    
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
}

@end
