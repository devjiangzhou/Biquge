//
//  JZBookDetailViewController.m
//  Biquge
//
//  Created by thx01 on 13-8-14.
//  Copyright (c) 2013年 jz. All rights reserved.
//

#import "JZBookDetailViewController.h"
#import "JZBookDetailService.h"
#import "JZStory.h"
#import <SDWebImage/SDWebImageDownloader.h>
#import "JZDictory.h"
#import "JZBookReadViewController.h"
#import "JZDirectoryView.h"
#import "JZDictoryService.h"
#import "JZStoryService.h"
#import "JZSearchResult.h"

@interface JZBookDetailViewController ()

@property (nonatomic,strong) IBOutlet UIScrollView* scroollView;
@property (nonatomic,strong) IBOutlet UIImageView* bookImageView;
@property (nonatomic,strong) IBOutlet  UILabel* currentBookNum;
@property (nonatomic,strong) IBOutlet  UILabel* currentBookTitle;
@property (nonatomic,strong) IBOutlet  UILabel* lastUpdateTime;
@property (nonatomic,strong) IBOutlet  UILabel* bookAuthor;
@property (nonatomic,strong) IBOutlet  UILabel* totalBookNum;
@property (nonatomic,strong) IBOutlet  UITextView* bookRemark;
@property (nonatomic,strong) IBOutlet  UILabel* lastBookTitle;

@property (nonatomic,strong) IBOutlet  UILabel* lastBookNum;

@property (nonatomic,strong) JZSearchResult* result;
//点击阅读
-(IBAction)click_Btn:(id)sender;

@property (nonatomic,strong) JZStory* story;

//章节目录当前索引
@property int dicPageIndex;
@property  (nonatomic,strong) UIView* pageIndexView;
@property  (nonatomic,strong)  UILabel* pageIndexLabel;
@end

@implementation JZBookDetailViewController
@synthesize bookPath;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
       // self.view.userInteractionEnabled = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.scroollView setContentSize:CGSizeMake(0, 600)];
    self.scroollView.delegate=self;
    self.scroollView.canCancelContentTouches = YES;
    self.scroollView.delaysContentTouches = NO;
    // Do any additional setup after loading the view from its nib.
    JZBookDetailService* detailService=[[JZBookDetailService alloc]init];
    JZStoryService* storyService=[[JZStoryService alloc]init];
    JZStory* dbStory= [storyService getStoryByPath:bookPath];
    if (dbStory) {
        self.story=dbStory;
    }else{
        self.story=[detailService queryBookDetail:bookPath];
    }
    
    self.title=self.story.storyName;
    
    [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",rootUrl,self.story.storyImagePath]] options:0 progress:^(NSUInteger receivedSize, long long expectedSize) {
    } completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
        if (image && finished) {
            self.bookImageView.image = image;
        }
    }];
    
    self.lastUpdateTime.text=self.story.lastUpdateTime;
    self.bookAuthor.text=self.story.storyAuthor;
    self.bookRemark.text=self.story.storyRemark;
    self.lastBookNum.text=[NSString stringWithFormat:@"第%i章",self.story.totalNum.intValue];
    self.totalBookNum.text=[NSString stringWithFormat:@"第%i章",self.story.totalNum.intValue];
    self.lastBookTitle.text=self.story.lastName;
    
    UIView* view=[self.view viewWithTag:500];
    
    [self.scroollView addSubview:view];
    
    UIView* noteView1=[self.view viewWithTag:1000];
    UIView* noteView2=[self.view viewWithTag:2000];
    UIView* noteView3=[self.view viewWithTag:3000];
    [noteView1 setHidden:NO];
    [noteView2 setHidden:YES];
    [noteView3 setHidden:YES];
    
    //判断是开始阅读还是继续阅读
    if (self.story.lastReadId>0) {
        UIButton* startBtn=(UIButton*)[self.view viewWithTag:1234];
        [startBtn setTitle:@"继续阅读" forState:UIControlStateNormal];
    }
    
    int screenWidth=ScreenWidth;
    int screenHeight=ScreenHeight;
    int navHeight=NAV_BAR_HEIGHT;
    self.pageIndexView=[[UIView alloc]initWithFrame:CGRectMake((screenWidth-100)/2, screenHeight-navHeight-130, 100, 50)];
    [ self.pageIndexView setBackgroundColor:[UIColor blackColor]];
    [self.view addSubview: self.pageIndexView];
    [self.pageIndexView setHidden:YES];
    
    self.pageIndexLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 50)];
    [self.pageIndexLabel setTextColor:[UIColor whiteColor]];
    [self.pageIndexView addSubview:self.pageIndexLabel];
}


