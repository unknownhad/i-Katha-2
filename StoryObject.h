//
//  StoryObject.h
//  iKatha
//
//  Created by M on 02/08/15.
//  Copyright (c) 2015 Boove Software. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StoryObject : NSObject

@property(strong,nonatomic)NSString *strTitle;
@property(strong,nonatomic)NSString *strText;
@property(nonatomic)int storyId;
@property(nonatomic)int numOfPages;
@property(nonatomic)int currentPage;
@property(strong,nonatomic)NSString *strDateCreated;
@property(strong,nonatomic)NSString *strDateEdited;
@property(strong,nonatomic)NSString *strAudioPath;
@property(strong,nonatomic)NSString *strImagePath;
@property(strong,nonatomic)NSMutableArray *arrAudioPaths;
@property(strong,nonatomic)NSMutableArray *arrImagePaths;
@property(strong,nonatomic)NSMutableArray *arrSentences;





@end
