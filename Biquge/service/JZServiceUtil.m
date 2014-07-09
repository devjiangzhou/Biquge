//
//  JZServiceUtil.m
//  Biquge
//
//  Created by thx01 on 13-8-10.
//  Copyright (c) 2013年 jz. All rights reserved.
//

#import "JZServiceUtil.h"

@implementation JZServiceUtil
+(NSURL*)getBookImagePath:(NSString*)bookWebPath
{
   bookWebPath= [bookWebPath stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSMutableArray *strs=[NSMutableArray arrayWithArray:[bookWebPath componentsSeparatedByString:@"/"]];
    NSString* identity=[strs lastObject];
    if (identity.length<=0) {
        [strs removeLastObject];
    }
    identity=[strs lastObject];
    NSArray* ids= [identity componentsSeparatedByString:@"_"];
    //http://www.biquge.com/image/4/4361/4361s.jpg
    NSURL * url=[NSURL URLWithString: [NSString stringWithFormat:@"%@/image/%@/%@/%@s.jpg",rootUrl,ids[0],ids[1],ids[1]]];
    return url;
}
@end
