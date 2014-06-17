//
//  DMSubcategoryCollectionViewCell.h
//  Demarco
//
//  Created by Harris Tang on 3/13/14.
//  Copyright (c) 2014 Harris Tang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DMSubcategoryCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *subcategoryTitle;
@property (assign, nonatomic) BOOL isSelected;

@end
