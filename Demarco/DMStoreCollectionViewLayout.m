//
//  DMStoreCollectionViewLayout.m
//  Demarco
//
//  Created by Harris Tang on 5/4/14.
//  Copyright (c) 2014 Harris Tang. All rights reserved.
//

#import "DMStoreCollectionViewLayout.h"

@implementation DMStoreCollectionViewLayout

- (id)init {
    
    self = [super init];
    
    if(self) {
        self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
            // iPad-specific interface here
            self.sectionInset = UIEdgeInsetsMake(0, 50 , 0, 50);
        }
        else
        {
            // iPhone-specific interface here
            self.sectionInset = UIEdgeInsetsMake(0, 15, 0, 15);
        }
        
        self.minimumLineSpacing = 10;
        self.minimumInteritemSpacing = 10;
    }
    
    return self;
}

@end
