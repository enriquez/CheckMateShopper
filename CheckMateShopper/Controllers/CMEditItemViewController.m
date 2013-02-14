//
//  CMEditItemViewController.m
//  CheckMateShopper
//
//  Created by Michael Enriquez on 2/13/13.
//  Copyright (c) 2013 Mike Enriquez. All rights reserved.
//

#import "CMEditItemViewController.h"

@interface CMEditItemViewController ()

@end

@implementation CMEditItemViewController

#pragma mark UIVIewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.nameTextField.text = self.item.name;
    self.categoryTextField.text = ((CMCategory *)self.item.category).name;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    _context = nil;
    _item = nil;
}

#pragma mark IBActions

- (IBAction)save:(id)sender {
    NSString *itemName     = self.nameTextField.text;
    NSString *categoryName = self.categoryTextField.text;
    
    if (itemName.length > 0 && categoryName.length > 0) {
        CMShopperHTTPClient *httpClient = [CMShopperHTTPClient sharedInstance];
        [httpClient updateItemWithId:self.item.itemId name:itemName category:categoryName onComplete:^(NSDictionary *item, NSError *error) {
            if (error) {
                NSLog(@"TODO: alert");
            } else {
                [self.context deleteObject:self.item];
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

- (IBAction)deleteItem:(id)sender {
    CMShopperHTTPClient *httpClient = [CMShopperHTTPClient sharedInstance];
    [httpClient deleteItemWithId:self.item.itemId onComplete:^(NSError *error) {
        if (error) {
            NSLog(@"TODO: alert");
        } else {
            [self.context deleteObject:self.item];
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }];
}
@end
