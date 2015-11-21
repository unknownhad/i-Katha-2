//
//  iKCollectionViewController.h
//  iKatha
//
//  Created by Boove Software on 28/11/13.
//  Copyright (c) 2013 Boove Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iKDetailViewController.h"
#import "iKCollectionViewCell.h"

int muteSelected;

@interface iKCollectionViewController : UICollectionViewController <UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property(strong,nonatomic)IBOutlet UICollectionView *collectionView;
//UIBarPositioningDelegate>
@property (nonatomic) NSInteger numberOfStories;
//@property(nonatomic) int storyIndx;


@end
