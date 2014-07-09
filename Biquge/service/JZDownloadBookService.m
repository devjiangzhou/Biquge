//
//  JZDownloadBookService.m
//  Biquge
//
//  Created by thx01 on 13-8-4.
//  Copyright (c) 2013年 jz. All rights reserved.
//

#import "JZDownloadBookService.h"
#import "TFHpple.h"
@implementation JZDownloadBookService
-(void) downLoadBookData{
    
    NSString* updateTime=[[NSUserDefaults standardUserDefaults]valueForKey:@"updateTime"];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *downloadTime;
    if (updateTime) {
        downloadTime= [dateFormatter dateFromString:updateTime];
    }else{
        downloadTime=[[NSDate alloc]init];
    }
    
    NSCalendar *cal = [NSCalendar currentCalendar];
    unsigned  int  unitFlags  =  NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit |NSMinuteCalendarUnit |NSSecondCalendarUnit;
    
    NSDateComponents *d = [cal components:unitFlags  fromDate:downloadTime  toDate: [[NSDate alloc]init] options:0];
    
    int sec = [d hour]*3600 + [d minute]*60+[d second];
    if (sec>=30*60 || sec<10) {
        
        NSError * error;
        NSData *data=[[NSData alloc]initWithContentsOfURL:[GlobeTool getUrl:allBookUrl] options:NSDataReadingMappedIfSafe error:&error];
        TFHpple * doc = [[TFHpple alloc] initWithHTMLData:data encoding:@"gbk"];
        
        NSArray* array= [doc searchWithXPathQuery:@"//div[@class='novellist']"];
        
        for (int i=0; i<array.count; i++) {
            TFHppleElement * element = [array objectAtIndex:i];
            for (int j=0; j<element.children.count; j++) {
                TFHppleElement * childElement = [element.children objectAtIndex:j];
                if ([childElement.tagName isEqualToString:@"ul"]) {
                     for (int z=0; z<childElement.children.count;z++) {
                           TFHppleElement * contentElement =  [childElement.children objectAtIndex:z];
                         if ([contentElement.tagName isEqualToString:@"li"]) {
                             NSLog(@"%@", [contentElement.text stringByReplacingOccurrencesOfString:@"/" withString:@""]);
                             TFHppleElement *  noteChild=contentElement.firstChild;
                             NSLog(@"%@",[[noteChild attributes]objectForKey:@"href"]);
                         }
                     }
                }
            }
        }

        
    }
}
@end
