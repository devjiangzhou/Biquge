//
//  JZBookReadViewController.m
//  Biquge
//
//  Created by thx01 on 13-9-3.
//  Copyright (c) 2013年 jz. All rights reserved.
//

#import "JZBookReadViewController.h"
#import "JZBookContentViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "JZBookContentService.h"
#import "JZDictoryService.h"
#import "JZStoryService.h"
#import "JZStory.h"
@interface JZBookReadViewController ()
@property (nonatomic,strong) UIPageViewController *pageViewController;
@property (nonatomic,strong) JZBookContentViewController *contentViewController;
@property (nonatomic,strong) NSArray *contentArray;
@property (nonatomic) BOOL isShowMenu;
@property (nonatomic) int lastReadId;
@property (nonatomic,strong) JZStory* story;
@property (nonatomic,strong) UIView* settingView; //设置view
@property  BOOL isOnePage;
@end

@implementation JZBookReadViewController
@synthesize pageViewController,contentViewController,contentArray,pathUrl,bookId;

-(BOOL) setPageContent:(int)dicId isFirst:(BOOL)first{
    JZDictoryService* dictoryService=[[JZDictoryService alloc]init];
    JZDictory* dic =[dictoryService getDictoryById:dicId];
    
    if (dic) {
        self.dictory=dic;
        //获取内容
        JZBookContentService* service=[[JZBookContentService alloc]init];
        NSString* content= [service getConetntByDicId:self.dictory];
        
        //分解内容
        contentArray=[service dicsForLongStr:content withFont:[UIFont fontWithName:@"Helvetica" size:20] inRect:CGRectMake(15, 10, 290, 460)];
        
        totalPages=contentArray.count;
        
        contentViewController = [[JZBookContentViewController alloc] init];
        if (first) {
            contentViewController.pageIndex=0;
            [contentViewController setContent:[contentArray objectAtIndex:0]];
        }else{
            //得到最后一个pageIndex
            contentViewController.pageIndex=(contentArray.count-1)*2;
            //得到最后一个页面内容
            [contentViewController setContent:[contentArray lastObject]];
        }
        
        contentViewController.view.backgroundColor=[self getBackGroudColor];
        [contentViewController setTitle:self.dictory.dictoryTitle];
        //设置当前页数
        [contentViewController setCurrIndex:0 withTotalPage:contentArray.count];
        return YES;
    }else{
        return NO;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //初始化翻页
    pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStylePageCurl navigationOrientation: UIPageViewControllerNavigationOrientationHorizontal options:nil];
    pageViewController.delegate = self;
    pageViewController.dataSource = self;
    pageViewController.doubleSided=YES;
    pageViewController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    pageViewController.view.backgroundColor=[self getBackGroudColor];
    
    JZStoryService* storyService=[[JZStoryService alloc]init];
    self.story=[storyService getStoryById:bookId];
    self.lastReadId=self.story.lastReadId.intValue;
    //查询以及分解内容
    if (self.dicUrl) {
        JZDictoryService* dicService=[[JZDictoryService alloc]init];
        JZDictory* dictory= [dicService getDictoryByUrl:self.dicUrl];
        self.lastReadId=dictory.dictoryId.intValue;
        [self setPageContent: dictory.dictoryId.intValue isFirst:YES];
    }else{
        [self setPageContent: self.lastReadId isFirst:YES];
    }
    
    NSArray *viewControllers = [NSArray arrayWithObject:contentViewController];
    [pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    [self addChildViewController:pageViewController];
    [self.view addSubview:pageViewController.view];
    pageViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [pageViewController didMoveToParentViewController:self];
    
    ///////////////添加 中间的按钮////////////////////////////
    UIButton* centerBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [centerBtn setFrame:CGRectMake(110, ScreenHeight/2-150, 100, 300)];
    [centerBtn setBackgroundColor:[UIColor clearColor]];
    [centerBtn addTarget:self action:@selector(centerBtn_click:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:centerBtn];
    
    CGRect frame=CGRectMake(0, ScreenHeight, 320, 50);
    UITabBar* tabbar=[[UITabBar alloc]initWithFrame:frame];
    tabbar.tag=400;
    [tabbar setTintColor:[[UIColor darkGrayColor]colorWithAlphaComponent:0.8] ];
    [tabbar setBarTintColor:[[UIColor darkGrayColor]colorWithAlphaComponent:0.8] ];
    [tabbar setBackgroundColor:[[UIColor darkGrayColor]colorWithAlphaComponent:0.8] ];
    [tabbar setDelegate:self];
    //  [tabbar setBackgroundColor:[UIColor clearColor]];
    UITabBarItem* blackItem=[[UITabBarItem alloc]initWithTitle:@"夜间" image:nil tag:123];
    UITabBarItem* dicItem=[[UITabBarItem alloc]initWithTitle:@"目录" image:nil tag:124];;
    UITabBarItem* setItem =[[UITabBarItem alloc]initWithTitle:@"设置" image:nil  tag:125];
    NSDictionary* dic=[NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor],NSForegroundColorAttributeName, nil];
    [setItem setTitleTextAttributes:dic forState:UIControlStateNormal];
    [dicItem setTitleTextAttributes:dic forState:UIControlStateNormal];
    [blackItem setTitleTextAttributes:dic forState:UIControlStateNormal];
    
    [tabbar setItems:@[setItem,blackItem,dicItem]];
    [self.view addSubview:tabbar];
    
    UIButton* leftBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setFrame:CGRectMake(-100, 150, 100, 50)];
    [leftBtn setBackgroundColor:[UIColor blackColor]];
    [leftBtn setTitle:@"上一章" forState:UIControlStateNormal];
    leftBtn.tag=234;
    [self.view addSubview:leftBtn];
    
    UIButton* rightBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setFrame:CGRectMake(320, 150, 100, 50)];
    [rightBtn setBackgroundColor:[UIColor blackColor]];
    [rightBtn setTitle:@"下一章" forState:UIControlStateNormal];
    rightBtn.tag=235;
    [self.view addSubview:rightBtn];
    
    [self saveLastDicId];
    
    //设置
    self.settingView=[[UIView alloc]initWithFrame:CGRectMake(0, ScreenHeight-tabbar.frame.size.height-100, ScreenWidth, 100)];
    [self.settingView setBackgroundColor:[[UIColor darkGrayColor] colorWithAlphaComponent:0.9]];
    [self.settingView setHidden:YES];
    [self.view addSubview:self.settingView];
    
    //字体
    UILabel* label1=[[UILabel alloc]initWithFrame:CGRectMake(10, 10, 90, 40)];
    [label1 setFont:[UIFont boldSystemFontOfSize:15]];
    [label1 setText:@"字体："];
    
    UIButton* btn1=[UIButton buttonWithType:UIButtonTypeCustom];
    [btn1 setTitle:@"小" forState:UIControlStateNormal];
    [btn1 setBackgroundColor:[UIColor whiteColor]];
    [btn1 setFrame:CGRectMake(100, 10, 100, 35)];
    
    UIButton* btn2=[UIButton buttonWithType:UIButtonTypeCustom];
    [btn2 setTitle:@"大" forState:UIControlStateNormal];
    [btn2 setBackgroundColor:[UIColor whiteColor]];
    [btn2 setFrame:CGRectMake(220, 10, 100, 35)];
    
    [self.settingView addSubview:label1];
    [self.settingView addSubview:btn1];
    [self.settingView addSubview:btn2];
    
    
    //背景颜色
    
    UILabel* label2=[[UILabel alloc]initWithFrame:CGRectMake(10, 60, 90, 40)];
    [label2 setFont:[UIFont boldSystemFontOfSize:15]];
    [label2 setText:@"背景："];
    
    UIScrollView* bjView=[[UIScrollView alloc]initWithFrame:CGRectMake(100, 60, 200, 40)];
    [bjView setContentSize:CGSizeMake(12*49, 40)];
    NSNumberFormatter* numberF=[[NSNumberFormatter alloc]init];
    for (int i=0; i<=12; i++) {
        UIButton* btn=[UIButton buttonWithType:UIButtonTypeCustom];
        [btn setFrame:CGRectMake(i*45, 0, 40, 40)];
        [btn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"icon_bc_background%d.9.png",i]] forState:UIControlStateNormal];
        NSString* tag=[NSString stringWithFormat:@"1234%d",i];
        [btn setTag:[numberF numberFromString:tag].intValue];
        [btn addTarget:self action:@selector(changeBjImage:) forControlEvents:UIControlEventTouchUpInside];
        [bjView addSubview:btn];
    }
    [self.settingView addSubview:label2];
    [self.settingView addSubview:bjView];
}

