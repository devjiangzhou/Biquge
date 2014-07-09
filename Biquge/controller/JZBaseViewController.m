//
//  JZBaseViewController.m
//  biquge
//
//  Created by thx01 on 13-8-3.
//  Copyright (c) 2013年 jz. All rights reserved.
//

#import "JZBaseViewController.h"
#import "JZBook.h"
#import <QuartzCore/QuartzCore.h>
#import "JZTuijianService.h"
#import "JZDownloadBookService.h"
#import "JZBookTableCellView.h"
#import "JZBookDetailViewController.h"
@interface JZBaseViewController ()

@property int currentPage;
@end

@implementation JZBaseViewController

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
    [super viewDidLoad];
    if (isIOS7) {
         [self.navigationController.navigationBar setBackgroundImage: [UIImage imageNamed:[NSString stringWithFormat:@"%@_7",[self.info objectForKey:@"image"]]] forBarMetrics: UIBarMetricsDefault];
    }else{
        [self.navigationController.navigationBar setBackgroundImage: [UIImage imageNamed:[self.info objectForKey:@"image"]] forBarMetrics: UIBarMetricsDefault];
    }
	[self.navigationItem setTitle:[self.info objectForKey:@"title"]];
    
    
    
//    NSNumberFormatter *numberFormatter=[[NSNumberFormatter alloc]init];
//    int bookType= [numberFormatter numberFromString:[self.info objectForKey:@"bookType"]].intValue;
//    JZTuijianService * service=[[JZTuijianService alloc]init];
//    NSArray* array=[service queryArray:bookType];
//    
//    self.books=[service queryByType:bookType];
//    //JZDownloadBookService *downloadService=[[JZDownloadBookService alloc]init];
//    //[downloadService downLoadBookData];
//    
//    if (array.count>0) {
//        self.booksData=[NSArray arrayWithArray:array];
//        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"JZTuijianView" owner:self options:nil];
//        JZTuijianView *tuijianView=[nib objectAtIndex:0];
//        [tuijianView setBook:[self.booksData objectAtIndex:0]];
//        tuijianView.delegate=self;
//        [self.tuijianView addSubview:tuijianView];
//        
//        self.pageControl.numberOfPages=self.booksData.count;
//        [self.pageControl addTarget:self action:@selector(pageTurn:) forControlEvents:UIControlEventValueChanged];
//    }
}

//滑动
-(void)swipeTo:(NSString *)transition{
    if ([transition isEqualToString:kCATransitionFromRight]){
		if (self.pageControl.currentPage == self.pageControl.numberOfPages - 1){
            self.pageControl.currentPage=0;
        }else{
            [self.pageControl setCurrentPage:self.pageControl.currentPage + 1];
        }
	} else {
        if (self.pageControl.currentPage == 0){
            self.pageControl.currentPage=self.pageControl.numberOfPages - 1;
        }else{
            [self.pageControl setCurrentPage:self.pageControl.currentPage - 1];
        }
	}
	[self pageTurn:self.pageControl];
}

/**
 * 给滑动添加效果 然后做事
 */
- (void)pageTurn:(UIPageControl *)pageControl {
    int nextPage=pageControl.currentPage;
    NSString *transition;
    if ((nextPage - self.currentPage > 0 && nextPage-self.currentPage <5) || nextPage-self.currentPage ==-5) {
        transition = kCATransitionFromRight;
    } else{
        transition = kCATransitionFromLeft;
    }
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"JZTuijianView" owner:self options:nil];
    JZTuijianView *tuijianView=[nib objectAtIndex:0];
    [tuijianView setBook: [self.booksData objectAtIndex:nextPage]];
    tuijianView.delegate=self;
    [self.tuijianView addSubview:tuijianView];
    [self.tuijianView.layer addAnimation:[self animationWithString:transition] forKey:nil];
    self.currentPage=pageControl.currentPage;
}

#pragma mark 添加滑动效果
- (CATransition *)animationWithString:(NSString *)direction{
	CATransition *animation = [CATransition animation];
    [animation setDelegate:self];
	[animation setType:kCATransitionReveal];
	[animation setSubtype:direction];
	[animation setDuration:1.0];
	[animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
	return animation;
}

#pragma mark 显示按钮
-(void) showButton{
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 60,55);
    button.showsTouchWhenHighlighted = YES;
    [button setBackgroundColor:[UIColor blackColor]];
    [button setTitle:@"隐藏" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(expandNavigationCar) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* item = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem=item;
}
#pragma mark 隐藏按钮
-(void) hideButton{
    self.navigationItem.leftBarButtonItem=nil;
}

#pragma mark taoble数据和委托

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.books count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identifier = @"FirstLevelCell";
    
    JZBookTableCellView *cellWrapper = (JZBookTableCellView*)[tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cellWrapper == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"JZBookTableCellView" owner:self options:nil];
        cellWrapper = [nib objectAtIndex:0];
        [cellWrapper setBackgroundColor:[UIColor clearColor]];
        [cellWrapper.contentView setBackgroundColor:[UIColor clearColor]];
        cellWrapper.selectionStyle=UITableViewCellSelectionStyleGray;
        [cellWrapper setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        
        UIView *selectBackView=[[UIView alloc]init];
        [selectBackView setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5l]];
        [cellWrapper setSelectedBackgroundView:selectBackView];
    }else{
        // 删除cell中的子对象,刷新覆盖问题。
        while ([cellWrapper.contentView.subviews lastObject] != nil) {
            [(UIView*)[cellWrapper.contentView.subviews lastObject] removeFromSuperview];
        }
    }
    JZBook* book=[self.books objectAtIndex:indexPath.row];
    [cellWrapper setBook:book];
    return cellWrapper;
}


//点击书籍查看详细信息
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    JZBook* jzbook=[self.books objectAtIndex:indexPath.row];
    JZBookDetailViewController* detailViewController=[[JZBookDetailViewController alloc]initWithNibName:@"JZBookDetailViewController" bundle:nil];
    [detailViewController setBookPath:jzbook.bookPath];
    [self.navigationController pushViewController:detailViewController animated:YES];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
    
}
- (BOOL)prefersStatusBarHidden
{
    return NO;
}

-(void)expandNavigationCar{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
