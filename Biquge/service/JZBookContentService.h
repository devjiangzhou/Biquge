//
//  JZBookContentService.h
//  Biquge
//
//  Created by thx01 on 13-9-7.
//  Copyright (c) 2013年 jz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JZDictory.h"
@interface JZBookContentService : NSObject
-(NSString*)getConetntByDicId:(JZDictory*)dic;
-(NSArray*) dicsForLongStr:(NSString*)content withFont:(UIFont*)font inRect:(CGRect)rect;
@end
