//
//  JZStoryService.h
//  Biquge
//
//  Created by thx01 on 13-9-9.
//  Copyright (c) 2013年 jz. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "JZStory.h"
@interface JZStoryService : NSObject
-(JZStory*)getStoryById:(int)id;
-(JZStory*)getStoryByPath:(NSString*)webPath;
@end
