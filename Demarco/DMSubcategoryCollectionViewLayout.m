//
//  DMSubcategoryCollectionViewLayout.m
//  Demarco
//
//  Created by Harris Tang on 3/13/14.
//  Copyright (c) 2014 Harris Tang. All rights reserved.
//

#import "DMSubcategoryCollectionViewLayout.h"

@implementation DMSubcategoryCollectionViewLayout

- (id)init {

    self = [super init];

    if(self) {
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
            // iPad-specific interface here
            self.sectionInset = UIEdgeInsetsMake(0, 50, 0, 50);
        }
        else
        {
            self.sectionInset = UIEdgeInsetsMake(0, 15, 0, 15);
        }
        
        
        

        self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    }
    
    return self;
}

@end
