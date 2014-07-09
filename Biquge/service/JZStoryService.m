//
//  JZStoryService.m
//  Biquge
//
//  Created by thx01 on 13-9-9.
//  Copyright (c) 2013年 jz. All rights reserved.
//

#import "JZStoryService.h"
@implementation JZStoryService
-(JZStory*)getStoryById:(int)id{
    NSPredicate* predicate=[NSPredicate predicateWithFormat:@"storyId == %i",id];
    return [JZStory findFirstWithPredicate:predicate];
}
-(JZStory*)getStoryByPath:(NSString*)webPath{
    NSPredicate* predicate=[NSPredicate predicateWithFormat:@"storyWebPath == %@",webPath];
    return [JZStory findFirstWithPredicate:predicate];
}
@end
