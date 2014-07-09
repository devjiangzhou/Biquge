//
//  JZHomeViewController.m
//  biquge
//
//  Created by thx01 on 13-8-3.
//  Copyright (c) 2013年 jz. All rights reserved.
//

#import "JZHomeViewController.h"
#import "JZBaseViewController.h"

#import "JZTuijianService.h"
#import "MBProgressHUD.h"

@interface JZHomeViewController ()

@end

@implementation JZHomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    
    return self;
}

- (void)viewDidLoad
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
	// Do any additional setup after loading the view, typically from a nib.
    [self.view setBackgroundColor: [UIColor colorWithPatternImage:[UIImage imageNamed:@"background-dark-gray-tex.png"]]];
    self.cardVerticalOrigin=90;
    //kFullScreenDistanceThreshold
    self.cardNavigationBarOverlap=1;
    self.cardMinimumTapsRequired=1;
    //kFullScreenDistanceThreshold
    //初始化菜单
    NSString* plistPath = [[NSBundle mainBundle] pathForResource: @"NavigationControllerData" ofType: @"plist"];
    //绑定数据
    self.viewControllerData = [[NSArray alloc] initWithContentsOfFile:plistPath];
    
    [super viewDidLoad];
}


- (NSInteger)numberOfControllerCardsInNoteView:(KLNoteViewController*) noteView {
    return  [self.viewControllerData count];
}

- (UIViewController *)noteView:(KLNoteViewController*)noteViewController viewControllerAtIndex:(NSInteger) index;{
    NSMutableDictionary* navDict =  [[NSMutableDictionary alloc]initWithDictionary:[self.viewControllerData objectAtIndex: index]];
    [navDict setObject:[NSString stringWithFormat:@"%i",index] forKey:@"bookType"];
    
    JZBaseViewController * viewController = [[JZBaseViewController alloc]initWithNibName:@"JZBaseViewController" bundle:nil];
    [viewController setInfo: navDict];
    if (index==self.viewControllerData.count-1) {  //设置最后一个显示隐藏按钮
        [viewController showButton];
    }
    viewController.edgesForExtendedLayout=UIRectEdgeNone;
    return [[UINavigationController alloc] initWithRootViewController:viewController];
}

#pragma mark 控制显示隐藏按钮
-(void) noteViewController: (KLNoteViewController*) noteViewController didUpdateControllerCard:(KLControllerCard*)controllerCard toDisplayState:(KLControllerCardState) toState fromDisplayState:(KLControllerCardState) fromState
{
//    if ([noteViewController indexForControllerCard:controllerCard]==1) {
//        NSLog(@"%lu，，，%lu",toState,fromState);
//    }
    UINavigationController *nav= [noteViewController.childViewControllers objectAtIndex:[noteViewController indexForControllerCard:controllerCard]];
    //处理拖动时 错位的情况
    if (toState==KLControllerCardStateFullScreen && fromState==KLControllerCardStateFullScreen) {
        [nav.topViewController.navigationController.navigationBar setFrame:CGRectMake(0, 20, ScreenWidth, 44)];
    }
    if(isIOS7){
        if (toState==KLControllerCardStateFullScreen && fromState ==KLControllerCardStateDefault) {
            [nav.topViewController.navigationController.navigationBar setFrame:CGRectMake(nav.topViewController.navigationController.navigationBar.frame.origin.x, nav.topViewController.navigationController.navigationBar.frame.origin.y, ScreenWidth, 64)];
        }
        if (toState==KLControllerCardStateDefault && fromState ==KLControllerCardStateFullScreen){
            [nav.topViewController.navigationController.navigationBar setFrame:CGRectMake(nav.topViewController.navigationController.navigationBar.frame.origin.x, nav.topViewController.navigationController.navigationBar.frame.origin.y, ScreenWidth, 44)];
        }
   }
    if (toState==KLControllerCardStateDefault) {//隐藏除了最后一个所有的隐藏按钮
        for(int i=0;i<noteViewController.childViewControllers.count-1;i++){
            UINavigationController* childView=[noteViewController.childViewControllers objectAtIndex:i];
                childView.topViewController.navigationItem.leftBarButtonItem=nil;
        }
    }else if (toState==KLControllerCardStateFullScreen){//显示按钮
       if ([nav.topViewController isKindOfClass:[JZBaseViewController class]]) {
            JZBaseViewController* viewController=(JZBaseViewController*)nav.topViewController;
            //[[[MBProgressHUD alloc]initWithView:controllerCard] showAnimated:YES whileExecutingBlock:^{
                if (!viewController.books) {
                    JZTuijianService * service=[[JZTuijianService alloc]init];
                    NSArray* array=[service queryArray:[noteViewController indexForControllerCard:controllerCard]];
                    
                    viewController.books=[service queryByType:[noteViewController indexForControllerCard:controllerCard]];
                    [viewController.tableView reloadData];
                    if (array.count>0) {
                        viewController.booksData=[NSArray arrayWithArray:array];
                        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"JZTuijianView" owner:self options:nil];
                        JZTuijianView *tuijianView=[nib objectAtIndex:0];
                        [tuijianView setBook:[viewController.booksData objectAtIndex:0]];
                        tuijianView.delegate=viewController;
                        [viewController.tuijianView addSubview:tuijianView];
                        
                        viewController.pageControl.numberOfPages=viewController.booksData.count;
                        [viewController.pageControl addTarget:self action:@selector(pageTurn:) forControlEvents:UIControlEventValueChanged];
                    }
                }
            //}];
           
            [viewController showButton];
        }else{
            UIButton* backButton = [UIButton buttonWithType:101];//UIButtonType，其实101和系统返回按钮一样
            [backButton addTarget:nav.topViewController action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
            [backButton setTitle:@"返回" forState:UIControlStateNormal];
            UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc] initWithCustomView:backButton] ;
            nav.topViewController.navigationItem.leftBarButtonItem = leftBtn;
        }
    }
}

-(void) loadBook:(NSInteger*)index{
    
}
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
    
}
- (BOOL)prefersStatusBarHidden
{
    return NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
