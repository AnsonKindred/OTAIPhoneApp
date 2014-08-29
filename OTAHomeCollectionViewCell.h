//
//  OTAHomeCollectionViewCell.h
//  Off The Ave
//
//  Created by Zeb Long on 11/13/12.
//  Copyright (c) 2012 North Avenue Studios. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OTAHomeCollectionViewCell : UICollectionViewCell {
    IBOutlet UILabel *iconLabel;
    IBOutlet UIImageView *iconImage;
}

@property (strong) IBOutlet UILabel* iconLabel;
@property (strong) IBOutlet UIImageView* iconImage;

@end