-(void)viewDidAppear:(BOOL)animated{
    [UIApplication sharedApplication].statusBarHidden=YES;
    [self.navigationController.navigationBar setHidden:YES];
    
    [self.view setFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    
    //返回按钮
    UIButton* backButton = [UIButton buttonWithType:101];//UIButtonType，其实101和系统返回按钮一样
    [backButton addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    [backButton setTitle:@"返回" forState:UIControlStateNormal];
    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc] initWithCustomView:backButton] ;
    self.navigationItem.leftBarButtonItem = leftBtn;
    
    self.isShowMenu=NO;
}

//控制隐藏和显示菜单
-(void) centerBtn_click:(id)sender{
    [UIView beginAnimations:@"click_center" context:nil];
    [UIView setAnimationDelay:0.1];
    if (self.isShowMenu) {
        [UIApplication sharedApplication].statusBarHidden=YES;
        [self.navigationController.navigationBar setHidden:YES];
        [self.settingView setHidden:YES];
        
        [[self.view viewWithTag:400] setFrame:CGRectMake(0, ScreenHeight, 320, 50)];
        [[self.view viewWithTag:234] setFrame:CGRectMake(-100, 150, 100, 50)];
        [[self.view viewWithTag:235] setFrame:CGRectMake(320, 150, 100, 50)];
        self.isShowMenu=NO;
    }else{
        [UIApplication sharedApplication].statusBarHidden=NO;
        [self.navigationController.navigationBar setHidden:NO];
        
        [[self.view viewWithTag:400] setFrame:CGRectMake(0, ScreenHeight-50, 320, 50)];
        [[self.view viewWithTag:234] setFrame:CGRectMake(0, 150, 100, 50)];
        [[self.view viewWithTag:235] setFrame:CGRectMake(220, 150, 100, 50)];
        self.isShowMenu=YES;
    }
    [UIView commitAnimations];
    [self.view setFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
}
-(void)back:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - UIPageViewControllerDataSource Methods
/**
 *上一页
 */
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController
      viewControllerBeforeViewController:(UIViewController *)viewController {
    
    contentViewController = [[JZBookContentViewController alloc] init];
    if (currentIndex == 0) {
        self.lastReadId--;
        //查询以及分解内容
        BOOL result= [self setPageContent:self.lastReadId isFirst:NO];
        if (!result) {
            self.lastReadId++;
            return nil;
        }
        [self saveLastDicId];
        currentIndex=totalPages*2;
    }else{
        currentIndex = ((JZBookContentViewController *)viewController).pageIndex;
        contentViewController.title=self.dictory.dictoryTitle;
        contentViewController.pageIndex=currentIndex-1;
        //设置当前页数
        if (currentIndex%2!=1) {
            contentViewController.content = [contentArray objectAtIndex:(currentIndex-1)/2];
            //翻页时翻转的view
            contentViewController.view.layer.transform =CATransform3DMakeScale(-1, 1 , 1);
        }else{
            contentViewController.content = [contentArray objectAtIndex:(currentIndex-1)/2];
        }
    }
    [contentViewController setCurrIndex:(currentIndex-1)/2 withTotalPage:contentArray.count];
    contentViewController.view.backgroundColor=[self getBackGroudColor];
    
    return contentViewController;
}
/**
 *下一页
 */
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController
       viewControllerAfterViewController:(UIViewController *)viewController {
    contentViewController = [[JZBookContentViewController alloc]init];
   
    if (currentIndex/2==totalPages-1 && self.isOnePage) {
        self.lastReadId++;
        //查询以及分解内容
        BOOL result= [self setPageContent:self.lastReadId isFirst:YES];
        if (!result) {
            self.lastReadId--;
            return nil;
        }
        [self saveLastDicId];
        currentIndex=1;
        self.isOnePage=NO;
    }else{
        currentIndex = ((JZBookContentViewController *)viewController).pageIndex;
        contentViewController.title=self.dictory.dictoryTitle;
        contentViewController.pageIndex=currentIndex+1;
        if (currentIndex%2==1) {
            [contentViewController setCurrIndex:(currentIndex+1)/2 withTotalPage:contentArray.count];
            contentViewController.content = [contentArray objectAtIndex:(currentIndex+1)/2];
        }else{
            [contentViewController setCurrIndex:currentIndex/2 withTotalPage:contentArray.count];
            contentViewController.content = [contentArray objectAtIndex:currentIndex/2];
            contentViewController.view.layer.transform =CATransform3DMakeScale(-1, 1 , 1);
        }
        if (totalPages==1 || currentIndex/2==totalPages-1) {
            self.isOnePage=YES;
        }
    }
    contentViewController.view.backgroundColor=[self getBackGroudColor];
    return contentViewController;
}
- (UIPageViewControllerSpineLocation)pageViewController:(UIPageViewController *)pageViewController
                   spineLocationForInterfaceOrientation:(UIInterfaceOrientation)orientation{
    UIViewController *currentViewController = [self.pageViewController.viewControllers objectAtIndex:0];
    NSArray *viewControllers = [NSArray arrayWithObjects:currentViewController,nil];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:NULL];
    self.pageViewController.doubleSided = YES;
    return UIPageViewControllerSpineLocationMin;
}

