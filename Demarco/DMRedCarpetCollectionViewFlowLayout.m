//
//  DMRedCarpetCollectionViewFlowLayout.m
//  Demarco
//
//  Created by Harris Tang on 5/10/14.
//  Copyright (c) 2014 Harris Tang. All rights reserved.
//

#import "DMRedCarpetCollectionViewFlowLayout.h"

@implementation DMRedCarpetCollectionViewFlowLayout


- (id)init {
    
    self = [super init];
    
    if(self) {
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
            // iPad-specific interface here
            self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
            self.sectionInset = UIEdgeInsetsMake(0, 50, 0, 50);
            self.minimumLineSpacing = 50;
            self.minimumInteritemSpacing = 50;
        }
        else
        {
            // iPhone-specific interface here
            self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
            self.sectionInset = UIEdgeInsetsMake(0, 15, 0, 15);
            self.minimumLineSpacing = 15;
            self.minimumInteritemSpacing = 15;
        }
        
        
        
    }
    
    return self;
    
}
@end
