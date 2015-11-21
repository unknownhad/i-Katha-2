//
//  iKCollectionViewCell.h
//  iKatha
//
//  Created by Boove Software on 28/11/13.
//  Copyright (c) 2013 Boove Software. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface iKCollectionViewCell : UICollectionViewCell
@property(weak,nonatomic)IBOutlet UIImageView *cellImageView;
@property(weak,nonatomic) IBOutlet UILabel *cellLabel;
@end
