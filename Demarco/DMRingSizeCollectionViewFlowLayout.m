//
//  DMRingSizeCollectionViewFlowLayout.m
//  Demarco
//
//  Created by Harris Tang on 3/18/14.
//  Copyright (c) 2014 Harris Tang. All rights reserved.
//

#import "DMRingSizeCollectionViewFlowLayout.h"

@implementation DMRingSizeCollectionViewFlowLayout


#define ACTIVE_DISTANCE 100
#define ZOOM_FACTOR 0.3

- (id)init
{
    self = [super init];
    if (self) {
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
            // iPad-specific interface here
            self.itemSize = CGSizeMake(80, 70);
            self.scrollDirection = UICollectionViewScrollDirectionVertical;
            self.sectionInset = UIEdgeInsetsMake(280, 0, 280, 0);
            self.minimumInteritemSpacing = 25;
            self.minimumLineSpacing = 25;
        }
        else
        {
            // iPhone-specific interface here
            self.itemSize = CGSizeMake(60, 50);
            self.scrollDirection = UICollectionViewScrollDirectionVertical;
            self.sectionInset = UIEdgeInsetsMake(140, 0, 140, 0);
            self.minimumInteritemSpacing = 25;
            self.minimumLineSpacing = 25;
        }
        
        
        
    }
    return self;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return  YES;
}

-(NSArray*)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSArray* array = [super layoutAttributesForElementsInRect:rect];
    CGRect visibleRect;
    visibleRect.origin = self.collectionView.contentOffset;
    visibleRect.size = self.collectionView.bounds.size;
    
    for (UICollectionViewLayoutAttributes* attributes in array) {
        if (CGRectIntersectsRect(attributes.frame, rect)) {
            CGFloat distance = CGRectGetMidY(visibleRect) - attributes.center.y;
            CGFloat normalizedDistance = distance / ACTIVE_DISTANCE;
            if (ABS(distance) < ACTIVE_DISTANCE) {
                CGFloat zoom = 1 + ZOOM_FACTOR*(1 - ABS(normalizedDistance));
                attributes.transform3D = CATransform3DMakeScale(zoom, zoom, 1.0);
                attributes.zIndex = 1;
            }
        }
    }
    return array;
}




// calculate the end position of the cell in the middle
- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity
{
    CGFloat offsetAdjustment = MAXFLOAT;
    CGFloat verticalCenter = proposedContentOffset.y + (CGRectGetHeight(self.collectionView.bounds) / 2.0);
    CGRect targetRect = CGRectMake(0.0, proposedContentOffset.y, self.collectionView.bounds.size.width, self.collectionView.bounds.size.height);
    
    NSArray* array = [super layoutAttributesForElementsInRect:targetRect];
    
    for (UICollectionViewLayoutAttributes* layoutAttributes in array) {
        
        CGFloat itemVerticalCenter = layoutAttributes.center.y;
        
        if (ABS(itemVerticalCenter - verticalCenter) < ABS(offsetAdjustment)) {
            offsetAdjustment = itemVerticalCenter - verticalCenter;
        }
    }

    return CGPointMake(proposedContentOffset.x, proposedContentOffset.y + offsetAdjustment);
}

@end
