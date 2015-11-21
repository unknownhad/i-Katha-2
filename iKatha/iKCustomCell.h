//
//  iKCustomCell.h
//  iKatha
//
//  Created by M on 13/08/15.
//  Copyright (c) 2015 Boove Software. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface iKCustomCell : UITableViewCell
{
    
}

@property(weak,nonatomic)IBOutlet UILabel *lblName;
@property(weak,nonatomic)IBOutlet UIButton *btnEdit;
@property(weak,nonatomic)IBOutlet UIButton *btnDelete;


@end
