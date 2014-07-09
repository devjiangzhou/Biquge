//
//  JZStory.h
//  Biquge
//
//  Created by thx01 on 13-9-9.
//  Copyright (c) 2013年 jz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface JZStory : NSManagedObject

@property (nonatomic, retain) NSNumber * isDownload;
@property (nonatomic, retain) NSNumber * isOver;
@property (nonatomic, retain) NSString * lastName;
@property (nonatomic, retain) NSString * lastUpdateTime;
@property (nonatomic, retain) NSString * storyAuthor;
@property (nonatomic, retain) NSString * storyBookPath;
@property (nonatomic, retain) NSNumber * storyId;
@property (nonatomic, retain) NSString * storyImagePath;
@property (nonatomic, retain) NSString * storyName;
@property (nonatomic, retain) NSString * storyRemark;
@property (nonatomic, retain) NSString * storyWebPath;
@property (nonatomic, retain) NSNumber * totalNum;
@property (nonatomic, retain) NSNumber * lastReadId;
@property (nonatomic, retain) NSString * lastReadTime;
@property (nonatomic, retain) NSArray * dicList;
@end
