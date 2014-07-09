//
//  JZDictoryService.m
//  Biquge
//
//  Created by thx01 on 13-9-9.
//  Copyright (c) 2013年 jz. All rights reserved.
//

#import "JZDictoryService.h"

@implementation JZDictoryService


-(JZDictory*)getDictoryByUrl:(NSString*)url{
    NSPredicate* predicate=[NSPredicate predicateWithFormat:@"dictoryWebPath == %@",url];
    return [JZDictory findFirstWithPredicate:predicate];
}


-(JZDictory*)getDictoryById:(int)id{
    NSPredicate* predicate=[NSPredicate predicateWithFormat:@"dictoryId == %i",id];
    return [JZDictory findFirstWithPredicate:predicate];
}

/**
 *  得到小说开始的章节的id 即最小的id,用来判断是否继续阅读
 */
-(int) getMinId:(id)storyId{
    NSPredicate* predicate=[NSPredicate predicateWithFormat:@"storyId == %i",storyId];
    JZDictory* dic=  [JZDictory findFirstWithPredicate:predicate sortedBy:@"dictoryId" ascending:YES];
    return  dic.dictoryId.intValue;
}

-(JZSearchResult*)getDicResult:(int)id withIndex:(int)pageIndex withPageCount:(int)count{
    NSManagedObjectContext* context=[NSManagedObjectContext defaultContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"JZDictory" inManagedObjectContext:context];
    [request setEntity:entity];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"dictoryId" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    NSPredicate* predicate=[NSPredicate predicateWithFormat:@"storyId == %i",id];
    [request setPredicate:predicate];
    [request setSortDescriptors:sortDescriptors];
    [request setFetchLimit:count];
    [request setFetchOffset:pageIndex * count];
    
    NSError* error;
    NSArray *array = [context executeFetchRequest:request error:&error];
    JZSearchResult* result=[[JZSearchResult alloc]init];
    [result setResult:array];
    [result setPageCount:count];
    [result setPageIndex:pageIndex];
    //总条数
    int totalCont= [JZDictory countOfEntitiesWithPredicate:predicate];
    //总页数
    int totalPage = totalCont / count;
    if (totalCont % count != 0){
        totalPage += 1;
    }
    [result setTotalPages:totalPage];
    return  result;
}
-(JZSearchResult*)getDicResultByArray:(NSArray*)array withIndex:(int)pageIndex withPageCount:(int)count{

    JZSearchResult* result=[[JZSearchResult alloc]init];
    
    [result setResult:[array subarrayWithRange:NSMakeRange(pageIndex*count, count)]];
    [result setPageCount:count];
    [result setPageIndex:pageIndex];
    
    int totalCont= array.count;
    //总页数
    int totalPage = totalCont / count;
    if (totalCont % count != 0){
        totalPage += 1;
    }
    [result setTotalPages:totalPage];
    return  result;
}
@end