-(void)viewDidAppear:(BOOL)animated{
    self.navigationItem.hidesBackButton = YES;
    UIButton* backButton = [UIButton buttonWithType:101];//UIButtonType，其实101和系统返回按钮一样
    [backButton addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    [backButton setTitle:@"返回" forState:UIControlStateNormal];
    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc] initWithCustomView:backButton] ;
    self.navigationItem.leftBarButtonItem = leftBtn;
}
-(void)back:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 开始阅读
/**
 * 开始阅读,或者继续阅读
 */
-(IBAction)click_Btn:(id)sender{
    
    JZBookReadViewController* bookReader=[[JZBookReadViewController alloc]init];
    //保存书籍
    [self readBook];
    [bookReader setBookId:self.story.storyId.intValue];
    [self.navigationController pushViewController:bookReader animated:YES];
}

-(IBAction)checkBtn_click:(id)sender{
    UIView* noteView1=[self.view viewWithTag:1000];
    UIView* noteView2=[self.view viewWithTag:2000];
    UIView* noteView3=[self.view viewWithTag:3000];
    UIButton* btn=(UIButton*)sender;
    if (btn.tag==123) {
        [noteView1 setHidden:NO];
        [noteView2 setHidden:YES];
        [noteView3 setHidden:YES];
        [[self.view viewWithTag:600]setHidden:YES];
    }else if(btn.tag==124){
        [noteView1 setHidden:YES];
        [noteView2 setHidden:NO];
        [noteView3 setHidden:YES];
        UIView* controlView=[self.view viewWithTag:600];
        [controlView setHidden:NO];
        int screenHeight=ScreenHeight;
        int navHeight=NAV_BAR_HEIGHT;
        [controlView setFrame:CGRectMake(0, screenHeight-navHeight-40, ScreenWidth, 40)];
        
        [self changeDicPage:0];
//        NSLog(@"总页数:%i",self.result.totalPages);
//        float avg=((258-64)/self.result.totalPages);
//        NSLog(@"平均 %f",avg);
    } else if(btn.tag==125){
        [[self.view viewWithTag:600]setHidden:YES];
    }
}

//滚动动画执行
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    UIView* view=[self.view viewWithTag:500];
    if (scrollView.contentOffset.y>=170) {
        //        if (isIOS7) {
        //            [view setFrame:CGRectMake(view.frame.origin.x, 64, view.frame.size.width, view.frame.size.height)];
        //        }else{
        [view setFrame:CGRectMake(view.frame.origin.x, 0, view.frame.size.width, view.frame.size.height)];
        //        }
        [self.view addSubview:view];
    }else{
        [view setFrame:CGRectMake(view.frame.origin.x, 160, view.frame.size.width, view.frame.size.height)];
        [scrollView addSubview:view];
    }
}

/**
 * 点击章节列表
 */
-(void)click_Dic:(UITapGestureRecognizer*)sender{
        UIView* labelView=(UILabel*)sender.view;
        JZDictory* dic=[self.result.result objectAtIndex:labelView.tag-1];
        [self readBook];
        JZBookReadViewController* bookReader=[[JZBookReadViewController alloc]init];
        //保存书籍
        [self readBook];
        [bookReader setBookId:self.story.storyId.intValue];
        [bookReader setDicUrl:dic.dictoryWebPath];
        [self.navigationController pushViewController:bookReader animated:YES];
}

/**
 * 拖动按钮，表示章节当前页进度
 */
-(IBAction) dragNote:(id)sender forEvent:(UIEvent *)event{
    
    UIButton* btn=(UIButton*)sender;
    UIView* view=[self.view viewWithTag:600];
    UILabel* widthLabel= (UILabel*)[view viewWithTag:456];
    float x=[[[event allTouches] anyObject] locationInView:view].x;

    float y=btn.frame.size.height/2+btn.frame.origin.y;
    //+3是为了更好可以滑动到最后一页
    if (x>=65 && x<=65+widthLabel.frame.size.width+3) {
        float avgMoveX=(widthLabel.frame.size.width/self.result.totalPages);
        int pageIndex=(x-65)/avgMoveX;
        if (pageIndex!=self.dicPageIndex && pageIndex>=1 && pageIndex<=self.result.totalPages) {
            if (self.pageIndexView.hidden) {
                self.pageIndexView.hidden=NO;
            }
            self.dicPageIndex=pageIndex;
            [self.pageIndexLabel setText:[NSString stringWithFormat:@"%i页/%i页",pageIndex,self.result.totalPages]];
        }
    }
    if (x<65) {
        x=65;
    }
    if (x>258) {
        x=258;
    }
    btn.center=CGPointMake(x,y);
}

