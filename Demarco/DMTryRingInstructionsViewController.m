//
//  DMTryRingInstructionsViewController.m
//  Demarco
//
//  Created by Harris Tang on 5/21/14.
//  Copyright (c) 2014 Harris Tang. All rights reserved.
//

#import "DMTryRingInstructionsViewController.h"
#import "DMTryOnRingViewController.h"
@interface DMTryRingInstructionsViewController ()

@property (weak, nonatomic) IBOutlet UIButton *startTryRingButton;

@end

@implementation DMTryRingInstructionsViewController

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
    
    [self.startTryRingButton.layer setBorderColor:[[[UIColor colorWithRed:0.047 green:0.286 blue:0.322 alpha:1] colorWithAlphaComponent:0.5] CGColor]];
    [self.startTryRingButton.layer setBorderWidth:2.0];
    
    //The rounded corner part, where you specify your view's corner radius:
    self.startTryRingButton.layer.cornerRadius = 5;
    self.startTryRingButton.clipsToBounds = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)showPhotoPicker:(id)sender {
    
    DMTryOnRingViewController *tryOnRingVC = [[DMTryOnRingViewController alloc] init];
    tryOnRingVC.ringInfo = self.ringInfo;
    //[self.navigationController pushViewController:tryOnRingVC animated:YES];
    [self presentViewController:tryOnRingVC animated:YES completion:nil];
    
}
- (IBAction)backToDetails:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
