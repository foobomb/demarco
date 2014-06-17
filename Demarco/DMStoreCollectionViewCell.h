//
//  DMStoreCollectionViewCell.h
//  Demarco
//
//  Created by Harris Tang on 5/4/14.
//  Copyright (c) 2014 Harris Tang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DMStoreCollectionViewCell : UICollectionViewCell

@property (strong, nonatomic) NSDictionary *storeInfo;
@property (weak, nonatomic) IBOutlet UILabel *storeNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *storeAddressLabel;

@property (weak, nonatomic) IBOutlet UILabel *storeCityLabel;
@property (weak, nonatomic) IBOutlet UILabel *storePhoneLabel;
@property (weak, nonatomic) IBOutlet UIButton *callButton;

@end