//滑动结束后隐藏pageView
-(IBAction)hidePageView:(id)sender forEvent:(UIEvent *)event{
     [self changeDicPage:self.dicPageIndex-1];
    [self.pageIndexView setHidden:YES];
}

#pragma
/**
 *读取书籍，如果没有阅读过保存
 *dicId 如果为0,代表没有阅读过
 */
-(void)readBook{
    NSNumberFormatter* numberFormatter= [[NSNumberFormatter alloc]init];
    NSPredicate* predicate=[NSPredicate predicateWithFormat:[NSString stringWithFormat:@"storyWebPath == '%@'",self.story.storyWebPath]];
    JZStory* story= [JZStory findFirstWithPredicate:predicate];
    if (story==nil) {
        JZStory* story1=[JZStory createEntity];
        int maxBookId=[numberFormatter numberFromString: [GlobeTool getValueOfKey:bookMaxId]].intValue+1;
        story1.storyId=[NSNumber numberWithInt:maxBookId];
        story1.isDownload=self.story.isDownload;
        story1.isOver= self.story. isOver;
        story1.lastUpdateTime=self.story. lastUpdateTime;
        story1.storyAuthor= self.story. storyAuthor;
        story1.storyImagePath=self.story. storyImagePath;
        story1.storyName=self.story.storyName;
        story1.storyRemark= self.story.storyRemark;
        story1.storyWebPath=self.story.storyWebPath;
        story1.totalNum= self.story.totalNum;
        story1.lastName=self.story.lastName;
        story1.storyBookPath=self.story.storyBookPath;
        
        [GlobeTool setKeyAndValue:bookMaxId value: [NSString stringWithFormat:@"%i",maxBookId] ];
        
        for (int i=0; i<self.story.dicList.count; i++) {
            JZDictory* dic=[self.story.dicList objectAtIndex:i];
            int maxDicId=[numberFormatter numberFromString: [GlobeTool getValueOfKey:DicMaxId]].intValue+1;
            if (i==0) {
                story1.lastReadId=[NSNumber numberWithInt:maxDicId];
            }
            JZDictory* dictory=[JZDictory createEntity];
            dictory.dictoryId=[NSNumber numberWithInt:maxDicId];
            [GlobeTool setKeyAndValue:DicMaxId value:[NSString stringWithFormat:@"%i",maxDicId]];
            dictory.dictoryDiskPath=dic.dictoryDiskPath;
            dictory.dictoryWebPath=dic.dictoryWebPath;
            dictory.isDownlaod=dic.isDownlaod;
            dictory.dictoryTitle=dic.dictoryTitle;
            dictory.storyId=story1.storyId;
        }
        self.story=story1;
        [[NSManagedObjectContext defaultContext] saveOnlySelfAndWait];
    }else{
        self.story=story;
    }
}

-(void) changeDicPage:(int)pageIndex{
    UIView* noteView2=[self.view viewWithTag:2000];
    
    for (UIView*  view in [noteView2 subviews]) {
        [view removeFromSuperview];
        view.gestureRecognizers=nil;
    }
    
    JZDictoryService* service=[[JZDictoryService alloc]init];
    
    if (self.story.storyId.intValue!=0 && self.story.storyId.intValue>0) {
        self.result =[service getDicResult:self.story.storyId.intValue withIndex:pageIndex withPageCount:30];
    }else{
        self. result=[service getDicResultByArray:self.story.dicList withIndex:pageIndex withPageCount:30];
    }
    [self.scroollView setContentSize:CGSizeMake(0, 230+40*(self.result.result.count+2))];
    UIView* contentView=[self.scroollView viewWithTag:123456789];
    [contentView setFrame:CGRectMake(contentView.frame.origin.x, contentView.frame.origin.y, contentView.frame.size.width, 40*(self.result.result.count+2))];
    [noteView2 setFrame:CGRectMake(noteView2.frame.origin.x, noteView2.frame.origin.y, noteView2.frame.size.width, 40*(self.result.result.count+2))];
    for(int i=0;i<self.result.result.count;i++){
        JZDictory* dic=[self.result.result objectAtIndex:i];
        UIView* view=[[UIView alloc]initWithFrame:CGRectMake(10, i*42+2, 300, 40)];
        [view setBackgroundColor:[UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.5]];
        UILabel* label=[[UILabel alloc]initWithFrame:CGRectMake(5, 0, 300, 40)];
        [label setFont:[UIFont boldSystemFontOfSize:13]];
        [label setText:dic.dictoryTitle];
        
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(click_Dic:)];
        tapGestureRecognizer.numberOfTapsRequired = 1;
        view.tag=i+1;
        NSLog(@"%d",i);
        [view addSubview:label];
        [view addGestureRecognizer:tapGestureRecognizer];
        [noteView2 addSubview:view];
    }
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
}

@end
