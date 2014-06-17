//
//  DMRedCarpetDetailViewController.m
//  Demarco
//
//  Created by Harris Tang on 5/10/14.
//  Copyright (c) 2014 Harris Tang. All rights reserved.
//

#import "DMRedCarpetDetailViewController.h"
#import "DMImageStore.h"

@interface DMRedCarpetDetailViewController ()
@property (weak, nonatomic) IBOutlet UITextView *titleTextView;

@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;
@property (weak, nonatomic) IBOutlet UIImageView *largePhotoImageView;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@end

@implementation DMRedCarpetDetailViewController

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
    
    self.largePhotoImageView.image = [[DMImageStore sharedStore] imageForKey:[self.itemInfo objectForKey:@"Large Photo"]];

    self.titleTextView.text = [self.itemInfo objectForKey:@"Title"];
    // removes padding from textview
    self.titleTextView.textContainer.lineFragmentPadding = 0;
    self.titleTextView.textContainerInset = UIEdgeInsetsZero;
    
    // removes tab from description "\t"
    NSString * descriptionString = [self.itemInfo objectForKey:@"Description"];
    descriptionString = [descriptionString stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    
    self.descriptionTextView.text = descriptionString;
    
    // removes padding from textview
    self.descriptionTextView.textContainer.lineFragmentPadding = 0;
    self.descriptionTextView.textContainerInset = UIEdgeInsetsZero;
    
    
    NSString *dateStr = [self.itemInfo objectForKey:@"Date"];
    
    // Convert string to date object
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [dateFormat dateFromString:dateStr];
    
    // Convert date object to desired output format
    [dateFormat setDateFormat:@"EEEE MMMM d, YYYY"];
    dateStr = [dateFormat stringFromDate:date];
    
    self.dateLabel.text = dateStr;
    

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)closeDetails:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
