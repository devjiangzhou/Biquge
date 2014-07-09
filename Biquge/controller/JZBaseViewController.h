//
//  JZBaseViewController.h
//  biquge
//
//  Created by thx01 on 13-8-3.
//  Copyright (c) 2013年 jz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KLNoteViewController.h"
#import "JZTuijianView.h"
@interface JZBaseViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,TuijiantouchViewDelegate>

//@property (nonatomic,strong) UIBarButtonItem* leftBarButtonItem;
//@property (nonatomic,strong) UIBarButtonItem* rightBarButtonItem;

@property (nonatomic,strong) NSArray* books; //下面是热门书籍
@property (nonatomic,strong) NSArray* booksData; //页面上方六个推荐view


@property (nonatomic,strong) IBOutlet UIView* tuijianView;
@property (nonatomic,strong) IBOutlet UIPageControl *pageControl;
@property (nonatomic,strong) IBOutlet UITableView* bookTableView;

@property (nonatomic,strong) IBOutlet UITableView* tableView;
//跳转信息
@property (nonatomic, strong) NSDictionary* info;
-(void) hideButton;
-(void) showButton;


@end
