//
//  JZBookDetailViewController.h
//  Biquge
//
//  Created by thx01 on 13-8-14.
//  Copyright (c) 2013年 jz. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface JZBookDetailViewController : UIViewController<UIScrollViewDelegate>
@property (nonatomic,copy) NSString * bookPath;
-(IBAction) dragNote:(id)sender forEvent:(UIEvent *)event;
-(IBAction) hidePageView:(id)sender forEvent:(UIEvent *)event;
@end
