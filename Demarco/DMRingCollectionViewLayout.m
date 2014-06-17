//
//  DMRingCollectionViewLayout.m
//  Demarco
//
//  Created by Harris Tang on 3/13/14.
//  Copyright (c) 2014 Harris Tang. All rights reserved.
//

#import "DMRingCollectionViewLayout.h"

@implementation DMRingCollectionViewLayout

- (id)init {

    self = [super init];
    
    if(self) {
        
        self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        self.sectionInset = UIEdgeInsetsMake(0, 15, 0, 15);
        self.minimumLineSpacing = 20;
        self.minimumInteritemSpacing = 20;
        
    }
    
    return self;
}

@end
