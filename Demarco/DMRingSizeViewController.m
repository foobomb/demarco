//
//  DMRingSizeViewController.m
//  Demarco
//
//  Created by Harris Tang on 3/16/14.
//  Copyright (c) 2014 Harris Tang. All rights reserved.
//

#import "DMRingSizeViewController.h"
#import "DMRingSizeCollectionView.h"
#import "DMRingSizeCollectionViewCell.h"
#import "DMRingSizeCollectionViewFlowLayout.h"
#import "DMSizedCircleView.h"
@interface DMRingSizeViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *selectedRingSizeView;

@property (weak, nonatomic) IBOutlet DMRingSizeCollectionView *ringSizeCollectionView;
@property (weak, nonatomic) IBOutlet DMSizedCircleView *sizedCircleView;
@property (weak, nonatomic) IBOutlet UILabel *ringSizeLabel;

- (IBAction)backHome:(id)sender;

@end

@implementation DMRingSizeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.ringSizeCollectionView registerClass:[DMRingSizeCollectionViewCell class] forCellWithReuseIdentifier:@"RingSizeCell"];
    
    self.ringSizeCollectionView.collectionViewLayout = [[DMRingSizeCollectionViewFlowLayout alloc]init];
    self.ringSizeCollectionView.dataSource = self;
    self.ringSizeCollectionView.delegate = self;
    
    self.selectedRingSizeView.layer.borderColor = [UIColor colorWithRed:0.047 green:0.286 blue:0.322 alpha:1].CGColor;
    self.selectedRingSizeView.layer.borderWidth = 6.0f;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSIndexPath *path = [NSIndexPath indexPathForItem:14 inSection:0];
    
    [self.ringSizeCollectionView scrollToItemAtIndexPath:path atScrollPosition:UICollectionViewScrollPositionCenteredVertically animated:NO];
    
    [self setRingSize:@"7"];
}

- (NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskLandscape;
}


#pragma mark - UICollectionView datasource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 30;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    DMRingSizeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"RingSizeCell" forIndexPath:indexPath];
    
    float ringSize = indexPath.row * .5;
    
    cell.label.text = [[NSNumber numberWithFloat:ringSize] stringValue];
    
    return cell;

}

#pragma mark - UICollectionView delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self setSelectedRing];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self setSelectedRing];
}

- (IBAction)backHome:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


- (void) setSelectedRing
{
    CGPoint center;
    
    center.x = 108 /2;
    center.y = self.ringSizeCollectionView.center.y + self.ringSizeCollectionView.contentOffset.y;
    
    NSIndexPath *path = [self.ringSizeCollectionView indexPathForItemAtPoint:center];
    if(path) {
        DMRingSizeCollectionViewCell *cell = (DMRingSizeCollectionViewCell *)[self.ringSizeCollectionView cellForItemAtIndexPath:path];
        [self setRingSize: cell.label.text];
    }

}

- (void) setRingSize:(NSString *)size
{
    self.ringSizeLabel.text = [NSString stringWithFormat:@"%@", size];
    self.sizedCircleView.ringSize = [size floatValue];
    [self.sizedCircleView setNeedsDisplay];
}
@end
