//
//  DMRedCarpetViewController.m
//  Demarco
//
//  Created by Harris Tang on 5/20/14.
//  Copyright (c) 2014 Harris Tang. All rights reserved.
//

#import "DMRedCarpetViewController.h"
#import "DMRedCarpetCollectionView.h"
#import "DMRedCarpetCollectionViewCell.h"
#import "DMRedCarpetCollectionViewFlowLayout.h"
#import "DMRedCarpetDetailViewController.h"
#import "DMImageStore.h"

@interface DMRedCarpetViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>


@property (weak, nonatomic) IBOutlet DMRedCarpetCollectionView *redCarpetCollectionView;
@property (strong, nonatomic) NSArray* redCarpetItems;

@end

@implementation DMRedCarpetViewController

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

    // Do any additional setup after loading the view from its nib.
    
    [self fetchItems];
    
    UINib *rcCell = [UINib nibWithNibName:@"DMRedCarpetCollectionViewCell" bundle:nil];
    [self.redCarpetCollectionView registerNib:rcCell forCellWithReuseIdentifier:@"rcCell"];
    self.redCarpetCollectionView.collectionViewLayout = [[DMRedCarpetCollectionViewFlowLayout alloc]init];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    if(self.redCarpetItems) {
        return [self.redCarpetItems count];
    }

    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    DMRedCarpetCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"rcCell" forIndexPath:indexPath];
    
    // async get the image from cache (or from url if not cached yet)
    cell.photoImageView.alpha = 0.0f;
    cell.itemInfo = self.redCarpetItems[indexPath.row];
    cell.titleTextView.text = [cell.itemInfo objectForKey:@"Title"];
    cell.activityIndicator.hidden = NO;
    [cell.activityIndicator startAnimating];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        UIImage *photoImage = [[DMImageStore sharedStore] imageForKey:[cell.itemInfo objectForKey:@"Photo"]];
        
        // completion block
        dispatch_sync(dispatch_get_main_queue(), ^{
            [cell.activityIndicator stopAnimating];
            cell.activityIndicator.hidden = YES;
            [cell.photoImageView setImage:photoImage];

            [cell setNeedsDisplay];
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:0.1f];
            
            cell.photoImageView.alpha = 1.0f;
            [UIView commitAnimations];
        });
    });
    
    return cell;

}

#pragma mark - UICollectionView Delegate Methods

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    DMRedCarpetCollectionViewCell* cell = (DMRedCarpetCollectionViewCell*)[self.redCarpetCollectionView cellForItemAtIndexPath:indexPath];
    DMRedCarpetDetailViewController *itemDetailVC = [[DMRedCarpetDetailViewController alloc] init];
    
    itemDetailVC.itemInfo = cell.itemInfo;
    [self.navigationController pushViewController:itemDetailVC animated:YES];
    
}

#pragma mark - UICollectionView Delegate Flow Layout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        // iPad-specific interface here
        return CGSizeMake(400, 500);
    }
    else
    {
        // iPhone-specific interface here
        return CGSizeMake(200, 250);
    }
    

}


#pragma mark - Demarco Data Source

- (void) fetchItems {
    self.redCarpetCollectionView.hidden = true;
    [self.redCarpetCollectionView setContentOffset:CGPointZero animated:NO];
    
    // retrieve categories from site
    NSString *path = [[NSBundle mainBundle] pathForResource:@"DemarcoDataSource" ofType:@"plist"];
    NSDictionary *demarcoData = [[NSDictionary alloc] initWithContentsOfFile:path];
    
    NSString *url = [demarcoData objectForKey:@"Red Carpet"];
    
    url  = [url stringByAddingPercentEncodingWithAllowedCharacters:NSCharacterSet.URLQueryAllowedCharacterSet];
    
    NSURL *itemUrl = [NSURL URLWithString:url];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData* data = [NSData dataWithContentsOfURL: itemUrl];
        [self performSelectorOnMainThread:@selector(didFetchItems:)
                               withObject:data
                            waitUntilDone:YES];
    });
    
}

- (void) didFetchItems:(NSData *)responseData {
    
    self.redCarpetCollectionView.hidden = false;
    NSError* error;
    
    if(!error) {
        self.redCarpetItems = [NSJSONSerialization JSONObjectWithData:responseData
                                                          options:kNilOptions
                                                            error:&error];
        [self.redCarpetCollectionView reloadData];
    }

}

@end
