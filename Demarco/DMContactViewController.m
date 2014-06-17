//
//  DMContactViewController.m
//  Demarco
//
//  Created by Harris Tang on 5/4/14.
//  Copyright (c) 2014 Harris Tang. All rights reserved.
//

#import "DMContactViewController.h"
#import "DMImageStore.h"
#import <QuartzCore/QuartzCore.h>

@interface DMContactViewController () <UITextFieldDelegate, UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *styleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *ringImageView;
@property (weak, nonatomic) IBOutlet UITextField *firstNameField;
@property (weak, nonatomic) IBOutlet UITextField *lastNameField;
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UITextField *phoneField;
@property (weak, nonatomic) IBOutlet UITextField *postalCodeField;
@property (weak, nonatomic) IBOutlet UITextView *customerNotesField;
@property (weak, nonatomic) IBOutlet UIScrollView *formScrollView;

@end

@implementation DMContactViewController

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
    
    self.styleLabel.text = [NSString stringWithFormat:@"STYLE: %@", [self.ringInfo objectForKey:@"styleNumber"]];
    
    self.ringImageView.image = [[DMImageStore sharedStore] imageForKey:[self.ringInfo objectForKey:@"pictureURL"]];
    
    // removes padding from textview
    self.customerNotesField.textContainer.lineFragmentPadding = 0;
    self.customerNotesField.textContainerInset = UIEdgeInsetsZero;
    
    //To make the border look very close to a UITextField
    [self.customerNotesField.layer setBorderColor:[[[UIColor lightGrayColor] colorWithAlphaComponent:0.5] CGColor]];
    [self.customerNotesField.layer setBorderWidth:0.5];
    
    //The rounded corner part, where you specify your view's corner radius:
    self.customerNotesField.layer.cornerRadius = 5;
    self.customerNotesField.clipsToBounds = YES;

    [self.formScrollView setContentSize:CGSizeMake(self.formScrollView.frame.size.width, self.formScrollView.frame.size.height + 100)];
    
    [self.formScrollView scrollRectToVisible:self.firstNameField.frame animated:NO];
    
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
- (IBAction)submitInquiry:(id)sender {
    
    NSString *postURLstr = @"http://www.demarcojewelry.com/complete-app.php";
    NSURL *postURL = [NSURL URLWithString:postURLstr];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:postURL];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];

    NSError *JSONerror;
    NSMutableDictionary *formDictionary = [[NSMutableDictionary alloc]init];
    [formDictionary setObject:self.firstNameField.text forKey:@"firstname"];
    [formDictionary setObject:self.lastNameField.text forKey:@"lastname"];
    [formDictionary setObject:self.emailField.text forKey:@"email"];
    [formDictionary setObject:self.phoneField.text forKey:@"phone"];
    [formDictionary setObject:self.postalCodeField.text forKey:@"postal_code"];
    [formDictionary setObject:self.customerNotesField.text forKey:@"customer_notes"];
    
    NSString *productID = [self.ringInfo objectForKey:@"productID"];
    [formDictionary setObject:productID forKey:@"product_id"];
    
    NSData *formData = [NSJSONSerialization dataWithJSONObject:formDictionary options:0 error:&JSONerror];
    [request setHTTPBody:formData];
    
    NSError *error;
    NSURLResponse *response;
    [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];

    if(!error) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Demarco Inquiry" message: @"Thank You! Your inquiry has been recieved." delegate: nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Demarco Inquiry" message: @"ERROR! Sorry, your inquiry could not be completed at this time." delegate: nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}

#pragma mark - hide keyboard on touch away
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}



- (void)textFieldDidBeginEditing:(UITextField *)textField {
//    NSLog(@"begin editing");
    [self.formScrollView setContentOffset:CGPointMake(0,textField.center.y-60) animated:YES];
//    //Keyboard becomes visible
    
//    [self.formScrollView scrollRectToVisible:textField.frame animated:YES];
//self.formScrollView.frame = CGRectMake(self.formScrollView.frame.origin.x,
//                                  self.formScrollView.frame.origin.y,
//                                  self.formScrollView.frame.size.width,
//                                  self.formScrollView.frame.size.height - 215 + 50);   //resize
    
    //self.formScrollView scrollRectToVisible:<#(CGRect)#> animated:YES;
    
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    NSLog(@"begin editing");
    [self.formScrollView setContentOffset:CGPointMake(0,textView.center.y-60) animated:YES];
}


@end
