//
//  DMInventoryDetailViewController.m
//  Demarco
//
//  Created by Harris Tang on 3/14/14.
//  Copyright (c) 2014 Harris Tang. All rights reserved.
//

#import "DMInventoryDetailViewController.h"
#import "DMContactViewController.h"
#import "DMImageStore.h"
#import "DMTryRingInstructionsViewController.h"

@interface DMInventoryDetailViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *ringImageView;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;
@property (weak, nonatomic) IBOutlet UILabel *styleLabel;

@property (weak, nonatomic) IBOutlet UISegmentedControl *ringOptionsSegmentedControl;
@end

@implementation DMInventoryDetailViewController

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

    self.ringImageView.image = [[DMImageStore sharedStore] imageForKey:[self.ringInfo objectForKey:@"pictureURL"]];

    // removes tab from description "\t"
    NSString * descriptionString = [self.ringInfo objectForKey:@"description"];
    descriptionString = [descriptionString stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    
    self.descriptionTextView.text = descriptionString;
    
    // removes padding from textview
    self.descriptionTextView.textContainer.lineFragmentPadding = 0;
    self.descriptionTextView.textContainerInset = UIEdgeInsetsZero;
    
    self.styleLabel.text = [NSString stringWithFormat:@"STYLE: %@", [self.ringInfo objectForKey:@"styleNumber"]];

    [self.ringOptionsSegmentedControl setSelectedSegmentIndex:UISegmentedControlNoSegment];
    
    NSString *pngURL = [self.ringInfo objectForKey:@"pngURL"];
    
    if([pngURL length] == 0) {
        [self.ringOptionsSegmentedControl removeSegmentAtIndex:2 animated:NO];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskLandscape;
}

- (IBAction)backToInventory:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)selectOption:(id)sender {
    
    int index = (int) self.ringOptionsSegmentedControl.selectedSegmentIndex;

    if(index == 0) {

        NSString *productID = [self.ringInfo objectForKey:@"productID"];
        NSString *ringURLStr = [NSString stringWithFormat:@"http://www.demarcojewelry.com/details.php?products_id=%@", productID];
        NSURL *shareURL = [NSURL URLWithString:ringURLStr];
        
        UIImage *shareImage = self.ringImageView.image;
        
        NSString *styleID = [self.ringInfo objectForKey:@"styleNumber"];
        NSString *shareTitle = [NSString stringWithFormat:@"Demarco Jewelry - Style: %@", styleID];
        
        UIActivityViewController *activityVC = [[UIActivityViewController alloc]initWithActivityItems:@[shareTitle, shareImage,shareURL] applicationActivities:nil];
        [activityVC setValue:shareTitle forKeyPath:@"subject"];
        
        [self presentViewController:activityVC animated:YES completion:nil];
        
    } else if(index == 1) {

        DMContactViewController *contactVC = [[DMContactViewController alloc]init];
        contactVC.ringInfo = self.ringInfo;
        [self.navigationController pushViewController:contactVC animated:YES];
        
    } else if(index == 2) {
        
        DMTryRingInstructionsViewController *instructionsVC = [[DMTryRingInstructionsViewController alloc]init];
        
        instructionsVC.ringInfo = self.ringInfo;
        [self.navigationController pushViewController:instructionsVC animated:YES];
        
    }
    
    [self.ringOptionsSegmentedControl setSelectedSegmentIndex:UISegmentedControlNoSegment];
    
}

@end
