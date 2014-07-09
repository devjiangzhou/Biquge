//
//  JZDirectoryView.h
//  Biquge
//
//  Created by thx01 on 13-8-29.
//  Copyright (c) 2013年 jz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JZDirectoryView : UIView<UITableViewDataSource,UITableViewDelegate>
{
    NSArray* array;
}
-(void) setData:(NSArray *)array;
@end
