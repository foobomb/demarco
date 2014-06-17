//
//  DMStoreCollectionViewCell.m
//  Demarco
//
//  Created by Harris Tang on 5/4/14.
//  Copyright (c) 2014 Harris Tang. All rights reserved.
//

#import "DMStoreCollectionViewCell.h"

@interface DMStoreCollectionViewCell() <UIAlertViewDelegate>

@end

@implementation DMStoreCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (IBAction)callStore:(id)sender {
    
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"tel:+11111"]]) {
    
        NSString *phoneNumber = (NSString *) [self.storeInfo objectForKey:@"Store Phone"];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Call Store"
                                                        message:[NSString stringWithFormat:@"Dial %@?", phoneNumber]
                                                       delegate:self
                                              cancelButtonTitle:@"No"
                                              otherButtonTitles:@"Yes", nil];
        [alert show];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Phone Not Found"
                                                        message:@"Phone features are not available on this device."
                                                       delegate:self
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"OK", nil];
        [alert show];
    }

}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([alertView.title isEqualToString:@"Call Store"]) {
        
        if(buttonIndex == 1) {
            
            NSString *phoneNumber = (NSString *) [self.storeInfo objectForKey:@"Store Phone"];
            
            //trim whitespace
            phoneNumber =[[phoneNumber componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] componentsJoinedByString:@""];
            
            NSString *phoneURLString = [NSString stringWithFormat:@"tel:%@", phoneNumber];
            NSURL *phoneURL = [NSURL URLWithString:phoneURLString];
            [[UIApplication sharedApplication] openURL:phoneURL];
        }
        
    } else if([alertView.title isEqualToString:@"View Map"]) {
        
        if(buttonIndex == 1) {
        
            NSString* address = [NSString stringWithFormat:@"%@ %@",self.storeAddressLabel.text, self.storeCityLabel.text];
            //URL ENCODE STRING
            address =  [address stringByAddingPercentEscapesUsingEncoding: NSASCIIStringEncoding];
            
            NSString* urlText = [NSString stringWithFormat:@"http://maps.apple.com/?q=%@", address];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlText]];
        }
    }
}

- (IBAction)viewMap:(id)sender {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"View Map"
                                                    message:[NSString stringWithFormat:@"Open in Maps App?"]
                                                   delegate:self
                                          cancelButtonTitle:@"No"
                                          otherButtonTitles:@"Yes", nil];
    [alert show];
   
}

@end
