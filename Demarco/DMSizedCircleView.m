//
//  DMSizedCircleView.m
//  Demarco
//
//  Created by Harris Tang on 3/16/14.
//  Copyright (c) 2014 Harris Tang. All rights reserved.
//

#import "DMSizedCircleView.h"

#define DEFAULT_SIZE 100.0

@implementation DMSizedCircleView


- (id)init
{
    self = [super init];
    
    if(self) {
        self.circleDiameter = DEFAULT_SIZE;

    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if(self) {
        self.circleDiameter = DEFAULT_SIZE;
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    //    CGFloat sizeFactor = isPad() ? 2.099f : 2.6f;
  
    // (size 0 mm / points per mm) + ((mm increase per size * size) / points per mm)
    self.circleDiameter = (11.63 / 0.15) + ((0.8128 * self.ringSize) / 0.15);
    
    //    self.circleDiameter = 78.0f + 2.6f * (self.ringSize + 1);
    //float sizedCircleDiameter = sizeFactor * (size + 31);
    
    CGRect bounds = self.bounds;
    
    CGPoint center;
    center.x = bounds.origin.x + bounds.size.width / 2.0;
    center.y = bounds.origin.y + bounds.size.height / 2.0;
    
    float radius = self.circleDiameter / 2.0;
    
    UIBezierPath *path = [[UIBezierPath alloc]init];
    [path addArcWithCenter:center
                    radius:radius
                startAngle:0.0
                  endAngle:M_PI * 2.0
                 clockwise:YES];
    
    UIColor *fillColor = [UIColor whiteColor];
    [fillColor setFill];
    UIColor *strokeColor = [UIColor colorWithRed:0.047 green:0.286 blue:0.322 alpha:1];
    [path setLineWidth:2.0f];
    [strokeColor setStroke];
    [path closePath];
    [path fill];
    [path stroke];
    
}


@end
