//
//  JZDictoryService.h
//  Biquge
//
//  Created by thx01 on 13-9-9.
//  Copyright (c) 2013年 jz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JZDictory.h"
#import "JZSearchResult.h"
@interface JZDictoryService : NSObject

-(JZDictory*)getDictoryByUrl:(NSString*)url;
-(JZDictory*)getDictoryById:(int)id;
-(JZSearchResult*)getDicResult:(int)id withIndex:(int)pageIndex withPageCount:(int)count;
-(JZSearchResult*)getDicResultByArray:(NSArray*)array withIndex:(int)pageIndex withPageCount:(int)count;
@end
