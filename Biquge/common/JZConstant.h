//
//  JZConstant.h
//  Biquge
//
//  Created by thx01 on 13-8-4.
//  Copyright (c) 2013年 jz. All rights reserved.
//

////===========================系统设置
#define ScreenHeight [[UIScreen mainScreen] bounds].size.height
#define ScreenWidth [[UIScreen mainScreen] bounds].size.width
#define StateBarHeight 20
#define MainWidth  ScreenWidth


#define MainHeight  (ScreenHeight - StateBarHeight)

#define isIOS7  [[[UIDevice currentDevice] systemVersion] floatValue] >=7
#define NAV_BAR_HEIGHT isIOS7?64:44
#define isIPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size): NO)
//判断设备是否是iPad
#define IsIpad [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad
////===========================

#import <Foundation/Foundation.h>

typedef enum{
    
    PAIHANGBANG =1,
    XUANHUAN    =2,
    XIUZHEN     =3,
    CHUANYUE    =4,
    KEHUAN      =5,
    WANGYOU     =6,
    DUSHI       =7
}BOOKTYPE;

@interface JZConstant : NSObject
//书籍最大值
extern NSString * const bookMaxId;
//目录最大值
extern NSString * const DicMaxId;

//根路径
extern NSString * const rootUrl;
//玄幻
extern NSString * const xhUrl;
//修真
extern NSString * const xzUrl;
//穿越
extern NSString * const cyUrl;
//科幻
extern NSString * const khUrl;
//网游
extern NSString * const wyUrl;
//都市
extern NSString * const dsUrl;
//排行榜
extern NSString * const phbUrl;
//所有小说
extern NSString * const allBookUrl;
@end
