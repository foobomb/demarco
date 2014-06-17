//
//  DMRingCollectionViewCell.h
//  Demarco
//
//  Created by Harris Tang on 3/13/14.
//  Copyright (c) 2014 Harris Tang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DMRingCollectionViewCell : UICollectionViewCell

@property (strong, nonatomic) NSDictionary* ringInfo;
@property (weak, nonatomic) IBOutlet UIImageView *ringImageView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end
