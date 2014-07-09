//
//  JZBookDetailService.h
//  Biquge
//
//  Created by thx01 on 13-8-14.
//  Copyright (c) 2013年 jz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JZStory.h"
@interface JZBookDetailService : NSObject
-(JZStory*) queryBookDetail:(NSString*)bookWebPath;
@end
