//
//  JZBookTableCellView.m
//  Biquge
//
//  Created by thx01 on 13-8-4.
//  Copyright (c) 2013年 jz. All rights reserved.
//

#import "JZBookTableCellView.h"
#import "SDWebImage/SDWebImageManager.h"
@interface JZBookTableCellView()

@end
@implementation JZBookTableCellView

-(void)setBook:(JZBook *)book{
    self.bookName.text=book.bookName;
    self.bookAuthor.text=book.bookAuthor;
    
    [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:book.bookImagePath] options:0 progress:^(NSUInteger receivedSize, long long expectedSize) {
        
    } completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
        if (image && finished) {
            self.bookImageView.image = image;
        }
    }];

}

@end
