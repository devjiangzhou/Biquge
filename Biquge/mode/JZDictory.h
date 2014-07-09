//
//  JZDictory.h
//  Biquge
//
//  Created by thx01 on 13-9-7.
//  Copyright (c) 2013年 jz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface JZDictory : NSManagedObject

@property (nonatomic, retain) NSString * dictoryDiskPath;
@property (nonatomic, retain) NSNumber * dictoryId;
@property (nonatomic, retain) NSString * dictoryTitle;
@property (nonatomic, retain) NSString * dictoryWebPath;
@property (nonatomic, retain) NSNumber * isDownlaod;
@property (nonatomic, retain) NSNumber * storyId;

@end
