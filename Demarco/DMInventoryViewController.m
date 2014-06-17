//
//  DMInventoryViewController.m
//  Demarco
//
//  Created by Harris Tang on 3/13/14.
//  Copyright (c) 2014 Harris Tang. All rights reserved.
//

#import "DMInventoryViewController.h"
#import "DMSubcategoryCollectionViewLayout.h"
#import "DMRingCollectionViewLayout.h"
#import "DMSubcategoryCollectionViewCell.h"
#import "DMRingCollectionViewCell.h"
#import "DMInventoryDetailViewController.h"
#import "DMImageStore.h"

@interface DMInventoryViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@end

@implementation DMInventoryViewController

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
    
    // set title
    self.inventoryTitleLabel.text = [self.inventoryTitle uppercaseString];

    // set the initial subcategory
    if(self.subCategories) {
        self.selectedSubcategory = self.subCategories[0];
    } else {
        
        // reposition ring collection view if there are no categories
        self.subcategoryCollectionView.hidden = true;
        CGRect ringCollectionViewFrame = [self.ringCollectionView frame];
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
            // iPad-specific interface here
            ringCollectionViewFrame.origin.y = 150;
        }
        else
        {
            // iPhone-specific interface here
            ringCollectionViewFrame.origin.y = 70;
        }
        
        [self.ringCollectionView setFrame:ringCollectionViewFrame];
    }
    
    // request inventory items from JSON Data Source
    [self fetchInventory];
    
    // initialize collection view cells
    UINib *subcategoryCell = [UINib nibWithNibName:@"DMSubcategoryCollectionViewCell" bundle:nil];
    [self.subcategoryCollectionView registerNib:subcategoryCell forCellWithReuseIdentifier:@"subcategoryCell"];
    self.subcategoryCollectionView.collectionViewLayout = [[DMSubcategoryCollectionViewLayout alloc]init];

    self.subcategoryCollectionView.showsHorizontalScrollIndicator = false;
    
    UINib *ringCell = [UINib nibWithNibName:@"DMRingCollectionViewCell" bundle:nil];
    [self.ringCollectionView registerNib:ringCell forCellWithReuseIdentifier:@"ringCell"];
    self.ringCollectionView.collectionViewLayout = [[DMRingCollectionViewLayout alloc]init];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskLandscape;
}


#pragma mark - Actions
- (IBAction)backHome:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UICollectionView Data Source

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if(collectionView == self.subcategoryCollectionView) {
        return [self.subCategories count];
    } else if(collectionView == self.ringCollectionView) {
        return [self.selectedInventoryItems count];
    }
    
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(collectionView == self.subcategoryCollectionView) {
        
        DMSubcategoryCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"subcategoryCell" forIndexPath:indexPath];
        
        if([[self.subCategories[indexPath.row] uppercaseString] isEqualToString:[self.selectedSubcategory uppercaseString]]) {
            cell.isSelected = true;
        } else {
            cell.isSelected = false;
        }

        cell.subcategoryTitle.text = [self.subCategories[indexPath.row] uppercaseString];
        [cell setNeedsDisplay];
        return cell;
        
    } else if(collectionView == self.ringCollectionView) {
        
        DMRingCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ringCell" forIndexPath:indexPath];
        
        cell.ringInfo = self.selectedInventoryItems[indexPath.row];
        
        // async get the image from cache (or from url if not cached yet)
//        cell.alpha = 0.0f;
        cell.ringImageView.alpha = 0.0f;
        cell.activityIndicator.hidden = NO;
        [cell.activityIndicator startAnimating];

        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

            UIImage *ringImage = [[DMImageStore sharedStore] imageForKey:[cell.ringInfo objectForKey:@"pictureURL"]];
            
            // completion block
            dispatch_sync(dispatch_get_main_queue(), ^{
                [cell.activityIndicator stopAnimating];
                cell.activityIndicator.hidden = YES;
                [cell.ringImageView setImage:ringImage];
                [cell setNeedsDisplay];
                [UIView beginAnimations:nil context:NULL];
                [UIView setAnimationDuration:0.1f];

                cell.ringImageView.alpha = 1.0f;
                [UIView commitAnimations];
            });
        });
        
        return cell;
    }
    
    return nil;
}

