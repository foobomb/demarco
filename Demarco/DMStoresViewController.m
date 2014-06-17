//
//  DMStoresViewController.m
//  Demarco
//
//  Created by Harris Tang on 5/4/14.
//  Copyright (c) 2014 Harris Tang. All rights reserved.
//

#import "DMStoresViewController.h"
#import "DMStoreCollectionView.h"
#import "DMStoreCollectionViewCell.h"
#import "DMStoreCollectionViewLayout.h"
#import <CoreLocation/CoreLocation.h>

@interface DMStoresViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *zipCodeField;
@property (weak, nonatomic) IBOutlet DMStoreCollectionView *storeCollectionView;
@property (strong, nonatomic) NSMutableArray *stores;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation *currentLocation;

@end

@implementation DMStoresViewController

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

    UINib *storeCell = [UINib nibWithNibName:@"DMStoreCollectionViewCell" bundle:nil];
    [self.storeCollectionView registerNib:storeCell forCellWithReuseIdentifier:@"storeCell"];
    self.storeCollectionView.collectionViewLayout = [[DMStoreCollectionViewLayout alloc]init];
    [self.storeCollectionView reloadData];
    [self findLocation];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskLandscape;
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)submitZipCode:(id)sender {
    
    [self.zipCodeField resignFirstResponder];
    
    if(self.zipCodeField.text.length >= 5) {
        [self fetchStores:self.zipCodeField.text];
    }
    
}

- (IBAction)findStoreByLocation:(id)sender {
    [self findLocation];
}

- (void) findLocation
{
    self.locationManager = [CLLocationManager new];
    self.locationManager.delegate = self;
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [self.locationManager startUpdatingLocation];
    
}


#pragma mark - hide keyboard on touch away
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

#pragma mark - location manager delegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    self.currentLocation = [locations objectAtIndex:0];
    [self.locationManager stopUpdatingLocation];
    
    CLGeocoder *geocoder = [[CLGeocoder alloc]init];
    [geocoder reverseGeocodeLocation:self.currentLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        
        if(!error) {
            CLPlacemark *placemark = [placemarks objectAtIndex:0];
            NSString *zipCode = [[NSString alloc] initWithString:placemark.postalCode];
            self.zipCodeField.text = zipCode;
            [self fetchStores:self.zipCodeField.text];
            self.currentLocation = nil;
        }
        
    }];
    
    
}


#pragma mark - Store Collection View Data Source

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if(self.stores) {
        return [self.stores count];
    }
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    DMStoreCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"storeCell" forIndexPath:indexPath];
    
    [self setupStoreCell:cell withStoreInfo:self.stores[indexPath.row]];
    
    return cell;
}

#pragma mark - Store Collection View Delegate Methods

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    // call and view map
}


#pragma mark - Store Collection View Delegate Flow Layout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        // iPad-specific interface here
        return CGSizeMake(500, 300);
    }
    else
    {
        // iPhone-specific interface here
        return CGSizeMake(300, 200);
    }

}

#pragma mark - Store Data Source

- (void) fetchStores:(NSString *)zipCode {
    
    self.storeCollectionView.hidden = true;
    
    [self.storeCollectionView setContentOffset:CGPointZero animated:NO];
    
    // retrieve stores from site
    NSString *path = [[NSBundle mainBundle] pathForResource:@"DemarcoDataSource" ofType:@"plist"];
    NSDictionary *demarcoData = [[NSDictionary alloc] initWithContentsOfFile:path];
    
    NSString *url = [NSString stringWithFormat:@"%@?zip=%@", [demarcoData objectForKey:@"Stores"], zipCode];
    
    url  = [url stringByAddingPercentEncodingWithAllowedCharacters:NSCharacterSet.URLQueryAllowedCharacterSet];
    
    NSURL *storesUrl = [NSURL URLWithString:url];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData* data = [NSData dataWithContentsOfURL: storesUrl];
        [self performSelectorOnMainThread:@selector(fetchedStores:)
                               withObject:data
                            waitUntilDone:YES];
    });

}

- (void) fetchedStores:(NSData *)responseData {
    
    if(!self.stores) {
        self.stores = [[NSMutableArray alloc] init];
    } else {
        [self.stores removeAllObjects];
    }
    
    self.storeCollectionView.hidden = false;

    NSError *error;
    
    NSArray *storeData = [NSJSONSerialization JSONObjectWithData:responseData
                                                          options:kNilOptions
                                                            error:&error];
    self.stores = [storeData mutableCopy];

    [self.storeCollectionView reloadData];

}

#pragma mark - helper methods

- (void) setupStoreCell:(DMStoreCollectionViewCell *) cell withStoreInfo: (NSDictionary *)storeInfo {

    NSString *name = [storeInfo objectForKey:@"Store Name"];
    NSString *address = [storeInfo objectForKey:@"Store Address"];
    NSString *city = [storeInfo objectForKey:@"Store City"];
    NSString *state = [storeInfo objectForKey:@"Store State"];
    NSString *zip = [storeInfo objectForKey:@"Store Zip"];
    NSString *phone = [storeInfo objectForKey:@"Store Phone"];

    cell.storeInfo = storeInfo;
    cell.storeNameLabel.text = name;
    cell.storeAddressLabel.text = address;
    cell.storeCityLabel.text = [NSString stringWithFormat:@"%@, %@ %@", city, state, zip];
    cell.storePhoneLabel.text = phone;
    
}


@end



















