//
//  JZBookDetailService.m
//  Biquge
//
//  Created by thx01 on 13-8-14.
//  Copyright (c) 2013年 jz. All rights reserved.
//

#import "JZBookDetailService.h"
#import "TFHpple.h"
#import "JZDictory.h"
@implementation JZBookDetailService

-(JZStory*) queryBookDetail:(NSString*)bookWebPath{
    NSURL* bookUrl=[NSURL URLWithString:bookWebPath];
    
    JZStory *story=[[JZStory alloc]initWithEntity:[JZStory entityDescription] insertIntoManagedObjectContext:nil];
    if (bookUrl) {
        [story setStoryWebPath:bookWebPath];
        
        NSError * error;
        NSData *data=[[NSData alloc]initWithContentsOfURL:bookUrl options:NSDataReadingMappedIfSafe error:&error];
        TFHpple * doc = [[TFHpple alloc] initWithHTMLData:data encoding:@"gbk"];
        
        
        NSArray* array=[doc searchWithXPathQuery:@"//div[@id='info']"];
        for (int i=0; i<array.count; i++) {
            TFHppleElement * element = [array objectAtIndex:i];
            for (int j=0; j<element.children.count; j++) {
                TFHppleElement * childElement = [element.children objectAtIndex:j];
                if (j==1) {
                    [story setStoryName:[childElement text]];
                }else if (j==3){
                    NSArray* strs= [[childElement text] componentsSeparatedByString:@"："];
                    [story setStoryAuthor:strs[1]];
                }else if (j==7){
                    NSArray* strs= [[childElement text] componentsSeparatedByString:@"："];
                    [story setLastUpdateTime:strs[1]];
                }
            }
        }
        
        array=[doc searchWithXPathQuery:@"//div[@id='intro']"];
        for (int i=0; i<array.count; i++) {
            TFHppleElement * element = [array objectAtIndex:i];
            for (int j=0; j<element.children.count; j++) {
                TFHppleElement * childElement = [element.children objectAtIndex:j];
                if (j==1) {
                    [story setStoryRemark:[childElement text]];
                }
            }
        }
        
        
        array=[doc searchWithXPathQuery:@"//div[@id='fmimg']"];
        
        for (int i=0; i<array.count; i++) {
            TFHppleElement * element = [array objectAtIndex:i];
            for (int j=0; j<element.children.count; j++) {
                TFHppleElement * childElement = [element.children objectAtIndex:j];
                if (j==0) {
                    NSString* bookImagePath=[[childElement attributes]objectForKey:@"src"];
                    [story setStoryImagePath:bookImagePath];
                }else{
                    NSString* className=[[childElement attributes] objectForKey:@"class"];
                    if ([className isEqualToString:@"a"]) {
                        [story setIsOver:[NSNumber numberWithInt:1]];
                    }else if ([className isEqualToString:@"b"]){
                        [story setIsOver:[NSNumber numberWithInt:0]];
                    }
                }
                
            }
        }
        
        NSMutableArray* list=[NSMutableArray arrayWithArray:[doc searchWithXPathQuery:@"//dd"]];
        NSMutableArray* tmp=[list mutableCopy];
        
        NSMutableIndexSet* delIndexs=[NSMutableIndexSet indexSet];
        
        int count=0;
        if (list.count%2!=0) {
            count=list.count/2+1;
        }else{
            count=list.count/2;
        }
        for (int i=0; i<count; i++) {
            TFHppleElement * firstEle = [list objectAtIndex:i];
            NSString* firstHref=[firstEle.firstChild.attributes objectForKey:@"href"];
            TFHppleElement * lastEle = [list objectAtIndex:list.count-i-1];
            
            NSString* lastHref=[lastEle.firstChild.attributes objectForKey:@"href"];
            
            if ([firstHref isEqualToString:lastHref]) {
                [delIndexs addIndex:i];
            }
        }
        
        [tmp removeObjectsAtIndexes:delIndexs];
        [list removeAllObjects];
        list=nil;
        
        story.totalNum=[NSNumber numberWithInt:tmp.count];
        
        TFHppleElement * ele =[tmp lastObject];
        @try {
            NSArray* titles=  [[ele.firstChild text] componentsSeparatedByString:@" "];
            [story setLastName:titles[1]];
        }
        @catch (NSException *exception) {
            NSLog(@"%@",@"解析标题错误");
            [story setLastName:[ele.firstChild text]];
        }
        
        NSMutableArray* dics=[[NSMutableArray alloc]initWithCapacity:1000];
        for (TFHppleElement* dicElement in tmp) {
            JZDictory *dictory=[[JZDictory alloc]initWithEntity:[JZDictory entityDescription] insertIntoManagedObjectContext:nil];
            [dictory setDictoryTitle: [dicElement.firstChild text]];
            NSString* path=nil;
            NSString* href=[dicElement.firstChild.attributes objectForKey:@"href"];
            
            if (![href hasPrefix:rootUrl]) {
                path=[NSString stringWithFormat:@"%@%@",rootUrl,[dicElement.firstChild.attributes objectForKey:@"href"]];
            }
            [dictory setDictoryWebPath:path];
            [dics addObject:dictory];
        }
        [story setDicList:dics];
    }else{
        story=nil;
    }
    return story;
}
@end
