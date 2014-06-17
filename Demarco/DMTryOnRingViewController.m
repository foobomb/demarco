//
//  DMTryOnRingViewController.m
//  Demarco
//
//  Created by Harris Tang on 5/22/14.
//  Copyright (c) 2014 Harris Tang. All rights reserved.
//

#import "DMTryOnRingViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "DMImageStore.h"
#import <QuartzCore/QuartzCore.h>

@interface DMTryOnRingViewController () <UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIImagePickerController *imagePicker;

@property (weak, nonatomic) IBOutlet UIImageView *handImageView;
@property (weak, nonatomic) IBOutlet UIImageView *ringImageView;
@property (weak, nonatomic) IBOutlet UIView *tryOnContainerView;
@property (strong, nonatomic) UIView *snapshotView;

@property (weak, nonatomic) IBOutlet UISegmentedControl *adjustmentSelector;

@end

@implementation DMTryOnRingViewController

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
    self.ringImageView.image = [[DMImageStore sharedStore] imageForKey:[self.ringInfo objectForKey:@"pngURL"]];
}

-(void)viewDidAppear:(BOOL)animated{

    if(!self.handImageView.image)
    {
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            
            UIActionSheet *photoTypeSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Camera", @"Photo Library", nil];
            
            [photoTypeSheet showInView:self.view];
        } else {
            [self openPhotoLibrary];
        }
        
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Touch Gestures

- (IBAction)pinchGesture:(UIPinchGestureRecognizer *)sender {
    
    CGFloat scale = sender.scale;
    if(self.adjustmentSelector.selectedSegmentIndex == 0) {
        self.ringImageView.transform = CGAffineTransformScale(self.ringImageView.transform, scale, scale);
    } else if (self.adjustmentSelector.selectedSegmentIndex == 1) {
        self.handImageView.transform = CGAffineTransformScale(self.handImageView.transform, scale, scale);
    }
    
    sender.scale = 1.0;

}


- (IBAction)rotationGesture:(UIRotationGestureRecognizer *)sender {
    
    if(self.adjustmentSelector.selectedSegmentIndex == 0) {
        self.ringImageView.transform = CGAffineTransformRotate(self.ringImageView.transform, sender.rotation);
    } else if (self.adjustmentSelector.selectedSegmentIndex == 1) {
        self.handImageView.transform = CGAffineTransformRotate(self.handImageView.transform, sender.rotation);
    }
    sender.rotation = 0;
    
}

- (IBAction)panGesture:(UIPanGestureRecognizer *)sender {

    CGPoint translation = [sender translationInView:self.view];
    if(self.adjustmentSelector.selectedSegmentIndex == 0) {
        CGPoint ringCenter = self.ringImageView.center;
        self.ringImageView.center = CGPointMake(ringCenter.x + translation.x, ringCenter.y + translation.y);
    } else if (self.adjustmentSelector.selectedSegmentIndex == 1) {
        CGPoint handCenter = self.handImageView.center;
        self.handImageView.center = CGPointMake(handCenter.x + translation.x, handCenter.y + translation.y);
    }
    [sender setTranslation:CGPointMake(0, 0) inView:self.view];
}


- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

#pragma mark - UIActionSheet delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [self openCamera];
    } else if (buttonIndex == 1) {
        [self openPhotoLibrary];
    } else if (buttonIndex == 2) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)actionSheetCancel:(UIActionSheet *)actionSheet
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)openCamera
{
    self.imagePicker = [[UIImagePickerController alloc]init];
    self.imagePicker.delegate = self;
    self.imagePicker.mediaTypes =[[NSArray alloc] initWithObjects: (NSString *) kUTTypeImage, nil];
    self.imagePicker.modalPresentationStyle = UIModalPresentationFullScreen;
    self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    
    [self presentViewController:self.imagePicker animated:YES completion:nil];
}

- (void)openPhotoLibrary
{
    self.imagePicker = [[UIImagePickerController alloc]init];
    self.imagePicker.delegate = self;
    self.imagePicker.mediaTypes =[[NSArray alloc] initWithObjects: (NSString *) kUTTypeImage, nil];
    self.imagePicker.modalPresentationStyle = UIModalPresentationFullScreen;
    self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:self.imagePicker animated:YES completion:nil];
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        // iPad-specific interface here
        return UIInterfaceOrientationMaskLandscape;
    }
    else
    {
        // iPhone-specific interface here
        return UIInterfaceOrientationMaskPortrait;
    }
}

#pragma mark - ImagePickerController Delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    self.handImageView.image = image;

    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)backToDetails:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)shareTryOn:(id)sender {
      
    UIGraphicsBeginImageContextWithOptions(self.tryOnContainerView.bounds.size, NO, 0.0);

    [self.tryOnContainerView drawViewHierarchyInRect:self.tryOnContainerView.bounds afterScreenUpdates:NO];

    UIImage *shareImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    NSString *productID = [self.ringInfo objectForKey:@"productID"];
    NSString *ringURLStr = [NSString stringWithFormat:@"http://www.demarcojewelry.com/details.php?products_id=%@", productID];
    NSURL *shareURL = [NSURL URLWithString:ringURLStr];
    
    NSString *styleID = [self.ringInfo objectForKey:@"styleNumber"];
    NSString *shareTitle = [NSString stringWithFormat:@"Demarco Jewelry - Style: %@", styleID];
    
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:@[shareTitle, shareImage, shareURL] applicationActivities:nil];
    [self presentViewController:activityVC animated:YES completion:nil];
    
}

@end












