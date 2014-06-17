//
//  DMInventoryViewController.h
//  Demarco
//
//  Created by Harris Tang on 3/13/14.
//  Copyright (c) 2014 Harris Tang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DMSubcategoryCollectionView.h"
#import "DMRingCollectionView.h"

@interface DMInventoryViewController : UIViewController

@property (weak, nonatomic) NSString *inventoryTitle;
@property (weak, nonatomic) NSMutableArray *subCategories;
@property (weak, nonatomic) IBOutlet UILabel *inventoryTitleLabel;
@property (strong, nonatomic) NSArray* inventoryItems;
@property (strong, nonatomic) NSString* selectedCategory;
@property (strong, nonatomic) NSString* selectedSubcategory;
@property (strong, nonatomic) NSMutableArray* selectedInventoryItems;

- (IBAction)backHome:(id)sender;
@property (weak, nonatomic) IBOutlet UICollectionView *subcategoryCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *ringCollectionView;

@end
