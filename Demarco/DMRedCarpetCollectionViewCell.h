//
//  DMRedCarpetCollectionViewCell.h
//  Demarco
//
//  Created by Harris Tang on 5/10/14.
//  Copyright (c) 2014 Harris Tang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DMRedCarpetCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
@property (weak, nonatomic) IBOutlet UITextView *titleTextView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property NSDictionary *itemInfo;

@end
