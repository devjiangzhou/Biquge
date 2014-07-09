//
//  JZSearchResult.h
//  Biquge
//
//  Created by thx01 on 13-9-10.
//  Copyright (c) 2013年 jz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JZSearchResult : NSObject

@property (nonatomic) int pageIndex;
@property (nonatomic) int totalPages;
@property (nonatomic) int pageCount;
@property (nonatomic) NSArray* result;

@end
