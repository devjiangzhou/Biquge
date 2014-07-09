//
//  JZTuijianView.m
//  Biquge
//
//  Created by thx01 on 13-8-4.
//  Copyright (c) 2013年 jz. All rights reserved.
//

#import "JZTuijianView.h"
#import  <QuartzCore/QuartzCore.h>
#import "SDWebImage/SDWebImageManager.h"
@interface JZTuijianView()

@property (nonatomic,strong) IBOutlet UIImageView* bookImageView;
@property (nonatomic,strong) IBOutlet UILabel* bookName;
@property (nonatomic,strong) IBOutlet UILabel* bookAuthor;
@property (nonatomic,strong) IBOutlet UILabel* bookRemark;

@property (nonatomic) CGPoint startTouchPoint;   //位置
@property (nonatomic,copy) NSString *dirString;         //滑动方向
@end

@implementation JZTuijianView

-(void) setBook:(JZBook *)book{
    [self.bookName setText:book.bookName];
    [self.bookAuthor setText:book.bookAuthor];
    [self.bookRemark setText:book.bookRemark];
    //单独异步下载一个图片
    [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:book.bookImagePath] options:0 progress:^(NSUInteger receivedSize, long long expectedSize) {
        
    } completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
        if (image && finished) {
            self.bookImageView.image = image;
        }
    }];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    self.startTouchPoint = [touch locationInView:self];
    self.dirString = NULL;
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = touches.anyObject;
    CGPoint currentTouchPosition = [touch locationInView:self];
    
#define HORIZ_SWIPE_DRAG_MIN 5
#define VERT_SWIPE_DRAG_MAX 100
    
    if (fabsf(self.startTouchPoint.x - currentTouchPosition.x) >=
        HORIZ_SWIPE_DRAG_MIN &&
        fabsf(self.startTouchPoint.y - currentTouchPosition.y) <=
        VERT_SWIPE_DRAG_MAX)  {
        // Horizontal Swipe
        if (self.startTouchPoint.x < currentTouchPosition.x) {
            self.dirString = kCATransitionFromLeft;
        }
        else
            self.dirString = kCATransitionFromRight;
    }
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if (self.dirString)
        [self.delegate swipeTo:self.dirString];
}

@end
