//
//  KLPublicMicros.h
//  KLPageViewController
//
//  Created by liqian on 2018/9/5.
//  Copyright © 2018年 liqian. All rights reserved.
//

#ifndef KLPublicMicros_h
#define KLPublicMicros_h

// 颜色
#define KLColorHex(rgbValue) \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16)) / 255.0 \
green:((float)((rgbValue & 0xFF00) >> 8)) / 255.0 \
blue:((float)(rgbValue & 0xFF)) / 255.0 alpha:1.0]

#define KLColorRGB(r, g, b)     [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define KLColorRGBA(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(r)/255.0 blue:(r)/255.0 alpha:a]

// 字体
#define KLFontLight(font)  [UIFont fontWithName:@"PingFangSC-Light" size:font]
#define KLFontRegular(font)  [UIFont fontWithName:@"PingFangSC-Regular" size:font]
#define KLFontMedium(font)  [UIFont fontWithName:@"PingFangSC-Medium" size:font]
#define KLFontEngMedium(font) [UIFont fontWithName:@"HelveticaNeue-Medium" size:font]

// UI.
#ifndef KLScreenSize
#define KLScreenSize [UIScreen mainScreen].bounds.size
#endif

#ifndef KLScreenWidth
#define KLScreenWidth KLScreenSize.width
#endif

#ifndef KLScreenHeight
#define KLScreenHeight KLScreenSize.height
#endif


#endif /* KLPublicMicros_h */
