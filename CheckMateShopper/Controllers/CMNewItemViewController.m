//
//  CMNewItemViewController.m
//  CheckMateShopper
//
//  Created by Michael Enriquez on 2/13/13.
//  Copyright (c) 2013 Mike Enriquez. All rights reserved.
//

#import "CMNewItemViewController.h"

@interface CMNewItemViewController ()

@end

@implementation CMNewItemViewController

#pragma mark UIVIewController

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    _context = nil;
}

#pragma mark IBActions

- (IBAction)save:(id)sender {
    NSString *itemName     = self.nameTextField.text;
    NSString *categoryName = self.categoryTextField.text;

    if (itemName.length > 0 && categoryName.length > 0) {
        CMShopperHTTPClient *httpClient = [CMShopperHTTPClient sharedInstance];
        [httpClient createItemWithName:itemName category:categoryName onComplete:^(NSDictionary *item, NSError *error) {
            if (error) {
                NSLog(@"TODO: alert");
            } else {
                [self dismissViewControllerAnimated:YES completion:nil];
            }
        }];
    } else {
        NSLog(@"TODO: alert");
    }
}

- (IBAction)cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