#pragma 点击设置、目录按钮
- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    NSUInteger index= [tabBar.items indexOfObject:item];
    switch (index) {
        case 0:
            //控制设置面板隐藏
            if (self.settingView.hidden) {
                [self.settingView setHidden:NO];
            }else{
                [self.settingView setHidden:YES];
            }
            break;
        case 1:
            
            break;
        case 2:
            
            break;
    }
}
#pragma 保存最后阅读章节
-(void) saveLastDicId{
    JZStory* story=[JZStory findFirstByAttribute:@"storyId" withValue:[NSNumber numberWithInt:bookId]];
    [story setLastReadId:[NSNumber numberWithInt:self.lastReadId]];//保存最后阅读章节
    [[NSManagedObjectContext defaultContext]saveOnlySelfAndWait];
}
#pragma 切换背景
-(void)changeBjImage:(id)sender{
    UIButton* btn=(UIButton*)sender;
    int tag=btn.tag;
    NSString* index=[[NSString stringWithFormat:@"%d",tag] stringByReplacingOccurrencesOfString:@"1234" withString:@""];
    [GlobeTool setKeyAndValue:@"bjImageIndex" value:index];
    pageViewController.view.backgroundColor=[self getBackGroudColor];
    contentViewController.view.backgroundColor=[self getBackGroudColor];
}

-(UIColor*) getBackGroudColor{
    NSString* index= [GlobeTool getValueOfKey:@"bjImageIndex"];
    if (!index) {
        [GlobeTool setKeyAndValue:@"bjImageIndex" value:@"0"];
    }
    return   [UIColor colorWithPatternImage:[UIImage imageNamed:[NSString stringWithFormat:@"bg_bc_background%@.jpg",index]]];
}
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
- (BOOL)prefersStatusBarHidden
{
    return YES;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
