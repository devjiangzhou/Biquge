//
//  JZBookContentViewController.m
//  Biquge
//
//  Created by thx01 on 13-9-3.
//  Copyright (c) 2013年 jz. All rights reserved.
//

#import "JZBookContentViewController.h"
#import "JZLabel.h"
@interface JZBookContentViewController ()
@property (nonatomic,strong) UILabel* currIndexLabel;
@property (nonatomic,strong)  NSMutableAttributedString* attrStr;
@end

@implementation JZBookContentViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    ///////////////显示内容 电池  当前页数  标题////////////////////////////
//    NSMutableAttributedString * attrStr=[[NSMutableAttributedString alloc]initWithString:@""];
//    [attrStr setLeading:10];
//    [attrStr setKerning:5];
//    [attrStr setFont:[UIFont fontWithName:@"Helvetica" size:17]];
//    [attrStr setTextColor:[UIColor blackColor]];
//    [attrStr setTextAlignment:kCTTextAlignmentLeft multipleLine:YES lineBreakMode:kCTLineBreakByWordWrapping];
    
    
    
//    NSMutableAttributedString * attrStr=[[NSMutableAttributedString alloc]initWithString:@""];
//    [attrStr setLeading:10];
//    [attrStr setKerning:5];
//    [attrStr setFont:[UIFont fontWithName:@"Helvetica" size:17]];
//    [attrStr setTextColor:[UIColor blackColor]];
//    JZLabel* contentLabel=[[JZLabel alloc]initWithFrame:CGRectMake(15, 10, 290, 450)];
//    [contentLabel setAttributedText:attrStr];
//    contentLabel.tag=100;
//    [contentLabel setNumberOfLines:0];
//    [contentLabel setLineBreakMode:NSLineBreakByCharWrapping];
//    self.attrStr=attrStr;
    
    JZLabel* contentLabel=[[JZLabel alloc]initWithFrame:CGRectMake(15, 10, 290, 465)];
//    [contentLabel setAttributedText:attrStr];
    contentLabel.tag=100;
    [contentLabel setNumberOfLines:0];
    [contentLabel setLineBreakMode:NSLineBreakByCharWrapping];
    [contentLabel setFont:[UIFont fontWithName:@"Helvetica" size:20]];
    
    UILabel* titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(50, 460, 220, 20)];
    titleLabel.textColor=[UIColor blackColor];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setFont:[UIFont boldSystemFontOfSize:10]];
    if (self.title) {
        [titleLabel setText:self.title];
    }else{
        [titleLabel setText:@"title"];
    }
    titleLabel.tag=300;
    
    UILabel* batteryLeveLabel=[[UILabel alloc]initWithFrame:CGRectMake(5, 460, 45, 20)];
    batteryLeveLabel.textColor=[UIColor blackColor];
    [batteryLeveLabel setFont:[UIFont boldSystemFontOfSize:11]];
    [batteryLeveLabel setText:[NSString stringWithFormat:@"%g%%",[GlobeTool getBatteryLeve]*100]];
    
    
    UILabel* currIndexLabel=[[UILabel alloc]initWithFrame:CGRectMake(270, 460, 45, 20)];
    [currIndexLabel setTextAlignment:NSTextAlignmentRight];
    currIndexLabel.textColor=[UIColor blackColor];
    [currIndexLabel setFont:[UIFont boldSystemFontOfSize:11]];
    currIndexLabel.tag=200;
    self.currIndexLabel=currIndexLabel;
    
    
    [contentLabel setBackgroundColor:[UIColor clearColor]];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [batteryLeveLabel setBackgroundColor:[UIColor clearColor]];
    [currIndexLabel setBackgroundColor:[UIColor clearColor]];
    
    [self.view addSubview:contentLabel];
    [self.view addSubview:batteryLeveLabel];
    [self.view addSubview:titleLabel];
    [self.view addSubview:currIndexLabel];
}

-(void) setCurrIndex:(int)currIndex withTotalPage:(int)totalPage{
    self.currIndex=currIndex;
    self.totalPage=totalPage;
    UILabel* pageLabel=(UILabel*)[self.view viewWithTag:200];
    [pageLabel setText:[NSString stringWithFormat:@"第%i/%i页",currIndex+1,totalPage]];
}

-(void) setContent:(NSString *)content{
    NSMutableAttributedString * attrStr=[[NSMutableAttributedString alloc]initWithString:content];
    [attrStr setTextAlignment:kCTTextAlignmentLeft multipleLine:YES lineBreakMode:kCTLineBreakByWordWrapping];
    [attrStr setLeading:8];
    [attrStr setKerning:2];
    [attrStr setFont:[UIFont fontWithName:@"Helvetica" size:20]];
    
    [attrStr setTextColor:[UIColor blackColor]];
    JZLabel* contentLabel=(JZLabel*)[self.view viewWithTag:100];
    [contentLabel setAttributedText:attrStr];
    [contentLabel sizeThatFits:contentLabel.frame.size];
   // [contentLabel setText:content];
}
-(void) setTitle:(NSString *)title{
    UILabel* titleLabel=(UILabel*)[self.view viewWithTag:300];
    [titleLabel setText:title];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
