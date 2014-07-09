//
//  GlobeTool.h
//  eMine
//
//  Created by thx01 on 13-6-5.
//  Copyright (c) 2013年 thx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"
@interface GlobeTool : NSObject
extern NSString * const config_name;  //plist文件名称
/*
 ** 用颜色创建image
 */
+ (UIImage *) createImageWithColor: (UIColor *) color;
/*
 **从plist文件读取属性
 */
+(NSString*) getValueOfKey:(NSString*)name;
/*
 **往plist文件写入属性
 */
+(void) setKeyAndValue:(NSString*)name value:(NSString*)val;
/*
 ** 使用16进制颜色
 */
+(UIColor *) getHexColor: (NSString *) hexColor;
/**
 画图形渐进色方法，此方法只支持双色值渐变
 @param context     图形上下文的CGContextRef
 @param clipRect    需要画颜色的rect
 @param startPoint  画颜色的起始点坐标
 @param endPoint    画颜色的结束点坐标
 @param options     CGGradientDrawingOptions
 @param startColor  开始的颜色值
 @param endColor    结束的颜色值
 */
+ (void)DrawGradientColor:(CGContextRef)context
                     rect:(CGRect)clipRect
                    point:(CGPoint) startPoint
                    point:(CGPoint) endPoint
                  options:(CGGradientDrawingOptions) options
               startColor:(UIColor*)startColor
                 endColor:(UIColor*)endColor;
/**
 *  通过判断ipad和iphone返回相应的xib名称
 */
+(NSString*) getXibNameByWithDevice:(NSString*)xibName;

/**
 *  处理路径  拼接根路径
 */
+(NSURL*) getUrl:(NSString*)url;
/**
* 获取电池电量，范围0到1.0。－1表示电量未知。
*/
+(float) getBatteryLeve;

@end
