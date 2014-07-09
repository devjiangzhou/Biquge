//
//  JZServiceUtil.h
//  Biquge
//
//  Created by thx01 on 13-8-10.
//  Copyright (c) 2013年 jz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JZServiceUtil : NSObject
/**
 * 通过书籍路径 转换成 书籍图片路径
 */
+(NSURL*)getBookImagePath:(NSString*)bookWebPath;

@end
