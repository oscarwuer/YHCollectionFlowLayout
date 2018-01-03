//
//  UIView+FrameCategory.h
//  DPScope
//
//  Created by gft  on 13-3-19.
//  Copyright (c) 2013年 gft . All rights reserved.
//

#import <UIKit/UIKit.h>

/*!
 *  为了方便，宏定义直接放在这儿
 */

// 屏幕宽高
#define screen_width ([UIScreen mainScreen].bounds.size.width)
#define screen_height ([UIScreen mainScreen].bounds.size.height)

// iPhone X宏定义
#define iPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)]?CGSizeEqualToSize(CGSizeMake(1125, 2436),[[UIScreen mainScreen]currentMode].size):NO)

// 颜色赋值
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define UIColorFromRGBAlpha(rgbValue,alphaValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:alphaValue]

// 相关平方字体
#define MMTFontTextBodySize(s) [UIFont fontWithName:@"Helvetica" size:s] //普通正文
#define MMTFontTextBoldSize(s) [UIFont fontWithName:@"Helvetica-Bold" size:s] //加粗字体
#define MMTFontTextPingFangSCRgularSize(s) [UIFont fontWithName:@"PingFangSC-Regular" size:s] //平方常字体
#define MMTFontTextPingFangSCMediumSize(s) [UIFont fontWithName:@"PingFangSC-Medium" size:s] //平方粗字体
#define MMTFontTextPingFangSCSemiboldSize(s) [UIFont fontWithName:@"PingFangSC-Semibold" size:s] //平方半黑体

@interface UIView (FrameCategory)

/**
 * Shortcut for frame.origin.x.
 *
 * Sets frame.origin.x = left
 */
@property (nonatomic) CGFloat left;

/**
 * Shortcut for frame.origin.y
 *
 * Sets frame.origin.y = top
 */
@property (nonatomic) CGFloat top;

/**
 * Shortcut for frame.origin.x + frame.size.width
 *
 * Sets frame.origin.x = right - frame.size.width
 */
@property (nonatomic) CGFloat right;

/**
 * Shortcut for frame.origin.y + frame.size.height
 *
 * Sets frame.origin.y = bottom - frame.size.height
 */
@property (nonatomic) CGFloat bottom;

/**
 * Shortcut for frame.size.width
 *
 * Sets frame.size.width = width
 */
@property (nonatomic) CGFloat width;

/**
 * Shortcut for frame.size.height
 *
 * Sets frame.size.height = height
 */
@property (nonatomic) CGFloat height;

/**
 * Shortcut for center.x
 *
 * Sets center.x = centerX
 */
@property (nonatomic) CGFloat centerX;

/**
 * Shortcut for center.y
 *
 * Sets center.y = centerY
 */
@property (nonatomic) CGFloat centerY;

/**
 * Return the x coordinate on the screen.
 */
@property (nonatomic, readonly) CGFloat ttScreenX;

/**
 * Return the y coordinate on the screen.
 */
@property (nonatomic, readonly) CGFloat ttScreenY;

/**
 * Return the x coordinate on the screen, taking into account scroll views.
 */
@property (nonatomic, readonly) CGFloat screenViewX;

/**
 * Return the y coordinate on the screen, taking into account scroll views.
 */
@property (nonatomic, readonly) CGFloat screenViewY;

/**
 * Return the view frame on the screen, taking into account scroll views.
 */
@property (nonatomic, readonly) CGRect screenFrame;

/**
 * Shortcut for frame.origin
 */
@property (nonatomic) CGPoint origin;

/**
 * Shortcut for frame.size
 */
@property (nonatomic) CGSize size;

/**
 * Finds the first descendant view(子视图) (including this view) that is a member of a particular class.
 */
- (UIView*)descendantOrSelfWithClass:(Class)cls;

/**
 * Finds the first ancestor view (including this view) that is a member of a particular class.
 */
- (UIView*)ancestorOrSelfWithClass:(Class)cls;


- (void)removeAllSubviews;

/**
 *  通过view找父视图所在的控制器
 *
 *  @return 所要找的导航控制器
 */
- (UINavigationController *)superNavigation;



@end
