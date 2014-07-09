//
//  JZTuijianView.h
//  Biquge
//
//  Created by thx01 on 13-8-4.
//  Copyright (c) 2013年 jz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JZBook.h"
@protocol TuijiantouchViewDelegate<NSObject>
- (void)swipeTo:(NSString *)transition;
@end

@interface JZTuijianView : UIView
    @property (nonatomic,strong) JZBook* book;
    @property (nonatomic, weak) id <TuijiantouchViewDelegate> delegate;
@end
