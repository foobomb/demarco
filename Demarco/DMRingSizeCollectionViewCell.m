//
//  DMRingSizeCollectionViewCell.m
//  Demarco
//
//  Created by Harris Tang on 3/18/14.
//  Copyright (c) 2014 Harris Tang. All rights reserved.
//

#import "DMRingSizeCollectionViewCell.h"

@implementation DMRingSizeCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.label = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, frame.size.width, frame.size.height)];
        self.label.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
        self.label.textAlignment = NSTextAlignmentCenter;
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
            // iPad-specific interface here
            self.label.font = [UIFont fontWithName:@"Optima" size:30.0];
        }
        else
        {
            // iPhone-specific interface here
            self.label.font = [UIFont fontWithName:@"Optima" size:17.0];
        }

        
        
        self.backgroundColor = [UIColor whiteColor];
//        //self.label.backgroundColor = [UIColor underPageBackgroundColor];
//        //self.label.textColor = [UIColor blackColor];
        [self.contentView addSubview:self.label];;
        self.contentView.layer.borderWidth = 1.0f;
        self.contentView.layer.borderColor = [UIColor whiteColor].CGColor;
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
