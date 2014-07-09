//
//  JZDirectoryView.m
//  Biquge
//
//  Created by thx01 on 13-8-29.
//  Copyright (c) 2013年 jz. All rights reserved.
//

#import "JZDirectoryView.h"
#import "JZStory.h"
#import "JZDictory.h"
@interface JZDirectoryView()
@property (nonatomic,strong)UITableView* dicTableView;
@end

@implementation JZDirectoryView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.multipleTouchEnabled = YES;
        [self setFrame:frame];
        
        self.dicTableView=[[UITableView alloc]initWithFrame:frame style:UITableViewStylePlain];
        [self.dicTableView setFrame:frame];
        [self.dicTableView setBackgroundColor:[UIColor whiteColor]];
        [self.dicTableView setDataSource:self];
        [self.dicTableView setDelegate:self];
        [self.dicTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        
        UIView* bottomView=[[UIView alloc]initWithFrame:CGRectMake(0, self.superview.frame.size.height-50, 320, 50)];
        [bottomView setBackgroundColor:[UIColor lightGrayColor]];
        [self addSubview:bottomView];
        [self addSubview:self.dicTableView];
    }
    return self;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 */
- (void)drawRect:(CGRect)rect
{
    // Drawing code
  }

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return array.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identifier = @"dicCell";
    
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        
        cell.contentMode=UIViewContentModeCenter;
    }else{
        // 删除cell中的子对象,刷新覆盖问题。
        while ([cell.contentView.subviews lastObject] != nil) {
            [(UIView*)[cell.contentView.subviews lastObject] removeFromSuperview];
        }
    }
    UIView* view=[[UIView alloc]initWithFrame:CGRectMake(10, 5, 300, 50)];
    [view setBackgroundColor:[UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.5]];
    UILabel* label=[[UILabel alloc]initWithFrame:CGRectMake(5, 5, 300, 40)];
    
    JZDictory* dic=[array objectAtIndex:indexPath.row];
    [label setText:dic.dictoryTitle];
    [view addSubview:label];
    [cell.contentView addSubview:view];
    return cell;
}

-(void) setData:(NSArray *)result{
    array=result;
    [self.dicTableView reloadData];
}

@end
