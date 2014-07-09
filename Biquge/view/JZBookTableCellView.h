//
//  JZBookTableCellView.h
//  Biquge
//
//  Created by thx01 on 13-8-4.
//  Copyright (c) 2013年 jz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JZBook.h"
@interface JZBookTableCellView : UITableViewCell
@property (nonatomic,weak) JZBook* book;

@property (nonatomic,weak) IBOutlet UILabel* bookName;
@property (nonatomic,weak) IBOutlet UILabel* bookAuthor;

@property (nonatomic,weak) IBOutlet UIImageView* bookImageView;
@end
