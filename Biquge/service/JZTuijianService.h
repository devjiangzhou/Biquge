//
//  JZTuijianService.h
//  Biquge
//
//  Created by thx01 on 13-8-4.
//  Copyright (c) 2013年 jz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JZTuijianService : NSObject

/**
 *  查到所有的推荐
 */
-(NSArray*) queryArray:(int)bookType;

/**
 *  查到对应的推荐书籍
 */
-(NSArray*) queryByType:(int)bookType;
@end
