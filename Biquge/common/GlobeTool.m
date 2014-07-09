//
//  GlobeTool.m
//  eMine
//
//  Created by thx01 on 13-6-5.
//  Copyright (c) 2013年 thx. All rights reserved.
//

#import "GlobeTool.h"

NSString* const config_name=@"app-config";
@implementation GlobeTool

+ (UIImage *) createImageWithColor: (UIColor *) color
{
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

+(NSString*) getValueOfKey:(NSString*)name{
    //取得檔案路徑
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    //plist命名
    NSString *filePath = [documentsDirectory stringByAppendingString:[NSString stringWithFormat:@"/%@.plist",config_name]];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSMutableDictionary *plistDict;
    
    //檢查檔案是否存在，return false則創建
    if ([fileManager fileExistsAtPath: filePath])
    {
        plistDict = [[NSMutableDictionary alloc] initWithContentsOfFile:filePath];
    }else{
        plistDict = [[NSMutableDictionary alloc] init];
    }
    return [plistDict valueForKey:name];
}

+(void) setKeyAndValue:(NSString*)name value:(NSString*)val{
    
    //取得檔案路徑
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    //plist命名
    NSString *filePath = [documentsDirectory stringByAppendingString:[NSString stringWithFormat:@"/%@.plist",config_name]];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSMutableDictionary *plistDict;
    
    //檢查檔案是否存在，return false則創建
    if ([fileManager fileExistsAtPath: filePath])
    {
        plistDict = [[NSMutableDictionary alloc] initWithContentsOfFile:filePath];
    }else{
        plistDict = [[NSMutableDictionary alloc] init];
    }
    //向動態字典追加參數
    [plistDict setObject:val forKey:name];
    [plistDict writeToFile:filePath atomically: YES];
}

+(UIColor *) getHexColor: (NSString *) hexColor
{
    NSString *cString = [[hexColor stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    // String should be 6 or 8 characters
    
    if ([cString length] < 6) return [UIColor blackColor];
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"]) cString = [cString substringFromIndex:1];
    if ([cString length] != 6) return [UIColor blackColor];
    
    // Separate into r, g, b substrings
    
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    // Scan values
    unsigned int r, g, b;
    
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}

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
                 endColor:(UIColor*)endColor
{
    UIColor* colors [2] = {startColor,endColor};
    CGColorSpaceRef rgb = CGColorSpaceCreateDeviceRGB();
    CGFloat colorComponents[8];
    
    for (int i = 0; i < 2; i++) {
        UIColor *color = colors[i];
        CGColorRef temcolorRef = color.CGColor;
        
        const CGFloat *components = CGColorGetComponents(temcolorRef);
        for (int j = 0; j < 4; j++) {
            colorComponents[i * 4 + j] = components[j];
        }
    }
    
    CGGradientRef gradient =  CGGradientCreateWithColorComponents(rgb, colorComponents, NULL, 2);
    
    CGColorSpaceRelease(rgb);
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, options);
    CGGradientRelease(gradient);
}

+(NSString*) getXibNameByWithDevice:(NSString*)xibName{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return xibName;
    } else {
        return [NSString stringWithFormat:@"%@_iPad",xibName];
    }
    return nil;
}

+(NSURL*) getUrl:(NSString*)url{
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",rootUrl,url]];
}

+(float) getBatteryLeve{
    [[UIDevice currentDevice] setBatteryMonitoringEnabled:YES];
    return [[UIDevice currentDevice] batteryLevel];
}
@end
