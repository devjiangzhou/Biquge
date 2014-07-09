//
//  JZBookReadViewController.h
//  Biquge
//
//  Created by thx01 on 13-9-3.
//  Copyright (c) 2013年 jz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JZDictory.h"
#import "JZDictoryService.h"

@interface JZBookReadViewController : UIViewController <UIPageViewControllerDelegate, UIPageViewControllerDataSource,UITabBarDelegate>{
    int currentIndex;
    int totalPages;
}
@property int bookId;
@property NSString* dicUrl;
@property (nonatomic,retain) JZDictory* dictory;
@property (nonatomic,copy) NSString* pathUrl;
@end
