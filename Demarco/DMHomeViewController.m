//
//  DMHomeViewController.m
//  Demarco
//
//  Created by Harris Tang on 3/11/14.
//  Copyright (c) 2014 Harris Tang. All rights reserved.
//

#import "DMHomeViewController.h"
#import "DMInventoryViewController.h"
#import "DMRingSizeViewController.h"
#import "DMTryOnViewController.h"
#import "DMStoresViewController.h"
#import "DMAboutViewController.h"
#import "DMRedCarpetViewController.h"

@interface DMHomeViewController ()

@property (weak, nonatomic) IBOutlet UIButton* bridalCollection;
@property (weak, nonatomic) IBOutlet UIButton* fineJewelry;
@property (weak, nonatomic) IBOutlet UIButton* gentsCollection;
@property (strong, nonatomic) NSDictionary* categories;

- (IBAction)browseCollection:(id)sender;
- (IBAction)showRingSizer:(id)sender;
- (IBAction)showTryOn:(id)sender;
- (IBAction)showAboutDemarco:(id)sender;
- (IBAction)showAuthorizedRetailers:(id)sender;

@end

@implementation DMHomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
 
        // retrieve categories from site
        NSString *path = [[NSBundle mainBundle] pathForResource:@"DemarcoDataSource" ofType:@"plist"];
        NSDictionary *demarcoData = [[NSDictionary alloc] initWithContentsOfFile:path];
        NSURL *categoriesUrl = [NSURL URLWithString: [demarcoData objectForKey:@"Categories"]];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSData* data = [NSData dataWithContentsOfURL: categoriesUrl];
            [self performSelectorOnMainThread:@selector(fetchedCategories:)
                                   withObject:data
                                waitUntilDone:YES];
        });
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
   
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)browseCollection:(id)sender {
    
    DMInventoryViewController *inventoryVC = [[DMInventoryViewController alloc]init];
    
    NSDictionary* inventoryCategory;
    NSString* category;
    
    if(sender == self.bridalCollection) {
        category = @"Bridal";
    } else if (sender == self.fineJewelry) {
        category = @"Fine Jewelry";
    } else if (sender == self.gentsCollection) {
        category = @"Gentlemens";
    }
    
    inventoryCategory = [self.categories objectForKey:category];
    
    inventoryVC.selectedCategory = category;
    inventoryVC.inventoryTitle = [inventoryCategory objectForKey:@"category"];
    inventoryVC.subCategories =  [inventoryCategory objectForKey:@"subcategories"];
    
    [self.navigationController pushViewController:inventoryVC animated:YES];
    
}

- (IBAction)showRingSizer:(id)sender {
    
    DMRingSizeViewController *ringSizeVC = [[DMRingSizeViewController alloc]init];
    
    [self.navigationController pushViewController:ringSizeVC animated:YES];
    
}

- (IBAction)showTryOn:(id)sender {
    
    DMTryOnViewController *tryOnVC = [[DMTryOnViewController alloc]init];
    [self.navigationController pushViewController:tryOnVC animated:YES];

}

- (IBAction)showAboutDemarco:(id)sender {

    DMAboutViewController *aboutVC = [[DMAboutViewController alloc]init];
    [self.navigationController pushViewController:aboutVC animated:YES];
}

- (IBAction)showAuthorizedRetailers:(id)sender {
    
    DMStoresViewController *storesVC = [[DMStoresViewController alloc]init];
    [self.navigationController pushViewController:storesVC animated:YES];
    
}

- (IBAction)showRedCarpet:(id)sender {

    DMRedCarpetViewController *redCarpetVC = [[DMRedCarpetViewController alloc]init];
    [self.navigationController pushViewController:redCarpetVC animated:YES];

}

#pragma mark - Demarco Data Source

- (void) fetchedCategories:(NSData *)responseData {

    NSError* error;
    self.categories = [NSJSONSerialization JSONObjectWithData:responseData
                                                         options:kNilOptions
                                                           error:&error];
}

@end
