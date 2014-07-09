//
//  JZBookContentViewController.h
//  Biquge
//
//  Created by thx01 on 13-9-3.
//  Copyright (c) 2013年 jz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JZBookContentViewController : UIViewController
//总页数/当前第几页
@property (nonatomic) int totalPage;
@property (nonatomic) int currIndex;
//显示当前内容在内容数组的索引
@property (nonatomic) int pageIndex;

-(void) setTitle:(NSString *)title;
-(void) setContent:(NSString *)content;
-(void) setCurrIndex:(int)currIndex withTotalPage:(int)totalPage;
@end
