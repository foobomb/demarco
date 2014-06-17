//
//  DMSubcategoryCollectionViewCell.m
//  Demarco
//
//  Created by Harris Tang on 3/13/14.
//  Copyright (c) 2014 Harris Tang. All rights reserved.
//

#import "DMSubcategoryCollectionViewCell.h"



@implementation DMSubcategoryCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        // iPad-specific interface here
        if(self.isSelected) {
            self.layer.borderColor = [UIColor colorWithRed:0.047 green:0.286 blue:0.322 alpha:1].CGColor;
            self.layer.borderWidth = 4.0f;
        } else {
            self.layer.borderColor = nil;
            self.layer.borderWidth = 0.0;
        }
    }
    else
    {

        if(self.isSelected) {
            self.layer.borderColor = [UIColor colorWithRed:0.047 green:0.286 blue:0.322 alpha:1].CGColor;
            self.layer.borderWidth = 2.0f;
        } else {
            self.layer.borderColor = nil;
            self.layer.borderWidth = 0.0;
        }
    }
    
}


@end
