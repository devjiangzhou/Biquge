//
//  JZTuijianService.m
//  Biquge
//
//  Created by thx01 on 13-8-4.
//  Copyright (c) 2013年 jz. All rights reserved.
//

#import "JZTuijianService.h"
#import "JZServiceUtil.h"
#import "JZBook.h"
#import "TFHpple.h"
@implementation JZTuijianService

-(NSArray*) queryArray:(int)bookType{
    NSMutableArray *result=[[NSMutableArray alloc]initWithCapacity:6];
    NSURL *bookUrl= [self getBookUrl:bookType];
    if (bookUrl) {
        NSError * error;
        NSData *data=[[NSData alloc]initWithContentsOfURL:bookUrl options:NSDataReadingMappedIfSafe error:&error];
        TFHpple * doc = [[TFHpple alloc] initWithHTMLData:data encoding:@"gbk"];
        
        NSArray* array=[doc searchWithXPathQuery:@"//div[@class='item']"];
        for (int i=0; i<array.count; i++) {
            JZBook* book=[[JZBook alloc]init];
            TFHppleElement * element = [array objectAtIndex:i];
            for (int j=0; j<element.children.count; j++) {
                TFHppleElement * childElement = [element.children objectAtIndex:j];
                for (int z=0; z<childElement.children.count;z++) {
                    TFHppleElement * contentElement = [childElement.children objectAtIndex:z];
                    if ([[contentElement attributes] objectForKey:@"href"] && [contentElement.tagName isEqualToString:@"a"]) {
                        book.bookPath=[[contentElement attributes] objectForKey:@"href"];
                        
                        TFHppleElement* imageNode= [contentElement.children objectAtIndex:0];
                        if ([imageNode.tagName isEqualToString:@"img"] && [[imageNode attributes] objectForKey:@"src"]) {
                            book.bookImagePath=[[imageNode attributes] objectForKey:@"src"];
                        }
                    }else if([contentElement.tagName isEqualToString:@"dt"] ){
                        TFHppleElement* authorNode= [[contentElement children] objectAtIndex:0];
                        book.bookAuthor=authorNode.text;
                        TFHppleElement* bookNameNode= [[contentElement children] objectAtIndex:1];
                        book.bookName=bookNameNode.text;
                    }else if([contentElement.tagName isEqualToString:@"dd"] ){
                        book.bookRemark=contentElement.text;
                    }
                }
            }
            [result addObject:book];
        }
        
    }
    return result;
}

-(NSArray*)queryByType:(int)bookType{
    NSMutableArray *result=[[NSMutableArray alloc]initWithCapacity:6];
    NSURL *bookUrl= [self getBookUrl:bookType];
    if (bookUrl) {
        NSError * error;
        NSData *data=[[NSData alloc]initWithContentsOfURL:bookUrl options:NSDataReadingMappedIfSafe error:&error];
        TFHpple * doc = [[TFHpple alloc] initWithHTMLData:data encoding:@"gbk"];
        NSArray* array=[doc searchWithXPathQuery:@"//div[@class='r']"];
        for (int i=0; i<array.count; i++) {
            TFHppleElement * element = [array objectAtIndex:i];
            for (int j=0; j<element.children.count; j++) {
                TFHppleElement * childElement = [element.children objectAtIndex:j];
                if ([childElement.tagName isEqualToString:@"ul"]) {
                    for (int z=0; z<childElement.children.count;z++) {
                        TFHppleElement * contentElement =  [childElement.children objectAtIndex:z];
                        if ([contentElement.tagName isEqualToString:@"li"]) {
                            JZBook* book=[[JZBook alloc]init];
                            TFHppleElement * child =[contentElement.children objectAtIndex:1];
                            TFHppleElement * bookChild =[contentElement.children objectAtIndex:0];
                            [book setBookAuthor:child.text];//book作者
                            [book setBookName:bookChild.firstChild.text]; //book name
                            [book setBookPath:[[bookChild.firstChild attributes]objectForKey:@"href"]]; //book path
                            [book setBookImagePath:[[JZServiceUtil getBookImagePath:book.bookPath] absoluteString]];
                            [result addObject:book];
                        }
                    }
                }
            }
        }
        
    }
    return result;
}

-(NSURL*) getBookUrl:(int)bookType{
    NSURL* bookUrl;
    switch (bookType) {
        case XUANHUAN:
            bookUrl=[GlobeTool getUrl:xhUrl];
            break;
        case XIUZHEN:
            bookUrl=[GlobeTool getUrl:xzUrl];
            break;
        case CHUANYUE:
            bookUrl=[GlobeTool getUrl:cyUrl];
            break;
        case WANGYOU:
            bookUrl=[GlobeTool getUrl:wyUrl];
            break;
        case KEHUAN:
            bookUrl=[GlobeTool getUrl:khUrl];
            break;
        case DUSHI:
            bookUrl=[GlobeTool getUrl:dsUrl];
            break;
    }
    return bookUrl;
}
@end
