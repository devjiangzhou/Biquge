//
//  JZBookContentService.m
//  Biquge
//
//  Created by thx01 on 13-9-7.
//  Copyright (c) 2013年 jz. All rights reserved.
//

#import "JZBookContentService.h"
#import "JZStory.h"
#import "JZDictory.h"
#import "TFHpple.h"
#import  "JZLabel.h"
@implementation JZBookContentService
-(NSString*)getConetntByDicId:(JZDictory*)dic{
    if(dic!=nil){
        NSString* url= dic.dictoryWebPath;
        //处理路径
        if (![url hasPrefix:rootUrl]) {
            url=[NSString stringWithFormat:@"%@%@",rootUrl,url];
        }
        NSError * error;
        NSData *data=[[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:url] options:NSDataReadingMappedIfSafe error:&error];
        TFHpple * doc = [[TFHpple alloc] initWithHTMLData:data encoding:@"gbk"];
        NSArray* array=[doc searchWithXPathQuery:@"//div[@id='content']"];
        TFHppleElement * element = [array objectAtIndex:0];
        return [self handleCotent:[element raw]];
    }
    return @"";
}

-(NSArray*) dicsForLongStr:(NSString*)content withFont:(UIFont*)font inRect:(CGRect)rect{
    NSMutableArray* array=[NSMutableArray array];
    NSLog(@"%d",content.length);
    //返回一个数组, 包含每一页的字符串开始点和长度(NSRange)
    NSMutableArray *ranges=[[NSMutableArray alloc]init];
    //显示字体的行高
    CGFloat lineHeight= [self getStringSize:font rect:rect note:@"样()!@#$?.,/\\~a-z+"].height+4;
    
    //  CGFloat lineHeight= [@"样本" sizeWithFont:font].height+4;
    //每次floor后，都必须+1
    NSInteger maxLine=floor(rect.size.height/lineHeight);
    
    NSInteger totalLines=0;
    NSString *lastParaLeft=nil;
    NSRange range=NSMakeRange(0, 0);
    //把字符串按段落分开, 提高解析效率
    NSArray *paragraphs=[content componentsSeparatedByString:@"\n"];
    
    for (int p=0;p< [paragraphs count];p++) {
        NSString *para;
        if (lastParaLeft!=nil) {
            //上一页完成后剩下的内容继续计算
            para=lastParaLeft;
            lastParaLeft=nil;
        }else {
            para=[paragraphs objectAtIndex:p];
            if (p<[paragraphs count]-1){ //刚才分段去掉了一个换行,现在换给它
                para=[para stringByAppendingString:@"\n"];
            }
        }
        
        CGSize  paraSize = [self getStringSize:font rect:rect note:para];
        
        NSInteger paraLines=floor(paraSize.height/lineHeight+0.5);
        NSLog(@"行数：%d",paraLines);
        if (totalLines+paraLines<maxLine) {
            totalLines+=paraLines;
            range.length+=[para length];
            if (p==[paragraphs count]-1) {
                //到了文章的结尾 这一页也算
                [ranges addObject:[NSValue valueWithRange:range]];
                //IMILog(@”===========Page Over=============”);
            }
        }else if (totalLines+paraLines==maxLine) {
            //很幸运, 刚好一段结束,本页也结束, 有这个判断会提高一定的效率
            range.length+=[para length];
            [ranges addObject:[NSValue valueWithRange:range]];
            range.location+=range.length;
            range.length=0;
            totalLines=0;
            NSLog(@"第 %d 页",ranges.count);
            //IMILog(@”===========Page Over=============”);
        }else{
            //重头戏, 页结束时候本段文字还有剩余
            NSInteger lineLeft=maxLine-totalLines;
            CGSize tmpSize;
            NSInteger i;
            for (i=1; i<[para length]; i++) {
                //逐字判断是否达到了本页最大容量
                NSString *tmp=[para substringToIndex:i];
                tmpSize = [self getStringSize:font rect:rect note:tmp];
                int nowLine=floor(tmpSize.height/lineHeight+0.5);
                if (lineLeft<nowLine) {
                    //超出容量,跳出, 字符要回退一个, 应为当前字符已经超出范围了
                    lastParaLeft=[para substringFromIndex:i-1];
                    break;
                }
            }
            range.length+=i-1;
            [ranges addObject:[NSValue valueWithRange:range]];
            range.location+=range.length;
            range.length=0;
            totalLines=0;
            p--;
            NSLog(@"第 %d 页",ranges.count);
            //IMILog(@”===========Page Over=============”);
        }
    }
    
    for (int i=0; i<ranges.count; i++) {
        NSRange range= [[ranges objectAtIndex:i] rangeValue];
        NSString* str;
        if (range.location<=content.length) {
            if (ranges.count-1==i) {
                str=[content substringFromIndex:range.location];
                for (int k=0; k<maxLine-totalLines+1; k++) {
                    str=[str stringByAppendingString:@"\n"];
                }
            }else{
                if (range.location+range.length>content.length) {
                    str=[content substringFromIndex:range.location];
                }else{
                    str=[content substringWithRange:range];
                }
            }
        }
        if (str) {
            if ([str hasPrefix:@"\n"]) {
                str = [str substringFromIndex:2];
            }
            [array addObject:[str mutableCopy]];
        }
        str=nil;
    }
    return [NSArray arrayWithArray:array];
}
//通过计算行距和间距 计算大小
-(CGSize) getStringSize:(UIFont*)uiFont rect:(CGRect)rect note:(NSString*)text{
    
    //    NSMutableAttributedString * attrStr=[[NSMutableAttributedString alloc]initWithString:text];
    //    [attrStr setTextAlignment:kCTTextAlignmentLeft multipleLine:YES lineBreakMode:kCTLineBreakByWordWrapping];
    //    [attrStr setLeading:8];
    //    [attrStr setKerning:2];
    //    [attrStr setFont:[UIFont fontWithName:@"Helvetica" size:20]];
    //    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attrStr);
    //    CGSize  size = CTFramesetterSuggestFrameSizeWithConstraints(framesetter,CFRangeMake(0,attrStr.length), NULL,rect.size, NULL);
    //    CFRelease(framesetter);
    
    //去掉空行
    NSString *labelString =text;
    NSString *myString = [labelString stringByReplacingOccurrencesOfString:@"\r\n" withString:@"\n"];
    
    //创建AttributeString
    NSMutableAttributedString *string =[[NSMutableAttributedString alloc]initWithString:myString];
    
    //设置字体及大小
    CTFontRef helveticaBold = CTFontCreateWithName((CFStringRef)uiFont.fontName,uiFont.pointSize,NULL);
    [string addAttribute:(id)kCTFontAttributeName value:(__bridge  id)helveticaBold range:NSMakeRange(0,[string length])];
    
    //设置字间距
    long number = 2;
    CFNumberRef num = CFNumberCreate(kCFAllocatorDefault,kCFNumberSInt8Type,&number);
    [string addAttribute:(id)kCTKernAttributeName value:(__bridge id)num range:NSMakeRange(0,[string length])];
    CFRelease(num);
    
    //创建文本对齐方式
    CTTextAlignment alignment = kCTTextAlignmentLeft;
    //设置文本行间距
    CGFloat lineSpace = 8;
    //设置文本段间距
    CGFloat paragraphSpacing = 5.0;
    //创建设置数组
    //    BOOL multiple=YES;
    //    CGFloat multipleLine = (multiple) ? 1.0f : 0.0f;
    CTLineBreakMode lineBreak=kCTLineBreakByWordWrapping;
    CTParagraphStyleSetting settings[4] = {
		{.spec = kCTParagraphStyleSpecifierAlignment, .valueSize = sizeof(alignment), .value = (const void*)&alignment},
        {.spec = kCTParagraphStyleSpecifierLineBreakMode, .valueSize = sizeof(lineBreak), .value = (const void*)&lineBreak},
        //{.spec = kCTParagraphStyleSpecifierLineHeightMultiple, .valueSize = sizeof(multipleLine), .value = (const void*)&multipleLine},,
        {.spec = kCTParagraphStyleSpecifierLineSpacingAdjustment, .valueSize = sizeof(lineSpace), .value = &lineSpace},
        {.spec = kCTParagraphStyleSpecifierParagraphSpacing, .valueSize = sizeof(paragraphSpacing), .value = (const void*)&paragraphSpacing}
	};
    CTParagraphStyleRef style = CTParagraphStyleCreate(settings , sizeof(settings));
    
    //给文本添加设置
    [string addAttribute:(id)kCTParagraphStyleAttributeName value:(__bridge id)style range:NSMakeRange(0 , [string length])];
    
    //排版
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)string);
    CGSize  size = CTFramesetterSuggestFrameSizeWithConstraints(framesetter,CFRangeMake(0,text.length), NULL,rect.size, NULL);
    CFRelease(framesetter);
    
    return  CGSizeMake(rect.size.width,size.height+1);;
}

-(NSString*) handleCotent:(NSString*)str{
    NSString* result=str;
    
    result= [result stringByReplacingOccurrencesOfString:@"<div id=\"content\">" withString:@""];
    result= [result stringByReplacingOccurrencesOfString:@"&nbsp;&nbsp;&nbsp;&nbsp;" withString:@"　　"];
    result= [result stringByReplacingOccurrencesOfString:@"<br/><br/>" withString:@"\n"];
    result= [result stringByReplacingOccurrencesOfString:@"</div>" withString:@""];
    
    return result;
}

@end