#pragma mark - UICollectionView Delegate Methods

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(collectionView == self.subcategoryCollectionView) {
        
        DMSubcategoryCollectionViewCell* cell = (DMSubcategoryCollectionViewCell*)[self.subcategoryCollectionView cellForItemAtIndexPath:indexPath];
        self.selectedSubcategory = cell.subcategoryTitle.text;

        [self.subcategoryCollectionView scrollToItemAtIndexPath:indexPath
                               atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally
                                       animated:YES];
        
        [self.subcategoryCollectionView reloadData];
        
        [self fetchInventory];
        
        
        
    } else if(collectionView == self.ringCollectionView) {

        DMRingCollectionViewCell* cell = (DMRingCollectionViewCell*)[self.ringCollectionView cellForItemAtIndexPath:indexPath];
        DMInventoryDetailViewController *inventoryDetailVC = [[DMInventoryDetailViewController alloc] init];
        
        inventoryDetailVC.ringInfo = cell.ringInfo;
        [inventoryDetailVC.view setNeedsDisplay];
        
        [self.navigationController pushViewController:inventoryDetailVC animated:YES];

    }
}

#pragma mark - UICollectionView Delegate Flow Layout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(collectionView == self.subcategoryCollectionView) {
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
            // iPad-specific interface here
            return CGSizeMake(400, 100);
        }
        else
        {
            return CGSizeMake(200, 44);
        }
        
    } else if(collectionView == self.ringCollectionView) {
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
            // iPad-specific interface here
            return CGSizeMake(300, 300);
        }
        else
        {
        return CGSizeMake(200, 200);
        }
        
    }

    return CGSizeMake(0, 0);
}

#pragma mark - Helper methods
//
//- (void)showInventoryDetails:(id)sender event:(id)event
//{
//
//    DMRingCollectionViewCell* cell = (DMRingCollectionViewCell*) [[[sender superview] superview] superview];
//    
//    DMInventoryDetailViewController *inventoryDetailVC = [[DMInventoryDetailViewController alloc] init];
//
//    inventoryDetailVC.ringInfo = cell.ringInfo;
//    [inventoryDetailVC.view setNeedsDisplay];
//    // load inventoryDetail with ring details
//    // rings[indexpath.row]...
//    
//    [self.navigationController pushViewController:inventoryDetailVC animated:YES];
//
//}

- (void) setSelectedInventoryItems {
    
    // initialize mutable array
    if(!self.selectedInventoryItems) {
        self.selectedInventoryItems = [[NSMutableArray alloc]init];
    } else {
        [self.selectedInventoryItems removeAllObjects];
    }
    
    self.selectedInventoryItems = [self.inventoryItems mutableCopy];

    [self.ringCollectionView reloadData];
    
}

#pragma mark - Demarco Data Source

- (void) fetchInventory {
    self.ringCollectionView.hidden = true;
    [self.ringCollectionView setContentOffset:CGPointZero animated:NO];
    
    // retrieve categories from site
    NSString *path = [[NSBundle mainBundle] pathForResource:@"DemarcoDataSource" ofType:@"plist"];
    NSDictionary *demarcoData = [[NSDictionary alloc] initWithContentsOfFile:path];
    
    NSString *url = [NSString stringWithFormat:@"%@?category=%@", [demarcoData objectForKey:@"Products"], self.selectedCategory];
    
    if(self.selectedSubcategory) {
        url = [url stringByAppendingString:[NSString stringWithFormat:@"&subcategory=%@", self.selectedSubcategory]];
    }
    
    url  = [url stringByAddingPercentEncodingWithAllowedCharacters:NSCharacterSet.URLQueryAllowedCharacterSet];
    
    NSURL *inventoryUrl = [NSURL URLWithString:url];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData* data = [NSData dataWithContentsOfURL: inventoryUrl];
        [self performSelectorOnMainThread:@selector(fetchedInventory:)
                               withObject:data
                            waitUntilDone:YES];
    });
    
}

- (void) fetchedInventory:(NSData *)responseData {
    
    self.ringCollectionView.hidden = false;
    NSError* error;
    self.inventoryItems = [NSJSONSerialization JSONObjectWithData:responseData
                                                      options:kNilOptions
                                                        error:&error];
    
    [self setSelectedInventoryItems];
}

@end
