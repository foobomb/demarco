//
//  DMTryOnViewController.m
//  Demarco
//
//  Created by Harris Tang on 3/19/14.
//  Copyright (c) 2014 Harris Tang. All rights reserved.
//

#import "DMTryOnViewController.h"

@interface DMTryOnViewController ()

@end

@implementation DMTryOnViewController

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

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)backHome:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskLandscape;
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
